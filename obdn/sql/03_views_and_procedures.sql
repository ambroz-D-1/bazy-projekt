-- Widoki analityczne i procedury
-- Uruchamiac po 02_insert_test_data.sql

SET SQLBLANKLINES ON

-- Widok: Aktywne ogloszenia z pelnym opisem nieruchomosci
-- (bez duplikatow – glowny widok dla obywateli i agentow)
CREATE OR REPLACE VIEW V_OGLOSZENIA_AKTYWNE AS
SELECT
    o.OGLOSZENIE_ID,
    o.TYP_OGLOSZENIA,
    o.TYTUL,
    o.CENA,
    o.WALUTA,
    o.STATUS,
    o.DATA_WYSTAWIENIA,
    zo.NAZWA AS ZRODLO,
    u.IMIE || ' ' || u.NAZWISKO AS WYSTAWIAJACY,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN
            b.ULICA || ' ' || b.NUMER_ADRESOWY || '/lok.' || l.NUMER_LOKALU || ', ' || b.MIASTO
        WHEN o.BUDYNEK_ID IS NOT NULL THEN
            b2.ULICA || ' ' || b2.NUMER_ADRESOWY || ', ' || b2.MIASTO
        ELSE
            d2.GMINA || ' (' || d2.NUMER_EGIB || '), ' || d2.WOJEWODZTWO
    END AS ADRES,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN l.TYP_LOKALU
        WHEN o.BUDYNEK_ID IS NOT NULL THEN 'BUDYNEK'
        ELSE 'DZIALKA'
    END AS TYP_NIERUCHOMOSCI,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN l.METRAZ_M2
        WHEN o.BUDYNEK_ID IS NOT NULL THEN NULL
        ELSE d2.POWIERZCHNIA_M2
    END AS POWIERZCHNIA_M2,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN l.LICZBA_POKOI
        ELSE NULL
    END AS LICZBA_POKOI,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN b.MIASTO
        WHEN o.BUDYNEK_ID IS NOT NULL THEN b2.MIASTO
        ELSE d2.GMINA
    END AS MIASTO,
    CASE
        WHEN o.LOKAL_ID IS NOT NULL THEN b.DZIELNICA
        WHEN o.BUDYNEK_ID IS NOT NULL THEN b2.DZIELNICA
        ELSE NULL
    END AS DZIELNICA
FROM
    OGLOSZENIA o
    LEFT JOIN ZRODLA_OGLOSZEN zo ON zo.ZRODLO_ID = o.ZRODLO_ID
    LEFT JOIN USERS u ON u.USER_ID = o.WYSTAWIAJACY_ID
    LEFT JOIN LOKALE l ON l.LOKAL_ID = o.LOKAL_ID
    LEFT JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
    LEFT JOIN BUDYNKI b2 ON b2.BUDYNEK_ID = o.BUDYNEK_ID
    LEFT JOIN DZIALKI d ON d.DZIALKA_ID = b.DZIALKA_ID
    LEFT JOIN DZIALKI d2 ON d2.DZIALKA_ID = o.DZIALKA_ID
WHERE
    o.STATUS = 'AKTYWNE'
    AND o.JEST_DUPLIKATEM = 0;

-- Widok: Pelna historia wlasnosci z danymi nieruchomosci
-- Dostepna dla urzednikow, bankow i admina
CREATE OR REPLACE VIEW V_HISTORIA_WLASNOSCI_PELNA AS
SELECT
    hw.HISTORIA_ID,
    hw.DATA_OD,
    hw.DATA_DO,
    hw.AKTYWNA,
    hw.UDZIAL_PROCENTOWY,
    u.USER_ID,
    u.IMIE || ' ' || u.NAZWISKO AS WLASCICIEL,
    u.EMAIL,
    CASE
        WHEN hw.LOKAL_ID IS NOT NULL THEN
            b.ULICA || ' ' || b.NUMER_ADRESOWY || '/lok.' || l.NUMER_LOKALU || ', ' || b.MIASTO
        WHEN hw.BUDYNEK_ID IS NOT NULL THEN
            b2.ULICA || ' ' || b2.NUMER_ADRESOWY || ', ' || b2.MIASTO
        ELSE
            d2.GMINA || ' (' || d2.NUMER_EGIB || ')'
    END AS NIERUCHOMOSC,
    CASE
        WHEN hw.LOKAL_ID IS NOT NULL THEN 'LOKAL'
        WHEN hw.BUDYNEK_ID IS NOT NULL THEN 'BUDYNEK'
        ELSE 'DZIALKA'
    END AS TYP_NIERUCHOMOSCI,
    hw.LOKAL_ID,
    hw.BUDYNEK_ID,
    hw.DZIALKA_ID
FROM
    HISTORIA_WLASNOSCI hw
    JOIN USERS u ON u.USER_ID = hw.USER_ID
    LEFT JOIN LOKALE l ON l.LOKAL_ID = hw.LOKAL_ID
    LEFT JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
    LEFT JOIN BUDYNKI b2 ON b2.BUDYNEK_ID = hw.BUDYNEK_ID
    LEFT JOIN DZIALKI d2 ON d2.DZIALKA_ID = hw.DZIALKA_ID
ORDER BY
    hw.DATA_OD DESC;

-- Widok: Aktywne hipoteki i obciazenia (dla bankow i urzednikow)
CREATE OR REPLACE VIEW V_HIPOTEKI_AKTYWNE AS
SELECT
    h.HIPOTEKA_ID,
    h.WIERZYCIEL,
    h.KWOTA,
    h.WALUTA,
    h.DATA_WPISU,
    CASE
        WHEN h.LOKAL_ID IS NOT NULL THEN
            b.ULICA || ' ' || b.NUMER_ADRESOWY || '/lok.' || l.NUMER_LOKALU || ', ' || b.MIASTO
        WHEN h.BUDYNEK_ID IS NOT NULL THEN
            b2.ULICA || ' ' || b2.NUMER_ADRESOWY || ', ' || b2.MIASTO
        ELSE
            d2.GMINA || ' (' || d2.NUMER_EGIB || ')'
    END AS NIERUCHOMOSC,
    CASE
        WHEN h.LOKAL_ID IS NOT NULL THEN 'LOKAL'
        WHEN h.BUDYNEK_ID IS NOT NULL THEN 'BUDYNEK'
        ELSE 'DZIALKA'
    END AS TYP_NIERUCHOMOSCI,
    h.LOKAL_ID,
    h.BUDYNEK_ID,
    h.DZIALKA_ID,
    hw.IMIE || ' ' || hw.NAZWISKO AS AKTUALNY_WLASCICIEL
FROM
    HIPOTEKI h
    LEFT JOIN LOKALE l ON l.LOKAL_ID = h.LOKAL_ID
    LEFT JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
    LEFT JOIN BUDYNKI b2 ON b2.BUDYNEK_ID = h.BUDYNEK_ID
    LEFT JOIN DZIALKI d2 ON d2.DZIALKA_ID = h.DZIALKA_ID
    LEFT JOIN (
        SELECT u.IMIE, u.NAZWISKO, hiw.LOKAL_ID
        FROM HISTORIA_WLASNOSCI hiw
        JOIN USERS u ON u.USER_ID = hiw.USER_ID
        WHERE hiw.AKTYWNA = 1
    ) hw ON hw.LOKAL_ID = h.LOKAL_ID
WHERE
    h.AKTYWNA = 1
ORDER BY
    h.DATA_WPISU DESC;

-- Widok: Statystyki rynkowe (dla analitykow, bez danych osobowych)
CREATE OR REPLACE VIEW V_STATYSTYKI_RYNKOWE_SUMMARY AS
SELECT
    sr.ROK,
    sr.MIESIAC,
    sr.MIASTO,
    sr.DZIELNICA,
    sr.TYP_NIERUCHOMOSCI,
    sr.LICZBA_TRANSAKCJI,
    sr.CENA_SREDNIA_M2,
    sr.CENA_MEDIANA_M2,
    sr.CENA_MIN_M2,
    sr.CENA_MAX_M2,
    sr.DATA_OBLICZENIA
FROM
    STATYSTYKI_RYNKOWE sr
ORDER BY
    sr.ROK DESC,
    sr.MIESIAC DESC,
    sr.MIASTO,
    sr.DZIELNICA;

-- Widok: Wykryte duplikaty ogloszen
-- (do analizy i czyszczenia przez admina)
CREATE OR REPLACE VIEW V_DUPLIKATY_OGLOSZEN AS
SELECT
    o.OGLOSZENIE_ID,
    o.TYTUL,
    o.CENA,
    o.STATUS,
    zo.NAZWA AS ZRODLO,
    o.HASH_DEDUPLIKACJI,
    o.DUPLIKAT_GLOWNEGO_ID,
    og.TYTUL AS TYTUL_GLOWNEGO,
    zo2.NAZWA AS ZRODLO_GLOWNEGO
FROM
    OGLOSZENIA o
    JOIN ZRODLA_OGLOSZEN zo ON zo.ZRODLO_ID = o.ZRODLO_ID
    LEFT JOIN OGLOSZENIA og ON og.OGLOSZENIE_ID = o.DUPLIKAT_GLOWNEGO_ID
    LEFT JOIN ZRODLA_OGLOSZEN zo2 ON zo2.ZRODLO_ID = og.ZRODLO_ID
WHERE
    o.JEST_DUPLIKATEM = 1
ORDER BY
    o.HASH_DEDUPLIKACJI;

-- Widok: Portfel agenta / dewelopera (aktywne ogloszenia)
CREATE OR REPLACE VIEW V_PORTFEL_AGENTA AS
SELECT
    u.USER_ID AS AGENT_ID,
    u.IMIE || ' ' || u.NAZWISKO AS AGENT,
    ru.NAZWA AS ROLA,
    COUNT(o.OGLOSZENIE_ID) AS LICZBA_AKTYWNYCH,
    SUM(
        CASE
            WHEN o.TYP_OGLOSZENIA = 'SPRZEDAZ' THEN 1
            ELSE 0
        END
    ) AS SPRZEDAZ,
    SUM(
        CASE
            WHEN o.TYP_OGLOSZENIA = 'WYNAJEM' THEN 1
            ELSE 0
        END
    ) AS WYNAJEM,
    MIN(o.CENA) AS CENA_MIN,
    MAX(o.CENA) AS CENA_MAX,
    ROUND(AVG(o.CENA), 2) AS CENA_SREDNIA
FROM
    USERS u
    JOIN ROLE_UZYTKOWNIKOW ru ON ru.ROLE_ID = u.ROLA_ID
    LEFT JOIN OGLOSZENIA o ON o.WYSTAWIAJACY_ID = u.USER_ID
    AND o.STATUS = 'AKTYWNE'
    AND o.JEST_DUPLIKATEM = 0
WHERE
    ru.MOZE_WYSTAWIAC_OGLOSZENIA = 1
    AND u.STATUS = 'AKTYWNY'
GROUP BY
    u.USER_ID,
    u.IMIE,
    u.NAZWISKO,
    ru.NAZWA;

-- Procedura: Szacuj wartosc rynkowa lokalu
-- Algorytm: mediana cena/m2 z transakcji w tym samym miescie
-- (ostatnie 12 miesiecy) razy metraz lokalu
CREATE OR REPLACE PROCEDURE SP_SZACUJ_WARTOSC_LOKALU (p_lokal_id IN NUMBER) AS
    v_metraz    NUMBER;

v_miasto VARCHAR2 (100);

v_median_m2 NUMBER;

v_wartosc NUMBER;

BEGIN
    SELECT l.METRAZ_M2, b.MIASTO
    INTO v_metraz, v_miasto
    FROM LOKALE l
        JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
    WHERE
        l.LOKAL_ID = p_lokal_id;

    BEGIN
        SELECT MEDIAN(t.CENA / l2.METRAZ_M2)
        INTO v_median_m2
        FROM TRANSAKCJE t
            JOIN LOKALE l2 ON l2.LOKAL_ID = t.LOKAL_ID
            JOIN BUDYNKI b2 ON b2.BUDYNEK_ID = l2.BUDYNEK_ID
        WHERE
            b2.MIASTO = v_miasto
            AND t.DATA_TRANSAKCJI >= ADD_MONTHS (TRUNC (SYSDATE), -12)
            AND l2.METRAZ_M2 > 0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_median_m2 := NULL;
    END;

    IF v_median_m2 IS NOT NULL THEN
        v_wartosc := ROUND (v_median_m2 * v_metraz, 2);
    END IF;

    UPDATE LOKALE
    SET
        SZACOWANA_WARTOSC = v_wartosc
    WHERE
        LOKAL_ID = p_lokal_id;

    COMMIT;
END SP_SZACUJ_WARTOSC_LOKALU;
/

-- Procedura: Deduplikuj ogloszenia
-- Algorytm:
--   1. Oblicz HASH_DEDUPLIKACJI dla ogloszen bez hasha
--      (na podstawie identyfikatora nieruchomosci + typ_ogloszenia)
--   2. W grupach ogloszen z tym samym hashem,
--      oznacz wszystkie oprocz najstarszego jako duplikat
CREATE OR REPLACE PROCEDURE SP_DEDUPLIKUJ_OGLOSZENIA AS
    v_hash VARCHAR2 (64);

BEGIN
    FOR o IN (
        SELECT OGLOSZENIE_ID, LOKAL_ID, BUDYNEK_ID, DZIALKA_ID, TYP_OGLOSZENIA
        FROM OGLOSZENIA
        WHERE
            STATUS IN ('AKTYWNE', 'ZAREZERWOWANE')
            AND HASH_DEDUPLIKACJI IS NULL
    ) LOOP
        SELECT STANDARD_HASH (
            NVL (TO_CHAR (o.LOKAL_ID), 'X') || '|' || NVL (TO_CHAR (o.BUDYNEK_ID), 'X') || '|' || NVL (TO_CHAR (o.DZIALKA_ID), 'X') || '|' || o.TYP_OGLOSZENIA,
            'SHA256'
        )
        INTO v_hash
        FROM DUAL;

        UPDATE OGLOSZENIA
        SET
            HASH_DEDUPLIKACJI = v_hash
        WHERE
            OGLOSZENIE_ID = o.OGLOSZENIE_ID;
    END LOOP;

    UPDATE OGLOSZENIA
    SET
        JEST_DUPLIKATEM = 0,
        DUPLIKAT_GLOWNEGO_ID = NULL
    WHERE
        JEST_DUPLIKATEM = 1;

    FOR grp IN (
        SELECT HASH_DEDUPLIKACJI, MIN (OGLOSZENIE_ID) AS GLOWNE_ID, COUNT (*) AS CNT
        FROM OGLOSZENIA
        WHERE
            HASH_DEDUPLIKACJI IS NOT NULL
            AND STATUS IN ('AKTYWNE', 'ZAREZERWOWANE')
        GROUP BY
            HASH_DEDUPLIKACJI
        HAVING
            COUNT (*) > 1
    ) LOOP
        UPDATE OGLOSZENIA
        SET
            JEST_DUPLIKATEM = 1,
            DUPLIKAT_GLOWNEGO_ID = grp.GLOWNE_ID
        WHERE
            HASH_DEDUPLIKACJI = grp.HASH_DEDUPLIKACJI
            AND OGLOSZENIE_ID != grp.GLOWNE_ID
            AND STATUS IN ('AKTYWNE', 'ZAREZERWOWANE');
    END LOOP;

    COMMIT;
END SP_DEDUPLIKUJ_OGLOSZENIA;
/

-- Procedura: Oblicz statystyki rynkowe dla miasta i okresu
-- Algorytm: agregacja transakcji lokal w danym miesiacu/roku/miescie
-- UPSERT do STATYSTYKI_RYNKOWE per typ lokalu
CREATE OR REPLACE PROCEDURE SP_OBLICZ_STATYSTYKI_RYNKOWE (
    p_miasto IN VARCHAR2,
    p_rok IN NUMBER,
    p_miesiac IN NUMBER
) AS
    v_liczba  NUMBER := 0;

v_srednia NUMBER;

v_mediana NUMBER;

v_min NUMBER;

v_max NUMBER;

v_typ VARCHAR2 (30);

CURSOR cur_typy IS
    SELECT DISTINCT l.TYP_LOKALU
    FROM TRANSAKCJE t
        JOIN LOKALE l ON l.LOKAL_ID = t.LOKAL_ID
        JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
    WHERE
        b.MIASTO = p_miasto
        AND EXTRACT (YEAR FROM t.DATA_TRANSAKCJI) = p_rok
        AND EXTRACT (MONTH FROM t.DATA_TRANSAKCJI) = p_miesiac
        AND l.METRAZ_M2 > 0;

BEGIN
    OPEN cur_typy;

    LOOP
        FETCH cur_typy INTO v_typ;
        EXIT WHEN cur_typy%NOTFOUND;

        SELECT COUNT (*), AVG (t.CENA / l.METRAZ_M2), MEDIAN (t.CENA / l.METRAZ_M2), MIN (t.CENA / l.METRAZ_M2), MAX (t.CENA / l.METRAZ_M2)
        INTO v_liczba, v_srednia, v_mediana, v_min, v_max
        FROM TRANSAKCJE t
            JOIN LOKALE l ON l.LOKAL_ID = t.LOKAL_ID
            JOIN BUDYNKI b ON b.BUDYNEK_ID = l.BUDYNEK_ID
        WHERE
            b.MIASTO = p_miasto
            AND l.TYP_LOKALU = v_typ
            AND EXTRACT (YEAR FROM t.DATA_TRANSAKCJI) = p_rok
            AND EXTRACT (MONTH FROM t.DATA_TRANSAKCJI) = p_miesiac
            AND l.METRAZ_M2 > 0;

        IF v_liczba > 0 THEN
            MERGE INTO STATYSTYKI_RYNKOWE sr
            USING (
                SELECT p_miesiac AS MJ, p_rok AS R, p_miasto AS M, v_typ AS TYP
                FROM DUAL
            ) src
            ON (
                sr.MIESIAC = src.MJ
                AND sr.ROK = src.R
                AND sr.MIASTO = src.M
                AND sr.TYP_NIERUCHOMOSCI = src.TYP
                AND sr.DZIELNICA IS NULL
            )
            WHEN MATCHED THEN
                UPDATE
                SET
                    LICZBA_TRANSAKCJI = v_liczba,
                    CENA_SREDNIA_M2 = ROUND (v_srednia, 2),
                    CENA_MEDIANA_M2 = ROUND (v_mediana, 2),
                    CENA_MIN_M2 = ROUND (v_min, 2),
                    CENA_MAX_M2 = ROUND (v_max, 2),
                    DATA_OBLICZENIA = SYSTIMESTAMP
            WHEN NOT MATCHED THEN
                INSERT (
                    MIESIAC, ROK, MIASTO, TYP_NIERUCHOMOSCI, LICZBA_TRANSAKCJI, CENA_SREDNIA_M2, CENA_MEDIANA_M2, CENA_MIN_M2, CENA_MAX_M2, DATA_OBLICZENIA
                )
                VALUES (
                    p_miesiac, p_rok, p_miasto, v_typ, v_liczba, ROUND (v_srednia, 2), ROUND (v_mediana, 2), ROUND (v_min, 2), ROUND (v_max, 2), SYSTIMESTAMP
                );
        END IF;
    END LOOP;

    CLOSE cur_typy;
    COMMIT;
END SP_OBLICZ_STATYSTYKI_RYNKOWE;
/

-- Role i uprawnienia (uruchamiac jako DBA/ADMIN)
-- CREATE ROLE OBDN_ADMIN;
-- CREATE ROLE OBDN_AGENT;
-- CREATE ROLE OBDN_OBYWATEL;
-- CREATE ROLE OBDN_URZEDNIK;
-- CREATE ROLE OBDN_BANK;
-- CREATE ROLE OBDN_ANALITYK;
--
-- GRANT SELECT, INSERT, UPDATE, DELETE ON USERS                TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON DZIALKI              TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON BUDYNKI              TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON LOKALE               TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORIA_WLASNOSCI   TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON HIPOTEKI             TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON TRANSAKCJE           TO OBDN_ADMIN;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON OGLOSZENIA           TO OBDN_ADMIN;
-- GRANT SELECT ON V_OGLOSZENIA_AKTYWNE                         TO OBDN_OBYWATEL;
-- GRANT SELECT ON V_HISTORIA_WLASNOSCI_PELNA                   TO OBDN_BANK;
-- GRANT SELECT ON V_HIPOTEKI_AKTYWNE                           TO OBDN_BANK;
-- GRANT SELECT ON V_STATYSTYKI_RYNKOWE_SUMMARY                 TO OBDN_ANALITYK;
-- GRANT SELECT, INSERT, UPDATE ON V_OGLOSZENIA_AKTYWNE         TO OBDN_AGENT;
-- GRANT SELECT ON V_PORTFEL_AGENTA                             TO OBDN_AGENT;
-- GRANT EXECUTE ON SP_DEDUPLIKUJ_OGLOSZENIA                    TO OBDN_ADMIN;
-- GRANT EXECUTE ON SP_OBLICZ_STATYSTYKI_RYNKOWE                TO OBDN_ADMIN;
-- GRANT EXECUTE ON SP_SZACUJ_WARTOSC_LOKALU                    TO OBDN_BANK;

-- Test: uruchom procedury i sprawdz wyniki
-- BEGIN SP_DEDUPLIKUJ_OGLOSZENIA; END;
-- /
-- BEGIN SP_SZACUJ_WARTOSC_LOKALU(1); END;
-- /
-- BEGIN SP_OBLICZ_STATYSTYKI_RYNKOWE('Wroclaw', 2023, 1); END;
-- /
-- SELECT * FROM V_OGLOSZENIA_AKTYWNE;
-- SELECT * FROM V_DUPLIKATY_OGLOSZEN;
-- SELECT * FROM V_PORTFEL_AGENTA;
-- SELECT * FROM V_HISTORIA_WLASNOSCI_PELNA;
-- SELECT * FROM V_HIPOTEKI_AKTYWNE;
