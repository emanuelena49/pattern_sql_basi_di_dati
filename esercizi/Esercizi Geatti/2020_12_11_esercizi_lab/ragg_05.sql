/*
5. ottenere il titolo e la differenza tra voto massimo e voto minimo per ogni
   film che abbia ricevuto almeno due valutazioni. Ordina il risultato
   alfabeticamente rispetto al titolo.

*/

SELECT title, max(stars)-MIN(stars) AS diff
FROM (movie RIGHT JOIN rating ON movie.mid=rating.mid)
GROUP BY title
HAVING COUNT(stars)>=2
ORDER BY title