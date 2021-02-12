/*

9. Tra i film che sono stati recensiti almeno una volta, trova (in ordine
   alfabetico) i titoli di quelli che hanno ricevuto soltato valutazioni
   maggiori o uguali a 4.
   VINCOLO: senza usare interrogazioni raggruppate.

*/

/* con GB */
SELECT title
FROM (movie NATURAL JOIN rating)
GROUP BY mid, title
HAVING min(stars)>=4
ORDER BY title

/*senza gb */
SELECT DISTINCT title
FROM movie NATURAL JOIN rating
WHERE not EXISTS (
    SELECT *
    FROM rating as r1
    WHERE r1.mid = movie.mid AND
    	r1.stars < 4
    )
ORDER BY title

/* Con NOT IN:*/
        SELECT title
        FROM movie natural join rating 
        WHERE mid not in (
          SELECT mid
          FROM rating
          WHERE stars < 4
        )
        order by title;