-- ============================================================
-- Dane testowe – slowniki + uzytkownicy + posty + interakcje
-- Uruchamiac po 01_create_tables.sql
-- ============================================================

-- ============================================================
-- Role (UML: Rola <|-- Admin, Rola <|-- UzytkownikWidok)
-- ============================================================
INSERT INTO
    ROLES (
        NAME,
        DESCRIPTION,
        CAN_ACCESS_ALL,
        CAN_VIEW_OWN_INTERACTIONS
    )
VALUES (
        'ADMIN',
        'Administrator – pelny dostep do wszystkich danych i widokow',
        1,
        1
    );

INSERT INTO
    ROLES (
        NAME,
        DESCRIPTION,
        CAN_ACCESS_ALL,
        CAN_VIEW_OWN_INTERACTIONS
    )
VALUES (
        'USER',
        'Uzytkownik widok – widzi swoje polubienia i komentarze',
        0,
        1
    );

COMMIT;

-- ============================================================
-- Kategorie postow
-- ============================================================
INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'SAFE_ANIMALS',
        'Tresci o zwierzetach (kotki, pieski itp.)',
        0,
        NULL
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'SAFE_FOOD',
        'Przepisy kulinarne, smaczna kawusia',
        0,
        NULL
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'SAFE_MUSIC',
        'Muzyka, recenzje, playlisty',
        0,
        NULL
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'SAFE_LIFESTYLE',
        'Styl zycia, podroze, sport, hobby',
        0,
        NULL
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'SAFE_TECH',
        'Technologia, programowanie, gadgety',
        0,
        NULL
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'POLITICAL_LEFT',
        'Tresci o profilu lewicowym, socjaldemokratyczne',
        1,
        'LEFT'
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'POLITICAL_RIGHT',
        'Tresci o profilu prawicowym, konserwatywne',
        1,
        'RIGHT'
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'POLITICAL_CENTER',
        'Polemika polityczna, umiarkowane poglady',
        1,
        'CENTER'
    );

INSERT INTO
    POST_CATEGORIES (
        NAME,
        DESCRIPTION,
        IS_POLITICAL,
        POLITICAL_LEAN
    )
VALUES (
        'POLITICAL_EXTREMIST',
        'Tresci z kranców spektrum politycznego',
        1,
        'EXTREMIST'
    );

-- ============================================================
-- Powody szczegolnej uwagi
-- ============================================================
INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'VULGAR_LANGUAGE',
        'Wulgarny jezyk, przeklenstwa',
        1
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'ADVERTISER_UNFRIENDLY',
        'Materialy nieodpowiednie dla reklamodawcow',
        2
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'ILLEGAL_GUIDE',
        'Poradniki dotyczace nielegalnych czynnosci',
        3
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'MISOGYNIC',
        'Tresci mizogyniczne',
        4
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'HOMOPHOBIC',
        'Tresci homofobiczne',
        4
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'ANTIDEMOCRATIC',
        'Tresci antydemokratyczne / prorosyjskie',
        4
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'EUROSCEPTIC_EXTREME',
        'Skrajny eurosceptycyzm / nacjonalizm',
        4
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'EXTREMIST_CONTENT',
        'Rasizm, ekstremizm, mowa nienawisci',
        5
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'VIOLENCE',
        'Tresci pokazujace przemoc',
        5
    );

INSERT INTO
    SPECIAL_ATTENTION_REASONS (
        NAME,
        DESCRIPTION,
        SEVERITY_LEVEL
    )
VALUES (
        'ANTISEMITIC',
        'Tresci antysemickie',
        5
    );

-- ============================================================
-- Uzytkownicy
-- ============================================================
INSERT INTO
    USERS (
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        ROLE_ID
    )
VALUES (
        'Admin',
        'Systemu',
        'admin@platforma.pl',
        1
    );

INSERT INTO
    USERS (FIRST_NAME, LAST_NAME, EMAIL)
VALUES (
        'Anna',
        'Kowalska',
        'anna.kowalska@mail.com'
    );

INSERT INTO
    USERS (FIRST_NAME, LAST_NAME, EMAIL)
VALUES (
        'Piotr',
        'Nowak',
        'piotr.nowak@mail.com'
    );

INSERT INTO
    USERS (FIRST_NAME, LAST_NAME, EMAIL)
VALUES (
        'Maria',
        'Wisniewska',
        'maria.w@mail.com'
    );

INSERT INTO
    USERS (FIRST_NAME, LAST_NAME, EMAIL)
VALUES (
        'Tomasz',
        'Zajac',
        'tomasz.z@mail.com'
    );

INSERT INTO
    USERS (FIRST_NAME, LAST_NAME, EMAIL)
VALUES (
        'Kamil',
        'Lewandowski',
        'kamil.l@mail.com'
    );

COMMIT;

-- ============================================================
-- Posty
-- ============================================================

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        2,
        1,
        'Moj kot Mruczek robi smiesznie miny – musicie zobaczyc!'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        3,
        2,
        'Przepis na idealne tiramisu – sprawdzony przez babcie'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        4,
        3,
        'Top 10 albumow roku 2025 wedlug mojej playlisty'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        5,
        4,
        'Relacja z wyprawy w Tatry – zdjecia i trasy'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        6,
        5,
        'Najlepsze IDE do Pythona w 2025 – porownanie'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        2,
        6,
        'Dlaczego polityka socjalna jest kluczem do przyszlosci Europy'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        3,
        7,
        'Tradycja i tozsamosc narodowa – wartosci ktore trzeba chronic'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        CONTENT_SUMMARY
    )
VALUES (
        4,
        8,
        'Analiza rynkow – dlaczego centrowe podejscie dziala'
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        REASON_ID,
        SEVERITY_SCORE,
        CONTENT_SUMMARY,
        IS_FLAGGED
    )
VALUES (
        5,
        9,
        8,
        5,
        'Post zawierajacy mowe nienawisci – oznaczony przez moderacje',
        1
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        REASON_ID,
        SEVERITY_SCORE,
        CONTENT_SUMMARY,
        IS_FLAGGED
    )
VALUES (
        5,
        1,
        1,
        1,
        'Smiesznie filmy ale z paroma wulgaryzmami w opisie',
        0
    );

INSERT INTO
    POSTS (
        AUTHOR_ID,
        CATEGORY_ID,
        REASON_ID,
        SEVERITY_SCORE,
        CONTENT_SUMMARY,
        IS_FLAGGED
    )
VALUES (
        6,
        7,
        6,
        4,
        'Kontrowersyjny komentarz polityczny z elementami antydemo',
        1
    );

COMMIT;

-- ============================================================
-- Polubienia
-- ============================================================
INSERT INTO LIKES (USER_ID, POST_ID) VALUES (2, 1);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (3, 1);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (4, 1);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (3, 2);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (4, 3);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (2, 6);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (6, 6);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (3, 7);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (5, 7);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (5, 9);

INSERT INTO LIKES (USER_ID, POST_ID) VALUES (6, 9);

COMMIT;

-- ============================================================
-- Komentarze
-- ============================================================
INSERT INTO
    COMMENTS (USER_ID, POST_ID, CONTENT)
VALUES (
        3,
        1,
        'Hahaha Mruczek jest najlepszy! Mam identyczna fotke mojego kota :D'
    );

INSERT INTO
    COMMENTS (USER_ID, POST_ID, CONTENT)
VALUES (
        4,
        2,
        'Probowalam tego przepisu – wyszlo wysmieniecie, dziekuje!'
    );

INSERT INTO
    COMMENTS (USER_ID, POST_ID, CONTENT)
VALUES (
        2,
        6,
        'W pelni sie zgadzam z Twoja analiza polityczna.'
    );

INSERT INTO
    COMMENTS (USER_ID, POST_ID, CONTENT)
VALUES (
        6,
        7,
        'Ciekawy punkt widzenia, chocia nie do konca sie zgadzam.'
    );

COMMIT;

-- ============================================================
-- Udostepnienia
-- ============================================================
INSERT INTO
    SHARES (
        FROM_USER_ID,
        POST_ID,
        TO_USER_ID
    )
VALUES (2, 1, 3);

INSERT INTO
    SHARES (
        FROM_USER_ID,
        POST_ID,
        TO_USER_ID
    )
VALUES (3, 7, 5);

INSERT INTO
    SHARES (
        FROM_USER_ID,
        POST_ID,
        TO_USER_ID
    )
VALUES (5, 9, NULL);

INSERT INTO
    SHARES (
        FROM_USER_ID,
        POST_ID,
        TO_USER_ID
    )
VALUES (6, 6, 2);

COMMIT;

-- ============================================================
-- Czasy ogladania postow
-- ============================================================
INSERT INTO
    POST_VIEWS (
        USER_ID,
        POST_ID,
        VIEW_START,
        VIEW_END
    )
VALUES (
        2,
        1,
        TIMESTAMP '2025-04-01 10:00:00',
        TIMESTAMP '2025-04-01 10:02:30'
    );

INSERT INTO
    POST_VIEWS (
        USER_ID,
        POST_ID,
        VIEW_START,
        VIEW_END
    )
VALUES (
        3,
        2,
        TIMESTAMP '2025-04-01 11:00:00',
        TIMESTAMP '2025-04-01 11:04:15'
    );

INSERT INTO
    POST_VIEWS (
        USER_ID,
        POST_ID,
        VIEW_START,
        VIEW_END
    )
VALUES (
        5,
        9,
        TIMESTAMP '2025-04-02 15:30:00',
        TIMESTAMP '2025-04-02 15:38:00'
    );

COMMIT;