/*
4. Ottieni il titolo e la valutazione massima per ogni film che è stato
   valutato almeno una volta, in ordine descrescente rispetto al voto.

*/
SELECT title, MAX(stars) max_rating
FROM (movie RIGHT JOIN rating ON movie.mid=rating.mid)
GROUP BY title
ORDER BY max_rating DESC