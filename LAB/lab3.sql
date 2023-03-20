use Marketing
go

/*ex 1: o interogare cu unul din operatorii UNION, INTERSECT, EXCEPT, la alegere;*/

SELECT cod_p FROM Legatura
UNION
SELECT cod_p FROM Produs
WHERE Produs.cantitate < 10 AND pret> 100

/*ex 2:  doua interogari cu operatorii INNER JOIN si, la alegere, LEFT JOIN, RIGHT JOIN sau FULL JOIN;
   o interogare va extrage date din minim trei tabele aflate in relatie many-to-many;*/

-- Afiseaza producatorii care produc produse cu produsele lor
SELECT P.nume, PR.denumire
FROM Producator P
INNER JOIN Legatura L ON P.id_prod = L.id_prod
INNER JOIN Produs PR ON L.cod_p = PR.cod_p;

-- Afiseaza producatorii o singura data care produc ciocolata sau napolitane
SELECT DISTINCT P.nume
FROM Producator P
INNER JOIN Legatura L ON P.id_prod = L.id_prod
INNER JOIN Produs PR ON L.cod_p = PR.cod_p
Where PR.denumire = 'ciocolata ' OR PR.denumire = 'napolitane'

-- Afiseaza toti producatorii, indiferent daca produc sau nu produse; 
SELECT P.nume, PR.denumire
FROM Producator P
LEFT OUTER JOIN Legatura L ON P.id_prod = L.id_prod
LEFT OUTER JOIN Produs PR ON L.cod_p = PR.cod_p;

SELECT P.nume, PR.denumire
FROM Producator P
RIGHT OUTER JOIN Legatura L ON P.id_prod = L.id_prod
RIGHT OUTER JOIN Produs PR ON L.cod_p = PR.cod_p;

-- Afiseaza produsele care au fost comandate macar o data
SELECT P.denumire, C.nr_comanda
From Produs P
INNER JOIN ProdCom PC ON P.cod_p=PC.cod_p
INNER JOIN Comanda C ON PC.nr_comanda=C.nr_comanda

SELECT P.denumire, C.nr_comanda
From Produs P
LEFT OUTER JOIN ProdCom PC ON P.cod_p=PC.cod_p
LEFT OUTER JOIN Comanda C ON PC.nr_comanda=C.nr_comanda

SELECT P.denumire, C.nr_comanda
From Produs P
RIGHT OUTER JOIN ProdCom PC ON P.cod_p=PC.cod_p
RIGHT OUTER JOIN Comanda C ON PC.nr_comanda=C.nr_comanda

/* ex 3: trei interogari cu clauza GROUP BY; una dintre acestea va contine clauza HAVING; se vor folosi
   cel putin trei operatori de agregare dintre: COUNT, SUM, AVG, MIN, MAX. */

   SELECT COUNT(*) FROM Producator

   -- Afiseaza numarul total de comezi pe care le-a facut un client
   SELECT id_c,
   COUNT(nr_comanda) AS TOTALCOM
   FROM Comanda
   GROUP BY id_c; 

   -- Afiseaza numarul total de comenzi = 2 pe care le-a facut un client
   SELECT id_c,
   COUNT(nr_comanda) AS TOTALCOM
   FROM Comanda
   GROUP BY id_c
   HAVING count(nr_comanda) = 2

   -- Afiseaza pretul maxim al produselor
   SELECT denumire, 
   MAX(pret) as PRETMAX
   FROM Produs
   GROUP BY denumire
    
	SELECT *FROM Produs

   -- Afiseaza pretul minim al produselor
   SELECT denumire, 
   MIN(pret) as PRETMAX
   FROM Produs
   GROUP BY denumire

   SELECT *FROM Produs
 
   --SELECT AVG(pret)
   --FROM Produs

/* ex 4: doua interogari imbricate – se vor folosi operatorii IN si EXISTS (interogare SELECT in clauza
   WHERE); */

   SELECT * FROM Produs WHERE denumire IN ('paine', 'faina', 'ulei')

   SELECT nume, varsta FROM Client
   WHERE EXISTS(SELECT nr_comanda FROM Comanda WHERE Client.id_c = Comanda.id_c and Client.varsta < 20)

