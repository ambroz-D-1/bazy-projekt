# OBDN – Ogólnopolska Baza Danych Nieruchomości

## Co to jest

Centralny rejestr nieruchomości w Polsce. Pomysł polega na tym żeby zebrać w jednym miejscu to co teraz jest rozrzucone po kilkunastu różnych systemach – dane katastralne z EGIB, księgi wieczyste z EKW, adresy z TERYT, certyfikaty energetyczne z CEEB, a do tego ogłoszenia z Otodom, OLX, Gratka, Morizon itd.

Wzorzec to coś w stylu Zillow albo Rightmove, ale zintegrowane z polskim prawem i rejestrami. Na razie scope to baza danych – frontend to osobna historia.

---

## Model danych

Trzy poziomy hierarchii nieruchomości:

**Działka** – podstawowa jednostka katastralna. Ma numer EGIB, powierzchnię, przeznaczenie (MN, MW, R, ZL...), lokalizację GPS, przynależność administracyjną i numer KW jeśli jest.

**Budynek** – stoi na działce. Adres, rok budowy, klasa energetyczna, liczba kondygnacji, winda/garaż. Dane z CEEB.

**Lokal** – mieszkanie lub lokal użytkowy w budynku. Numer, piętro, metraż, pokoje, balkon, stan wykończenia. System liczy szacowaną wartość rynkową na podstawie transakcji z okolicy.

Każda zmiana jest pamiętana z datą – historia właścicieli, historia przebudów itp.

---

## Własność i prawo

- kto jest aktualnym właścicielem (obsługa współwłasności z udziałami)
- pełna historia właścicieli od–do
- hipoteki: wierzyciel, kwota, daty wpisu i wykreślenia
- numer księgi wieczystej i właściwy sąd rejonowy
- zarejestrowane transakcje z ceną, datą i notariuszem

---

## Ogłoszenia

Ogłoszenia mogą być wystawiane przez użytkowników albo importowane automatycznie z portali. Ważne mechanizmy:

- historia zmian ceny każdego ogłoszenia
- deduplikacja – jeśli to samo mieszkanie jest na Otodom i OLX, system to wykrywa i łączy rekordy (hash na podstawie id nieruchomości + typ ogłoszenia)
- stany ogłoszenia: Robocze → Aktywne → Zarezerwowane → Sprzedane/Wynajęte/Wycofane

---

## Role użytkowników

Sześć ról, każda widzi co innego:

- **Admin** – wszystko
- **Obywatel** – przegląda oferty i historię własności, bez danych osobowych innych
- **Agent/Biuro** – zarządza własnymi ogłoszeniami, widzi dane kontaktowe klientów
- **Deweloper** – dodaje osiedla i lokale, przyjmuje rezerwacje
- **Urzędnik** – aktualizuje dane katastralne i KW, rejestruje transakcje
- **Bank** – sprawdza wartość i stan prawny nieruchomości przy kredycie
- **Analityk** – tylko zagregowane statystyki, zero danych osobowych

---

## Analityka

- wyszukiwanie po mieście, promieniu, cenie, liczbie pokoi, typie
- statystyki: średnia i mediana ceny/m² per miasto, dzielnica, typ
- szacunkowa wartość lokalu na podstawie transakcji z ostatnich 12 miesięcy z okolicy
- trendy cenowe w czasie

Kalkulator opłacalności wynajmu – do rozważenia, zależy od zakresu projektu.

---

## Wymagania niefunkcjonalne

RODO: użytkownik może usunąć konto (dane osobowe anonimizowane), ale dane historyczne i transakcyjne muszą zostać min. 10 lat.

Dostępność 24/7. Przerwy konserwacyjne tylko nocą i z komunikatem z wyprzedzeniem.

Baza open source (Oracle XE lokalnie lub Oracle Free Tier w chmurze) – bez miesięcznych opłat licencyjnych.
