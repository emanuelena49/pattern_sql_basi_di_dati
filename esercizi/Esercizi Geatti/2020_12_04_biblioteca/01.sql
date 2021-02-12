/*
1. i nome dei soci di sesso femminile che hanno letto qualche libro;
*/

SELECT DISTINCT nome
FROM socio NATURAL JOIN ha_letto
WHERE sesso='F'