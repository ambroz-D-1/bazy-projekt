#!/usr/bin/env bash
# Deploy PEGASUS + OBDN (Oracle XE w Dockerze)
# Uzycie: ./setup.sh [--reset] [--skip-data]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$ROOT/.env"
CONTAINER="pegasus-db"
ORACLE_SVC="XEPDB1"
RESET=0
SKIP_DATA=0

for arg in "$@"; do
  case $arg in
    --reset)     RESET=1 ;;
    --skip-data) SKIP_DATA=1 ;;
  esac
done

step() { echo ""; echo -e "\033[0;36m[$1] $2\033[0m"; }
ok()   { echo -e "    \033[0;32mOK: $1\033[0m"; }
fail() { echo -e "    \033[0;31mBLAD: $1\033[0m"; exit 1; }
info() { echo -e "    \033[0;90m$1\033[0m"; }

run_sql() {
  local conn="$1" sql="$2"
  local tmp; tmp=$(mktemp /tmp/obdn_XXXXXX.sql)
  printf 'WHENEVER SQLERROR EXIT FAILURE ROLLBACK\n%s' "$sql" > "$tmp"
  docker cp "$tmp" "${CONTAINER}:/tmp/_run.sql"
  docker exec -u oracle "$CONTAINER" sqlplus -L "$conn" "@/tmp/_run.sql"
  local ec=$?
  rm -f "$tmp"
  return $ec
}

create_schema() {
  local schema="$1" password="$2"
  local reset_clause
  if [ "$RESET" -eq 1 ]; then
    reset_clause="EXECUTE IMMEDIATE 'DROP USER ${schema} CASCADE'; DBMS_OUTPUT.PUT_LINE('Stary schemat ${schema} usunieto.');"
  else
    reset_clause="DBMS_OUTPUT.PUT_LINE('Schemat ${schema} juz istnieje – pomijam DROP (brak --reset).');"
  fi

  local sql="SET SERVEROUTPUT ON
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM dba_users WHERE username = '${schema}';
    IF v_exists > 0 THEN
        ${reset_clause}
    END IF;
    SELECT COUNT(*) INTO v_exists FROM dba_users WHERE username = '${schema}';
    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER ${schema} IDENTIFIED BY \"${password}\"';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO ${schema}';
        EXECUTE IMMEDIATE 'GRANT CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE, CREATE SESSION TO ${schema}';
        DBMS_OUTPUT.PUT_LINE('Uzytkownik ${schema} utworzony.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Uzytkownik ${schema} juz istnieje – pomijam CREATE USER.');
    END IF;
END;
/
PROMPT ${schema} gotowy.
EXIT;"
  run_sql "sys/${ORACLE_PWD}@localhost:1521/${ORACLE_SVC} as sysdba" "$sql"
}

load_scripts() {
  local schema="$1" password="$2" sql_dir="$3"
  if [ "$SKIP_DATA" -eq 1 ]; then
    scripts="@${sql_dir}/01_create_tables.sql"
  else
    scripts="@${sql_dir}/01_create_tables.sql
@${sql_dir}/02_insert_test_data.sql
@${sql_dir}/03_views_and_procedures.sql
@${sql_dir}/04_demo_data.sql"
  fi

  local master_sql="SET SQLBLANKLINES ON
${scripts}
EXIT;"
  run_sql "${schema}/\"${password}\"@localhost:1521/${ORACLE_SVC}" "$master_sql"
}

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  PEGASUS + OBDN  –  One-Click DB Setup     ║"
echo "╚════════════════════════════════════════════╝"

# ─────────────────────────────────────────────
step "1/8" "Sprawdzam Docker"
# ─────────────────────────────────────────────
command -v docker &>/dev/null || fail "Docker nie jest zainstalowany. Pobierz: https://www.docker.com/products/docker-desktop/"
docker info &>/dev/null            || fail "Docker nie jest uruchomiony."
ok "Docker uruchomiony"

# ─────────────────────────────────────────────
step "2/8" "Konfiguracja .env"
# ─────────────────────────────────────────────
rand_pwd() { LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 16; }

if [ ! -f "$ENV_FILE" ]; then
  ORACLE_PWD="$(rand_pwd)1Aa"
  PEGASUS_PWD="$(rand_pwd)2Bb"
  OBDN_PWD="$(rand_pwd)3Cc"
  printf 'ORACLE_PASSWORD=%s\nPEGASUS_PASSWORD=%s\nOBDN_PASSWORD=%s\n' \
    "$ORACLE_PWD" "$PEGASUS_PWD" "$OBDN_PWD" > "$ENV_FILE"
  ok "Plik .env wygenerowany z losowymi haslami"
else
  ok "Plik .env istnieje – uzywam istniejacych hasel"
fi

ORACLE_PWD=$(grep "^ORACLE_PASSWORD="  "$ENV_FILE" | cut -d= -f2-)
PEGASUS_PWD=$(grep "^PEGASUS_PASSWORD=" "$ENV_FILE" | cut -d= -f2-)
OBDN_PWD=$(grep "^OBDN_PASSWORD="    "$ENV_FILE" | cut -d= -f2- || true)
[ -n "$ORACLE_PWD"  ] || fail "Brak ORACLE_PASSWORD w .env"
[ -n "$PEGASUS_PWD" ] || fail "Brak PEGASUS_PASSWORD w .env"

# Jesli stary .env nie mial OBDN_PASSWORD – dodaj je
if [ -z "$OBDN_PWD" ]; then
  OBDN_PWD="$(rand_pwd)3Cc"
  printf '\nOBDN_PASSWORD=%s\n' "$OBDN_PWD" >> "$ENV_FILE"
  info "Dodano OBDN_PASSWORD do istniejacego .env"
fi

# ─────────────────────────────────────────────
step "3/8" "Uruchamiam Oracle XE + CloudBeaver (Docker)"
# ─────────────────────────────────────────────
cd "$ROOT"
docker compose up -d 2>&1 | while IFS= read -r line; do info "$line"; done
ok "Kontenery uruchomione"

# ─────────────────────────────────────────────
step "4/8" "Czekam na gotowos Oracle XE (max 5 min)"
# ─────────────────────────────────────────────
DEADLINE=$(( $(date +%s) + 300 ))
while [ "$(date +%s)" -lt "$DEADLINE" ]; do
  if docker logs "$CONTAINER" 2>&1 | grep -q "DATABASE IS READY TO USE"; then
    ok "Oracle XE GOTOWY"; break
  fi
  info "... inicjalizacja w toku"
  sleep 10
done
docker logs "$CONTAINER" 2>&1 | grep -q "DATABASE IS READY TO USE" || {
  docker logs "$CONTAINER" --tail 30; fail "Oracle XE nie uruchomil sie w ciagu 5 minut"
}

# ─────────────────────────────────────────────
step "5/8" "Tworze schemat PEGASUS"
# ─────────────────────────────────────────────
create_schema "PEGASUS" "$PEGASUS_PWD"
ok "Uzytkownik PEGASUS gotowy"

# ─────────────────────────────────────────────
step "6/8" "Laduje skrypty SQL – PEGASUS"
# ─────────────────────────────────────────────
load_scripts "PEGASUS" "$PEGASUS_PWD" "/sql"
ok "Skrypty PEGASUS zaladowane"

# ─────────────────────────────────────────────
step "7/8" "Tworze schemat OBDN"
# ─────────────────────────────────────────────
create_schema "OBDN" "$OBDN_PWD"
ok "Uzytkownik OBDN gotowy"

# ─────────────────────────────────────────────
step "8/8" "Laduje skrypty SQL – OBDN"
# ─────────────────────────────────────────────
load_scripts "OBDN" "$OBDN_PWD" "/sql_obdn"
ok "Skrypty OBDN zaladowane"

# ─────────────────────────────────────────────
# Weryfikacja
# ─────────────────────────────────────────────
VERIFY_SQL="SET LINESIZE 80
COLUMN owner       FORMAT A10
COLUMN object_type FORMAT A25
COLUMN cnt         FORMAT 9999
SELECT owner, object_type, COUNT(*) cnt
  FROM dba_objects
 WHERE owner IN ('PEGASUS','OBDN')
 GROUP BY owner, object_type
 ORDER BY 1, 2;
EXIT;"
echo ""
run_sql "/ as sysdba" "$VERIFY_SQL"

# ─────────────────────────────────────────────
PORT=$(grep '"[0-9]*:1521"' "$ROOT/docker-compose.yml" | grep -o '[0-9]*:1521' | cut -d: -f1)

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║            GOTOWE!                         ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo -e "  \033[0;33mCloudBeaver (przegladarka):\033[0m"
echo -e "  \033[0;33m  http://localhost:8978\033[0m"
echo ""
echo "  Dane polaczenia – OBDN:"
echo "    Host:         localhost"
echo "    Port:         $PORT"
echo "    Service name: $ORACLE_SVC"
echo "    Uzytkownik:   OBDN"
echo "    Haslo:        $OBDN_PWD"
echo ""
echo "  Dane polaczenia – PEGASUS:"
echo "    Uzytkownik:   PEGASUS"
echo "    Haslo:        $PEGASUS_PWD"
echo ""
echo "  Zatrzymanie:  docker compose down"
echo "  Pelny reset:  docker compose down -v && ./setup.sh --reset"
