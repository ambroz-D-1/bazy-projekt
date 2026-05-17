-- Dane testowe – slowniki + uzytkownicy + nieruchomosci + interakcje
-- Uruchamiac po 01_create_tables.sql

-- Role uzytkownikow (7 rol)
INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'ADMIN',
        'Administrator – pelny dostep do wszystkich danych i funkcji systemu',
        1,
        1,
        1,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'OBYWATEL',
        'Obywatel – przegladanie ofert i historii wlasnosci, wlasne ogloszenia',
        1,
        0,
        0,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'AGENT',
        'Agent / biuro nieruchomosci – zarzadzanie portfelem ofert',
        1,
        1,
        0,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'DEWELOPER',
        'Deweloper – prezentacja projektow osiedli, rezerwacje lokali',
        1,
        1,
        0,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'URZEDNIK',
        'Urzednik – aktualizacja danych katastralnych, hipoteki, transakcje',
        0,
        1,
        1,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'BANK',
        'Bank – weryfikacja wartosci i stanu prawnego nieruchomosci przy kredytach',
        0,
        1,
        0,
        0
    );

INSERT INTO
    ROLE_UZYTKOWNIKOW (
        NAZWA,
        OPIS,
        MOZE_WYSTAWIAC_OGLOSZENIA,
        WIDZI_DANE_OSOBOWE,
        MOZE_AKTUALIZOWAC_KATASTER,
        TYLKO_DANE_AGREGOWANE
    )
VALUES (
        'ANALITYK',
        'Analityk rynkowy – zagregowane statystyki bez danych osobowych',
        0,
        0,
        0,
        1
    );

COMMIT;

-- Przeznaczenie gruntow
INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'MIESZKALNE',
        'Grunty przeznaczone pod zabudowe mieszkaniowa'
    );

INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'KOMERCYJNE',
        'Grunty przeznaczone pod zabudowe uslugowa i handlowa'
    );

INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'ROLNE',
        'Grunty rolne – pola uprawne, laki, pastwiska'
    );

INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'LESNE',
        'Grunty lesne i zadrzewione'
    );

INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'REKREACYJNE',
        'Grunty rekreacyjne i wypoczynkowe'
    );

INSERT INTO
    PRZEZNACZENIE_GRUNTOW (NAZWA, OPIS)
VALUES (
        'PRZEMYSLOWE',
        'Grunty przeznaczone pod dzialalnosc przemyslowa i magazynowa'
    );

COMMIT;

-- Zrodla ogloszen (system + 4 portale zewnetrzne)
INSERT INTO
    ZRODLA_OGLOSZEN (NAZWA, URL_BAZOWY, AKTYWNE)
VALUES (
        'SYSTEM_OBDN',
        NULL,
        1
    );

INSERT INTO
    ZRODLA_OGLOSZEN (NAZWA, URL_BAZOWY, AKTYWNE)
VALUES (
        'OTODOM',
        'https://www.otodom.pl',
        1
    );

INSERT INTO
    ZRODLA_OGLOSZEN (NAZWA, URL_BAZOWY, AKTYWNE)
VALUES (
        'OLX',
        'https://www.olx.pl/nieruchomosci',
        1
    );

INSERT INTO
    ZRODLA_OGLOSZEN (NAZWA, URL_BAZOWY, AKTYWNE)
VALUES (
        'GRATKA',
        'https://gratka.pl/nieruchomosci',
        1
    );

INSERT INTO
    ZRODLA_OGLOSZEN (NAZWA, URL_BAZOWY, AKTYWNE)
VALUES (
        'MORIZON',
        'https://www.morizon.pl',
        1
    );

COMMIT;

-- Uzytkownicy (8 podstawowych – po jednym z kazdej roli)
INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Admin',
        'OBDN',
        'admin@obdn.gov.pl',
        1
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Jan',
        'Kowalski',
        'jan.kowalski@gmail.com',
        '600100200',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Anna',
        'Nowak',
        'anna.nowak@gmail.com',
        '601100300',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Biuro',
        'Nieruchomosci',
        'biuro@nieruchomosci.pl',
        '22 123 45 67',
        3
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Invest',
        'Deweloper',
        'inwest@deweloper.pl',
        '22 987 65 43',
        4
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Piotr',
        'Urzedowski',
        'urzednik@starostwo.pl',
        5
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Analityk',
        'Bankowy',
        'analityk@bank.pl',
        6
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Maria',
        'Rynkowa',
        'rynek@analityka.pl',
        7
    );

COMMIT;

-- Dzialki katastralne (3 dzialki)
INSERT INTO
    DZIALKI (
        NUMER_EGIB,
        POWIERZCHNIA_M2,
        PRZEZNACZENIE_ID,
        WSPOLRZEDNE_LAT,
        WSPOLRZEDNE_LON,
        GMINA,
        POWIAT,
        WOJEWODZTWO
    )
VALUES (
        '021401_1.0001.AR_1.1/5',
        500,
        1,
        51.0836,
        17.0613,
        'Wroclaw',
        'Wroclaw',
        'dolnoslaskie'
    );

INSERT INTO
    DZIALKI (
        NUMER_EGIB,
        POWIERZCHNIA_M2,
        PRZEZNACZENIE_ID,
        WSPOLRZEDNE_LAT,
        WSPOLRZEDNE_LON,
        GMINA,
        POWIAT,
        WOJEWODZTWO
    )
VALUES (
        '126101_1.0002.AR_2.8/3',
        800,
        1,
        50.0613,
        19.9375,
        'Krakow',
        'Krakow',
        'malopolskie'
    );

INSERT INTO
    DZIALKI (
        NUMER_EGIB,
        POWIERZCHNIA_M2,
        PRZEZNACZENIE_ID,
        WSPOLRZEDNE_LAT,
        WSPOLRZEDNE_LON,
        GMINA,
        POWIAT,
        WOJEWODZTWO
    )
VALUES (
        '021401_1.0003.AR_3.5/1',
        1200,
        2,
        51.1000,
        17.0300,
        'Wroclaw',
        'Wroclaw',
        'dolnoslaskie'
    );

COMMIT;

-- Budynki (po jednym na kazda dzialke)
INSERT INTO
    BUDYNKI (
        DZIALKA_ID,
        ROK_BUDOWY,
        MATERIAL_KONSTRUKCJI,
        KLASA_ENERGETYCZNA,
        TYP_OGRZEWANIA,
        LICZBA_PITER,
        WINDA,
        GARAZ,
        NUMER_ADRESOWY,
        ULICA,
        KOD_POCZTOWY,
        MIASTO,
        DZIELNICA
    )
VALUES (
        1,
        2000,
        'CEGLA',
        'C',
        'CO_MIEJSKIE',
        4,
        0,
        0,
        '5',
        'Rozana',
        '50-100',
        'Wroclaw',
        'Krzyki'
    );

INSERT INTO
    BUDYNKI (
        DZIALKA_ID,
        ROK_BUDOWY,
        MATERIAL_KONSTRUKCJI,
        KLASA_ENERGETYCZNA,
        TYP_OGRZEWANIA,
        LICZBA_PITER,
        WINDA,
        GARAZ,
        NUMER_ADRESOWY,
        ULICA,
        KOD_POCZTOWY,
        MIASTO,
        DZIELNICA
    )
VALUES (
        2,
        2015,
        'BETON',
        'B',
        'GAZOWE',
        6,
        1,
        1,
        '12',
        'Sloneczna',
        '30-200',
        'Krakow',
        'Bronowice'
    );

INSERT INTO
    BUDYNKI (
        DZIALKA_ID,
        ROK_BUDOWY,
        MATERIAL_KONSTRUKCJI,
        KLASA_ENERGETYCZNA,
        TYP_OGRZEWANIA,
        LICZBA_PITER,
        WINDA,
        GARAZ,
        NUMER_ADRESOWY,
        ULICA,
        KOD_POCZTOWY,
        MIASTO,
        DZIELNICA
    )
VALUES (
        3,
        1985,
        'WIELKA_PLYTA',
        'E',
        'CO_MIEJSKIE',
        9,
        1,
        0,
        '3',
        'Lipowa',
        '50-200',
        'Wroclaw',
        'Srodmiescie'
    );

COMMIT;

-- Lokale (5 lokali w 3 budynkach)
INSERT INTO
    LOKALE (
        BUDYNEK_ID,
        NUMER_LOKALU,
        PIETRO,
        METRAZ_M2,
        LICZBA_POKOI,
        BALKON,
        PARKING,
        STAN_WYKONCZENIA,
        TYP_LOKALU
    )
VALUES (
        1,
        '1',
        1,
        45,
        2,
        0,
        0,
        'DOBRY',
        'MIESZKANIE'
    );

INSERT INTO
    LOKALE (
        BUDYNEK_ID,
        NUMER_LOKALU,
        PIETRO,
        METRAZ_M2,
        LICZBA_POKOI,
        BALKON,
        PARKING,
        STAN_WYKONCZENIA,
        TYP_LOKALU
    )
VALUES (
        1,
        '5',
        3,
        62,
        3,
        1,
        0,
        'BARDZO_DOBRY',
        'MIESZKANIE'
    );

INSERT INTO
    LOKALE (
        BUDYNEK_ID,
        NUMER_LOKALU,
        PIETRO,
        METRAZ_M2,
        LICZBA_POKOI,
        BALKON,
        PARKING,
        STAN_WYKONCZENIA,
        TYP_LOKALU
    )
VALUES (
        2,
        '2',
        2,
        54,
        2,
        1,
        0,
        'BARDZO_DOBRY',
        'MIESZKANIE'
    );

INSERT INTO
    LOKALE (
        BUDYNEK_ID,
        NUMER_LOKALU,
        PIETRO,
        METRAZ_M2,
        LICZBA_POKOI,
        BALKON,
        PARKING,
        STAN_WYKONCZENIA,
        TYP_LOKALU
    )
VALUES (
        2,
        '8',
        4,
        78,
        3,
        1,
        1,
        'WYSOKI_STANDARD',
        'MIESZKANIE'
    );

INSERT INTO
    LOKALE (
        BUDYNEK_ID,
        NUMER_LOKALU,
        PIETRO,
        METRAZ_M2,
        LICZBA_POKOI,
        BALKON,
        PARKING,
        STAN_WYKONCZENIA,
        TYP_LOKALU
    )
VALUES (
        3,
        '1',
        0,
        30,
        1,
        0,
        0,
        'DO_REMONTU',
        'KAWALERKA'
    );

COMMIT;

-- Ksiegi wieczyste
INSERT INTO
    KSIEGI_WIECZYSTE (
        NUMER_KW,
        SAD_WIECZYSTOKSIEGOWY,
        DZIALKA_ID,
        DATA_ZALOZENIA
    )
VALUES (
        'WR1K/00012345/6',
        'Sad Rejonowy dla Wroclawia-Krzyki',
        1,
        DATE '1995-03-15'
    );

INSERT INTO
    KSIEGI_WIECZYSTE (
        NUMER_KW,
        SAD_WIECZYSTOKSIEGOWY,
        DZIALKA_ID,
        DATA_ZALOZENIA
    )
VALUES (
        'KR1P/00067890/2',
        'Sad Rejonowy dla Krakowa-Krowodrzy',
        2,
        DATE '2010-06-01'
    );

INSERT INTO
    KSIEGI_WIECZYSTE (
        NUMER_KW,
        SAD_WIECZYSTOKSIEGOWY,
        DZIALKA_ID,
        DATA_ZALOZENIA
    )
VALUES (
        'WR1K/00054321/8',
        'Sad Rejonowy dla Wroclawia-Srodmiescie',
        3,
        DATE '1980-01-20'
    );

COMMIT;

-- Historia wlasnosci
-- Lokal 1 (45m2, Rozana 5/1 Wroclaw): Jan Kowalski od 2020
INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (1, 2, 100, DATE '2020-01-15', 1);

-- Lokal 2 (62m2, Rozana 5/5): wspolwlasnosc 50/50 Anna+Jan od 2022
INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (2, 3, 50, DATE '2022-06-01', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (2, 2, 50, DATE '2022-06-01', 1);

-- Lokal 3 (54m2, Sloneczna 12/2 Krakow): Anna sprzedala 2023-01-01
INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        DATA_DO,
        AKTYWNA
    )
VALUES (3, 3, 100, DATE '2019-05-10', DATE '2023-01-01', 0);

-- Lokal 3: Jan Kowalski nabyl 2023-01-01
INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (3, 2, 100, DATE '2023-01-01', 1);

COMMIT;

-- Hipoteki
-- Lokal 1: PKO Bank (kupno na kredyt)
INSERT INTO
    HIPOTEKI (
        LOKAL_ID,
        WIERZYCIEL,
        KWOTA,
        WALUTA,
        DATA_WPISU,
        AKTYWNA
    )
VALUES (
        1,
        'PKO Bank Polski S.A.',
        250000,
        'PLN',
        DATE '2020-01-15',
        1
    );

-- Lokal 3: Santander (po zakupie przez Jana)
INSERT INTO
    HIPOTEKI (
        LOKAL_ID,
        WIERZYCIEL,
        KWOTA,
        WALUTA,
        DATA_WPISU,
        AKTYWNA
    )
VALUES (
        3,
        'Santander Bank Polska S.A.',
        300000,
        'PLN',
        DATE '2023-01-05',
        1
    );

COMMIT;

-- Transakcje
-- Lokal 3: sprzedaz Anna->Jan 2023-01-01
INSERT INTO
    TRANSAKCJE (
        LOKAL_ID,
        SPRZEDAJACY_ID,
        KUPUJACY_ID,
        CENA,
        WALUTA,
        DATA_TRANSAKCJI,
        NOTARIUSZ,
        NUMER_AKTU
    )
VALUES (
        3,
        3,
        2,
        320000,
        'PLN',
        DATE '2023-01-01',
        'Notariusz Marek Adamski',
        'Rep. A Nr 123/2023'
    );

-- Lokal 4: sprzedaz od dewelopera 2022-06-15
INSERT INTO
    TRANSAKCJE (
        LOKAL_ID,
        SPRZEDAJACY_ID,
        KUPUJACY_ID,
        CENA,
        WALUTA,
        DATA_TRANSAKCJI,
        NOTARIUSZ,
        NUMER_AKTU
    )
VALUES (
        4,
        5,
        3,
        480000,
        'PLN',
        DATE '2022-06-15',
        'Notariusz Ewa Malinowska',
        'Rep. A Nr 456/2022'
    );

-- Lokal 5: starsza transakcja 2021-03-20
INSERT INTO
    TRANSAKCJE (
        LOKAL_ID,
        SPRZEDAJACY_ID,
        KUPUJACY_ID,
        CENA,
        WALUTA,
        DATA_TRANSAKCJI,
        NOTARIUSZ,
        NUMER_AKTU
    )
VALUES (
        5,
        NULL,
        2,
        180000,
        'PLN',
        DATE '2021-03-20',
        'Notariusz Krzysztof Wiśniewski',
        'Rep. A Nr 789/2021'
    );

COMMIT;

-- Ogloszenia (mix wlasnych i z portali, z dubletem)
-- Lokal 1 na wynajem (Jan Kowalski, wlasny system)
INSERT INTO
    OGLOSZENIA (
        LOKAL_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        OPIS,
        CENA,
        WALUTA,
        STATUS
    )
VALUES (
        1,
        2,
        1,
        'WYNAJEM',
        'Wynajme 2-pokojowe mieszkanie Wroclaw Krzyki – 45m2',
        'Zadbane mieszkanie 2-pokojowe, 45m2, 1p., brak balkonu. Idealne dla pary lub singli.',
        2800,
        'PLN',
        'AKTYWNE'
    );

-- Lokal 2 na sprzedaz (agent, wlasny system)
INSERT INTO
    OGLOSZENIA (
        LOKAL_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        OPIS,
        CENA,
        WALUTA,
        STATUS
    )
VALUES (
        2,
        4,
        1,
        'SPRZEDAZ',
        'Sprzedam 3-pokojowe Wroclaw Krzyki – 62m2 z balkonem',
        'Przestronne 3-pokojowe, 62m2, 3p., balkon, bardzo dobry stan. Spokojna okolica.',
        450000,
        'PLN',
        'AKTYWNE'
    );

-- Lokal 3 na wynajem – z Otodom (Jan Kowalski wystawil na portalu zewnetrznym)
INSERT INTO
    OGLOSZENIA (
        LOKAL_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        OPIS,
        CENA,
        WALUTA,
        STATUS,
        URL_ZRODLOWY
    )
VALUES (
        3,
        2,
        2,
        'WYNAJEM',
        'Mieszkanie 2-pokojowe Krakow Bronowice 54m2',
        'Bardzo ladne 2-pokojowe, 54m2, balkon, swietna lokalizacja w Bronowicach.',
        2500,
        'PLN',
        'AKTYWNE',
        'https://www.otodom.pl/pl/oferta/mieszkanie-2-pok-krakow-bronowice-54m2-ID12345'
    );

-- Lokal 3 na wynajem – z OLX (DUPLIKAT poprzedniego!)
INSERT INTO
    OGLOSZENIA (
        LOKAL_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        OPIS,
        CENA,
        WALUTA,
        STATUS,
        URL_ZRODLOWY
    )
VALUES (
        3,
        2,
        3,
        'WYNAJEM',
        '54m2 Krakow Bronowice wynajem – 2 pokoje',
        '2 pokoje, 54m2, balkon, Krakow Bronowice, bardzo ladne.',
        2500,
        'PLN',
        'AKTYWNE',
        'https://www.olx.pl/d/oferta/54m2-krakow-bronowice-2-pokoje-CID3-IDabcde.html'
    );

-- Lokal 4 – wycofane ogloszenie (po sprzedazy)
INSERT INTO
    OGLOSZENIA (
        LOKAL_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        CENA,
        WALUTA,
        STATUS
    )
VALUES (
        4,
        5,
        1,
        'SPRZEDAZ',
        'NOWE 3-pokojowe 78m2 Krakow Bronowice – deweloper',
        520000,
        'PLN',
        'WYCOFANE'
    );

-- Dzialka 1 na sprzedaz (przez agenta)
INSERT INTO
    OGLOSZENIA (
        DZIALKA_ID,
        WYSTAWIAJACY_ID,
        ZRODLO_ID,
        TYP_OGLOSZENIA,
        TYTUL,
        OPIS,
        CENA,
        WALUTA,
        STATUS
    )
VALUES (
        1,
        4,
        1,
        'SPRZEDAZ',
        'Dzialka budowlana 500m2 Wroclaw Krzyki',
        'Dzialka pod zabudowe jednorodzinna, media w drodze, dobra komunikacja.',
        150000,
        'PLN',
        'AKTYWNE'
    );

COMMIT;

-- Historia cen ogloszen
-- Lokal 2: cena obnizyla sie z 480000 do 450000
INSERT INTO
    HISTORIA_CEN_OGLOSZEN (
        OGLOSZENIE_ID,
        CENA_POPRZEDNIA,
        CENA_NOWA,
        DATA_ZMIANY
    )
VALUES (
        2,
        480000,
        450000,
        TIMESTAMP '2025-02-15 12:00:00'
    );

COMMIT;
