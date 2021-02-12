/*

3. Ottieni i nomi dei critici, i titoli dei film, la corrispondente valutazione
   e la data della valutazione, ordinati come segue:
    . il nome del critico (in ordine alfabetico)
    . il titolo del film (in ordine alfabetico)
    . valutazione (dalla più alta alla più bassa)

*/

SELECT name, title, stars
FROM ((movie NATURAL JOIN rating) NATURAL JOIN reviewer)
ORDER BY name, title, stars DESC