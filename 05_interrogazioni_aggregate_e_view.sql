-- -------------------------------------------------------------- --
-- 1. CLASSICO PATTERN VIEW + AGGREGATA -- 
-- Attore che ha fatto più film (tipico pattern d'esame)

-- (elimino in modo da riuscire ad eseguire più volte) -- 
DROP VIEW IF EXISTS numero_film_attore;

-- creazione di una view --
CREATE VIEW 
    numero_film_attore (cod_attore, numero_film) AS -- nome della view e nome dei campi --
    
    -- da qui inizio a definire che cosa ritorna -- 
    SELECT cod_attore, COUNT cod_film   -- chiamata a f. aggregata -- 
    FROM recita
    GROUP BY cod_attore -- raggruppamento per codice attore --
;

-- utilizzo di una view per classico pattern del massimo --
SELECT cod_attore, numero_film
FROM numero_film_attore
WHERE numero_film >= ALL (
    SELECT numero_film
    FROM numero_film_attore
);

-- 1.1 ALTERNATIVA: chiamata di un sacco di aggregate, anche con condizioni varie --
-- (NOTA: è solo un esempio, per max e min NON usare all'esame)
SELECT MAX numero_film AS max, MIN numero_film AS min, AVG numero_film AS mean, 
FROM numero_film_attore;



-- -------------------------------------------------------------- --
-- 2. GROUP BY & CLAUSOLA HAVING --
-- seleziona gli attori che hanno fatto più di 5 film come protagonisti --

-- WHERE <- eseguito PRIMA del GROUP BY --
-- HAVING <- eseguito DOPO il GROUP BY --

SELECT cod_attore FROM recita 
-- PRIMA del group by, seleziono solo le recitazioni come protagonista --
WHERE protagonista=FALSE    
-- effettuo il raggruppamento --
GROUP BY cod_attore
-- applico una condizione SUL raggruppamento (ora posso usare anche le aggregate) -- 
HAVING COUNT(cod_film) > 5;


