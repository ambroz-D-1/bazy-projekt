# Ogólnopolska Baza Danych Nieruchomości (OBDN)

## Co to jest

Centralny system informatyczny łączący w jednym miejscu wszystkie informacje o
nieruchomościach w Polsce: działkach, budynkach i mieszkaniach; razem z historią
właścicieli, ogłoszeniami sprzedaży i wynajmu oraz cenami transakcji.

System integruje dane z rozproszonych rejestrów państwowych (EGIB, EKW, TERYT, CEEB)
oraz portali ogłoszeniowych (Otodom, OLX, Gratka, Morizon). Wzorzec: Zillow/Rightmove,
ale zintegrowany z polskim prawem i rejestrami.

---

## Dane o nieruchomościach (trzy poziomy)

**Działka katastralna** – numer EGIB, powierzchnia, przeznaczenie, lokalizacja GPS,
gmina, powiat, województwo, numer księgi wieczystej.

**Budynek** – rok budowy, materiał konstrukcji, klasa energetyczna, typ ogrzewania,
liczba pięter, winda, garaż, pełny adres (ulica, numer, kod pocztowy, miasto, dzielnica).

**Lokal** – numer lokalu, piętro, metraż, liczba pokoi, balkon, parking, stan
wykończenia, typ lokalu (mieszkanie / kawalerka / lokal użytkowy). Pole szacowanej
wartości rynkowej aktualizowane przez system.

System przechowuje **pełną historię zmian** – każda przebudowa lub zmiana właściciela
jest rejestrowana z datą.

---

## Własność i historia prawna

- Aktualny właściciel z udziałem procentowym (obsługa współwłasności).
- Pełna historia właścicieli z datami „od–do".
- Hipoteki i inne obciążenia (wierzyciel, kwota, daty wpisu i wykreślenia).
- Numer księgi wieczystej i właściwy sąd.
- Każda transakcja z ceną, datą i notariuszem.

---

## Ogłoszenia i oferty

- Ogłoszenia wystawiane przez użytkowników systemu.
- Oferty pobierane automatycznie z Otodom, OLX, Gratka, Morizon i innych portali.
- Historia zmian ceny każdego ogłoszenia.
- Wykrywanie duplikatów: jeśli to samo mieszkanie jest na kilku portalach, system
  łączy je w jeden rekord (deduplikacja na podstawie hasha adres+typ).
- Cykl życia ogłoszenia: Robocze → Aktywne → Zarezerwowane → Sprzedane/Wynajęte / Wycofane.

---

## Użytkownicy – sześć ról

| Rola | Co robi |
|---|---|
| **Obywatel** | Przegląda oferty, historia własności |
| **Agent/Biuro** | Wystawia ogłoszenia, zarządza portfelem ofert |
| **Deweloper** | Prezentuje osiedla, przyjmuje rezerwacje |
| **Urzędnik** | Aktualizuje dane katastralne, weryfikuje dokumenty |
| **Bank** | Sprawdza wartość i stan prawny przy kredycie |
| **Analityk** | Zagregowane statystyki rynkowe bez danych osobowych |

---

## Co chcemy z tego wyciągnąć

- Wyszukiwanie po mieście / promieniu od punktu na mapie, cenie, liczbie pokoi, typie.
- Wyniki na liście i mapie interaktywnej w ciągu kilku sekund.
- Historia własności i stan hipoteki po kliknięciu na nieruchomość.
- Średnie i mediany cen na m² per miasto, dzielnica i typ nieruchomości.
- Szacunkowa wartość lokalu na podstawie podobnych transakcji z okolicy.
- Kalkulator opłacalności wynajmu.

---

## Kto co widzi

- **Admin** – dostęp do wszystkiego.
- **Urzędnik** – zarządza danymi katastralnymi i prawnymi; widzi dane osobowe.
- **Agent / Deweloper** – zarządza własnymi ogłoszeniami; widzi dane kontaktowe.
- **Bank** – wgląd w hipoteki i wyceny; widzi dane osobowe w zakresie kredytowym.
- **Obywatel** – przegląda oferty i historię własności nieruchomości.
- **Analityk** – wyłącznie zagregowane statystyki, bez danych osobowych.

---

## Technologia

Oracle Database – uruchamiana lokalnie przez Docker lub przez przeglądarkę
na livesql.oracle.com bez żadnej instalacji.

## Wymagania niefunkcjonalne

- Zgodność z RODO: prawo do usunięcia konta (dane osobowe anonimizowane), ale
  dane historyczne i transakcyjne przechowywane min. 10 lat i nieusuwalne przez
  zwykłych użytkowników.
- Dostępność 24/7; przerwy konserwacyjne wyłącznie nocą z wyprzedzeniem.
- Kod źródłowy i dokumentacja należą do zamawiającego.
- Open source bez miesięcznych opłat licencyjnych.
