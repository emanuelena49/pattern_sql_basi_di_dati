-- ------------------------------------------------------------------------------------------ 
-- 1 IL PIU' GRANDE (>= tutti)
-- L'impiegato con lo stipendio più alto


SELECT cf 
FROM impiegato 
WHERE stipendio >= ALL (

    SELECT stipendio 
    FROM impiegato
); 


-- ------------------------------------------------------------------------------------------ 
-- 1.1 IL PIU' GRANDE (non esiste un >)
SELECT cf 
FROM impiegato I1
WHERE NOT EXISTS (

    SELECT * 
    FROM impiegato 
    WHERE stipendio > I1.stipendio
); 

-- ------------------------------------------------------------------------------------------ 
-- 1.2 IL PIU' GRANDE (non esiste un > - NO GOOD, "stile algebra")


SELECT cf
FROM impiegato
WHERE NOT IN (

    -- tutti gli impiegati che hanno lo stipendio < di qualcun altro
    SELECT cf 
    FROM impiegato I1 I2
    WHERE I1.stipendio < I2.stipendio
);
