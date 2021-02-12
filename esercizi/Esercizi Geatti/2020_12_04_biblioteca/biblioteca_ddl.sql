/* BIBLIOTECA */



/* CREAZIONE DELLO SCHEMA

CREATE SCHEMA biblioteca;

SET search_path TO biblioteca;*/

CREATE TABLE socio
(
  ci character varying(10) NOT NULL,
  nome character varying(50) NOT NULL,
  sesso character(1),
  CONSTRAINT socio_pkey PRIMARY KEY (ci),
  CONSTRAINT socio_sesso_check CHECK (sesso IN ('M','F'))
);

CREATE TABLE genere
(
  nome character varying(50) NOT NULL,
  sala character(1) NOT NULL,
  CONSTRAINT genere_pkey PRIMARY KEY (nome)
);

CREATE TABLE libro
(
  isbn character varying(13) NOT NULL,
  titolo character varying(250),
  autore character varying(50),
  genere character varying(50),
  CONSTRAINT libro_pkey PRIMARY KEY (isbn),
  CONSTRAINT fk_libro_genere FOREIGN KEY (genere)
      REFERENCES genere (nome) 
      ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ha_letto
(
  ci character varying(10) NOT NULL,
  isbn character varying(13) NOT NULL,
  CONSTRAINT pk_ha_letto PRIMARY KEY (ci, isbn),
  CONSTRAINT fk_ha_letto_libro FOREIGN KEY (isbn)
      REFERENCES libro (isbn) 
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ha_letto_socio FOREIGN KEY (ci)
      REFERENCES socio (ci) 
      ON UPDATE CASCADE ON DELETE CASCADE
);

