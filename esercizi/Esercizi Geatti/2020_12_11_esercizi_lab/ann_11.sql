/*


11. Qual è il reviewer che ha recensito tutti i film di Spielberg?

  tutti i reviewer tali che:
  l'insieme di film recensiti dal reviewer:
  sia un sovrainsieme dei film diretti da Spielberg.
    == EQUIVALENTI ==
  tutti i reviewer tali che:
  non esiste un film diretto da Spielberg:
  che non è stato recensito da lui.

  */

SELECT name
FROM reviewer
WHERE NOT EXISTS(
    SELECT *
   	FROM movie
    WHERE director='Steven Spielberg' AND
    	NOT EXISTS(
            SELECT *
            FROM rating
            WHERE rating.mid = movie.mid AND
            	rating.rid = reviewer.rid
        )
    )