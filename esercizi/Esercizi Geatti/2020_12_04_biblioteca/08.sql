/*

8. i numeri di carta di identita di chi ha letto libri di cui NON è specificato
   il genere.

*/

SELECT ci
FROM socio
WHERE NOT EXISTS(
    SELECT *
    FROM (ha_letto JOIN libro on ha_letto.isbn = libro.isbn)
    WHERE ci = socio.ci AND
    	genere = null
)