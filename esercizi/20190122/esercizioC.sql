from prodotto p NATURAL join fornisce F
WHERE not EXISTS (
    SELECT *
      from prodotto P1
      WHERE p.cod_produttore = P1.cod_produttore and not EXISTS (
        SELECT *
          from fornisce F1
          WHERE P1.cod_prodotto = F1.cod_prodotto And F1.cod_cliente = F.cod_cliente)
    )
   
    And not EXISTS(
        SELECT *
          FROM prodotto P1 NATURAL Join fornisce F1
          where F.cod_cliente = F1.cod_cliente ANd P1.cod_produttore != p.cod_produttore
    )
