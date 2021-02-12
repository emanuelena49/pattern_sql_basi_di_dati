/*
    3. gli autori e il genere dei libri letti da soci maschi;
*/

SELECT autore, genere
FROM libro
WHERE not EXISTS(
    SELECT * 
    FROM (socio NATURAL JOIN ha_letto)
    WHERE sesso='F' AND libro.isbn = isbn
)