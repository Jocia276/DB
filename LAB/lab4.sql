USE Marketing
go

 -- de cate ori au fost comandate toate produsele la care le-am atribuit cel putin un producator 

 go
 CREATE PROCEDURE
 nr_vanzari_online_produs
 AS
 BEGIN
 SELECT P.denumire as produs, PR.nume as nume_producator , L.data_producere, count(C.nr_comanda) as nr_vanzari
 FROM Producator PR
 INNER JOIN Legatura L ON PR.id_prod = L.id_prod
 INNER JOIN Produs P ON L.cod_p = P.cod_p
 LEFT JOIN ProdCom PC ON P.cod_p = PC.cod_p
 LEFT JOIN Comanda C On PC.nr_comanda = C.nr_comanda
 GROUP BY P.denumire, PR.nume, L.data_producere
 end

 go
 exec nr_vanzari_online_produs
 

 --- ex 1)
 /*scrieti cate o procedura stocata care introduce date intr-un tabel, pentru cel putin trei tabele, inclusiv un tabel cu o cheie primara compusa;
 
 ->parametrii unei astfel de proceduri sunt atributele care descriu entitatile / relatiile din tabel,  mai putin coloanele cheilor primare 
 (exceptie facand o procedura stocata care adauga date intr-o tabela de legatura, pentru care se poate indica cheia primara);
 ->fiecare procedura va utiliza functii pentru validarea anumitor parametri; se cer cel putin trei functii 
 user-defined (optional se pot utiliza, pe langa aceste trei functii, si functii sistem); */

 go

 -- functie de validate a id-ului; nu trebuie sa fie null

 CREATE FUNCTION validate_id (@id int)
 RETURNS bit -- returns true if id nu este null
 BEGIN
 DECLARE @valid bit
 SET @valid = 0
 IF @id IS NOT NULL SET @valid=1
 RETURN @valid
 END

 go

 -- functie de validare a numelui; nu trebuie sa contina cifre/caractere speciale

 CREATE FUNCTION validate_name( @name varchar(50))
 RETURNS BIT 
 BEGIN
 DECLARE @valid bit
 SET @valid = 0
 IF (@name IS NOT NULL AND @name NOT LIKE '%[^A-Z]%') SET @valid = 1
 RETURN @valid
 END

 go
 -- functie de validare a unui producator; verifica daca exista sau nu

 CREATE FUNCTION if_exist_producator(@id int)
 RETURNS bit
 BEGIN 
 declare @valid bit
 set @valid=0
declare @n int
set @n =0
select @n = count(*) from Producator where  id_prod =@id

if @n = 0 set @valid=1
RETURN @valid
END
 
 go

 -- procedura pentru inserarea de date in tabelul produs

 CREATE OR ALTER PROCEDURE insert_into_produs

 @denumire varchar(50),
 @cantitate int,
 @pret int

 AS
 BEGIN

-- DECLARE @valid_id bit
DECLARE @valid_name bit

--SET @valid_id = dbo.validate_id(@cod_p)

--IF  @valid_id != 1 THROW 51000,'Codul produsului trebuie sa fie diferit de null!',1

SET @valid_name = dbo.validate_name(@denumire)

IF @valid_name !=1 THROW 51000,'Numele produsului trebuie sa contina doar litere!',1
/*
DECLARE @n int
SET @n =0
SELECT @n = count(*) from Produs WHERE cod_p = @cod_p

IF @n != 0 THROW 51000, 'Produsul exista deja!',1
ELSE*/
INSERT INTO Produs(denumire, cantitate, pret)
VALUES( @denumire, @cantitate, @pret)
END

go
select *from Produs

exec insert_into_produs  ovaz, 7, 12 ; -- produsul exista deja
exec insert_into_produs  k, 9, 9 ; -- codul produsului trebuie sa fie diferit de null
exec insert_into_produs  2,2,2 ; -- numele produsului trebuie sa contina doar litere
exec insert_into_produs  lapteD, 2, 26 ; 
delete from Produs where cod_p=3232
--

go

-- procedura pentru inserarea de date in tabelul Producator

CREATE OR ALTER PROCEDURE insert_into_t_producator
@nume varchar(50)

AS
BEGIN
DECLARE @valid_id bit
declare @valid_name bit
declare @valid_producer bit
/*
SET @valid_id = dbo.validate_id(@id)
IF @valid_id != 1
THROW 51000,'ID-ul producatorului trebuie sa fie diferit de null!',1
*/
SET @valid_name = dbo.validate_name(@nume)
IF @valid_name !=1  THROW 51000,'Numele producatorului trebuie sa contina doar litere!',1
/*
SET @valid_producer = dbo.if_exist_producator(@id)
IF @valid_producer != 1 THROW 51000, 'Producatorul exista deja!',1
ELSE*/
INSERT INTO Producator( nume)
VALUES ( @nume)
END
go

exec insert_into_t_producator  abc
exec insert_into_t_producator  Panemar

exec insert_into_t_producator  Tucano
delete from Producator where id_prod=1111

exec insert_into_t_producator  C2
exec insert_into_t_producator mmnmn

select *from Producator

-----

go

--procedura pentru inserarea de date in tabelul Legatura

CREATE OR ALTER PROCEDURE insert_into_legatura
@cod_produs int, 
@id_producator int,
@data_producere date

AS
BEGIN

IF @cod_produs IS NULL
THROW 51000,'Codul produsului trebuie sa fie diferit de null!',1

IF @id_producator IS NULL
THROW 51000, 'ID-ul producatorului NU trebuie sa fie NULL', 1

IF @data_producere IS NULL
THROW 51000, 'Data nu trebuie sa fie null', 1

DECLARE @n int
SET @n =0
SELECT @n = count(*) from Producator
WHERE id_prod =@id_producator

IF @n = 0 
THROW 51000, 'Producatorul precizat nu exista!', 1

DECLARE @m int
SET @m =0
SELECT @m = count(*) from Produs WHERE cod_p = @cod_produs

IF @m = 0
THROW 51000, 'Produsul precizat nu exista!', 1

DECLARE @n1 int
SET @n1 =0
SELECT @n1 = count(*) from Legatura WHERE id_prod =@id_producator

DECLARE @m1 int
SET @m1 =0
SELECT @m1 = count(*) from Legatura WHERE cod_p = @cod_produs

IF @n1 != 0 or @m1 != 0 THROW 51000, 'Legatura dintre produs si producator exista deja!',1
ELSE 
INSERT INTO Legatura(cod_p, id_prod, data_producere)
VALUES (@cod_produs, @id_producator, @data_producere)
END 
GO

select *from Produs
select *from Producator
select *from Legatura


exec insert_into_legatura 2, 16, '2022-08-08'
exec insert_into_legatura null, 16, '2022-08-08'
exec insert_into_legatura 2, null, '2022-08-08'
exec insert_into_legatura 2, 161616, '2022-08-08'
exec insert_into_legatura 20001010, 16, '2022-08-08'

exec insert_into_legatura 7879, 1145, '2021-12-12'

insert into Produs(cod_p, denumire, cantitate, pret) values(7879, 'jocurii', 7, 50)
insert into Producator(id_prod, nume) values (1145, 'Microsoft')

go

--- ex 2) 
--- creati un view care combina date care provin din doua sau trei tabele; 
--- View1 afiseaza numele clientului impreuna cu produsul pe care l-a cumparat si producatorul produsului

CREATE VIEW View1 AS
SELECT C.nume as numeclient, P.denumire, PR.nume
FROM Client C 
INNER JOIN Cumparaturi Cm ON C.id_c = Cm.id_c
INNER JOIN Produs P ON Cm.cod_p = P.cod_p
INNER JOIN Legatura L ON P.cod_p = L.cod_p
INNER JOIN Producator PR ON L.id_prod = PR.id_prod;

SELECT *FROM View1

-- EX 3)
/*implementati, pentru un tabel la alegere, un trigger pentru operatia de adaugare si unul pentru
cea de stergere; 
  la executia fiecarui trigger se va afisa pe ecran un mesaj cu data si ora la care
s-a realizat operatia, tipul operatiei (Insert/Delete) si numele tabelului; optional, puteti crea
triggere similare si pe alte tabele.*/

 use Marketing 
 go

drop table arhiva_cumparare
create table arhiva_cumparare(
nume varchar(50) PRIMARY KEY,
data_c datetime2,
cantitate int)

drop table arhiva_vanzare
create table arhiva_vanzare(
nume varchar(50) PRIMARY KEY,
data_v date,
cantitate int)

--TRIGGER DE INSERT

go
CREATE TRIGGER ai_produs
ON [dbo].[Produs]
AFTER INSERT
AS 
BEGIN
INSERT INTO arhiva_cumparare(nume, data_c, cantitate)
SELECT denumire, SYSDATETIME(), cantitate from inserted 

DECLARE @data DATETIME2
	SET @data = SYSDATETIME()

DECLARE @print_message NVARCHAR(2000)
SET @print_message = N'Trigger-ul de INSERT pentru tabelul PRODUS s-a realizat la data de ' + CAST(@data as nvarchar(50)) + N'.'
PRINT @print_message
END 

select *from Produs
insert into Produs VALUES (222, 'gaantere2', 5, 30)
INSERT INTO Produs Values (2566, 'a', 3, 7)
select *from arhiva_cumparare


-- TRIGGER DE DELETE

go
CREATE TRIGGER ad_produs
ON Produs
AFTER DELETE
AS
BEGIN
INSERT INTO arhiva_vanzare(nume, data_v, cantitate)
SELECT denumire, SYSDATETIME(), cantitate from deleted
DECLARE @data DATETIME2
	SET @data = SYSDATETIME()

DECLARE @print_message NVARCHAR(2000)
SET @print_message = N'Trigger-ul de DELETE pentru tabelul PRODUS s-a realizat la data de ' + CAST(@data as nvarchar(50)) + N'.'
PRINT @print_message
END 

select *from Produs
delete from Produs where cod_p=1211
insert into Produs values(1211, 'masa', 1, 120)
select *from arhiva_vanzare
