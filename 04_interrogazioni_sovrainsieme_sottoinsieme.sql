-- ------------------------------------------------------------------------------------------ --
-- 1. SOVRAINSIEME NON STRETTO --
-- attori che hanno recitato in tutti i film di 'Nolan' (concesso anche altro) --

SELECT cod_attore
FROM attore A1
WHERE NOT EXISTS(   -- non deve esistere... --
    
    -- ... un film di Nolan --
    SELECT *
    FROM film F1
    WHERE regista='Nolan' AND 

        -- ... dove l'attore non ha recitato  --
        -- ( = non esiste una tupla in recita per questo film e questo attore) --
        NOT EXISTS(

            SELECT *
            FROM recita
            WHERE cod_attore=A1.cod_attore AND 
                cod_film=F1.cod_film
        )
);   



-- ------------------------------------------------------------------------------------------ --
-- 1.1 SOVRAINSIEME STRETTO --
-- attori che hanno recitato in tutti i film di 'Nolan' e in almeno anche in un altro film --

SELECT cod_attore
FROM attore A1
WHERE NOT EXISTS (  -- l'attore ha partecipato a tutti i film di Nolan ... --

    SELECT *
    FROM film F1
    WHERE regista='Nolan' AND 
        NOT EXISTS(

            SELECT *
            FROM recita
            WHERE cod_attore=A1.cod_attore AND 
                cod_film=F1.cod_film
        )
) AND EXISTS (      -- ... e in almeno 1 film che non è di Nolan --
    SELECT * 
    FROM recita NATURAL JOIN film 
    WHERE regista<>'Nolan' AND cod_attore=A1.cod_attore
); 



-- ------------------------------------------------------------------------------------------ --
-- 2. SOTTOINSIEME NON STRETTO --
-- attori che hanno recitato solo in film di 'Nolan' (non in altri) --

SELECT cod_attore 
FROM attore A1
WHERE NOT EXISTS (
    -- (facile) non deve esistere un film di quell'attore dove il regista non è Nolan --

    SELECT *
    FROM recita NATURAL JOIN film   -- (natural join su cod_film) --
    WHERE regista<>'Nolan' AND cod_attore=A1.cod_attore
);



-- ------------------------------------------------------------------------------------------
-- 2.1 SOTTOINSIEME STRETTO --
-- attori che hanno recitato solo in film di 'Nolan' MA NON IN TUTTI --

SELECT cod_attore 
FROM attore A1
WHERE NOT EXISTS (  -- l'attore ha partecipato SOLO a film di Nolan ... --

    SELECT *
    FROM recita NATURAL JOIN film
    WHERE regista<>'Nolan' AND cod_attore=A1.cod_attore

) AND EXISTS (      -- ... ma ne ha perso almeno uno. --

    SELECT *
    FROM film F1
    WHERE regista='Nolan' AND 
        NOT EXISTS(

            SELECT *
            FROM recita
            WHERE cod_attore=A1.cod_attore AND 
                cod_film=F1.cod_film
        )
);



-- ------------------------------------------------------------------------------------------ --
-- 3. UGUALIANZA INSIEMISTICA --
-- attori che hanno recitato in TUTTI e SOLI i film di 'Nolan' --

SELECT cod_attore 
FROM attore A1
WHERE NOT EXISTS (  -- l'attore ha partecipato SOLO a film di Nolan ... --

    SELECT *
    FROM recita NATURAL JOIN film
    WHERE regista<>'Nolan' AND cod_attore=A1.cod_attore

) AND NOT EXISTS (  -- ... e non se ne è perso neanche uno. --

    SELECT *
    FROM film F1
    WHERE regista='Nolan' AND 
        NOT EXISTS(

            SELECT *
            FROM recita
            WHERE cod_attore=A1.cod_attore AND 
                cod_film=F1.cod_film
        )
);



-- ------------------------------------------------------------------------------------------ --
-- 4. UGUALIANZA INSIEMISTICA (senza "valori fissi") --
-- coppie di attori che hanno fatto esattamente gli stessi film --

SELECT A1.cod_attore, A2.cod_attore 
FROM attore A1, attore A2
WHERE A1.cod_attore < A2.cod_attore AND     -- Il primo attore è diverso dal secondo (e non ci sono ripetizioni) --

    -- A2 ha partecipato a SOLO film in cui c'è anche A1 (SOTTOINSIEME) --
    NOT EXISTS (

        -- non esiste un film dove A2 ha recitato ... --
        SELECT *
        FROM recita R1
        WHERE R1.cod_attore= A2.cod_attore AND 

            -- ... e A1 non ha recitato. --
            NOT EXISTS (

                SELECT *
                FROM recita R2
                WHERE R2.cod_film = R1.cod_film AND
                    R2.cod_attore = A1.cod_attore
            )
    ) AND 

    -- A2 ha partecipato a TUTTI i film in cui c'è A1 (SOVRAINSIEME) --
    NOT EXISTS (

        -- non esiste un film dove A1 ha recitato ... --
        SELECT *
        FROM recita R1
        WHERE R1.cod_attore= A1.cod_attore AND 

            -- ... e A2 non ha recitato. --
            NOT EXISTS (

                SELECT *
                FROM recita R2
                WHERE R2.cod_film = R1.cod_film AND
                    R2.cod_attore = A2.cod_attore
            )
    );





