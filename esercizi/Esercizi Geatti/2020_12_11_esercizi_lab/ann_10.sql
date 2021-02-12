/*

10. Quanti registi hanno diretto film più vecchi del film con mid = 107?
    - senza nessun join
    - senza group by
    - va bene count()

*/

SELECT COUNT(DISTINCT director) AS how_many
from movie
WHERE year < (
    SELECT year
    FROM movie
    WHERE mid=107
)