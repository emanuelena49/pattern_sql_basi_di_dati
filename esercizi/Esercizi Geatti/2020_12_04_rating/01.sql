/*
    1. ottieni i titoli dei film diretti da Steven Spielberg in ordine alfabetico.

*/

SELECT title
FROM movie
WHERE director="Steven Spielberg"
ORDER BY title