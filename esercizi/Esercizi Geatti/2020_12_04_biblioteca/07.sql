/*

    7. i numeri di carta d'identità delle coppie di soci che hanno letto uno stesso
    libro.
        . ha_letto1 join ha_letto2 on ha_letto1.isbn = ha_letto2.isbn
            caratterizza tutte le tuple in cui i due soci hanno letto almeno
            un libro "in comune".

*/

SELECT DISTINCT HL1.ci, HL2.ci
FROM ha_letto as HL1, ha_letto as HL2
WHERE HL1.isbn = HL2.isbn AND /* Stesso libro */
	HL1.ci < HL2.ci /* Socio diverso */
