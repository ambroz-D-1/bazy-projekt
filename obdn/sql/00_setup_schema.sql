-- ============================================================
-- Konfiguracja schematu OBDN na lokalnej bazie Oracle XE
-- Uruchamiac jako SYS (SYSDBA) na PDB: XEPDB1
--
-- Sposob uzycia (patrz README – sekcja "Uruchamianie lokalnie"):
--   docker exec -it obdn-db sqlplus sys/Admin1234@XEPDB1 as sysdba @/sql/00_setup_schema.sql
--
-- UWAGA: Przed uruchomieniem ustaw zmienne srodowiskowe:
--   OBDN_PASSWORD  – haslo dla uzytkownika OBDN
--
-- Przyklad (bash):
--   export OBDN_PASSWORD='twoje_silne_haslo'
--   docker exec -e OBDN_PASSWORD obdn-db sqlplus sys/Admin1234@XEPDB1 as sysdba @/sql/00_setup_schema.sql
--
-- W SQL*Plus zmieniona wartosc podstawia sie przez: &&OBDN_PASSWORD
-- ============================================================

CREATE USER OBDN IDENTIFIED BY && OBDN_PASSWORD;

GRANT CONNECT TO OBDN;

GRANT RESOURCE TO OBDN;

GRANT UNLIMITED TABLESPACE TO OBDN;

GRANT CREATE VIEW TO OBDN;

GRANT CREATE PROCEDURE TO OBDN;

GRANT CREATE SEQUENCE TO OBDN;

GRANT CREATE TABLE TO OBDN;

GRANT CREATE SESSION TO OBDN;

EXIT;
