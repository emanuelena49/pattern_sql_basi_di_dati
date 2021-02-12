/*

6. Ottieni, in ordine alfabetico, i nomi dei registi dei film che hanno
   ricevuto una valutazione media di tutti i loro film superiore a 3.
*/

SELECT director
FROM (movie NATURAL JOIN rating)
WHERE director is not null 
GROUP BY mid
HAVING AVG(stars)>3

