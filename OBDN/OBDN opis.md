# Ogólnopolska Baza Danych Nieruchomości (OBDN)

**Zleceniodawca:** grupa A

---

## 1. Czego chcemy

Zamawiamy centralny system informatyczny, który połączy w jednym miejscu wszystkie informacje o nieruchomościach w Polsce: działkach, budynkach i mieszkaniach; razem z historią właścicieli, ogłoszeniami sprzedaży i wynajmu oraz cenami transakcji. Dziś te dane są rozproszone po dziesiątkach systemów: starostwach, sądach, portalach ogłoszeniowych i urzędach gmin. Chcemy to zmienić.

Wyobrażamy sobie coś zbliżonego do Zillow (USA) lub Rightmove (UK), ale zintegrowanego z polskimi rejestrami państwowymi: **EGIB, EKW, TERYT, CEEB**. Dane z tych rejestrów mają trafiać do systemu automatycznie, bez ręcznego przepisywania.

---

## 2. Kto będzie korzystał

System obsługuje sześć różnych grup użytkowników, a każda potrzebuje innych funkcji i powinna widzieć tylko swoje dane:

- **Obywatele** — szukają mieszkania lub domu, przeglądają oferty i historię własności
- **Agenci i biura nieruchomości** — wystawiają ogłoszenia, zarządzają portfelem ofert
- **Deweloperzy** — prezentują projekty osiedli, przyjmują rezerwacje lokali
- **Urzędnicy** — aktualizują dane katastralne, weryfikują dokumenty
- **Banki** — sprawdzają wartość i stan prawny nieruchomości przy kredytach hipotecznych
- **Analitycy** — korzystają z zagregowanych statystyk rynkowych bez danych osobowych

---

## 3. Jakie dane ma zbierać

### Nieruchomości (trzy poziomy)

- **Działka katastralna:** numer EGIB, powierzchnia, przeznaczenie, lokalizacja GPS
- **Budynek:** rok budowy, materiał, klasa energetyczna, ogrzewanie, winda, garaż
- **Lokal:** piętro, metraż, liczba pokoi, balkon, parking, stan wykończenia

System musi pamiętać historię zmian — jeśli mieszkanie zostało przebudowane lub zmieniło właściciela, chcemy wiedzieć jak wyglądało wcześniej i od kiedy obowiązuje aktualny stan.

### Własność i historia prawna

- Aktualny właściciel z udziałem procentowym (obsługa współwłasności)
- Pełna historia właścicieli z datami (kto i kiedy)
- Hipoteki, służebności i inne obciążenia nieruchomości
- Numer księgi wieczystej; każda transakcja z ceną, datą i notariuszem

### Ogłoszenia i oferty

- Ogłoszenia wystawiane przez użytkowników systemu
- Oferty pobierane automatycznie z Otodom, OLX, Gratka, Morizon i innych portali
- Historia zmian ceny każdego ogłoszenia
- Jeśli to samo mieszkanie jest na kilku portalach, system ma to wykryć i pokazać jako jeden rekord, nie kilka oddzielnych ogłoszeń

### Analityka rynkowa

- Średnie i mediany cen per miasto, dzielnica i typ nieruchomości
- Szacunkowa wartość lokalu na podstawie podobnych transakcji w okolicy
- Kalkulator opłacalności wynajmu

---

## 4. Jak ma działać

### Wyszukiwanie

Użytkownik podaje kryteria: miasto lub promień od punktu na mapie, przedział cenowy, liczba pokoi, typ nieruchomości — i dostaje listę pasujących ogłoszeń widoczną na liście i na mapie interaktywnej. Wyniki muszą się pojawiać w ciągu kilku sekund.

### Historia i stan prawny

Po kliknięciu na nieruchomość użytkownik widzi jej pełną historię: poprzednich właścicieli, ceny transakcji, aktualny stan hipoteki i inne obciążenia. Dane mają być powiązane z księgami wieczystymi, bez ręcznego przepisywania tych samych informacji dwa razy.

---

## 5. Nasze wymagania wobec wykonawcy

- System zgodny z RODO, chroniący dane osobowe z prawem do usunięcia konta
- Dane historyczne i transakcyjne przechowywane przez co najmniej 10 lat, nie do skasowania przez zwykłych użytkowników
- Dostępność 24/7, przerwy konserwacyjne tylko w nocy, z wyprzedzeniem
- Kod źródłowy i dokumentacja należą do zamawiającego (brak uzależnienia od jednej firmy)
- Preferujemy open source bez miesięcznych opłat licencyjnych
- Dokumentacja napisana zrozumiałym językiem, nie tylko dla programistów

---

> Oczekujemy również, że wykonawca dopyta o szczegóły i przedstawi kompletne rozwiązanie.
