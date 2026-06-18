# Projekt UI – PEGASUS

---

---

## Ekran 1: Panel Admina – lista użytkowników

```
Użytkownicy                                      [Filtry v]
─────────────────────────────────────────────────────────────
Imię/Nazwisko      Zaangażowanie   Poglądy      Ekstr.  Akcje
Jan Kowalski       0.82            LEWICOWY     NIE     [profil]
Anna Nowak         0.45            NEUTRALNY    NIE     [profil]
Piotr Wisniewski   0.91            PRAWICOWY    TAK     [profil]
```

### Panel filtrów (rozwijany)

| Filtr                       | Typ wejścia                           |
|-----------------------------|---------------------------------------|
| Rola                        | select: Admin / Uzytkownik            |
| Poglądy polityczne          | select: LEWICOWY / NEUTRALNY / PRAWICOWY / wszystkie |
| Min. ENGAGEMENT_SCORE       | slider 0.0 – 1.0                      |
| Ekspozycja na ekstremizm    | checkbox: tylko z flagą               |
| Status konta                | select: AKTYWNY / ZAWIESZONY          |

---

## Ekran 2: Pełny profil użytkownika (Admin)

Dane z widoku V_USER_FULL_PROFILE.

```
Profil: Jan Kowalski  (ID: 42)            [Oznacz posty do przeglądu]
══════════════════════════════════════════════════════════════════════

Rola:                    UZYTKOWNIK
Status:                  AKTYWNY

Preferowana kategoria:   Polityka
Tematy:                  wybory, praworządność, UE
Zaangażowanie:           0.82  (POWER_USER)
Poglądy:                 LEWICOWY  (score: -0.65)
Ekspozycja ekstremizm:   NIE
Klaster społeczny:       3
Digital fingerprint:     a1b2c3d4e5f6...

Ostatnie interakcje (ostatnie 30 dni):
  Typ         Post                              Data         Czas
  LIKE        "Nowe wyniki wyborów..."          2025-10-15   2:34
  COMMENT     "Reforma systemu edukacji"        2025-10-14   1:02
  SHARE       "Liga Mistrzów – finał"           2025-10-13   0:45

Timeline poglądów (POLITICAL_SCORE w czasie):
  [wykres liniowy – ostatnie 12 miesięcy]
```

---

## Ekran 3: Ranking postów (Admin)

```
Ranking postów wg zaangażowania
──────────────────────────────────────────────────────────
Post                             Polub.  Koment.  Udost.  Score
"Nowe wyniki wyborów..."         1204    387      91      0.94
"Reforma systemu edukacji"       889     201      44      0.78
"Liga Mistrzów – finał"          654     98       31      0.61
```

Przycisk „Oznacz" przy poście → dodaje do raportu ostrzeżeń widocznego tylko dla admina.

---

## Ekran 4: Dodawanie admina (BigYahoo)
```
Dodaj konto administratora

Nazwa użytkownika:_______
Poziom uprawnień (1-5):__
Hasło: __________________

```

