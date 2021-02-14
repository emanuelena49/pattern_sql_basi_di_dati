
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


ALTER TABLE Dipartimento ADD CONSTRAINT fk_direttore
FOREIGN KEY (direttore) REFERENCES Ricercatore (nome) 
ON DELETE SET NULL
ON UPDATE CASCADE
DEFERRABLE INITIALLY IMMEDIATE; 

COMMIT;

-- popolamento --
START TRANSACTION;

SET transaction CONSTRAINTS ALL DEFERRED;

INSERT into Dipartimento values ('id000', 'Informatica', 'MIT', 'Marino Miculan'); 
INSERT into Dipartimento values ('id111', 'Informatica', 'Stanford', 'Angelo Montanari');
INSERT into Ricercatore values ('Marino Miculan', 55 ,'id000');
INSERT into Ricercatore values ('Angelo Montanari', 55 ,'id111');
INSERT into Ricercatore values ('Carla Piazza', 45 ,'id111');

COMMIT;


/*
Si scriva il codice SQL che corrisponde allo spostamento del ricercatore Robert Tarjan dal California Institute of
Technology verso la Standford University
*/

UPDATE Ricercatore 
SET afferisce='id000'
WHERE nome='Carla Piazza';

/*
Si consideri il seguente vincolo: il direttore di ogni dipartimento deve afferire al dipartimento stesso. Quali azioni
(inserimento/aggiornamento/cancellazione) e su quali tabelle possono violare tale vincolo? L’aggiornamento di cui
sopra pu`o violare questo vincolo?
*/

/*
    inserimento in Dipartimento, aggiornamento in Dipartimento

    aggiornamento in Ricercatore

    no, perche C.P. non è un direttore.
*/

-- ------------------------------------------------------------------- --
-- trigger per aggiornamento/inserimento in Dipartimento -- 

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
deferrable initially deferred              -- è differibile e di default viene differito -- 
for each row 
execute procedure funzione_controllo_direttore();

commit;

-- ------------------------------------------------------------------- --
-- trigger per aggiornamento di Ricercatore -- 

START TRANSACTION;

CREATE OR REPLACE FUNCTION controllo_aggiornamento_ricercatore()
RETURNS TRIGGER LANGUAGE plpgsql AS $$

    -- [d] -- 

    begin 
        -- new --
        -- old --

        if new.afferisce=old.afferisce then 
            return new; 
        end if;
        
        /*
            si è deciso di rimuovere automaticamente il ruolo di direttore
        */
        UPDATE Dipartimento
        SET direttore=NULL
        WHERE direttore=old.nome;

        return new;
    end;
$$;

-- v. alternativa: faccio fallire l'operazione --
CREATE OR REPLACE FUNCTION controllo_aggiornamento_ricercatore_2()
RETURNS TRIGGER LANGUAGE plpgsql AS $$

    DECLARE dummy TABLE;

    begin 
        if new.afferisce=old.afferisce then 
            return new; 
        end if;
        
        SELECT * INTO dummy
        FROM Dipartimento 
        WHERE direttore=old.nome;

        if found -- (var di default che dice se ultimo select ha trovato qualcosa )-- 
        then 
            raise exception 'Errore, non puoi cambiare dipartimento di % in quanto direttore', old;
            return null;
        else 
            -- OK --
            return new;
        end if; 
    end;
$$;

create trigger trigger_controllo_aggiornamento_ricercatore 
BEFORE UPDATE ON ricercatore
FOR EACH ROW 
EXECUTE PROCEDURE controllo_aggiornamento_ricercatore();

commit;




