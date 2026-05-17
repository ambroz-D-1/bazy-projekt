# Wymagania systemu OBDN

## Wymagania funkcjonalne

| ID     | Wymaganie                                                                                             | Priorytet |
|--------|-------------------------------------------------------------------------------------------------------|-----------|
| WF-01  | Wyszukiwanie nieruchomości po mieście, dzielnicy, typie, liczbie pokoi, metrażu i przedziale cenowym  | Wysoki    |
| WF-02  | Wyniki wyszukiwania wyświetlane na liście i na mapie interaktywnej (GPS z DZIALKI)                    | Średni    |
| WF-03  | Karta nieruchomości z danymi lokalu, stanem prawnym, hipotekami i historią transakcji                 | Wysoki    |
| WF-04  | Agent może wystawiać, edytować i wycofywać ogłoszenia (SPRZEDAZ / WYNAJEM)                           | Wysoki    |
| WF-05  | Historia zmian ceny każdego ogłoszenia (tabela HISTORIA_CEN_OGLOSZEN)                                | Średni    |
| WF-06  | Deduplikacja ogłoszeń z portali zewnętrznych (hash SHA-256 na id nieruchomości + typ ogłoszenia)      | Średni    |
| WF-07  | Urzędnik aktualizuje dane katastralne, wpisuje i wykreśla hipoteki                                   | Wysoki    |
| WF-08  | Urzędnik rejestruje transakcje kupna/sprzedaży z ceną, datą i danymi notariusza                      | Wysoki    |
| WF-09  | Automatyczny import ogłoszeń z portali zewnętrznych (Otodom, OLX, Gratka...)                         | Niski     |
| WF-10  | System szacuje wartość lokalu na podstawie transakcji z okolicy z ostatnich 12 miesięcy              | Średni    |
| WF-11  | Analityk przegląda statystyki rynkowe (avg/mediana ceny/m², trendy) – zero danych osobowych          | Wysoki    |
| WF-12  | Bank sprawdza wartość i stan prawny nieruchomości (hipoteki, numer KW, historia)                     | Wysoki    |
| WF-13  | Usunięcie konta: dane osobowe anonimizowane, dane transakcyjne i historyczne zostają min. 10 lat     | Wysoki    |
| WF-14  | Obsługa współwłasności z udziałami procentowymi w HISTORIA_WLASNOSCI                                 | Średni    |

## Wymagania niefunkcjonalne

| ID      | Wymaganie                                                                                     |
|---------|-----------------------------------------------------------------------------------------------|
| WNF-01  | Dostępność 24/7; przerwy konserwacyjne tylko nocą, z komunikatem z wyprzedzeniem              |
| WNF-02  | Dane transakcyjne przechowywane minimum 10 lat (RODO); usunąć może tylko administrator       |
| WNF-03  | Baza: Oracle XE lokalnie lub Oracle Autonomous DB Free Tier – bez miesięcznych opłat          |
| WNF-04  | Wyszukiwanie zwraca wyniki poniżej 2 sekund dla typowych zapytań                             |
| WNF-05  | Dane osobowe właścicieli widoczne tylko dla ról z flagą WIDZI_DANE_OSOBOWE = 1               |
| WNF-06  | System nie przechowuje haseł w postaci jawnej                                                 |
| WNF-07  | Każda zmiana właściciela pamiętana z datą – historia jest nieusuwalna                        |

## Scenariusze

### S-01: Obywatel szuka mieszkania
1. Użytkownik otwiera stronę główną i wpisuje kryteria: Kraków, typ MIESZKANIE, 2+ pokoje, cena do 600 000 PLN.
2. System zwraca listę pasujących ogłoszeń (bez duplikatów: JEST_DUPLIKATEM = 0), posortowanych rosnąco po cenie.
3. Użytkownik klika ogłoszenie – widzi kartę z metrażem, piętrem, klasą energetyczną i szacunkową wartością.
4. Widzi historię zmian ceny (wykres) i sprawdza, czy lokal ma aktywną hipotekę.
5. Kontaktuje się z agentem przez dane widoczne w ogłoszeniu.

### S-02: Agent wystawia ogłoszenie
1. Agent loguje się i przechodzi do „Moje ogłoszenia" → „Nowe ogłoszenie".
2. Wyszukuje lokal po numerze EGIB lub adresie.
3. Uzupełnia tytuł, opis, cenę i typ (SPRZEDAZ).
4. Zapisuje jako szkic (STATUS = ROBOCZE) – ogłoszenie nie jest publiczne.
5. Po weryfikacji publikuje (STATUS = AKTYWNE).
6. System oblicza HASH_DEDUPLIKACJI i sprawdza duplikaty.

### S-03: Urzędnik rejestruje transakcję
1. Urzędnik loguje się i otwiera sekcję „Transakcje" → „Zarejestruj".
2. Wyszukuje lokal po numerze EGIB lub KW.
3. Wpisuje cenę, datę, dane notariusza i numer aktu notarialnego.
4. Zatwierdza – system zapisuje transakcję w TRANSAKCJE i aktualizuje HISTORIA_WLASNOSCI (stary wpis AKTYWNA = 0, nowy z DATA_OD = dziś).
5. Procedura SP_OBLICZ_STATYSTYKI_RYNKOWE przelicza statystyki dla danego miasta/dzielnicy.

### S-04: Bank weryfikuje nieruchomość przy kredycie
1. Pracownik banku wyszukuje nieruchomość po numerze KW.
2. System wyświetla aktualną wartość szacunkową, aktywne hipoteki (wierzyciel, kwota, data wpisu) i historię transakcji.
3. Pracownik nie widzi danych osobowych sprzedającego – tylko zagregowane dane transakcyjne.
4. Na tej podstawie bank ocenia wartość zabezpieczenia kredytu.
