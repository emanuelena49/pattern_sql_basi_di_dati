-- ------------------------------------------------------------------------------------------ --
-- 1. N o + (ALMENO) --
-- Film in cui hanno recitato 2 o più attori. --

SELECT DISTINCT R1.cod_film
FROM recita R1, recita R2   -- 2 copie, devo metterli in join --
WHERE R1.cod_film = R2.cod_film AND -- cond. di join 1: stesso film --
    R1.cod_attore <> R2.cod_attore; -- cond. di join 2: attore diverso --



-- ------------------------------------------------------------------------------------------ --
-- 1.1  N o + (ALMENO) --
-- Film in cui hanno recitato 3 o più attori. --

SELECT DISTINCT R1.cod_film
FROM recita R1, recita R2, recita R3
WHERE R1.cod_film = R2.cod_film = R3.cod_film AND -- stesso film --

    -- 3 attori diversi --
    R1.cod_attore <> R2.cod_attore AND
    R1.cod_attore <> R3.cod_attore AND
    R2.cod_attore <> R3.cod_attore;



-- ------------------------------------------------------------------------------------------  --
-- 2. ESATTAMENTE N --
-- Film con ESATTAMENTE 2 attori --

-- 2+ attori --
SELECT DISTINCT R1.cod_film
FROM recita R1, recita R2 
WHERE R1.cod_film = R2.cod_film AND
    R1.cod_attore <> R2.cod_attore

EXCEPT

-- 3+ attori --
SELECT DISTINCT R1.cod_film
FROM recita R1, recita R2, recita R3
WHERE R1.cod_film = R2.cod_film = R3.cod_film AND
    R1.cod_attore <> R2.cod_attore AND
    R1.cod_attore <> R3.cod_attore AND
    R2.cod_attore <> R3.cod_attore;



-- ------------------------------------------------------------------------------------------  --
-- 3. N o - (AL PIU') --
-- Film con al più 3 attori. --

-- 1+ attori --
SELECT DISTINCT cod_film
FROM recita

EXCEPT

-- 4+ attori --
SELECT DISTINCT R1.cod_film
FROM recita R1, recita R2, recita R3, recita R4
WHERE R1.cod_film = R2.cod_film = R3.cod_film = R4.cod_film AND
    R1.cod_attore <> R2.cod_attore AND
    R1.cod_attore <> R3.cod_attore AND
    R1.cod_attore <> R4.cod_attore AND
    R2.cod_attore <> R3.cod_attore AND
    R2.cod_attore <> R4.cod_attore AND
    R3.cod_attore <> R4.cod_attore;
