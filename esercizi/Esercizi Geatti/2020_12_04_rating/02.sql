/*
    2. ottieni, in ordine crescente, gli anni distinti in cui sono stati prodotti
    film che hanno ricevuto una valutazione >= 4.
*/

SELECT DISTINCT year
FROM movie
WHERE EXISTS(
 	SELECT *
    FROM rating
    WHERE rating.mid <> movie.mid AND rating.stars>=4
)
ORDER BY year