/*
    4. i titoli dei libri gialli letti da Ellade Pedone;
*/

SELECT titolo
FROM libro, socio
WHERE socio.nome = "Ellade Pedone" AND
	libro.genere = "giallo"