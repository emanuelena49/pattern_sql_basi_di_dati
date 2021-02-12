/*
a) i reparti in cui sono presenti sia medici di sesso femminile che medici di sesso maschile, 
tutti nati dopo il 1960
(al pi`u 59 anni); 
*/

SELECT nome
FROM reparto R
WHERE EXISTS (
    SELECT *
    FROM Medico
    WHERE Reparto=R.nome AND
        Genere='Femmina'
) AND EXISTS (
    SELECT *
    FROM Medico
    WHERE Reparto=R.nome AND
        Genere='Maschio'
) AND 1960 <= ALL (
    SELECT AnnoNascita
    FROM Medico
    WHERE Reparto=R.nome
);


/*
(b) (FACOLTATIVO) il reparto (i reparti se pi`u di uno) col numero pi`u alto di medici di sesso femminile.
*/

CREATE VIEW conta_f (reparto, numero_f) AS 
    SELECT reparto, COUNT(*)
    FROM Medico 
    WHERE genere='Femmina'
    GROUP BY reparto;


SELECT reparto, numero_f
FROM conta_f
WHERE numero_f >= ALL (
    SELECT numero_f 
    FROM conta_f
);

/* algebra ospedali con dipendenti di tutte e sole le città del veneto */
candidati ← π nome (reparto)

citta_veneto ← π Citta (σ Regione=Veneto (si_trova_in))

requisiti ← candidati ⨯ citta_veneto

stato_di_fatto ← π Reparto, Citta (
medico 
) -- qui ho le città di tutti i medici di un reparto

-- reparti con almeno 1 città del veneto PERSA
no_good_sovrainsieme ← π Reparto (requisiti - stato_di_fatto)

-- reparti con ALMENO 1 città non del veneto
no_good_sottoinsieme ← π Reparto (stato_di_fatto - requisiti)

stato_di_fatto ← candidati - no_good_sottoinsieme - no_good_sovrainsieme


/*
- read uncommitted <- il secondo insert legge dal primo e fallisce perchè c'è il vincolo di chiave

    (la tupla verrà inserita sse t1 fa commit)

- read committed:

    quanto t2 prova ad inserire, viene messa in attesa (lock in scrittura sulla riga). Al termine dell'attesa, 
    quanto t1 ha terminato: 

    se t1 ha abortito, t2 riesce ad inserire.
    se t1 ha fatto commit, t2 non riesce ad inserire perchè scatta il vincolo di chiave.

    in ogni caso al termine ci sarà la nuova tupla.

- repeatable read, serialazable: visto che c'è sempre il lock in scrittura, succede la stessa cosa del read committed

*/


