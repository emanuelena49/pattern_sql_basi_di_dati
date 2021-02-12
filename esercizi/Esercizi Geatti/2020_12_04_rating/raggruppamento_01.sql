/*

1. Quanti film nella base di dati sono stati prodotti tra il 1977 e il 1985
   inclusi?

*/

SELECT COUNT(mid)
FROM movie
WHERE year>=1977 AND year<= 1985


