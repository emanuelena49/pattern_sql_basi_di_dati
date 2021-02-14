/*

2. Si consideri il seguente schema relazionale:
STUDENTE(matricola, nome, cognome)
ESAME(codice, descrizione)
HA SOSTENUTO(matricola studente, codice esame, valutazione, lode)

Tenendo presente che:
• si vogliono conoscere tutti i dettagli riguardanti studenti ed esami;
• la valutazione `e espressa da un numero intero compreso fra 0 e 30 e la lode pu`o essere assegnata
solamente a chi ottiene una valutazione pari a 30,
si presenti del codice SQL che implementa le tre tabelle, unitamente alle chiavi primarie, alle chiavi esterne
e a qualsiasi eventuale altro vincolo si ritenga necessario imporre.

*/
start transaction;

create table studente (
matricola int primary key,
nome varchar(100) not null,
cognome varchar(100) not null
);

create table esame(
codice int primary key,
descrizione varchar(300) not null 
);

create table Ha_Sostenuto(
  matricola_studente int REFERENCES studente (matricola),
  codice_esame int REFERENCES esame (codice),
  valutazione int not null,
  lode BOOLEAN DEFAULT FALSE,
  
  primary key (matricola_studente, codice_esame), 
  CONSTRAINT valutazione_0_30 CHECK (valutazione>=0 AND valutazione<=30), 
  CONSTRAINT controllo_lode CHECK (valutazione=30 OR (valutazione<30 AND lode=FALSE))
);

commit;
