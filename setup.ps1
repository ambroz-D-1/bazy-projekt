#Requires -Version 5.1
<#
.SYNOPSIS
    One-click deploy PEGASUS (Oracle XE w Dockerze)
.DESCRIPTION
    Uruchamia Oracle XE i CloudBeaver, tworzy schematy PEGASUS,
    laduje wszystkie dane testowe i pokazowe.
    Przy ponownym uruchomieniu: pomija DROP (chyba ze podano -Reset).
    Wymaga: Docker Desktop
.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Reset
    .\setup.ps1 -SkipData
#>
param(
    [switch]$Reset,
    [switch]$SkipData
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ROOT        = Split-Path -Parent $MyInvocation.MyCommand.Path
$ENV_FILE    = Join-Path $ROOT ".env"
$COMPOSE     = Join-Path $ROOT "docker-compose.yml"
$CONTAINER   = "pegasus-db"
$ORACLE_SVC  = "XEPDB1"

function Write-Step  { param($n, $msg) Write-Host "`n[$n] $msg" -ForegroundColor Cyan }
function Write-OK    { param($msg)     Write-Host "    OK: $msg" -ForegroundColor Green }
function Write-Fail  { param($msg)     Write-Host "    BLAD: $msg" -ForegroundColor Red; exit 1 }
function Write-Info  { param($msg)     Write-Host "    $msg" -ForegroundColor DarkGray }

function Invoke-OracleSQL {
    param([string]$ConnStr, [string]$SqlText)
    $tmp = [System.IO.Path]::GetTempFileName() + ".sql"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    $fullSql = "WHENEVER SQLERROR EXIT FAILURE ROLLBACK`r`n" + $SqlText
    [System.IO.File]::WriteAllText($tmp, $fullSql, $utf8NoBom)
    docker cp $tmp "${CONTAINER}:/tmp/_run.sql" | Out-Null
    $out = docker exec -u oracle $CONTAINER sqlplus -L $ConnStr "@/tmp/_run.sql" 2>&1 | Out-String
    $ec = $LASTEXITCODE
    Remove-Item $tmp -ErrorAction SilentlyContinue
    if ($out -match "ORA-\d{5}") { return 1 }
    return $ec
}

function New-RandomPassword { param($suffix)
    $pool = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'
    return (-join (1..16 | ForEach-Object { $pool[(Get-Random -Maximum $pool.Length)] })) + $suffix
}

Write-Host ""
Write-Host "#===========================================#" -ForegroundColor Cyan
Write-Host "#   PEGASUS  –  Database Setup      #" -ForegroundColor Cyan
Write-Host "#===========================================#" -ForegroundColor Cyan

# ---------------------------------------------
Write-Step "1/6" "Sprawdzam Docker"
# ---------------------------------------------
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Fail "Docker nie jest zainstalowany. Pobierz: https://www.docker.com/products/docker-desktop/"
}
try { docker info 2>&1 | Out-Null; if ($LASTEXITCODE -ne 0) { throw } }
catch { Write-Fail "Docker Desktop nie jest uruchomiony. Uruchom go i sprobuj ponownie." }
Write-OK "Docker uruchomiony"

# ---------------------------------------------
Write-Step "2/6" "Konfiguracja .env"
# ---------------------------------------------
if (-not (Test-Path $ENV_FILE)) {
    $oraclePwd  = New-RandomPassword "1Aa"
    $pegasusPwd = New-RandomPassword "2Bb"
    "ORACLE_PASSWORD=$oraclePwd`nPEGASUS_PASSWORD=$pegasusPwd`n" |
        Out-File $ENV_FILE -Encoding utf8 -NoNewline
    Write-OK "Plik .env wygenerowany z losowymi haslami"
} else {
    Write-OK "Plik .env istnieje – uzywam istniejacych hasel"
}

$envRaw     = [System.IO.File]::ReadAllText($ENV_FILE)
$oraclePwd  = ($envRaw -split "`n" | Where-Object { $_ -match "^ORACLE_PASSWORD="  }) -replace "^ORACLE_PASSWORD=",""  | ForEach-Object { $_.Trim() } | Select-Object -First 1
$pegasusPwd = ($envRaw -split "`n" | Where-Object { $_ -match "^PEGASUS_PASSWORD=" }) -replace "^PEGASUS_PASSWORD=","" | ForEach-Object { $_.Trim() } | Select-Object -First 1

if (-not $oraclePwd -or -not $pegasusPwd) { Write-Fail "Nie udalo sie odczytac hasel z .env" }

# ---------------------------------------------
Write-Step "3/6" "Uruchamiam Oracle XE + CloudBeaver (Docker)"
# ---------------------------------------------
Push-Location $ROOT
$prevEAP = $ErrorActionPreference; $ErrorActionPreference = "Continue"
cmd /c "docker compose up -d" 2>&1 | Out-Null
$ErrorActionPreference = $prevEAP
$running = docker ps --filter "name=$CONTAINER" --format "{{.Status}}" 2>&1
if (-not $running) { Write-Fail "docker compose up nieudany - kontener nie dziala" }
Pop-Location
Write-OK "Kontenery uruchomione"

# ---------------------------------------------
Write-Step "4/6" "Czekam na gotowos Oracle XE (max 5 min)"
# ---------------------------------------------
$deadline = (Get-Date).AddMinutes(5)
$ready = $false
while ((Get-Date) -lt $deadline) {
    $log = docker logs $CONTAINER 2>&1 | Out-String
    if ($log -match "DATABASE IS READY TO USE") { $ready = $true; break }
    Write-Info "... inicjalizacja w toku"
    Start-Sleep 10
}
if (-not $ready) {
    docker logs $CONTAINER --tail 30
    Write-Fail "Oracle XE nie uruchomil sie w ciagu 5 minut"
}
Write-OK "Oracle XE GOTOWY"

# ─── pomocnicza funkcja tworzenia schematu ────────────────────────────────────
function New-OracleSchema {
    param([string]$SchemaName, [string]$Password)

    $resetClause = if ($Reset) {
        "EXECUTE IMMEDIATE 'DROP USER $SchemaName CASCADE'; DBMS_OUTPUT.PUT_LINE('Stary schemat $SchemaName usunieto.');"
    } else {
        "DBMS_OUTPUT.PUT_LINE('Schemat $SchemaName juz istnieje -- pomijam DROP (brak -Reset).');"
    }

    $sql = @"
SET SERVEROUTPUT ON
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM dba_users WHERE username = '$SchemaName';
    IF v_exists > 0 THEN
        $resetClause
    END IF;
    SELECT COUNT(*) INTO v_exists FROM dba_users WHERE username = '$SchemaName';
    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER $SchemaName IDENTIFIED BY "$Password"';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO $SchemaName';
        EXECUTE IMMEDIATE 'GRANT CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE, CREATE SESSION TO $SchemaName';
        DBMS_OUTPUT.PUT_LINE('Uzytkownik $SchemaName utworzony.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Uzytkownik $SchemaName juz istnieje -- pomijam CREATE USER.');
    END IF;
END;
/
PROMPT $SchemaName gotowy.
EXIT;
"@
    $ec = Invoke-OracleSQL "sys/${oraclePwd}@localhost:1521/${ORACLE_SVC} as sysdba" $sql
    if ($ec -ne 0) { Write-Fail "Tworzenie uzytkownika $SchemaName nieudane (exit $ec)" }
}

# ─── pomocnicza funkcja ladowania skryptow SQL ────────────────────────────────
function Invoke-SqlScripts {
    param([string]$SchemaName, [string]$Password, [string]$SqlDir)

    $scripts = if ($SkipData) {
        "@${SqlDir}/01_create_tables.sql"
    } else {
        "@${SqlDir}/01_create_tables.sql`n@${SqlDir}/02_insert_test_data.sql`n@${SqlDir}/03_views_and_procedures.sql`n@${SqlDir}/04_demo_data.sql"
    }

    $masterSql = @"
SET SQLBLANKLINES ON
$scripts
EXIT;
"@
    $tmp = [System.IO.Path]::GetTempFileName() + ".sql"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tmp, $masterSql, $utf8NoBom)
    docker cp $tmp "${CONTAINER}:/tmp/_master.sql" | Out-Null
    docker exec -u oracle $CONTAINER sqlplus "${SchemaName}/${Password}@localhost:1521/${ORACLE_SVC}" "@/tmp/_master.sql"
    $ec = $LASTEXITCODE
    Remove-Item $tmp -ErrorAction SilentlyContinue
    if ($ec -ne 0) { Write-Fail "Uruchamianie skryptow SQL dla $SchemaName nieudane (exit $ec)" }
}

# ---------------------------------------------
Write-Step "5/6" "Tworze schemat PEGASUS"
# ---------------------------------------------
$setupSql = @"
-- 1. Przełącz się na właściwą bazę PDB (XEPDB1)
ALTER SESSION SET CONTAINER = $ORACLE_SVC;

"@

if ($Reset) {
    Write-Step "X" "Resetowanie schematu PEGASUS (czyszczenie)..."
    $setupSql += @"
-- Jeśli użytkownik nie istnieje, zignoruj błąd ORA-01918 i idź dalej
WHENEVER SQLERROR CONTINUE;
DROP USER PEGASUS CASCADE;
-- Przywróć rzucanie błędów dla krytycznych operacji
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
"@
}

$setupSql += @"
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;

-- 2. Tworzenie użytkownika PEGASUS
CREATE USER PEGASUS IDENTIFIED BY $pegasusPwd;
GRANT CONNECT, RESOURCE, DBA TO PEGASUS;

EXIT;
"@

Write-Step "X" "Tworzenie uzytkownika i uprawnien PEGASUS..."
$ec = Invoke-OracleSQL "/ as sysdba" $setupSql
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Tworzenie uzytkownika PEGASUS nieudane (exit $LASTEXITCODE)"
}
Write-OK "Uzytkownik PEGASUS utworzony"

# ---------------------------------------------
Write-Step "6/6" "Laduje skrypty SQL – PEGASUS"
# ---------------------------------------------
Invoke-SqlScripts "PEGASUS" $pegasusPwd "/sql"
Write-OK "Skrypty PEGASUS zaladowane"


# ---------------------------------------------
# Weryfikacja obu schematow
# ---------------------------------------------
$verifySql = @"
SET LINESIZE 80
COLUMN owner       FORMAT A10
COLUMN object_type FORMAT A25
COLUMN cnt         FORMAT 9999
SELECT owner, object_type, COUNT(*) cnt
  FROM dba_objects
 WHERE owner IN ('PEGASUS')
 GROUP BY owner, object_type
 ORDER BY 1, 2;
EXIT;
"@
Write-Host ""
Write-Host "  +-- Stan schematow " + ("-" * 30) + "+" -ForegroundColor Cyan
$ec = Invoke-OracleSQL "/ as sysdba" $verifySql
Write-Host ""

# ---------------------------------------------
# Podsumowanie
# ---------------------------------------------
$port = (Get-Content $COMPOSE | Select-String '"\d+:1521"').ToString() -replace '.*"(\d+):1521".*','$1'

Write-Host ""
Write-Host "#===========================================#" -ForegroundColor Green
Write-Host "#            GOTOWE!                        #" -ForegroundColor Green
Write-Host "#===========================================#" -ForegroundColor Green
Write-Host ""
Write-Host "  CloudBeaver (przegladarka):" -ForegroundColor Yellow
Write-Host "    http://localhost:8978" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Dane polaczenia – PEGASUS:" -ForegroundColor White
Write-Host "    Uzytkownik:   PEGASUS"            -ForegroundColor White
Write-Host "    Haslo:        $pegasusPwd"        -ForegroundColor White
Write-Host ""
Write-Host "  Zatrzymanie:  docker compose down"         -ForegroundColor DarkGray
Write-Host "  Pelny reset:  docker compose down -v && .\setup.ps1 -Reset" -ForegroundColor DarkGray
