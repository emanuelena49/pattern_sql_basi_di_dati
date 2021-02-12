SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.cliente (
    cod_cliente integer NOT NULL,
    telefono character varying,
    email character varying,
    settore character varying
);
CREATE TABLE public.fornisce (
    cod_cliente integer NOT NULL,
    cod_prodotto integer NOT NULL
);
CREATE TABLE public.prodotto (
    cod_prodotto integer NOT NULL,
    cod_produttore integer,
    tipologia character varying,
    prezzo_unitario double precision
);
ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_email_key UNIQUE (email);
ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cod_cliente);
ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_telefono_key UNIQUE (telefono);
ALTER TABLE ONLY public.fornisce
    ADD CONSTRAINT fornisce_pkey PRIMARY KEY (cod_cliente, cod_prodotto);
ALTER TABLE ONLY public.prodotto
    ADD CONSTRAINT prodotto_pkey PRIMARY KEY (cod_prodotto);
ALTER TABLE ONLY public.fornisce
    ADD CONSTRAINT fornisce_cod_cliente_fkey FOREIGN KEY (cod_cliente) REFERENCES public.cliente(cod_cliente);
ALTER TABLE ONLY public.fornisce
    ADD CONSTRAINT fornisce_cod_prodotto_fkey FOREIGN KEY (cod_prodotto) REFERENCES public.prodotto(cod_prodotto);