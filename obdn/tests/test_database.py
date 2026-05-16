"""
OBDN – testy integracyjne bazy danych
======================================
Uruchamiane w GitHub Actions i lokalnie:
    pip install oracledb pytest
    pytest obdn/tests/test_database.py -v

Zmienne srodowiskowe:
    ORACLE_SYS_PASSWORD  – haslo SYS (do tworzenia schematu)
    OBDN_PASSWORD        – haslo uzytkownika OBDN
    DB_HOST              – (opcja, domyslnie localhost)
    DB_PORT              – (opcja, domyslnie 1521)
    DB_SERVICE           – (opcja, domyslnie XEPDB1)
"""

import os
import re
import pytest
import oracledb

# ─── konfiguracja z env ────────────────────────────────────────────────────────
SYS_PWD  = os.environ.get("ORACLE_SYS_PASSWORD") or os.environ["ORACLE_PASSWORD"]
OBDN_PWD = os.environ["OBDN_PASSWORD"]
DB_HOST  = os.environ.get("DB_HOST",    "localhost")
DB_PORT  = int(os.environ.get("DB_PORT", "1521"))
DB_SVC   = os.environ.get("DB_SERVICE", "XEPDB1")
DSN      = f"{DB_HOST}:{DB_PORT}/{DB_SVC}"
SQL_DIR  = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", "sql"))

# ─── helpery połączeń ──────────────────────────────────────────────────────────
def sys_conn():
    return oracledb.connect(
        user="sys", password=SYS_PWD, dsn=DSN,
        mode=oracledb.AUTH_MODE_SYSDBA
    )

def obdn_conn():
    return oracledb.connect(user="OBDN", password=OBDN_PWD, dsn=DSN)


# ─── executor plików SQL ───────────────────────────────────────────────────────
_IGNORABLE = {
    955,   # ORA-00955: name already used by existing object
    1,     # ORA-00001: unique constraint violated (duplicate test data)
    1408,  # ORA-01408: such column list already indexed
    2261,  # ORA-02261: such unique or primary key already exists
    2264,  # ORA-02264: name already used by existing constraint
}

_SQLPLUS_RE = re.compile(
    r"^\s*(SET\s+|DEFINE\s+|PROMPT\s*|@|SPOOL\s+|CONNECT\s+|EXIT\s*;?\s*$)",
    re.IGNORECASE,
)

def _split_statements(content: str) -> list[str]:
    """
    Dzieli plik SQL na pojedyncze instrukcje.
    Bloki PL/SQL konczą sie / na osobnej linii.
    Zwykle instrukcje SQL konczą sie ;
    """
    content = content.replace("\r\n", "\n").replace("\r", "\n")
    statements: list[str] = []
    current: list[str] = []
    in_plsql = False

    PLSQL_START = re.compile(
        r"\b(BEGIN|DECLARE|CREATE\s+OR\s+REPLACE\s+(?:PROCEDURE|FUNCTION|TRIGGER|PACKAGE|TYPE))\b",
        re.IGNORECASE,
    )

    for line in content.split("\n"):
        stripped = line.strip()

        if not in_plsql and _SQLPLUS_RE.match(stripped):
            continue

        if stripped == "/":
            stmt = "\n".join(current).strip()
            stmt = re.sub(r"(\n[ \t]*;[ \t]*)+$", "", stmt).strip()
            if re.sub(r"--[^\n]*", "", stmt).strip():
                statements.append(stmt)
            current = []
            in_plsql = False
            continue

        current.append(line)

        joined = "\n".join(current)
        if PLSQL_START.search(joined):
            in_plsql = True

        if not in_plsql and stripped.endswith(";"):
            stmt = "\n".join(current).strip().rstrip(";").strip()
            stmt_clean = re.sub(r"--[^\n]*", "", stmt).strip()
            if stmt_clean:
                statements.append(stmt)
            current = []

    return statements


def execute_sql_file(conn, filepath: str) -> None:
    """Wykonuje plik SQL przez oracledb (bez SQL*Plus)."""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()

    statements = _split_statements(content)
    cursor = conn.cursor()

    for stmt in statements:
        stmt_exec = re.sub(r"--[^\n]*", "", stmt).strip()
        if not stmt_exec:
            continue
        try:
            cursor.execute(stmt_exec)
        except oracledb.DatabaseError as exc:
            (err,) = exc.args
            if err.code not in _IGNORABLE:
                fname = os.path.basename(filepath)
                raise RuntimeError(
                    f"[{fname}] ORA-{err.code:05d}: {err.message}\n"
                    f"Statement: {stmt_exec[:300]}"
                ) from exc

    conn.commit()
    cursor.close()


# ─── SETUP (raz na sesję pytest) ───────────────────────────────────────────────
@pytest.fixture(scope="session", autouse=True)
def setup_database():
    """Tworzy schemat OBDN i ładuje wszystkie dane testowe."""

    with sys_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM dba_users WHERE username='OBDN'")
        if cur.fetchone()[0]:
            cur.execute("DROP USER OBDN CASCADE")
        cur.execute(f'CREATE USER OBDN IDENTIFIED BY "{OBDN_PWD}"')
        for priv in (
            "CONNECT", "RESOURCE", "UNLIMITED TABLESPACE",
            "CREATE VIEW", "CREATE PROCEDURE", "CREATE SEQUENCE",
            "CREATE TABLE", "CREATE SESSION",
        ):
            cur.execute(f"GRANT {priv} TO OBDN")
        conn.commit()
        cur.close()

    scripts = [
        "01_create_tables.sql",
        "02_insert_test_data.sql",
        "03_views_and_procedures.sql",
        "04_demo_data.sql",
    ]
    with obdn_conn() as conn:
        for script in scripts:
            execute_sql_file(conn, os.path.join(SQL_DIR, script))

    yield


# ══════════════════════════════════════════════════════════════════════════════
# TESTY – Struktura schematu
# ══════════════════════════════════════════════════════════════════════════════
class TestSchema:
    EXPECTED_TABLES = {
        "ROLE_UZYTKOWNIKOW", "PRZEZNACZENIE_GRUNTOW", "ZRODLA_OGLOSZEN",
        "USERS", "DZIALKI", "BUDYNKI", "LOKALE", "KSIEGI_WIECZYSTE",
        "HISTORIA_WLASNOSCI", "HIPOTEKI", "TRANSAKCJE",
        "OGLOSZENIA", "HISTORIA_CEN_OGLOSZEN", "STATYSTYKI_RYNKOWE",
    }
    EXPECTED_VIEWS = {
        "V_OGLOSZENIA_AKTYWNE", "V_HISTORIA_WLASNOSCI_PELNA",
        "V_HIPOTEKI_AKTYWNE", "V_STATYSTYKI_RYNKOWE_SUMMARY",
        "V_DUPLIKATY_OGLOSZEN", "V_PORTFEL_AGENTA",
    }
    EXPECTED_PROCEDURES = {
        "SP_SZACUJ_WARTOSC_LOKALU",
        "SP_DEDUPLIKUJ_OGLOSZENIA",
        "SP_OBLICZ_STATYSTYKI_RYNKOWE",
    }

    def test_tables_exist(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT table_name FROM user_tables")
            tables = {r[0] for r in cur}
        assert tables == self.EXPECTED_TABLES, f"Brakujace: {self.EXPECTED_TABLES - tables}"

    def test_views_exist(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT view_name FROM user_views")
            views = {r[0] for r in cur}
        assert views == self.EXPECTED_VIEWS, f"Brakujace: {self.EXPECTED_VIEWS - views}"

    def test_procedures_valid(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute(
                "SELECT object_name, status FROM user_objects WHERE object_type='PROCEDURE'"
            )
            procs = {r[0]: r[1] for r in cur}
        assert set(procs) == self.EXPECTED_PROCEDURES, \
            f"Brakujace: {self.EXPECTED_PROCEDURES - set(procs)}"
        invalid = [n for n, s in procs.items() if s != "VALID"]
        assert not invalid, f"Procedury INVALID: {invalid}"

    def test_sequences_count(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM user_sequences")
            assert cur.fetchone()[0] == 14

    def test_indexes_created(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM user_indexes")
            assert cur.fetchone()[0] >= 20

    def test_self_reference_constraint(self):
        """OGLOSZENIA.DUPLIKAT_GLOWNEGO_ID powinno miec FK do siebie."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute(
                "SELECT COUNT(*) FROM user_constraints "
                "WHERE table_name='OGLOSZENIA' AND constraint_type='R'"
            )
            assert cur.fetchone()[0] >= 1


# ══════════════════════════════════════════════════════════════════════════════
# TESTY – Dane (mock data)
# ══════════════════════════════════════════════════════════════════════════════
class TestMockData:
    def test_roles_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT nazwa FROM role_uzytkownikow ORDER BY role_id")
            names = [r[0] for r in cur]
        assert len(names) >= 6
        assert "OBYWATEL" in names
        assert "AGENT" in names
        assert "URZEDNIK" in names

    def test_przeznaczenie_gruntow_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM przeznaczenie_gruntow")
            assert cur.fetchone()[0] >= 3

    def test_zrodla_ogloszen_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM zrodla_ogloszen")
            assert cur.fetchone()[0] >= 5

    def test_users_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM users WHERE status != 'USUNIETY'")
            assert cur.fetchone()[0] >= 5

    def test_nieruchomosci_hierarchy(self):
        """Musi byc przynajmniej 1 dzialka, 1 budynek, 1 lokal."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM dzialki")
            dzialki = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM budynki")
            budynki = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM lokale")
            lokale = cur.fetchone()[0]
        assert dzialki >= 1, "Brak dzialek"
        assert budynki >= 1, "Brak budynkow"
        assert lokale >= 1, "Brak lokali"

    def test_ogloszenia_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM ogloszenia")
            assert cur.fetchone()[0] >= 3

    def test_historia_wlasnosci_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM historia_wlasnosci")
            assert cur.fetchone()[0] >= 1

    def test_transakcje_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM transakcje")
            assert cur.fetchone()[0] >= 1

    def test_hipoteki_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM hipoteki WHERE aktywna = 1")
            assert cur.fetchone()[0] >= 1

    def test_historia_cen_present(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM historia_cen_ogloszen")
            assert cur.fetchone()[0] >= 1


# ══════════════════════════════════════════════════════════════════════════════
# TESTY – Widoki analityczne
# ══════════════════════════════════════════════════════════════════════════════
class TestViews:
    def test_v_ogloszenia_aktywne_returns_rows(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_ogloszenia_aktywne")
            assert cur.fetchone()[0] >= 1

    def test_v_ogloszenia_aktywne_columns(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT * FROM v_ogloszenia_aktywne WHERE ROWNUM = 1")
            cols = {d[0] for d in cur.description}
        expected = {"OGLOSZENIE_ID", "TYP_OGLOSZENIA", "TYTUL", "CENA",
                    "ADRES", "MIASTO", "TYP_NIERUCHOMOSCI"}
        assert expected.issubset(cols), f"Brakujace kolumny: {expected - cols}"

    def test_v_historia_wlasnosci_pelna_accessible(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_historia_wlasnosci_pelna")
            assert cur.fetchone()[0] >= 1

    def test_v_hipoteki_aktywne_accessible(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_hipoteki_aktywne")
            cur.fetchone()

    def test_v_portfel_agenta_accessible(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_portfel_agenta")
            assert cur.fetchone()[0] >= 1

    def test_v_statystyki_rynkowe_accessible(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_statystyki_rynkowe_summary")
            cur.fetchone()

    def test_v_duplikaty_ogloszen_accessible(self):
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT COUNT(*) FROM v_duplikaty_ogloszen")
            cur.fetchone()


# ══════════════════════════════════════════════════════════════════════════════
# TESTY – Procedury składowane
# ══════════════════════════════════════════════════════════════════════════════
class TestProcedures:
    def _get_lokal_id(self, conn) -> int:
        cur = conn.cursor()
        cur.execute("SELECT lokal_id FROM lokale WHERE ROWNUM = 1")
        row = cur.fetchone()
        assert row, "Brak lokali w tabeli LOKALE"
        return row[0]

    def test_sp_deduplikuj_ogloszenia_runs(self):
        """SP_DEDUPLIKUJ_OGLOSZENIA wykrywa i oznacza duplikaty."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.callproc("SP_DEDUPLIKUJ_OGLOSZENIA")
            conn.commit()

            cur.execute("SELECT COUNT(*) FROM ogloszenia WHERE hash_deduplikacji IS NOT NULL")
            hashed = cur.fetchone()[0]
        assert hashed >= 1, "Zadne ogloszenie nie otrzymalo hasha deduplikacji"

    def test_duplikaty_wykryte_po_deduplikacji(self):
        """Po wywolaniu deduplikacji V_DUPLIKATY_OGLOSZEN ma przynajmniej 1 wiersz."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.callproc("SP_DEDUPLIKUJ_OGLOSZENIA")
            conn.commit()

            cur.execute("SELECT COUNT(*) FROM v_duplikaty_ogloszen")
            duplikaty = cur.fetchone()[0]
        assert duplikaty >= 1, "Brak wykrytych duplikatow – sprawdz dane testowe"

    def test_sp_szacuj_wartosc_lokalu_runs(self):
        """SP_SZACUJ_WARTOSC_LOKALU oblicza i zapisuje szacunkowa wartosc."""
        with obdn_conn() as conn:
            lokal_id = self._get_lokal_id(conn)
            cur = conn.cursor()
            cur.callproc("SP_SZACUJ_WARTOSC_LOKALU", [lokal_id])
            conn.commit()

    def test_sp_oblicz_statystyki_rynkowe_runs(self):
        """SP_OBLICZ_STATYSTYKI_RYNKOWE oblicza i zapisuje statystyki."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.callproc("SP_OBLICZ_STATYSTYKI_RYNKOWE", ["Wroclaw", 2023, 1])
            conn.commit()

    def test_statystyki_zapisane_po_obliczeniu(self):
        """Po wywolaniu procedury statystyk, STATYSTYKI_RYNKOWE ma przynajmniej 1 wiersz."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.callproc("SP_OBLICZ_STATYSTYKI_RYNKOWE", ["Krakow", 2022, 6])
            conn.commit()

            cur.execute("SELECT COUNT(*) FROM statystyki_rynkowe")
            assert cur.fetchone()[0] >= 1

    def test_hash_deduplikacji_sha256_format(self):
        """HASH_DEDUPLIKACJI powinien byc SHA-256 (64 znaki hex)."""
        with obdn_conn() as conn:
            cur = conn.cursor()
            cur.callproc("SP_DEDUPLIKUJ_OGLOSZENIA")
            conn.commit()

            cur.execute(
                "SELECT hash_deduplikacji FROM ogloszenia "
                "WHERE hash_deduplikacji IS NOT NULL AND ROWNUM = 1"
            )
            row = cur.fetchone()

        if row:
            fp = row[0]
            assert len(fp) == 64, f"Zla dlugosc hasha: {len(fp)}"
            assert re.fullmatch(r"[0-9A-Fa-f]{64}", fp), f"Zly format hasha: {fp}"
