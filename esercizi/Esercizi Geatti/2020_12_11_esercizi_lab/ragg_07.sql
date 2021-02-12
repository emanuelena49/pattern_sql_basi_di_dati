/*

7. Ottieni, per ciascun critico, il nome del critico e il numero di film da
   costui recensiti, ordinando il risultato rispetto al nome.

*/

SELECT name, COUNT(DISTINCT mid) AS n_movies
FROM (rating NATURAL JOIN reviewer)
GROUP BY name
ORDER BY name