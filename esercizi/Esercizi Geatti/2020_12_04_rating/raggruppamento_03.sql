
/*

3. Qual è la data della critica più recente a un film di Victor Fleming?
   -- pensare a come farla senza funzioni aggregate...

*/

/* con f. aggregata */
SELECT MAX(ratingDate) last_rating_date
FROM (movie NATURAL JOIN rating)
WHERE director="Victor Fleming"

/* senza f. aggregata */
SELECT ratingDate
FROM (rating as r1 NATURAL JOIN movie as m1)
WHERE director="Victor Fleming" AND
	NOT EXISTS (
        SELECT *
        FROM (rating as r2 NATURAL JOIN movie as m2)
        WHERE m2.director="Victor Fleming" 
       	AND	r1.ratingDate<r2.ratingDate 
    )