CREATE DATABSE Marketing
go
use Marketing

DROP TABLE Produs
CREATE TABLE Produs(cod_p int identity(1,1) PRIMARY KEY,
					denumire varchar(50),
					cantitate int,
					pret int);

DROP TABLE Client
CREATE TABLE Client(id_c int identity(1,1) PRIMARY KEY,
					   nume varchar(100),
					   varsta int);

DROP TABLE Cumparaturi
CREATE TABLE Cumparaturi(cod_p int FOREIGN KEY REFERENCES Produs(cod_p) 
						  ON UPDATE CASCADE
						  ON DELETE CASCADE,
					      id_c int FOREIGN KEY REFERENCES Client(id_c) 
						  ON UPDATE CASCADE
						  ON DELETE CASCADE,
						  data_cumparare date,
						  CONSTRAINT PK_Cumparaturi PRIMARY KEY(cod_p, id_c));
DROP TABLE Producator
CREATE TABLE Producator(id_prod int identity(1,1) PRIMARY KEY,
                         nume varchar(50));

DROP TABLE Legatura
CREATE TABLE Legatura(cod_p int FOREIGN KEY REFERENCES Produs(cod_p) 
						ON UPDATE CASCADE
						ON DELETE CASCADE,
                       id_prod int FOREIGN KEY REFERENCES Producator(id_prod) 
					    ON UPDATE CASCADE
						ON DELETE CASCADE,
					   data_producere date,
					   CONSTRAINT PK_Legatura PRIMARY KEY(cod_p, id_prod));
DROP TABLE Comanda
CREATE TABLE Comanda(nr_comanda int identity(1,1) PRIMARY KEY,
					  ora time,
					  id_c int FOREIGN KEY REFERENCES Client(id_c) 
					  ON UPDATE CASCADE
					  ON DELETE CASCADE);
DROP TABLE ProdCom
CREATE TABLE ProdCom(cod_p int FOREIGN KEY REFERENCES Produs(cod_p)
						ON UPDATE CASCADE
						ON DELETE CASCADE,
					  nr_comanda int FOREIGN KEY REFERENCES Comanda(nr_comanda)
					    ON UPDATE CASCADE
					    ON DELETE CASCADE,
					  CONSTRAINT PK_ProdCom PRIMARY KEY(cod_p, nr_comanda));

INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'faina', 50, 6);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'ulei', 25, 12);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'oua', 120, 2);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'orez', 15, 5);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'gris', 15, 4);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'paine', 22, 7);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'ciocolata', 14, 3);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'napolitane', 18, 9);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'corn', 5, 5);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'covrigi', 24, 2);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'pizza', 3, 28);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'burger', 9, 32);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'prajitura', 12, 9);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'tort', 3, 50);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'cascaval', 7, 18);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'lapte', 10, 15);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'salam', 25, 27);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'mere', 50, 1);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'pere', 50, 2);
INSERT INTO Produs( denumire, cantitate, pret) VALUES ( 'banane', 30, 6);

select *from Produs;

INSERT INTO Client( nume, varsta) VALUES ( 'Maria', 25);
INSERT INTO Client( nume, varsta) VALUES ( 'Sorana', 19);
INSERT INTO Client( nume, varsta) VALUES ( 'Ioana', 20);
INSERT INTO Client( nume, varsta) VALUES ( 'Elena', 21);
INSERT INTO Client( nume, varsta) VALUES ( 'Bianca', 18);
INSERT INTO Client( nume, varsta) VALUES ( 'Cristina', 25);
INSERT INTO Client( nume, varsta) VALUES ( 'Andra', 50);
INSERT INTO Client( nume, varsta) VALUES ( 'Andrei', 52);
INSERT INTO Client( nume, varsta) VALUES ( 'Casiana', 20);
INSERT INTO Client( nume, varsta) VALUES ( 'Ioana', 48);
INSERT INTO Client( nume, varsta) VALUES ( 'Stefania', 73);
INSERT INTO Client( nume, varsta) VALUES ( 'Andrada', 65);
INSERT INTO Client( nume, varsta) VALUES ( 'Robert', 57);
INSERT INTO Client( nume, varsta) VALUES ( 'Darius', 7);
INSERT INTO Client( nume, varsta) VALUES ( 'Sebi', 25);
INSERT INTO Client( nume, varsta) VALUES ( 'Eliza', 24);
INSERT INTO Client( nume, varsta) VALUES ( 'Daniel', 28);
INSERT INTO Client( nume, varsta) VALUES ( 'Andreea', 30);
INSERT INTO Client( nume, varsta) VALUES ( 'Mihai', 47);
INSERT INTO Client( nume, varsta) VALUES ( 'Albert', 89);

select *from Client

INSERT INTO Producator( nume) VALUES( 'Panemar');
INSERT INTO Producator(nume) VALUES( 'Baneasa');
INSERT INTO Producator(nume) VALUES( 'Unisol');
INSERT INTO Producator(nume) VALUES( 'Deroni');
INSERT INTO Producator(nume) VALUES( 'Milka');
INSERT INTO Producator(nume) VALUES( 'Rochen');
INSERT INTO Producator( nume) VALUES( 'Alfers');
INSERT INTO Producator( nume) VALUES( 'Cupidon pizza');
INSERT INTO Producator( nume) VALUES( 'Big Belly');
INSERT INTO Producator( nume) VALUES( 'Pralina');
INSERT INTO Producator( nume) VALUES( 'Hochland');
INSERT INTO Producator( nume) VALUES( 'LaDorna');
INSERT INTO Producator( nume) VALUES( 'Napolact');
INSERT INTO Producator( nume) VALUES( 'Alpro');
INSERT INTO Producator( nume) VALUES( 'Dizing');
INSERT INTO Producator( nume) VALUES( 'Schogetten');

SELECT *FROM Producator;

INSERT INTO Comanda( ora, id_c) VALUES ( '10:15:00', 1);
INSERT INTO Comanda( ora, id_c) VALUES ( '11:15:00', 1);
INSERT INTO Comanda( ora, id_c) VALUES ( '12:15:00', 1);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:16:00', 2);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:17:00', 5);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:18:00', 8);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:15:02', 12);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:15:07', 5);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:25:00', 18);
INSERT INTO Comanda( ora, id_c) VALUES ( '18:15:00', 13);
INSERT INTO Comanda( ora, id_c) VALUES ( '19:16:00', 12);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:15:08', 15);
INSERT INTO Comanda( ora, id_c) VALUES ( '10:15:10', 8);
INSERT INTO Comanda( ora, id_c) VALUES ( NULL, 19);
INSERT INTO Comanda( ora, id_c) VALUES ( '15:15:15', 15);

select *from Comanda;
select *from Cumparaturi;
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(1, 1, '2022-11-02');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(1, 2, '2022-11-01');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(1, 3, '2022-10-22');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(3, 1, '2022-10-12');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(5, 2, '2022-10-13');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(8, 7, '2022-11-02');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(6, 9, '2022-11-01');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(18, 10, '2022-11-01');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(20, 12, '2022-10-29');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(20, 15, '2022-10-31');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(3, 10, '2022-10-30');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(7, 8, '2022-09-02');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(6, 8, '2022-09-15');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(13, 8, '2022-09-16');
INSERT INTO Cumparaturi(cod_p, id_c, data_cumparare) VALUES(19, 1, '2022-09-18');

INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (1, 1);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (1, 3);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (1, 5);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (2, 1);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (3, 1);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (10, 7);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (18, 10);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (1, 10);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (16, 13);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (2, 2);
INSERT INTO ProdCom(cod_p, nr_comanda) VALUES (15, 4);

select *from ProdCom
select *from Legatura
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (1,2, '2021-11-15');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (2,3, '2022-08-08');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (4,4, '2022-06-17');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (5,4, '2022-10-14');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (6,1, '2021-11-18');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (7,5, '2021-11-19');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (8,6, '2021-11-20');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (9,7, '2020-02-02');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (7,6, '2021-11-15');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (8,5, '2021-11-15');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (15,11, '2021-10-15');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (16,12, '2021-11-26');
INSERT INTO Legatura(cod_p, id_prod, data_producere) VALUES (7,16, '2022-11-01');

UPDATE Produs 
SET cantitate=12 
where pret=27;

UPDATE Produs
SET pret=3 
WHERE cantitate > 100;

UPDATE Produs
SET pret=45 
WHERE cantitate >= 2 and cantitate <=5;

UPDATE Produs 
SET cantitate=111 
WHERE denumire = 'oua' or denumire = 'orez' ;

select *from Produs;

delete from Comanda
where ora is null;
select *from Comanda;

delete from ProdCom 
where not nr_comanda =1 and not nr_comanda=10 and not nr_comanda=13;
select *from ProdCom

DELETE FROM Produs where cod_p=1;