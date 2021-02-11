-- ---------------------------------------------------------- --
-- 1. FUNZIONI AGGREGATE -- 

/*
    funzione che calcola il numero attori 
    che hanno recitato per un regista.
*/

-- 1.1 dichiarazione della funzione --
CREATE OR REPLACE FUNCTION numero_attori_regista (
    -- parametri tipizzati --
    nome_regista VARCHAR (255)
) RETURNS INT     -- tipo di dato ritornato -- 
LANGUAGE plpgsql    -- linguaggio usato --
AS $$
    -- qui inizio a scrivere la funzione (in plpgsql) -- 

    DECLARE
        variabile INT;    -- dichiarazione delle variabili che userò --
    BEGIN                   -- (SENZA punto e virgola) --
        -- codice -- 
        SELECT COUNT(DISTINCT cod_attore) AS numero_attori 
        INTO variabile  -- codice per assegnare l'esito di un'interrogazione ad una variabile -- 
        FROM recita NATURAL JOIN film
        WHERE regista=nome_regista;  -- qui uso il parametro per le mie interrogazioni -- 

        RETURN variabile;   -- return finale --

    END;                    -- (CON punto e virgola) --
$$;

-- 1.2 chiamata semplice --
SELECT  numero_attori_regista('Nolan') AS numero_attori_nolan;

-- 1.3 chiamata come funzione aggregata --
SELECT regista, numero_attori_regista(regista)
FROM film
GROUP BY regista;

-- ---------------------------------------------------------- --
-- 2. FUNZIONI AGGREGATE COME CONSTRAINT --

/*
    aggiungo una tabella proiezioni, dove voglio assicurarmi che 
    il film proiettato esca nell'anno in cui è programmata la proiezione
    o dopo (non voglio proiettare film "in anteprima").
*/

start TRANSACTION;

CREATE OR REPLACE FUNCTION controlla_data_proiezione(
    cod_film_ codice,
    data_proiezione TIMESTAMP
) RETURNS BOOLEAN AS $$

    DECLARE anno_proiezione INTEGER;
    DECLARE anno_uscita_ INTEGER;
    BEGIN
        
        -- recupero l'anno d'uscita del film --
        SELECT anno_uscita INTO anno_uscita_
        FROM film
        WHERE film.cod_film=cod_film_;

        -- se è nullo, non posso controllare ma OK --
        IF anno_uscita_ IS NULL THEN RETURN TRUE; END IF;

        -- estraggo l'anno della proiezione --
        SELECT EXTRACT(YEAR FROM data_proiezione) INTO anno_proiezione;

        -- effettuo il controllo con una struttura if-then-else --
        IF anno_proiezione>=anno_uscita_ THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;

$$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS proiezione;

CREATE TABLE proiezione(
    numero_sala INT, 
    data_proiezione DATE DEFAULT now(), 
    ora_proiezione TIME DEFAULT now(), 
    cod_film codice, 
    
    PRIMARY KEY (numero_sala, data_e_ora), 
    CONSTRAINT fk_film FOREIGN KEY (cod_film) REFERENCES film (cod_film), 

    -- controllo dell'anno --
    CONSTRAINT controllo_anno CHECK(
        controlla_data_proiezione(cod_film, data_proiezione)
    )
);

COMMIT;


-- inserisco 3 film con data -- 
INSERT INTO film (cod_film, titolo, anno_uscita) VALUES
    (100, 'Black Widow', 2021), 
    (200, 'Kingsman Secret Service', NULL), 
    (300, 'Dr Strange - Multiverse of Madness', 2022)
;

-- provo a creare 3 proiezioni --
INSERT INTO proiezione (cod_film, numero_sala) VALUES
    (100, 1), (200, 2);     -- vanno a buon fine --

INSERT INTO proiezione (cod_film, numero_sala) VALUES
    (300, 3);               -- fallisce --




