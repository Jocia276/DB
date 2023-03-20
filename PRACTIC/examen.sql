create database Gestiune_parcari
go

use Gestiune_parcari

create table Zona(
id_zona int primary key identity(1,1),
nume varchar(50))

create table Categorie(
id_cat int primary key identity(1,1),
nume varchar(50))

create table Parcare(
id_parcare int primary key identity(1,1),
nume varchar(50),
nr_total_de_locuri int,
id_zona int foreign key references Zona(id_zona) on update cascade on delete cascade,
id_cat int foreign key references Categorie(id_cat) on update cascade on delete cascade)

create table Masina(
id_masina int primary key identity(1,1),
nr_inmatriculare varchar(50))

create table Parcare_masini(
id_masina int foreign key references Masina(id_masina) on update cascade on delete cascade,
id_parcare int foreign key references Parcare(id_parcare) on update cascade on delete cascade,
ora_sosire time(0),
ora_plecare time(0),
constraint PK_parcare_masini primary key(id_masina, id_parcare))

insert into Zona values('Zona1 - Centru')
insert into Zona values('Zona2')
insert into Zona values('Zona3 - periferie')
insert into Zona values('Zona4 - bulevardul muncii')

select *from Zona

insert into Categorie values('mall')
insert into Categorie values('subterana')
insert into Categorie values('in aer liber')

select *from Categorie

insert into Parcare values('Parking1', 50, 1, 2)
insert into Parcare values('Parking2', 150, 4, 1)
insert into Parcare values('Parking3', 100, 3, 3)
insert into Parcare values('Parking4', 50, 2, 2)

select *from Parcare

insert into Masina values('NT-02-AIC')
insert into Masina values('NT-02-EIM')
insert into Masina values('CJ-06-ABC')
insert into Masina values('BV-90-ACB')

select *from Masina

insert into Parcare_masini values(1,1,'09:10:00', '10:10:00');
insert into Parcare_masini values(1,2,'14:10:00', '15:10:00')
insert into Parcare_masini values(1,3,'15:10:00', '15:50:00')
insert into Parcare_masini values(1,4,'17:10:00', '19:10:00')

select *from Parcare_masini

go
create or alter function get_nr_locuri_libere(@nume varchar(50))
as
begin
declare @n int 
set @n=0
SELECT @n = nr_total_de_locuri from Parcare where Parcare.nume=@nume

declare @id_parcare int
set @id_parcare= (select id_parcare from Parcare where nume=@nume)

declare @m int
set @m = 0
select @m = count(*) from Parcare_masini WHERE id_parcare= @id_parcare and ora_sosire >='14:00:00' and ora_plecare<='16:00:00'

declare @nr int
set @nr = @n-@m
return @nr
end

create or alter procedure get_locuri_libere
@nume varchar(50)
as 
begin
declare @n int 
SELECT @n = nr_total_de_locuri from Parcare where Parcare.nume=@nume

declare @id_parcare int
set @id_parcare= (select id_parcare from Parcare where nume=@nume)

declare @m int
select @m = count(*) from Parcare_masini WHERE id_parcare= @id_parcare and ora_sosire >='14:00:00' and ora_plecare<='16:00:00'

declare @nr int
set @nr = @n-@m
print @nr
end

exec get_locuri_libere 'Parking3' 


GO
CREATE OR ALTER VIEW view1 as
select Parcare.nume as nume_parcare, Zona.nume as nume_zona, Categorie.nume as nume_categorie, Parcare.nr_total_de_locuri
from Categorie inner join Parcare on Categorie.id_cat = Parcare.id_cat
inner join Zona on Parcare.id_zona = Zona.id_zona


select *from view1


