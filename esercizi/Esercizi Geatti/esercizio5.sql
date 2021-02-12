start transaction;

-- Crea funzione per controllare che una nuova tupla non esista come video
create or replace function controlla_video_not_exists() 
returns trigger language plpgsql as $$

declare dummy dom_codice;

begin

select * into dummy
from video
where codice=new.codice;

if found then
raise EXCEPTION 'Errore, stai provando ad inserire una tupla che esiste già come video: %', new;
return null;
else return new; 
end if;

end; 
$$;

-- Ora creo il trigger che usa la funzione
create trigger valida_pdf
before insert or update
on pdf
for each row
execute procedure controlla_video_not_exists();

commit;


-- Transazione per inserire qualche documento e un video
start transaction;

insert into documento (codice, titolo) 
values (2, 'B'), (3, 'C'), (4, 'D');

insert into video (codice, durata) 
values (2, 50);

commit;

-- Ora provo ad inserire un pdf che esiste già come video
insert into pdf (codice, pagine) 
values (2, 10); 
-- FALLISCE: SCATTA IL TRIGGER!

-- (provo ad inserire un pdf ok)
insert into pdf (codice, pagine) 
values (3, 10); 
-- FFUNZIONA! 