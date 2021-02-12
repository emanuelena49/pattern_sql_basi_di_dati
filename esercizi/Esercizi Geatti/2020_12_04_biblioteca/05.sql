/*
    5. i titoli dei libri e la sala in cui sono collocati;
*/

SELECT titolo, sala
FROM (libro JOIN genere on libro.genere=genere.nome)
