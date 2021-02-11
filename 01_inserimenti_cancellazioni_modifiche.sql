start transaction;
-- -------------------------------------------------------------------- --
-- 0. SVUOTA LE TABELLE -- 

DELETE FROM recita;     
DELETE FROM film;
DELETE FROM attore;
-- (NOTA: nel DELETE NON serve il *) --

-- -------------------------------------------------------------------- --
-- 1. INSERIMENTI --

-- nome tabella & campi espliciti che voglio inserire --
INSERT INTO film (cod_film, titolo, regista) 
    VALUES (1, 'Inception', 'Nolan'),   -- tuple che si inseriscono --
            (2, 'Tenet', 'Nolan'), 
            (3, 'Django', 'Tarantino'), 
            (4, 'Onca upon a time in Hollywood' , 'Tarantino');

INSERT INTO attore (cod_attore, nome, cognome) 
    VALUES (1, 'Leonardo', 'Di Caprio'),
            (2, 'Samuel', 'L. Jackson');

-- inserimento senza esplicitare i campi -- 
INSERT INTO recita VALUES 
    (1, 1, TRUE),   -- Di Caprio in Inception --
    (1, 3, FALSE),  -- Di Caprio in Django --
    (1, 4, TRUE),   -- Di Caprio in Once... --

    (2, 3, TRUE),   -- Samuel L. Jackson in Django (da modificare) --
    (2, 1, FALSE)   -- Samuel L. Jackson in Inception (da eliminare) --
;

-- -------------------------------------------------------------------- --
-- 2. DELETE --
-- Samuel L. Jackson NON ha recitato in Inception --

DELETE FROM recita
WHERE cod_attore = ANY(
    SELECT cod_attore
    FROM attore
    WHERE nome='Samuel' AND cognome='L. Jackson'
) AND cod_film = ANY(
    SELECT cod_film
    FROM film
    WHERE titolo='Inception'
);

-- -------------------------------------------------------------------- --
-- 3. UPDATE --
-- Samuel L. Jackson NON era protagonista in Django --

UPDATE recita 
SET protagonista=FALSE  
WHERE cod_attore=2 AND cod_film=3;
-- (NOTA: prima SET, poi WHERE) --

commit;