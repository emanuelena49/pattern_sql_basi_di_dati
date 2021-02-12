-- il cliente (i clienti se pi`u di uno) a cui viene fornito il maggior numero di prodotto --

CREATE VIEW maggiori_prodotti(cod_cliente,numero_prodotti) AS
    SELECT cod_cliente, count (cod_prodotto)
    from fornisce
    GROUP By cod_cliente;
 
SELECT cod_cliente
from maggiori_prodotti 
WHERE numero_prodotti = ALL (
    SELECT numero_prodotti
      from maggiori_prodotti
);