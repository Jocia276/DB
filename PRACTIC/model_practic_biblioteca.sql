use Biblioteca
go
--a

create table Librarie(
id_lib int primary key identity(1,1),
nume varchar(50),
adresa varchar(50))

insert into Librarie values('Librarium', 'Str. Paris')
insert into Librarie values('Book Store', 'Str. Bucuresti')
insert into Librarie values('Bookzone', 'Str. Teodor Mihali')
select *from Librarie

go
create table Domeniu(
id_dom int primary key identity(1,1),
descriere varchar(100))

insert into Domeniu values ('literatura')
insert into Domeniu values ('fantasy')
insert into Domeniu values ('drama')
select *from Domeniu

go
create table Carti(
id_carte int primary key identity(1,1),
titlu varchar(50),
id_dom int foreign key references Domeniu(id_dom) on delete cascade on update cascade)

insert into Carti values('Harap Alb', 1)
insert into Carti values('Pacienta tacuta', 3)
insert into Carti values('Moara cu noroc', 1)
insert into Carti values('Capra cu trei iezi', 2)

select *from Carti

go
create table Autor(
id_aut int primary key identity(1,1),
nume varchar(50),
prenume varchar(50))

insert into Autor values('Ion', 'Creanga')
insert into Autor values('Alexandru', 'Damian')
insert into Autor values('Ioan', 'Slavici')
select *from Autor

create table Carti_Autor(
id_carte int foreign key references Carti(id_carte) on delete cascade on update cascade,
id_aut int foreign key references Autor(id_aut)on delete cascade on update cascade,
CONSTRAINT PK_Cumparaturi PRIMARY KEY(id_carte, id_aut));

insert into Carti_Autor values(1,1)
insert into Carti_Autor values(3,3)
insert into Carti_Autor values(1,2)
select *from Carti_Autor

create table Carti_Librarii(
id_carte int foreign key references Carti(id_carte) on delete cascade on update cascade,
id_lib int foreign key references Librarie(id_lib) on delete cascade on update cascade,
data_achizitie date, 
constraint pk_carti_librarii primary key(id_carte, id_lib))

insert into Carti_Librarii values(1,2, '2002-02-20')
insert into Carti_Librarii values(2,3, '2002-03-20')
insert into Carti_Librarii values(1,3, '2020-02-20')
select *from Carti_Librarii

--b

go
create or alter procedure asoc_carte_autor

@nume varchar(50),
@prenume varchar(50),
@titlu varchar(50)
as
begin

--verificam daca autorul exista
DECLARE @n1 int
SET @n1 =0
SELECT @n1 = count(*) from Autor WHERE nume =@nume and prenume=@prenume

-- selectam id ul cartii
declare @id_carte int
set @id_carte= (select id_carte from Carti where titlu= @titlu)

-- selectam id-ul autorului
declare @id_autor int
set @id_autor = (select id_aut from Autor where nume= @nume and prenume = @prenume)

-- vedem daca exista autorul in legatura
DECLARE @n int
SET @n =0
SELECT @n = count(*) from Carti_Autor WHERE id_aut =@id_autor

-- vedem daca exista cartea in legatura
DECLARE @m int
SET @m =0
SELECT @m = count(*) from Carti_Autor WHERE id_carte =@id_carte

if @n1 != 0 /*daca autorul exista*/
begin
IF @n = 0 or @m = 0 insert into Carti_Autor values(@id_carte,@id_autor);
else THROW 51000, 'Legatura dintre carte si autor exista deja!',1
end
else
begin
insert into Autor values(@nume, @prenume);
declare @id_autor2 int
set @id_autor2 = (select id_aut from Autor where nume= @nume and prenume = @prenume)
insert into Carti_Autor values(@id_carte,@id_autor2);
end 

end
go

exec asoc_carte_autor 'Ion', 'Creanga', 'Pacienta tacuta'
exec asoc_carte_autor 'Ionel', 'Creanga', 'Capra cu trei iezi'
select *from Carti_Autor
select *from Autor
delete from Autor where nume = 'Ionel'


--c
GO
CREATE OR ALTER VIEW view1 as
select L.nume, count(CL.id_carte) as numar_carti 
from Librarie L 
inner join Carti_Librarii CL on L.id_lib = CL.id_lib
inner join Carti on CL.id_carte=Carti.id_carte
where year(CL.data_achizitie)>2000 
group by L.nume
order by L.nume desc
offset 0 rows

select *from view1

-- d

go
create or alter function getcarti()
returns table
as
return
select Carti.titlu as titlu_carte, Librarie.nume as nume, Librarie.adresa as adresa, count(Autor.id_aut) as nr_autori
from Autor inner join Carti_Autor on Autor.id_aut=Carti_Autor.id_aut
inner join Carti on Carti_Autor.id_carte=Carti.id_carte
inner join Carti_Librarii on Carti.id_carte=Carti_Librarii.id_carte
inner join Librarie on Carti_Librarii.id_lib=Librarie.id_lib
GROUP BY Carti.titlu, Librarie.nume, Librarie.adresa
go

select *from [dbo].[getcarti]()