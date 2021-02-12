/*

2. qual''''''''è la valutazione media dei film di James Cameron?

(Baldo stronzo)

*/

SELECT AVG(stars)
FROM (movie NATURAL JOIN rating)
WHERE director="James Cameron"

