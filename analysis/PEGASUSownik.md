# PEGASUSownik

## Co to jest

System zbierania i analizy danych o zachowaniu użytkowników na podstawie tego jak wchodzą w interakcje z postami. Zakładamy że system działa jako część już istniejącej platformy społecznościowej.

---

## Dane o użytkownikach

Przechowujemy podstawowe dane: id, imię, nazwisko. Coś jeszcze jak wpadniemy na pomysł.

---

## Posty

Każdy post ma przypisaną kategorię treści oraz opcjonalnie powód dla którego jest "szczególnej uwagi". Są to dwie osobne rzeczy, gdyż post może być polityczny i jednocześnie ekstremistyczny, albo zupełnie neutralny i też problematyczny.

Do postów dodajemy też jakąś skalę ekstremalności, żeby odróżnić lekkie przekleństwo od przemocy.

**Kategorie treści** (przykłady, do uzupełnienia):

bezpieczne - kotki, kawusia, muzyka, gotowanie itp.

polityczne - polemika polityczna/światopoglądowa, treści z krańców spektrum

**Powody szczególnej uwagi** (przykłady, do uzupełnienia):

- poradniki jak robić nielegalne rzeczy (w minecrafcie)
- materiały niewygodne dla reklamodawców
- treści ekstremistyczne (rasizm, mizoginia, homofobia etc.)
- treści antydemokratyczne, prorosyjskie, eurosceptyczne, antysemickie
- wulgarny język / przemoc

---

## Interakcje

Śledzimy trzy rodzaje interakcj:

- polubienia (kto, co)
- komentarze (kto, co, treść komentarza)
- udostępnienia (kto, co, komu)

Czas spędzony na poście - do dyskusji czy i jak to zrealizować.

---

## Co chcemy z tego wyciągnąć

Na podstawie historii interakcji budujemy profil każdego użytkownika:

- zainteresowania i preferowana tematyka treści
- stopień zaangażowania (czy tylko lajkuje, czy też komentuje i udostępnia)
- profil poglądów politycznych (na podstawie interakcji z treściami politycznymi)
- grupy powiązań między użytkownikami na podstawie wzajemnych udostępnień *(opcjonalnie)*
- jak treści wpływają na opinie użytkownika w czasie *(opcjonalnie, jak wpadniemy jak)*
- profil aktywności (kiedy i jak często jest aktywny)
- digital fingerprint (charakterystyczny wzorzec zachowania online)

Wszystko zebrane w jedną tabelę - jeden wiersz na użytkownika.

---

## Kto co widzi

admin - dostęp do wszystkiego (użytkownicy, posty, interakcje, profile analityczne)

użytkownik - widzi tylko swoje polubione posty i swoje komentarze

---

## Technologia

Planujemy użyć Oracle Database, której można używać przez przeglądarkę na livesql.oracle.com bez żadnej instalacji.