-- ============================================================
-- Dane pokazowe
-- Uruchamiac PO 03_views_and_procedures.sql
-- ============================================================

-- ============================================================
-- Dodatkowi uzytkownicy (ID 9-20)
-- ============================================================
INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Tomasz',
        'Wisniewki',
        'tomasz.w@gmail.com',
        '602200300',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Katarzyna',
        'Dabrowska',
        'kasia.d@gmail.com',
        '603300400',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Marek',
        'Grabowski',
        'marek.g@gmail.com',
        '604400500',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Ewa',
        'Szymanska',
        'ewa.sz@gmail.com',
        '605500600',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Premium',
        'Nieruchomosci',
        'biuro@premium.pl',
        '22 555 66 77',
        3
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Metro',
        'Nieruchomosci',
        'kontakt@metro.pl',
        '22 777 88 99',
        3
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, TELEFON, ROLA_ID)
VALUES (
        'Arko',
        'Deweloper',
        'sprzedaz@arko.pl',
        '71 300 400 500',
        4
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Janina',
        'Kowalczyk',
        'j.kowalczyk@starostwo.pl',
        5
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Analizy',
        'PKO',
        'analizy@pkobp.pl',
        6
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Rynek',
        'Nieruchomosci',
        'rynek@bnp.pl',
        7
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Lukasz',
        'Adamczyk',
        'lukasz.a@gmail.com',
        2
    );

INSERT INTO
    USERS (IMIE, NAZWISKO, EMAIL, ROLA_ID)
VALUES (
        'Monika',
        'Jasinska',
        'monika.j@gmail.com',
        2
    );

COMMIT;

-- ============================================================
-- Dodatkowe dzialki (ID 4-7)
-- ============================================================
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
        '021401_1.0004.AR_4.2/7',
        350,
        1,
        51.0950,
        17.0780,
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
        '221201_1.0001.AR_1.4/2',
        600,
        1,
        52.2297,
        21.0122,
        'Warszawa',
        'Warszawa',
        'mazowieckie'
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
        '221201_1.0002.AR_2.9/1',
        450,
        1,
        52.2400,
        21.0200,
        'Warszawa',
        'Warszawa',
        'mazowieckie'
    );

COMMIT;

-- ============================================================
-- Dodatkowe budynki (ID 4-7)
-- ============================================================
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
        4,
        2022,
        'BETON',
        'A',
        'POMPA_CIEPLA',
        4,
        1,
        1,
        '10A',
        'Olesnicka',
        '50-300',
        'Wroclaw',
        'Psie Pole'
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
        5,
        2010,
        'CEGLA',
        'C',
        'GAZOWE',
        5,
        0,
        0,
        '22',
        'Mokotowska',
        '02-500',
        'Warszawa',
        'Mokotow'
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
        6,
        2018,
        'BETON',
        'B',
        'CO_MIEJSKIE',
        7,
        1,
        1,
        '7',
        'Targowa',
        '03-700',
        'Warszawa',
        'Praga Polnoc'
    );

COMMIT;

-- ============================================================
-- Dodatkowe lokale (ID 6-14)
-- ============================================================
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
        4,
        '1',
        1,
        55,
        2,
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
        4,
        '2',
        2,
        88,
        4,
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
        4,
        '3',
        3,
        32,
        1,
        0,
        0,
        'WYSOKI_STANDARD',
        'KAWALERKA'
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
        5,
        '10',
        2,
        67,
        3,
        1,
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
        5,
        '15',
        4,
        48,
        2,
        1,
        0,
        'DO_REMONTU',
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
        6,
        '4',
        1,
        42,
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
        6,
        '20',
        5,
        105,
        4,
        1,
        1,
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
        5,
        '1A',
        0,
        80,
        0,
        0,
        1,
        'DOBRY',
        'LOKAL_UZYTKOWY'
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
        '3',
        2,
        38,
        1,
        0,
        0,
        'DEWELOPERSKI',
        'KAWALERKA'
    );

COMMIT;

-- ============================================================
-- Transakcje – wiecej danych do statystyk (ID 4-12)
-- ============================================================
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
        6,
        15,
        9,
        550000,
        'PLN',
        DATE '2025-01-10',
        'Notariusz Agnieszka Piotrowska',
        'Rep. A Nr 10/2025'
    );

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
        7,
        15,
        10,
        880000,
        'PLN',
        DATE '2025-01-22',
        'Notariusz Agnieszka Piotrowska',
        'Rep. A Nr 22/2025'
    );

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
        8,
        15,
        11,
        320000,
        'PLN',
        DATE '2025-01-28',
        'Notariusz Agnieszka Piotrowska',
        'Rep. A Nr 28/2025'
    );

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
        9,
        4,
        12,
        670000,
        'PLN',
        DATE '2025-02-05',
        'Notariusz Bartosz Kaczmarek',
        'Rep. A Nr 35/2025'
    );

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
        10,
        4,
        13,
        480000,
        'PLN',
        DATE '2025-02-18',
        'Notariusz Bartosz Kaczmarek',
        'Rep. A Nr 40/2025'
    );

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
        11,
        4,
        9,
        420000,
        'PLN',
        DATE '2025-03-01',
        'Notariusz Ewa Malinowska',
        'Rep. A Nr 50/2025'
    );

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
        12,
        4,
        10,
        1050000,
        'PLN',
        DATE '2025-03-15',
        'Notariusz Ewa Malinowska',
        'Rep. A Nr 65/2025'
    );

COMMIT;

-- ============================================================
-- Historia wlasnosci – dodatkowe wpisy
-- ============================================================
INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (6, 9, 100, DATE '2025-01-10', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (7, 10, 100, DATE '2025-01-22', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (8, 11, 100, DATE '2025-01-28', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (9, 12, 100, DATE '2025-02-05', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (10, 13, 100, DATE '2025-02-18', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (11, 9, 100, DATE '2025-03-01', 1);

INSERT INTO
    HISTORIA_WLASNOSCI (
        LOKAL_ID,
        USER_ID,
        UDZIAL_PROCENTOWY,
        DATA_OD,
        AKTYWNA
    )
VALUES (12, 10, 100, DATE '2025-03-15', 1);

COMMIT;

-- ============================================================
-- Dodatkowe ogloszenia (ID 7-15)
-- ============================================================
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
        6,
        15,
        1,
        'SPRZEDAZ',
        'NOWE 2-pokojowe Wroclaw Psie Pole 55m2 z garagem',
        'Nowe budownictwo A+, pompa ciepla, garaz w cenie. Swietna inwestycja.',
        590000,
        'PLN',
        'AKTYWNE'
    );

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
        7,
        15,
        1,
        'SPRZEDAZ',
        'NOWE 4-pokojowe 88m2 Wroclaw Psie Pole',
        'Przestronne 4-pokojowe w nowym budownictwie, klasa A, pompa ciepla.',
        930000,
        'PLN',
        'AKTYWNE'
    );

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
        8,
        15,
        1,
        'SPRZEDAZ',
        'Kawalerka 32m2 Wroclaw Psie Pole – nowe budownictwo',
        'Kawalerka w nowym budynku A+. Idealna na wynajem lub dla single.',
        340000,
        'PLN',
        'AKTYWNE'
    );

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
        9,
        4,
        2,
        'SPRZEDAZ',
        'Mieszkanie 3-pok 67m2 Warszawa Mokotow',
        '3-pokojowe w spokojnej okolicy Mokotowa, balkon, bardzo dobry stan.',
        720000,
        'PLN',
        'AKTYWNE',
        'https://www.otodom.pl/pl/oferta/mieszkanie-3pok-warszawa-mokotow-ID67890'
    );

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
        9,
        4,
        4,
        'SPRZEDAZ',
        'Mokotow 67m2 3 pokoje sprzedam',
        '3pok, 67m2, balkon, Warszawa Mokotow. Stan bardzo dobry.',
        720000,
        'PLN',
        'AKTYWNE',
        'https://gratka.pl/nieruchomosci/mieszkanie-3pok-mokotow-IDxyz'
    );

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
        10,
        4,
        1,
        'WYNAJEM',
        'Mieszkanie do remontu Warszawa Mokotow 48m2',
        '2-pokojowe do remontu, tanio. Swietna lokalizacja Mokotow.',
        2200,
        'PLN',
        'AKTYWNE'
    );

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
        11,
        16,
        1,
        'WYNAJEM',
        'Mieszkanie 2-pokojowe Warszawa Praga Polnoc 42m2',
        'Zadbane 2-pokojowe, dobry stan, blisko metra.',
        2600,
        'PLN',
        'AKTYWNE'
    );

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
        12,
        16,
        1,
        'SPRZEDAZ',
        'Apartament 4-pokojowy Warszawa Praga Polnoc 105m2',
        'Wyjatkowy apartament 4-pokojowy z tarasem. Rzadka okazja.',
        1100000,
        'PLN',
        'AKTYWNE'
    );

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
        14,
        4,
        1,
        'WYNAJEM',
        'Kawalerka Wroclaw Krzyki 38m2 – nowa na rynku',
        'Kawalerka w stanie deweloperskim, mozliwosc wyposazenia pod klucz.',
        2400,
        'PLN',
        'AKTYWNE'
    );

COMMIT;

-- ============================================================
-- Historia cen ogloszen – dodatkowe obniżki
-- ============================================================
INSERT INTO
    HISTORIA_CEN_OGLOSZEN (
        OGLOSZENIE_ID,
        CENA_POPRZEDNIA,
        CENA_NOWA,
        DATA_ZMIANY
    )
VALUES (
        8,
        610000,
        590000,
        TIMESTAMP '2025-02-01 10:00:00'
    );

INSERT INTO
    HISTORIA_CEN_OGLOSZEN (
        OGLOSZENIE_ID,
        CENA_POPRZEDNIA,
        CENA_NOWA,
        DATA_ZMIANY
    )
VALUES (
        9,
        970000,
        930000,
        TIMESTAMP '2025-02-20 14:00:00'
    );

INSERT INTO
    HISTORIA_CEN_OGLOSZEN (
        OGLOSZENIE_ID,
        CENA_POPRZEDNIA,
        CENA_NOWA,
        DATA_ZMIANY
    )
VALUES (
        10,
        750000,
        720000,
        TIMESTAMP '2025-03-01 09:00:00'
    );

INSERT INTO
    HISTORIA_CEN_OGLOSZEN (
        OGLOSZENIE_ID,
        CENA_POPRZEDNIA,
        CENA_NOWA,
        DATA_ZMIANY
    )
VALUES (
        14,
        1150000,
        1100000,
        TIMESTAMP '2025-03-10 11:30:00'
    );

COMMIT;
