-- ------------------------------------------------------------ --
-- 1. ON DELETE E ON UPDATE SULLE FOREIGN KEY --

-- creo tabelle e vincoli da esercizio 01/02/2021 --
START TRANSACTION;

CREATE DOMAIN id AS VARCHAR(5);

CREATE TABLE Dipartimento (
    id_dip id PRIMARY KEY, 
    nome_dip VARCHAR(50), 
    universita VARCHAR(50), 
    direttore VARCHAR(50)       /* FK references Ricercatore (nome) */

    /* 
        qui ho 2 tabelle con FK una verso l'altra. 
        Non posso creare qui il vincolo FK perchè Ricercatore ancora non esiste 
    */
); 

CREATE TABLE Ricercatore (
    nome VARCHAR(50) PRIMARY KEY, 
    eta int, 
    afferisce id, 

    -- vincolo di foreign key, non specifico nient'altro --
    CONSTRAINT fk_afferisce FOREIGN KEY (afferisce) REFERENCES Dipartimento (id_dip)
);

-- inserisco 1 valore per tabella -- 
INSERT into Dipartimento values ('idxxx', 'Informatica', 'MIT', 'Marino Miculan'); 
INSERT into Dipartimento values ('id111', 'Informatica', 'Stanford', 'Marino Miculan');
INSERT into Ricercatore values ('Marino Miculan', 55 ,'idxxx');
INSERT into Ricercatore values ('Angelo Montanari', 55 ,'idxxx');

COMMIT;

-- di default queste operazioni verranno bloccate per il vincolo FK --
update Dipartimento set id_dip='id000' WHERE id_dip='idxxx';
DELETE FROM Dipartimento WHERE id_dip='id111';

START TRANSACTION;
ALTER TABLE Ricercatore DROP CONSTRAINT fk_afferisce;

ALTER TABLE Ricercatore ADD CONSTRAINT fk_afferisce 
    FOREIGN KEY (afferisce) REFERENCES Dipartimento (id_dip)

    ON DELETE SET NULL  -- NO ACTION | RESTRAINT | CASCADE | SET NULL | SET DEFAULT -- 
    ON UPDATE CASCADE   -- NO ACTION | RESTRAINT | CASCADE -- 
    /*
        NO ACTION   <- quello di default, non fa niente e l'op. (sulla tupla puntata) 
                        viene bloccata, perchè si viola il vincolo FK.
        RESTRAINT   <- come NO ACTION, ma il controllo viene differito alla fine della transazione.
        CASCADE     <- aggiorna/elimina a cascata anche le tuple con FK -> la tupla eliminata/aggiornata.
        SET NULL|DEFAULT    <- quando scatta l'eliminazione, metti un valore nullo/di default nelle FK che
                                puntano la tupla eliminata.

        NOTA: "tupla aggiornata/eliminata"  <- in questo caso, quella in Dipartimento
        invece scatta il vincolo di FK nelle tuple di Ricercatore dove il campo afferisce
        punta alla tupla che viene aggiornata/eliminata.

        (se elimino/modifico la tupla in Ricercatore, non cambia niente)
    */
;

COMMIT;

-- ora funzioneranno --
update Dipartimento set id_dip='id000' WHERE id_dip='idxxx';
DELETE FROM Dipartimento WHERE id_dip='id111';

-- ------------------------------------------------------------ --
-- 2. VINCOLI DIFFERIBILI --

-- aggiungiamo alle tabelle di prima una FK Dipartimento.direttore -> Ricercatore.nome --

/*
    PROBLEMA: ci accorgiamo che, una volta creato il vincolo, sarà impossibile inserire 
    nuove tuple per intero a causa delle 2 tabelle le cui FK si puntano a vicenda.

    ci sono diverse soluzioni possibili:
    -   prima popolare e poi mettere i vincoli (problema: nuovo dip. con nuovo ricercatore impossibile)
    -   accettare valori nulli su quei campi ed effettuare l'inserimento in 2 step  (qui già lo facciamo, 
        ma non sempre è una buona soluzione)

    -   [...]

    -   rendere i vincoli DIFFERIBILI, cioè che vengono controllati solo alla fine di una transazione 
        - SE LA TRANSAZIONE  E' CONFIGURATA PER PERMETTERLO -
        (posso quindi effettuare tutti gli inserimenti e poi, a fine trans. , si controllano i vincoli di FK)
*/

-- inserisco il nuovo vincolo come differibile -- 
ALTER TABLE Dipartimento ADD CONSTRAINT fk_direttore 
    FOREIGN KEY (direttore) REFERENCES Ricercatore (nome) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE
    -- imposto il vincolo come differibile --
    DEFERRABLE INITIALLY IMMEDIATE;

-- tento un inserimento (senza transazione) -- 
-- (NON FUNZIONA: scatta fk_direttore) --
START TRANSACTION;
INSERT into Dipartimento values ('id111', 'Informatica', 'Stanford', 'Angelo Montanari');
INSERT into Ricercatore values ('Angelo Montanari', 55 ,'id111');
COMMIT;


-- osservo che non funziona in entrambi gli ordini -- 
-- (NON FUNZIONA: scatta fk_afferisce) --
START TRANSACTION;
INSERT into Ricercatore values ('Angelo Montanari', 55 ,'id111');
INSERT into Dipartimento values ('id111', 'Informatica', 'Stanford', 'Angelo Montanari');
COMMIT;

-- ora provo in una transazione dove differisco il controllo dei vincoli -- 
START TRANSACTION;

-- comando per differire il controllo dei vincoli --
SET CONSTRAINTS ALL DEFERRED;

INSERT into Dipartimento values ('id111', 'Informatica', 'Stanford', 'Angelo Montanari');
INSERT into Ricercatore values ('Angelo Montanari', 55 ,'id111');

COMMIT;

/*
    NOTE: 
    
    Per come è struttrato ora, devo inserire PRIMA dipartimeno POI ricercatore. 
    Solo fk_direttore è messo come differibile, fk_afferisce (visto che non si
    è specificato niente) di base è non differibile.

    Potrei impostare un vincolo come differito a priori (senza che sia necessario 
    esplicitarlo nella transazione) mettendo DEFERRABLE INITIALLY DEFERRED al posto
    di DEFERRABLE INITIALLY IMMEDIATE.

    Posso differire qualsiasi vincolo, a parte NOT NULL e i vincoli di tipo CHECK.

    Posso differire anche i trigger: nella creazione devo però mettere  
    CREATE CONSTRAINT TRIGGER [...]; al posto di CREATE TRIGGER [...]; .
*/

-- ------------------------------------------------------------ --
-- 2.1 TRIGGER DIFFERIBILE --

/*
    inserisco un trigger per controllare che, in fase di inserimento e aggiornamento di
    un Dipartimento, il direttore deve afferire al dipartimento.

    metto il trigger come differito di default (DEFERRABLE INITIALLY DEFERRED).

    NOTA: questo controllo in realtà è insufficiente per garantire che il direttore afferisce. 
    Dovrei controllare anche all'aggiornamento di un ricercatore.
*/

START TRANSACTION;

create or replace function funzione_controllo_direttore()
returns trigger language plpgsql as $$
    declare dipartimento_direttore id;
    begin

    -- se non ho un nuovo direttore, OK --
    if new.direttore is null then return new; end if;

    -- cerco il dipartimento del nuovo direttore --
    select afferisce into dipartimento_direttore
    from ricercatore where nome = new.direttore;

    if dipartimento_direttore=new.id_dip then 
        return new; -- ok, il nuovo direttore afferisce al dipartimento -- 
    else 
        raise exception 'Il direttore % non afferisce al dipartimento %', new.direttore, new.id_dip;
        return null; -- NO, il nuovo direttore non afferisce -- 
    end if;

    end;
$$;

drop trigger if EXISTS trigger_controllo_direttore on dipartimento;

create constraint trigger trigger_controllo_direttore   -- constraint trigger invece di trigger --  
after insert or update on Dipartimento     -- quando eseguo (NOTA: per i constraint trigger, SOLO after) --
deferrable initially deferred               -- è differibile e di default viene differito -- 
for each row 
execute procedure funzione_controllo_direttore();

commit;


-- questo inserimento fallirà (A.M. non afferisce al Politecnico)--
UPDATE Dipartimento 
    SET direttore='Angelo Montanari'
    WHERE id_dip='id000';
    

-- questo invece avrà successo -- 
start transaction;

insert into Ricercatore values ('Carla Piazza', 45, 'id000');

UPDATE Dipartimento 
    SET direttore='Carla Piazza'
    WHERE id_dip='id000';
    
commit;

-- qui si nota l'effetto del differimento --
start TRANSACTION;

insert into Dipartimento VALUES 
    ('id222', 'Informatica', 'Politecnico', 'Marino Miculan');

update Ricercatore 
    set afferisce='id222'
    where nome='Marino Miculan';

-- notare che non ho dovuto differire esplicitamente --

commit;



