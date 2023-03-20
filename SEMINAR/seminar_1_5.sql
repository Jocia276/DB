USE BD_SEM_PUBL

create table Categorie(
id_cat int PRIMARY KEY,
nume varchar(50),
deschriere varchar(50))

create table Publicatie (
id_publ int primary key,
titlu varchar(50),
abstract varchar(200),
autorp varchar(50),
id_cat int foreign key references Categorie(id_cat) on update cascade on delete set null)

create table Biblioteca(
id_biblio int primary key,
nume varchar(50) not null,
site varchar(50))

create table Indexare(
id_publ int foreign key references Publicatie(id_publ) on update cascade on delete cascade,
id_biblio int foreign key references Biblioteca(id_biblio) on update cascade on delete cascade,
CONSTRAINT PK_Indexare PRIMARY KEY(id_publ, id_biblio))


insert into Categorie values (111, 'jurnal', 'descr jurnal')
insert into Categorie values (122, 'conferinta', 'descr conferinta')

select *from Categorie

insert into Publicatie values (2919, 'titlu1', 'abstract1', 'autorp1', 122)
insert into Publicatie values (3310, 'titlu2', 'abstract2', 'autorp2', 111)
insert into Publicatie values (2910, 'titlu3', 'abstract3', 'autorp1', 122)
insert into Publicatie values (2909, 'titlu4', 'abstract4', 'autorp1', 111)

select *from Publicatie

insert into Biblioteca values (101, 'ACM', 'https://dl.acm.org/')
INSERT INTO Biblioteca values (335, 'dblp', 'https://dblp.uni-triere.kl')
insert into Biblioteca values (256, 'abc', 'https://abc.com')

select *from Biblioteca

insert into Indexare values(2919, 101)
insert into Indexare values(2919, 335)
insert into Indexare values(3310, 101)

select *from Indexare

--- Actualizati numele bibliotecii id-ul 101 la valoarea 'Association for Computing Machinary'

update Biblioteca
set nume = 'Association for Computing Machinary'
where id_biblio = 101

--- Stergeti publicatia cu id-ul 2919

delete from Publicatie where id_publ = 2919


    ----------------------------------- SEMINAR 3 --------------------------------------


--> 1. Utilizand clauza SELECT, sa se afiseze:
---- a. Numele si adresa web a tuturor biblbiotecilor electronice existente in baza de date

select nume, site from Biblioteca

---- b. Id-urile publicatiilor indexate; acestea se vor afisa o singura data;

select distinct id_publ from Indexare

---- c. Titlul publicatiilor stiintifice care au ca si autor principal pe 'autop1'

select titlu from Publicatie where autorp= 'autorp1'

---- d. Titlul publicatiilor stiintifice care au ca si autor principal pe 'autorp1' si pentru care id_cat = 111

select titlu from Publicatie where autorp= 'autorp1' and id_cat = 111

---- e. Site-ul web al bibliotecilor electronice cu numele 'ACM' sau 'DBLP'

select site from Biblioteca where nume='ACM' or nume='dblp'

/*varianta 2:*/
select site from Biblioteca where nume in ('ACM', 'dblp')

---- f. Numele publicatiilor stiintifice pentru care numele autorului principal se termina cu 'p1'   !!!!!!!!!!!!!!

select titlu from Publicatie where autorp like '%p1'

---- g. Denumirea si descrierea categoriilor al caror id este diferit de 111, 222, 333

select nume, deschriere from Categorie where id_cat not in (111, 222,333)


--> Utilizand operatii de join sa se afiseze:

---- a. Titlul publicatiei si numele categoriei pentru publicatiile care au ca si autor principal pe 'autorp1'

select P.titlu, C.nume
from Publicatie P inner join Categorie C on P.id_cat = C.id_cat
where P.autorp = 'autor1'

---- b. Titlul tuturor publicatiilor si numele bibliotecii, indiferernt daca sunt sau nu indexate intr-o biblioteca electronica

select P.titlu, B.nume
from Publicatie P left join Indexare I on P.id_publ=I.id_publ inner join Biblioteca B on I.id_biblio=B.id_biblio;

---- c. Site-ul web si numele bibliotecilor electronice care indexeaza publicatii stiintifice din categoria cu numele 'jurnal'

select B.site, B.nume
from Biblioteca B 
inner join Indexare I on B.id_biblio=I.id_biblio 
inner join Publicatie P on I.id_publ = P.id_publ
inner join Categorie C on P.id_cat=C.id_cat
where C.nume = 'jurnal';

---- d. Numele autorilor principali indexati in bliblioteca electronica cu numele 'dblp'

select P.autorp from Publicatie P
inner join Indexare I on P.id_publ=I.id_publ
inner join Biblioteca B on I.id_biblio=B.id_biblio
where B.nume='dblp'


--> 3. Utilizand reuniune, intersectie si diferenta, afisati:

---- a. Numele autorilor principali care au publicatii din categoria 'conferinta', dar si categoria 'jurnal'

select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'jurnal'
INTERSECT
select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'conferinta'

---- b. Numele autorilor principali care au publicatii din categoria 'conferinta', dar nu au publicatii in categoria 'jurnal'

select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'jurnal'
EXCEPT
select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'conferinta'

---- c. Numele autorilor principali care au publicat in jurnale sau conferinte

select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'jurnal'
UNION
select P.autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'conferinta'

--> 4. Creati un view care contine urmatoarele date: titlul unei publicatii stiintifice, autorul sau principal si numele categoriei sale

go 
CREATE VIEW View1 AS
select P.titlu, P.autorp, C.nume
from Publicatie P inner join Categorie C on P.id_cat=C.id_cat

select *from View1 

--> 5. Folosind functiile de agregare si clauzele GROUP BY si ORDER BY afisati:

---- a. numarul total de publicatii pentru fiecare autor principal, in ordine descrescatoare

select COUNT(id_publ) as nr_publ, autorp from Publicatie
GROUP BY autorp 
ORDER BY nr_publ DESC

---- b. numarul total de publicatii de categorie 'jurnal' pentru fiecare autor principal

select COUNT(id_publ) as nr_publ, autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'jurnal'
GROUP BY autorp

---- c. autorii care au cel putin doua publicatii

select COUNT(id_publ) as nr_publ, autorp from Publicatie
GROUP BY autorp 
having count(id_publ) >=2

---- d. autorii care au cel putin o publicatie de categorie 'jurnal'

select COUNT(id_publ) as nr_publ, autorp from Publicatie P
inner join Categorie C on P.id_cat= C.id_cat
where C.nume = 'jurnal'
GROUP BY autorp
having count(id_publ) >=1

---- e. autorul cu cele mai multe publicatii

select top 1 count(id_publ) as nr_publ, autorp from Publicatie
group by autorp
order by nr_publ DESC;


---------------------------------------------- SEMINAR 4 -----------------------------------------------

--> 1. Scrieti o procedura stocata care afiseaza:

---- a. toate publicatiile din baza de date
go
create procedure ex1a
as
begin
select titlu from Publicatie
end

exec ex1a

---- b. autorul cu cele mai multe publicatii
go
create procedure ex1b
as
begin
select top 1 autorp, count(id_publ) as nr from Publicatie
group by autorp
order by nr desc
end
go

exec ex1b


--> 2. Scrieti o procedura stocata care insereaza o publicatie in tabela Publicatie

go 

create procedure ex2 
(@id int, @titlu varchar (50), @abstr varchar(500), @autor varchar (50), @cat int)
as
begin
if @id is null 
 throw 51000,'Id-ul trebuie sa fie diferit de null!',1

declare @n int
set @n =0
select @n = count(*) from Publicatie
where id_publ = @id

if @n != 0 
throw 51000, 'Publicatia exista deja!',1
else
insert into Publicatie values (@id,@titlu, @abstr, @autor, @cat)
end
go

--apel
exec ex2 null, 't', 'a', 'autor3', 111

exec ex2 1, 't', 'a', 'autor3', 111

exec ex2 2, 't', 'a', 'Michael Brodie', 111

--> 3. Scrieti o procedura stocata care actualizeaza site-ul web al unei bibliotexi electronice date ca parametru
--     si care afiseaza un mesaj de succes dupa actualizare.

go
create  or alter procedure ex3 
	(@nume varchar(50), @site varchar(50))
as
begin
declare @n int
set @n = 0
select @n = count(*) from Biblioteca
where nume = @nume

if @n = 0
 throw 51000, 'Biblioteca precizata nu exista',1
 else
 update Biblioteca set site = @site
 where nume = @nume
DECLARE @print_message NVARCHAR(2000)
SET @print_message = N'Actualizarea s-a realizat cu succes!'  + N'.'
PRINT @print_message

end
go

insert into Biblioteca values (2,'Google Scholar','www.scholar.com')

exec ex3 'Scopus','www'
exec ex3 'DBLP', 'WWWw'
select *from Biblioteca


--> 4. Scrieti o procedura stocata care calculeaza numarul publicatiilor de categoria 'jurnal' a unui autor principal primit ca si parametru
go
create or alter procedure ex4
 @Autor varchar (50), @p int output
 as
 begin
 declare @n int
 set @n = 0
 select @n = count(*) from Publicatie
 where autorp = @Autor

 if @n = 0
 throw 51000, 'Autorul precizat nu exista', 1
 else
 --declare @nr int
 --set @nr = 0 
 select @p = count (*) from Publicatie p inner join Categorie c on  
 p.id_cat = c.id_cat where autorp = @Autor and nume = 'jurnal'
 print @p
 end
 go

 --apel

 declare @n int
 set @n  = 0
 exec ex4 'autor', @p = @n output
 print @n

--> 5. Scrieti o procedura stocata care primeste numele unui autor principal si care modifica categoria tuturor publicatiilor acestui autor
--     in ‘jurnal’ (pentru cele care nu sunt deja de categoria jurnal). In cazul in care autorul nu are alte publicatii inafara de categoria 
--     jurnal inainte de actualizare, afisati un mesaj care precizeaza acest lucru.


go
create procedure exemplu1 @Autor varchar(50)
as
begin
select titlu from Publicatie
where autorp = @Autor
end
go



alter procedure exemplu1 
	(@Autor varchar(50), @Nr int output)
as
begin
select @Nr = count(*) from Publicatie
where autorp = @Autor

if @Nr = 0
raiserror('Autorul precizat nu are publicatii', 10,1);
end


go
create procedure ex5 
 @Autor varchar(50)
 as
 begin
 --calculam nr total de publicatii ale autorului
 declare @nrtot int
 set @nrtot = 0
 exec exemplu1 @Autor, @Nr = @nrtot output

 --calculam nr de publicatii de tip jurnal ale autorului
 declare @nrj int
 set @nrj = 0
 exec ex4 @Autor, @p = @nrj output

 if @nrtot - @nrj = 0
 throw 51000, 'Toate publicatiile autorului precizat sunt de tip jurnal!',1
 else
 declare @id int
 set @id = -1

 select @id = id_cat from Categorie where nume = 'jurnal'
 if @id = -1
 throw 51000, 'Categoria jurnal nu exista!',1
 else
 update Publicatie set id_cat =@id where autorp = @Autor 
 
 end

 --apel

  exec ex5 'autorp1'
  
  select *from Publicatie


--> 6. Scrieti o procedura stocata care primeste numele unui autor principal, id-ul unei publicatii, titlul acesteia si categoria din care
--     publicatia face parte si adauga noua publicatie autorului precizat. In cazul in care publicatia exista deja, sa se actualizeze categoria
--     din care aceasta face parte.

--> 7. Scrieti o procedura stocata care primeste numele a doi autori principali si care afiseaza care dintre acestia are mai multe publicatii 
--     de categoria jurnal. Procedura apeleaza procedura stocata de la ex. 4. Se verifica mai intai ca cei doi autori principali sunt diferiti,
--     iar in caz contrar se afiseaza un mesaj de eroare.



------------------------------------------ SEMINAR 5 -----------------------------------


--------------- PARTEA 1 ---------------FUNCTII-----------------------------------------



--> 1. Scrieti o functie definita de utilizator care returneaza: 
--     (a) toate publicatiile din baza de date 

go
create function getPublicatii_ex1a()
returns table
as
return
select * from Publicatie

select * from dbo.getPublicatii_ex1a()

--     (b) autorul cu cele mai multe publicatii

go
create function getAutorTop()
returns table
as
return
select top 1 count(id_publ) as nr, autorp from Publicatie
group by autorp
order by nr desc

select autorp from dbo.getAutorTop()

--versiunea 2, functie care returneaza numele autorului cu cele mai multe publicatii
--ne folosim de functia anterioara ca sa extragem numele acestui autor
go
create function getAutorTop2()
returns varchar(50)
as
begin
declare @autor varchar(50)
set @autor = ' '

select @autor = autorp from dbo.getAutorTop()

return @autor
end

print dbo.getAutorTop2()


--> 2. Scrieti o functie definita de utilizator care calculeaza numarul publicatiilor de categoria jurnal a unui 
--     autor principal primit ca si parametru.

GO 
create or alter function getNrPubJurnal(@autor varchar(50))
returns int
as
begin
declare @nrj int
set @nrj = 0

select @nrj = count(*) from Publicatie where 
id_cat = '111'  and autorp = @autor

return @nrj
end

print dbo.getNrPubJurnal('Michael Brodie')

--> 3. Scrieti o functie care returneaza numarul total de publicatii de categorie ‘jurnal’
--     pentru fiecare autor principal.create or alter function getTotalJurnalByAutor()
returns table
as
return
select count(*) as nr_j, autorp from Publicatie
where id_cat = '111'
group by autorp 


select * from dbo.getTotalJurnalByAutor()--> 4. Scrieti o functie care primeste ca parametru un intreg reprezentand id-ul unei biblioteci electronice si care returneaza
--     valoarea 1 daca exista in baza de date o biblioteca cu id-ul respectiv, iar in caz contrar, returneaza valoarea 0.
GO
create function verifCat(@id int)
returns int
as
begin
declare @exista int
set @exista = 0

select @exista = count(*) from Categorie where id_cat = @id

return @exista
end

print dbo.verifCat('11341')


----------------- PARTEA 2 --------------- TRIGGERS -----------------------

--> 1. scrieti un trigger pentru tabela Publicatii pentru operatia de adaugare; afisati pe ecran numele tabelei si un
--     mesaj care sa indice faptul ca s-a adaugat o inregistrare

go
create or alter trigger dbo.[On_Publication_Insert]
on Publicatie
for insert
as
begin
set nocount on
select titlu, autorp from inserted
print getdate()
end

create trigger t_ex1
on Publicatie
for insert
as
begin
print 'Publicatie:'
print 'inregistrare adaugata'
end

insert into Publicatie values (7,'Pub5', 'Abstr5', 'Michael Brodie','111')

--> 2. Scrieti un trigger pentru tabela Biblioteca pentru operatia de stergere; triggerul va afisa un mesaj care sa
-- indice faptul ca s-a sters o inregistrare si numele bibliotecii din inregistrarea stearsa
