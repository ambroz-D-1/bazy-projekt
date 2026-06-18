-- ============================================================
-- Baza: Oracle Autonomous Database (Free Tier)
-- Uruchamiac wpierw jako uzytkownik ADMIN w SQL Developer Web
-- ============================================================

CREATE SEQUENCE SEQ_USERS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_POSTS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CATEGORIES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_REASONS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_LIKES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_COMMENTS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_SHARES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_VIEWS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PROFILES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_ADMINS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- ============================================================
-- Slownik: Statusy uzytkownikow
-- ============================================================
CREATE TABLE USER_STATUSES (
    
    STATUS_CODE  VARCHAR2(20)  PRIMARY KEY,
    DESCRIPTION  VARCHAR2(300),
);

INSERT INTO USER_STATUSES (STATUS_CODE, DESCRIPTION)
VALUES ('ACTIVE',    'Konto aktywne i w pelni funkcjonalne');
INSERT INTO USER_STATUSES (STATUS_CODE, DESCRIPTION)
VALUES ('SUSPENDED', 'Konto tymczasowo zawieszone przez administratora');
INSERT INTO USER_STATUSES (STATUS_CODE, DESCRIPTION)
VALUES ('DELETED',   'Konto oznaczone jako usuniete (soft delete)');
INSERT INTO USER_STATUSES (STATUS_CODE, DESCRIPTION)
VALUES ('WATCHED',   'Konto pod szczegolna obserwacja moderatora');
COMMIT;


-- ============================================================
-- Administratorzy
-- Poziomy uprawnien:
--   1 = Tylko odczyt raportow
--   2 = Moderacja postow (flagowanie)
--   3 = Zarzadzanie uzytkownikami (suspend / watch)
--   4 = Zarzadzanie adminami nizszego rzedu
--   5 = Pelny dostep (superadmin)
-- ============================================================
CREATE TABLE ADMINS (
    ADMIN_ID            NUMBER DEFAULT SEQ_ADMINS.NEXTVAL PRIMARY KEY,
    USERNAME            VARCHAR2(100)  NOT NULL UNIQUE,
    PASSWORD_HASH       VARCHAR2(255)  NOT NULL,
    PERMISSION_LEVEL    NUMBER(1)      NOT NULL CHECK (PERMISSION_LEVEL BETWEEN 1 AND 5)
);


-- ============================================================
-- Slownik: Kategorie postow
-- ============================================================
CREATE TABLE POST_CATEGORIES (
    CATEGORY_ID    NUMBER DEFAULT SEQ_CATEGORIES.NEXTVAL PRIMARY KEY,
    NAME           VARCHAR2(100) NOT NULL UNIQUE,
    DESCRIPTION    VARCHAR2(500),
    IS_POLITICAL   NUMBER(1) DEFAULT 0 CHECK (IS_POLITICAL IN (0, 1)),
    POLITICAL_LEAN VARCHAR2(20)  CHECK (
        POLITICAL_LEAN IN ('LEFT', 'RIGHT', 'CENTER', 'EXTREMIST')
        OR POLITICAL_LEAN IS NULL
    )
);


-- ============================================================
-- Slownik: Powody szczegolnej uwagi
-- ============================================================
CREATE TABLE SPECIAL_ATTENTION_REASONS (
    REASON_ID      NUMBER DEFAULT SEQ_REASONS.NEXTVAL PRIMARY KEY,
    NAME           VARCHAR2(100) NOT NULL UNIQUE,
    DESCRIPTION    VARCHAR2(500),
    SEVERITY_LEVEL NUMBER(1)    NOT NULL CHECK (SEVERITY_LEVEL BETWEEN 1 AND 5)
);


-- ============================================================
-- Uzytkownicy
-- ============================================================
CREATE TABLE USERS (
    USER_ID    NUMBER DEFAULT SEQ_USERS.NEXTVAL PRIMARY KEY,
    FIRST_NAME VARCHAR2(100) NOT NULL,
    LAST_NAME  VARCHAR2(100) NOT NULL,
    EMAIL      VARCHAR2(255) NOT NULL UNIQUE,
    CREATED_AT TIMESTAMP     DEFAULT SYSTIMESTAMP,
    STATUS     VARCHAR2(20)  DEFAULT 'ACTIVE'
                   REFERENCES USER_STATUSES (STATUS_CODE)
);


-- ============================================================
-- Posty
-- ============================================================
CREATE TABLE POSTS (
    POST_ID          NUMBER DEFAULT SEQ_POSTS.NEXTVAL PRIMARY KEY,
    AUTHOR_ID        NUMBER NOT NULL REFERENCES USERS (USER_ID),
    CATEGORY_ID      NUMBER NOT NULL REFERENCES POST_CATEGORIES (CATEGORY_ID),
    REASON_ID        NUMBER REFERENCES SPECIAL_ATTENTION_REASONS (REASON_ID),
    SEVERITY_SCORE   NUMBER(1) CHECK (SEVERITY_SCORE BETWEEN 1 AND 5),
    CONTENT_SUMMARY  VARCHAR2(500) NOT NULL,
    CREATED_AT       TIMESTAMP DEFAULT SYSTIMESTAMP,
    IS_FLAGGED       NUMBER(1) DEFAULT 0 CHECK (IS_FLAGGED IN (0, 1))
);


-- ============================================================
-- Polubienia
-- ============================================================
CREATE TABLE LIKES (
    LIKE_ID   NUMBER DEFAULT SEQ_LIKES.NEXTVAL PRIMARY KEY,
    USER_ID   NUMBER NOT NULL REFERENCES USERS (USER_ID),
    POST_ID   NUMBER NOT NULL REFERENCES POSTS (POST_ID),
    LIKED_AT  TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT UQ_LIKE UNIQUE (USER_ID, POST_ID)
);


-- ============================================================
-- Komentarze
-- ============================================================
CREATE TABLE COMMENTS (
    COMMENT_ID   NUMBER DEFAULT SEQ_COMMENTS.NEXTVAL PRIMARY KEY,
    USER_ID      NUMBER NOT NULL REFERENCES USERS (USER_ID),
    POST_ID      NUMBER NOT NULL REFERENCES POSTS (POST_ID),
    CONTENT      VARCHAR2(2000) NOT NULL,
    COMMENTED_AT TIMESTAMP DEFAULT SYSTIMESTAMP
);


-- ============================================================
-- Udostepnienia
-- ============================================================
CREATE TABLE SHARES (
    SHARE_ID     NUMBER DEFAULT SEQ_SHARES.NEXTVAL PRIMARY KEY,
    FROM_USER_ID NUMBER NOT NULL REFERENCES USERS (USER_ID),
    POST_ID      NUMBER NOT NULL REFERENCES POSTS (POST_ID),
    TO_USER_ID   NUMBER REFERENCES USERS (USER_ID),
    SHARED_AT    TIMESTAMP DEFAULT SYSTIMESTAMP
);


-- ============================================================
-- Czas spedzony na poscie
-- ============================================================
CREATE TABLE POST_VIEWS (
    VIEW_ID    NUMBER DEFAULT SEQ_VIEWS.NEXTVAL PRIMARY KEY,
    USER_ID    NUMBER NOT NULL REFERENCES USERS (USER_ID),
    POST_ID    NUMBER NOT NULL REFERENCES POSTS (POST_ID)
);


-- ============================================================
-- Profile behawioralne uzytkownikow
-- ============================================================
CREATE TABLE USER_PROFILES (
    PROFILE_ID                 NUMBER DEFAULT SEQ_PROFILES.NEXTVAL PRIMARY KEY,
    USER_ID                    NUMBER NOT NULL UNIQUE REFERENCES USERS (USER_ID),
    PREFERRED_CATEGORY_ID      NUMBER REFERENCES POST_CATEGORIES (CATEGORY_ID),
    PREFERRED_TOPICS           VARCHAR2(500),
    ENGAGEMENT_SCORE           NUMBER(5, 2) DEFAULT 0,
    ACTIVITY_PROFILE           VARCHAR2(20) DEFAULT 'NISKA' CHECK (
        ACTIVITY_PROFILE IN ('WYSOKA', 'SREDNIA', 'NISKA')
        OR ACTIVITY_PROFILE IS NULL
    ),
    POLITICAL_LEAN             VARCHAR2(20) CHECK (
        POLITICAL_LEAN IN ('LEFT', 'RIGHT', 'CENTER', 'EXTREMIST', 'NONE')
        OR POLITICAL_LEAN IS NULL
    ),
    POLITICAL_SCORE            NUMBER(5, 2) DEFAULT 0,
    EXTREMISM_EXPOSURE         NUMBER(1) DEFAULT 0 CHECK (EXTREMISM_EXPOSURE IN (0, 1)),
    SOCIAL_CLUSTER_ID          NUMBER,
    OPINION_INFLUENCE_TIMELINE VARCHAR2(20) CHECK (
        OPINION_INFLUENCE_TIMELINE IN ('ROSNACA', 'STABILNA', 'MALEJACA')
        OR OPINION_INFLUENCE_TIMELINE IS NULL
    ),
    DIGITAL_FINGERPRINT        VARCHAR2(64) UNIQUE,
    LAST_UPDATED               TIMESTAMP DEFAULT SYSTIMESTAMP
);


-- ============================================================
-- Indeksy
-- ============================================================
CREATE INDEX IDX_USERS_STATUS        ON USERS (STATUS);
CREATE INDEX IDX_POSTS_AUTHOR        ON POSTS (AUTHOR_ID);
CREATE INDEX IDX_POSTS_CATEGORY      ON POSTS (CATEGORY_ID);
CREATE INDEX IDX_POSTS_REASON        ON POSTS (REASON_ID);
CREATE INDEX IDX_LIKES_USER          ON LIKES (USER_ID);
CREATE INDEX IDX_LIKES_POST          ON LIKES (POST_ID);
CREATE INDEX IDX_COMMENTS_USER       ON COMMENTS (USER_ID);
CREATE INDEX IDX_COMMENTS_POST       ON COMMENTS (POST_ID);
CREATE INDEX IDX_SHARES_FROM         ON SHARES (FROM_USER_ID);
CREATE INDEX IDX_SHARES_TO           ON SHARES (TO_USER_ID);
CREATE INDEX IDX_VIEWS_USER          ON POST_VIEWS (USER_ID);
CREATE INDEX IDX_VIEWS_POST          ON POST_VIEWS (POST_ID);
CREATE INDEX IDX_PROFILES_USER       ON USER_PROFILES (USER_ID);
CREATE INDEX IDX_PROFILES_FINGERPRINT ON USER_PROFILES (DIGITAL_FINGERPRINT);
CREATE INDEX IDX_ADMINS_EMAIL        ON ADMINS (EMAIL);
CREATE INDEX IDX_ADMINS_USERNAME     ON ADMINS (USERNAME);


-- ============================================================
-- Materialized Views — analityka uzytkownikow
-- Odswiezane raz dziennie przez DBMS_SCHEDULER (patrz nizej)
-- Recznie: EXEC REFRESH_ANALYTICS('MANUAL');
-- ============================================================

-- ------------------------------------------------------------
-- MV 1: Dzienna aktywnosc uzytkownika
--        (lajki, komentarze, udostepnienia per user)
-- ------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_USER_DAILY_ACTIVITY
    BUILD DEFERRED
    REFRESH COMPLETE ON DEMAND
AS
SELECT
    u.USER_ID,
    u.FIRST_NAME,
    u.LAST_NAME,
    u.STATUS,
    COUNT(DISTINCT l.LIKE_ID)    AS TOTAL_LIKES,
    COUNT(DISTINCT c.COMMENT_ID) AS TOTAL_COMMENTS,
    COUNT(DISTINCT s.SHARE_ID)   AS TOTAL_SHARES,
    COUNT(DISTINCT l.LIKE_ID)
        + COUNT(DISTINCT c.COMMENT_ID)
        + COUNT(DISTINCT s.SHARE_ID)  AS TOTAL_INTERACTIONS,
    SYSDATE                           AS SNAPSHOT_DATE
FROM   USERS u
LEFT JOIN LIKES    l ON l.USER_ID      = u.USER_ID
LEFT JOIN COMMENTS c ON c.USER_ID      = u.USER_ID
LEFT JOIN SHARES   s ON s.FROM_USER_ID = u.USER_ID
GROUP BY u.USER_ID, u.FIRST_NAME, u.LAST_NAME, u.STATUS;


-- ------------------------------------------------------------
-- MV 2: Profil behawioralny — engagement i naciechowanie polityczne
-- ------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_USER_BEHAVIORAL_PROFILE
    BUILD DEFERRED
    REFRESH COMPLETE ON DEMAND
AS
SELECT
    up.USER_ID,
    up.ENGAGEMENT_SCORE,
    up.ACTIVITY_PROFILE,
    up.POLITICAL_LEAN,
    up.POLITICAL_SCORE,
    up.EXTREMISM_EXPOSURE,
    up.OPINION_INFLUENCE_TIMELINE,
    COUNT(DISTINCT CASE WHEN pc.IS_POLITICAL   = 1          THEN l.LIKE_ID    END) AS POLITICAL_LIKES,
    COUNT(DISTINCT CASE WHEN pc.IS_POLITICAL   = 1          THEN c.COMMENT_ID END) AS POLITICAL_COMMENTS,
    COUNT(DISTINCT CASE WHEN pc.IS_POLITICAL   = 1          THEN s.SHARE_ID   END) AS POLITICAL_SHARES,
    COUNT(DISTINCT CASE WHEN pc.POLITICAL_LEAN = 'EXTREMIST' THEN p.POST_ID   END) AS EXTREMIST_POSTS_INTERACTED,
    COUNT(DISTINCT CASE WHEN p.IS_FLAGGED      = 1          THEN p.POST_ID    END) AS FLAGGED_POSTS_INTERACTIONS,
    SYSDATE AS SNAPSHOT_DATE
FROM   USER_PROFILES up
JOIN   USERS u          ON u.USER_ID       = up.USER_ID
LEFT JOIN LIKES    l    ON l.USER_ID       = u.USER_ID
LEFT JOIN COMMENTS c    ON c.USER_ID       = u.USER_ID
LEFT JOIN SHARES   s    ON s.FROM_USER_ID  = u.USER_ID
LEFT JOIN POSTS    p    ON p.POST_ID IN (l.POST_ID, c.POST_ID, s.POST_ID)
LEFT JOIN POST_CATEGORIES pc ON pc.CATEGORY_ID = p.CATEGORY_ID
GROUP BY
    up.USER_ID,
    up.ENGAGEMENT_SCORE,
    up.ACTIVITY_PROFILE,
    up.POLITICAL_LEAN,
    up.POLITICAL_SCORE,
    up.EXTREMISM_EXPOSURE,
    up.OPINION_INFLUENCE_TIMELINE;


-- ------------------------------------------------------------
-- MV 3: Ranking uzytkownikow wg engagement score
-- ------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_USER_ENGAGEMENT_RANKING
    BUILD DEFERRED
    REFRESH COMPLETE ON DEMAND
AS
SELECT
    u.USER_ID,
    u.FIRST_NAME || ' ' || u.LAST_NAME AS FULL_NAME,
    u.STATUS,
    up.ENGAGEMENT_SCORE,
    up.POLITICAL_LEAN,
    up.EXTREMISM_EXPOSURE,
    RANK() OVER (ORDER BY up.ENGAGEMENT_SCORE DESC) AS ENGAGEMENT_RANK,
    SYSDATE AS SNAPSHOT_DATE
FROM   USERS u
JOIN   USER_PROFILES up ON up.USER_ID = u.USER_ID
WHERE  u.STATUS != 'DELETED';


-- ============================================================
-- Procedura odswiezajaca wszystkie MV
-- ============================================================
CREATE OR REPLACE PROCEDURE REFRESH_ANALYTICS
    (p_called_by VARCHAR2 DEFAULT 'SCHEDULER')
IS
    v_start   TIMESTAMP := SYSTIMESTAMP;
    v_end     TIMESTAMP;
    v_elapsed NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        '[' || TO_CHAR(v_start, 'YYYY-MM-DD HH24:MI:SS') || '] '
        || 'Odswiezanie analytics uruchomione przez: ' || p_called_by
    );

    DBMS_MVIEW.REFRESH('MV_USER_DAILY_ACTIVITY',     method => 'C', atomic_refresh => FALSE);
    DBMS_MVIEW.REFRESH('MV_USER_BEHAVIORAL_PROFILE', method => 'C', atomic_refresh => FALSE);
    DBMS_MVIEW.REFRESH('MV_USER_ENGAGEMENT_RANKING', method => 'C', atomic_refresh => FALSE);

    v_end     := SYSTIMESTAMP;
    v_elapsed := EXTRACT(SECOND FROM (v_end - v_start));

    DBMS_OUTPUT.PUT_LINE(
        '[' || TO_CHAR(v_end, 'YYYY-MM-DD HH24:MI:SS') || '] '
        || 'Zakonczone. Czas: ' || v_elapsed || 's'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD odswiezania analytics: ' || SQLERRM);
        RAISE;
END REFRESH_ANALYTICS;
/


-- ============================================================
-- DBMS_SCHEDULER — automatyczne uruchomienie codziennie o 03:00
-- Recznie: EXEC REFRESH_ANALYTICS('MANUAL');
--          lub: EXEC DBMS_SCHEDULER.RUN_JOB('JOB_REFRESH_ANALYTICS');
-- ============================================================
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'JOB_REFRESH_ANALYTICS',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'REFRESH_ANALYTICS',
        start_date      => TRUNC(SYSTIMESTAMP) + INTERVAL '3' HOUR,
        repeat_interval => 'FREQ=DAILY; BYHOUR=3; BYMINUTE=0; BYSECOND=0',
        end_date        => NULL,
        enabled         => TRUE,
        auto_drop       => FALSE,
        comments        => 'Codzienne odswiezanie materialized views analityki uzytkownikow'
    );
END;
/

COMMIT;
