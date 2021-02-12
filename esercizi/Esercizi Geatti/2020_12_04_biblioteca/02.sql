/*
    2. i titoli dei libri nella sala A;
*/
SELECT DISTINCT titolo
FROM libro NATURAL JOIN genere
WHERe sala='A'