start transaction;

-- --------------------------------------------------------------------- --
-- 0. DROP TABLES -- 
DROP TABLE If EXISTS  recita;
DROP TABLE If EXISTS  film;
DROP TABLE If EXISTS  attore;
DROP DOMAIN If EXISTS  codice;


-- --------------------------------------------------------------------- --
-- 1. CREAZIONE DI UNA TABELLA -- 

-- creazione di un dominio (tipo di dato) --
CREATE DOMAIN codice AS int;

-- creazione di alcune tabelle --
CREATE TABLE film (
    cod_film codice PRIMARY KEY,    -- chiave primaria --
    titolo VARCHAR (255) NOT NULL UNIQUE,  -- vincoli NOT NULL e UNIQUE (insieme formano un vincolo di chiave) --
    anno_uscita int, 
    regista VARCHAR (255)
); 

CREATE TABLE attore (
    cod_attore codice PRIMARY KEY,
    nome VARCHAR (255) NOT NULL,
    cognome VARCHAR (255),  -- da modificare --
    numero_film int  -- da eliminare -- 
); 

-- --------------------------------------------------------------------- --
-- 2. MODIFICA DI UNA TABELLA -- 

-- 2.1 aggiungere una colonna --
ALTER TABLE film ADD COLUMN anno_inizio_riprese int;

-- 2.2 inserire un vincolo --
ALTER TABLE film ADD 
CONSTRAINT controllo_data_uscita -- nome del vincolo --
CHECK (   -- la condizione booleana da verificare --
    (anno_uscita IS NULL) OR 
    (anno_inizio_riprese IS NULL) OR
    (anno_inizio_riprese <= anno_uscita)
);

-- 2.3 eliminazione e modifica di una colonna -- 
ALTER TABLE attore 
    -- elimino una colonna --
    DROP COLUMN numero_film, 
    -- modifico una colonna --
    ALTER COLUMN cognome SET NOT NULL;


-- --------------------------------------------------------------------- --
-- 3. FOREIGN KEYS & CHIAVI MULTI-VALORE -- 

CREATE TABLE recita (
    -- inserimento di una Foreign key --
    cod_attore codice,
    cod_film codice, 

    -- come inserire una foreign key (come vincolo) --
    CONSTRAINT FK_film                  -- nome del vincolo --
        FOREIGN KEY (cod_film)          -- su che campi si applica --
        REFERENCES film (cod_film),     -- a che campi fa riferimento --

    -- altro modo di definire una chiave primaria (formata da più attributi) -- 
    PRIMARY KEY (cod_attore, cod_film)
);

-- (piccola aggiunta di un campo) --
ALTER TABLE recita add COLUMN protagonista BOOLEAN DEFAULT FALSE; -- con valore di default -- 

-- 3.1 altro modo di inserire una FK (modificando la tabella) --
ALTER TABLE recita 
    add CONSTRAINT FK_attore    -- aggiungo come CONSTRAINT --s
    FOREIGN KEY (cod_attore) REFERENCES attore (cod_attore);

commit;