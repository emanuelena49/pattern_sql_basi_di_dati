/* (a) i clienti a cui vengono forniti solo prodotti di un’unica tipologia; */ 

SELECT DISTINCT cod_cliente
FROM fornisce f1 NATURAL JOIN prodotto p1
WHERE NOT EXISTS (
  SELECT *
  from fornisce f2 NATURAL JOIN prodotto p2
  WHERE f1.cod_cliente=f2.cod_cliente and 
  	p1.cod_prodotto <> p2.cod_prodotto and
  	p1.tipologia != p2.tipologia
);
