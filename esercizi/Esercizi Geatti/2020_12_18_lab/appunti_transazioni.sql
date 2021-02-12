/*

Proprietà da garantire:


*/

/* ES. TRANSAZIONE TRA 2 CC */

START TRANSACTION;
UPDATE accounts SET balance=balance+100 WHERE acctnum=12345;
UPDATE accounts SET balance=balance-100 WHERE acctnum=54321;
COMMIT;

/*
    NOTE:
    -   ogni istruzione (se non specificato esplicitamente)
         è vista come trans unitaria
    -   le trans non possono essere annidate
*/

/*
    "deferrable"

    in def dati: 
        deferrable initially immediate  
            <- righe controllate a fine insert/update

        deferrable initially deferred   
            <- righe controllate a fine transazione

    (di default è attivata la prima)

    durante la transazione:
        set constraint all deferred
            <- tutti i vincoli verranno controllati alla fine
*/