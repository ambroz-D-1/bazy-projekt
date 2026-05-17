# Projekt UI – OBDN

Interfejs webowy. Poniżej opis ekranów i formularzy – implementacja frontendu poza zakresem projektu bazodanowego.

---

## Ekran 1: Strona główna – wyszukiwarka

Centered search box, brak rejestracji wymaganej do wyszukiwania.

```
+-----------------------------------------------------------+
|  Ogólnopolska Baza Danych Nieruchomości                   |
|                                                           |
|  Miasto / dzielnica:  [_____________________________]     |
|                                                           |
|  Typ:    [Mieszkanie v]   Pokoje: [dowolna v]             |
|  Cena:   [________] – [________] PLN                      |
|  Metraż: [________] – [________] m²                       |
|                                                           |
|                    [  Szukaj  ]                           |
+-----------------------------------------------------------+
```

---

## Ekran 2: Wyniki wyszukiwania

Widok dwupanelowy – lista po lewej, mapa (Leaflet/Google Maps) po prawej.

```
+------------------------+----------------------------------+
| Wyniki (127 ogłoszeń)  |                                  |
|  Sortuj: [cena ASC v]  |         [ mapa ]                 |
|                        |                                  |
| +--------------------+ |   o  o    o                      |
| | ul. Karmelicka 5   | |      o                           |
| | 52 m², 3 pok., 3p  | |                                  |
| | winda, balkon      | |                                  |
| | 550 000 PLN        | |                                  |
| | [szczegóły >]      | |                                  |
| +--------------------+ |                                  |
| +--------------------+ |                                  |
| | ...                | |                                  |
| +--------------------+ |                                  |
+------------------------+----------------------------------+
```

Kliknięcie markera na mapie podświetla odpowiedni wiersz na liście i odwrotnie.

---

## Ekran 3: Karta nieruchomości

```
ul. Karmelicka 5/12, Kraków – Stare Miasto
════════════════════════════════════════════

[Dane lokalu]          [Stan prawny]          [Historia ceny]
Metraż: 52 m²          KW: KR1P/0012345/6     wykres liniowy
Piętro: 3/5            Hipoteka: BRAK         2024-01: 580 000
Pokoje: 3              Właściciel: ***        2024-06: 560 000
Balkon: TAK                                   2025-01: 550 000
Stan: DOBRY

[Dane budynku]         [Szacunkowa wartość]
Rok budowy: 1998       ~547 000 PLN
Materiał: CEGLA        (śr. transakcji w promieniu 500 m,
Ogrzewanie: GAZOWE     ostatnie 12 mies.)
Winda: TAK
Klasa energ.: C

[Historia transakcji]
Data            Cena          Typ
2018-03-15      380 000 PLN   sprzedaż
2023-10-01      490 000 PLN   sprzedaż
```

Dane osobowe właściciela zastąpione gwiazdkami dla ról bez WIDZI_DANE_OSOBOWE.

---

## Ekran 4: Panel Agenta – zarządzanie ogłoszeniami

```
Moje ogłoszenia                        [+ Nowe ogłoszenie]
──────────────────────────────────────────────────────────
Tytuł                       Status        Cena       Akcje
Mieszkanie Krak. 52 m²      AKTYWNE       550 000    [edytuj] [wycofaj]
Lokal uż. Śródmieście        ROBOCZE       —          [publikuj] [usuń]
Kawalerka Nowa Huta          ZAREZERWOWANE 310 000    [podgląd]
```

### Formularz nowego / edycji ogłoszenia

| Pole                   | Typ wejścia                              |
|------------------------|------------------------------------------|
| Lokal                  | autocomplete po EGIB lub adresie         |
| Typ ogłoszenia         | radio: Sprzedaż / Wynajem                |
| Tytuł                  | text, max 300 znaków                     |
| Opis                   | textarea, max 4000 znaków                |
| Cena                   | number (PLN)                             |
| Data wygaśnięcia       | datepicker                               |

Po zapisie jako ROBOCZE przycisk „Opublikuj" zmienia status na AKTYWNE.

---

## Ekran 5: Panel Urzędnika

Zakładki górne: **Działki** | **Budynki** | **Lokale** | **Transakcje** | **Hipoteki** | **Księgi wieczyste**

### Formularz rejestracji transakcji

| Pole                  | Typ wejścia                              |
|-----------------------|------------------------------------------|
| Nieruchomość          | autocomplete po EGIB lub numerze KW      |
| Sprzedający           | autocomplete po nazwisku / user_id       |
| Kupujący              | autocomplete po nazwisku / user_id       |
| Cena                  | number (PLN)                             |
| Data transakcji       | datepicker                               |
| Notariusz             | text                                     |
| Numer aktu not.       | text                                     |

Po zatwierdzeniu system automatycznie:
- zamyka stary wpis w HISTORIA_WLASNOSCI (DATA_DO = dziś, AKTYWNA = 0)
- tworzy nowy wpis (DATA_OD = dziś, AKTYWNA = 1)
- przelicza statystyki rynkowe (SP_OBLICZ_STATYSTYKI_RYNKOWE)

### Formularz wpisu hipoteki

| Pole                  | Typ wejścia                              |
|-----------------------|------------------------------------------|
| Nieruchomość          | autocomplete po EGIB lub numerze KW      |
| Wierzyciel            | text                                     |
| Kwota                 | number (PLN)                             |
| Data wpisu            | datepicker (domyślnie: dziś)             |

---

## Ekran 6: Panel Analityka

Dashboard tylko do odczytu. Zero danych osobowych.

```
Statystyki rynkowe – Kraków, Stare Miasto, MIESZKANIE
Okres: 2025-01 – 2025-12

  Śr. cena/m²:    14 200 PLN   (+3.2% vs rok temu)
  Mediana ceny/m²: 13 800 PLN
  Liczba trans.:   47

  [wykres liniowy: śr. cena/m² miesiąc po miesiącu]

  Rozkład typów:
  MIESZKANIE 61%  KAWALERKA 22%  LOKAL_UZY 17%
```

Filtry: miasto, dzielnica, typ nieruchomości, rok, miesiąc.

---

## Ekran 7: Panel Banku

- Wyszukiwanie po numerze KW lub adresie
- Widok tylko do odczytu: wartość szacunkowa + aktywne hipoteki + historia transakcji
- Przycisk „Eksportuj raport PDF" generuje dokument z pieczęcią systemową
- Brak możliwości edycji czegokolwiek

---

## Ekran 8: Panel Administratora

```
Użytkownicy systemu                         [+ Dodaj użytkownika]
──────────────────────────────────────────────────────────────────
Imię i nazwisko     Rola         Status     Akcje
Anna Kowalska       AGENT        AKTYWNY    [edytuj] [zawieś]
Tomasz Wiśniewski   URZEDNIK     AKTYWNY    [edytuj]
Jan Nowak           ANALITYK     ZAWIESZONY [przywróć] [usuń]
```

Dodatkowe opcje admina:
- Ręczne uruchomienie SP_DEDUPLIKUJ_OGLOSZENIA
- Ręczne uruchomienie SP_OBLICZ_STATYSTYKI_RYNKOWE
- Podgląd logów błędów systemowych
