/*

9. i numeri di carta d'identità dei soci che hanno letto almeno un libro
   situato nella sala A.

*/

SELECT ci
FROM socio
WHERE NOT EXISTS(
    SELECT *
    FROM ha_letto, libro, genere
    WHERE ci = socio.ci AND
    	ha_letto.isbn = libro.isbn AND
    	libro.genere = genere.nome AND
    	genere.sala = 'A'
)