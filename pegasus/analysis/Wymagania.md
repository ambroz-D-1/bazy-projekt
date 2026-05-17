# Wymagania systemu PEGASUS

## Wymagania funkcjonalne

| ID     | Wymaganie                                                                                             | Priorytet |
|--------|-------------------------------------------------------------------------------------------------------|-----------|
| WF-01  | Użytkownik przegląda feed postów podzielonych na kategorie                                            | Wysoki    |
| WF-02  | Użytkownik może polubić, skomentować i udostępnić post                                                | Wysoki    |
| WF-03  | System rejestruje czas spędzony na każdym poście (TIME_SPENT_SEC)                                    | Wysoki    |
| WF-04  | Każda interakcja aktualizuje profil analityczny użytkownika (trigger/SP_CALCULATE_USER_PROFILE)       | Wysoki    |
| WF-05  | Profil zawiera: preferowaną kategorię, tematy, ENGAGEMENT_SCORE, POLITICAL_LEAN, SOCIAL_CLUSTER_ID   | Wysoki    |
| WF-06  | System generuje digital fingerprint (hash zachowań) dla każdego użytkownika                          | Średni    |
| WF-07  | System wykrywa i flaguje ekspozycję użytkownika na treści ekstremalne (EXTREMISM_EXPOSURE)            | Wysoki    |
| WF-08  | Admin widzi pełny profil analityczny użytkownika (widok V_USER_FULL_PROFILE)                         | Wysoki    |
| WF-09  | Admin filtruje użytkowników wg poglądów, zaangażowania, klastra i flagi ekstremizmu                  | Średni    |
| WF-10  | Użytkownik widzi tylko własne interakcje (widok V_MY_INTERACTIONS)                                   | Wysoki    |
| WF-11  | System generuje ranking postów wg współczynnika zaangażowania                                         | Średni    |
| WF-12  | Admin może oznaczyć post jako wymagający szczególnej uwagi                                            | Średni    |

## Wymagania niefunkcjonalne

| ID      | Wymaganie                                                                                      |
|---------|------------------------------------------------------------------------------------------------|
| WNF-01  | Baza: Oracle XE lokalnie lub Oracle Autonomous DB Free Tier – bez miesięcznych opłat           |
| WNF-02  | Profil analityczny aktualizowany przy każdej interakcji (nie batch, nie raz dziennie)          |
| WNF-03  | Historia interakcji jest nieusuwalna – pełna ścieżka każdego użytkownika                      |
| WNF-04  | Użytkownik nie widzi własnego profilu analitycznego – to dane wewnętrzne systemu               |
| WNF-05  | Separacja uprawnień: Admin widzi wszystko, Użytkownik widzi tylko swoje dane                  |
| WNF-06  | System nie ujawnia algorytmu profilowania użytkownikom                                         |

## Scenariusze

### S-01: Użytkownik wchodzi w interakcję z postem
1. Użytkownik loguje się i otwiera feed.
2. System zaczyna mierzyć czas od otwarcia posta.
3. Użytkownik klika „Lubię" pod postem z kategorii Polityka.
4. System dodaje wpis do LIKES z TIME_SPENT_SEC = czas od otwarcia.
5. SP_CALCULATE_USER_PROFILE aktualizuje: PREFERRED_CATEGORY_ID, POLITICAL_LEAN, ENGAGEMENT_SCORE.
6. Jeśli post jest oznaczony jako ekstremistyczny – EXTREMISM_EXPOSURE użytkownika ustawiane na 1.

### S-02: Admin przegląda profil użytkownika
1. Admin loguje się do panelu i wyszukuje użytkownika po nazwisku lub e-mailu.
2. Otwiera pełny profil – widok V_USER_FULL_PROFILE: preferowana kategoria, tematy, POLITICAL_LEAN, POLITICAL_SCORE, SOCIAL_CLUSTER_ID, DIGITAL_FINGERPRINT.
3. Widzi ostrzeżenie jeśli EXTREMISM_EXPOSURE = 1.
4. Może oznaczyć posty tego użytkownika do dalszego przeglądu.

### S-03: Admin filtruje użytkowników
1. Admin otwiera widok „Analiza użytkowników".
2. Ustawia filtry: POLITICAL_LEAN = 'PRAWICOWY', EXTREMISM_EXPOSURE = 1, ENGAGEMENT_SCORE > 0.8.
3. System zwraca listę pasujących użytkowników z podstawowymi danymi profilu.
4. Admin eksportuje listę lub ręcznie przegląda profile.
