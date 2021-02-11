-- ---------------------------------------------------------- --
-- 1. TRIGGER (BEFORE) --
/*
    Non posso programmare più di una proiezione per ogni ora su una sala
*/

START TRANSACTION;

-- 1.1 creazione di una funzione per il trigger --
CREATE OR REPLACE FUNCTION controlla_orario_proiezione() -- no parametri --
RETURNS TRIGGER -- devo ritornare un trigger --
LANGUAGE plpgsql AS $$
    DECLARE n_proiezioni INT;
    BEGIN

        SELECT COUNT(*) INTO n_proiezioni
        FROM proiezione
        WHERE numero_sala=new.numero_sala AND -- con new, posso riferirmi alla nuova tupla (con old alla vecchia) --
            ora_proiezione >= new.ora_proiezione - (1 * interval '1 hour') AND 
            ora_proiezione <= new.ora_proiezione + (1 * interval '1 hour');

        IF n_proiezioni >= 1 THEN
            -- se voglio che l'interrogazione fallisca, return null --
            -- (sarebbe gradita un'exception) --
            RAISE EXCEPTION 'Impossibile aggiungere la proiezione %, ci sono altre proiezioni nel raggio di 1 ora.', new;
            RETURN NULL;    
        ELSE 
            RETURN new;     -- se voglio che abbia successo, ritorno la tupla --
        END IF;

    END;
$$; 

-- 1.2 creazione del trigger --
DROP TRIGGER IF EXISTS trigger_orario_proiezione ON proiezione;

CREATE TRIGGER trigger_orario_proiezione        -- NO "or replace" --
BEFORE INSERT OR UPDATE ON proiezione           -- quando e dove eseguirlo -- 
FOR EACH ROW                                    -- sulle tuple o sulle istruzioni? --
EXECUTE PROCEDURE controlla_orario_proiezione() -- procedura da eseguire --
;

COMMIT;

-- 1.3 test --

-- questa viene accettata --
INSERT INTO proiezione (numero_sala, ora_proiezione, cod_film) VALUES
    (1, '2:00:00'::time, 1);

-- queste no --
INSERT INTO proiezione (numero_sala, ora_proiezione, cod_film) VALUES
    (1, '1:30:00'::time, 1);

INSERT INTO proiezione (numero_sala, ora_proiezione, cod_film) VALUES
    (1, '2:30:00'::time, 1);

-- questa anche viene accettata --
INSERT INTO proiezione (numero_sala, ora_proiezione, cod_film) VALUES
    (1, '3:00:01'::time, 1);


-- ---------------------------------------------------------- --
-- 2. TRIGGER (AFTER) --
/*
    Tieni un contatore del numero di proiezioni di un film
*/

BEGIN TRANSACTION;

ALTER TABLE film ADD COLUMN numero_proiezioni int DEFAULT 0;

CREATE OR REPLACE FUNCTION incrementa_contatore_proiezioni()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
    
    DECLARE numero_proiezioni_ int;
    BEGIN

        -- incremento --
        UPDATE film
        SET numero_proiezioni=numero_proiezioni+1
        WHERE cod_film=new.cod_film;

        RETURN new;
    END;
$$;

END;

DROP TRIGGER IF EXISTS trigger_contatore_proiezioni ON proiezione;

CREATE TRIGGER trigger_contatore_proiezioni
AFTER INSERT ON proiezione      -- questa volta, eseguo DOPO l'inserimento --
FOR EACH ROW
EXECUTE PROCEDURE incrementa_contatore_proiezioni();

COMMIT;


-- creo un po' di proiezioni per verificare -- 
INSERT INTO proiezione (numero_sala, cod_film) VALUES
    (6, 1), (7, 1), (8, 1);