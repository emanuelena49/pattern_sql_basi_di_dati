/*
    6. i titoli dei libri e la sala in cui sono collocati, inclusi i libri di cui
    non è possibile ricavare la collocazione;
*/

SELECT titolo, sala
FROM (libro LEFT JOIN genere ON libro.genere=genere.nome)
