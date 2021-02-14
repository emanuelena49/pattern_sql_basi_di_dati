create table accounts (
    id int PRIMARY KEY, 
    balance FLOAT
);

INSERT into accounts VALUES 
(1, 10000), (2, 15000), (3, 7000), (4, 20000);

-- ----------------------------------------------------- --
-- 1. RIEPILOGO ANOMALIE & LV DI ISOLAMENTO --

/*
    ANOMALIE:
    a.  perdita aggiornamento
    b.  lettura sporca
    c.  aggiornamento fantasma
    d.  letture inconsisteneti
    e.  inserimento fantasma

    LV. DI ISOLAMENTO (in SQL):

    1)  read uncommitted    <- no vincoli sui lock
            (RISOLTE: /)

    2)  read committed      <- controllo 2PL (non stretto) SOLO per le scritture
            (RISOLTE: lettura sporca)

    3)  repeatable read     <- 2PL Stretto
            (RISOLTE: lettura sporca, aggiornamento fantasma, letture inconsistenti)

    4)  serializable        <- Lock di predicato
            (RISOLTE: tutte)

    perdita di aggiornamento? così come è presentata, negli esempi, si risolve con un 
    2PL su scritture e letture (dal lv. 3 in su). Nello standard però si definisce 
    "risolta a tutti i livelli" (nella pratica ciò si risolve usando l'istruzione 
    atomica UPDATE).

    conflitto "scrittura scrittura" (inserimento di 2 chiavi uguali) <- sempre risolti

    Variazioni su postgresql:
    -   perdita aggiornamento   <- da livello 3 in su
    -   inserimento fantasma    <- risolto anche a lv. 3 (snapshot isolation)
    -   read uncommitted praticamente non esiste, è trattato come read committed

*/


-- come impostare un livello di isolamento -- 
SET TRANSACTION ISOLATION LEVEL 
    SERIALIZABLE;   -- READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE --
                    -- (di default: READ COMMITTED) -- 



