/*
8. Ripeti l'interrogazione precedente, ma include nel risultato (in ordine
   alfabetico), soltanto i critici che hanno recensito esattamente un film.
*/

SELECT name, COUNT(distinct mid) AS n_movies
FROM (rating NATURAL JOIN reviewer)
GROUP BY name
HAVING count(DISTINCT mid)=1
ORDER BY name

