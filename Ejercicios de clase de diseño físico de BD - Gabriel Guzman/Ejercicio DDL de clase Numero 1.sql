/*
Script: Ejercicio DDL de clase Numero 1
Creamos la vase de datos fisica del ejercicio :
	Ejercicio 1 - Enmpresa se trasporte
*/

# Corra la base de datos si existe.
drop database if exists empresa_Trasporte;

# Crea la base de datos
create database empresa_Trasporte;

use empresa_Trasporte;

create table Camioneros (
	DNI char(9) not null primary key unique,
    Nombre varchar(50) not null,
    Telefono varchar (20) not null,
    Salario numeric (8,2) not null,
    Dirección varchar (50) not null,
    Poblacion varchar (20) not null
);

insert into Camioneros (DNI, Nombre, Telefono, Salario, Dirección, Poblacion)
values ('24567890Z','Antonio Sánchez','951324567', 2200,'Av. Parménides', 'Malaga'),
		('23456578Z','Carlos Martínes','346764456', 2500,'San Miquel', 'Torremolinos');

select * from Camioneros;

create table Camiones (
	Matricula varchar(10) not null primary key unique,
    Modelo varchar(20) not null,
    Tipo enum ('Camioneta','Ligero','Mediano','Pesado') not null,
    Potencia smallint unsigned not null
);

insert into Camiones (Matricula, Modelo, Tipo, Potencia)
values ('1245BJN','Pegaso','Camioneta','500'),
		('1354ABC','Volvo','Camioneta','800');
        
select * from Camiones;

create table Provincias (
	Codigo varchar(10) not null primary key unique,
    Nombre varchar(20) unique key not null 
);

insert into Provincias (Codigo, Nombre)
values ('MAL001','Málaga'),
		('BAR001','Barcelona');
        
select * from Provincias;

create table Paquetes (
	ID_Paquete int unsigned auto_increment not null primary key unique,
    Descrición varchar(100) not null,
    Destinatario varchar(100) not null,
    Dirección varchar(50) not null,
    DNI_Camionero char(9) not null,
    Codigo_Provincia varchar(10) not null,
    
    foreign key (DNI_Camionero) references Camioneros (DNI),
    foreign key (Codigo_Provincia) references Provincias (Codigo)
);

insert into Paquetes (ID_Paquete, Descrición, Destinatario, Dirección, DNI_Camionero, Codigo_Provincia)
values ('1','frágil Urgente', 'Maria Jiménez','San Miquel, 7','24567890Z','MAL001'),
		('2','Paquete pesado', 'Paulo Lopez','Cruz, 20','23456578Z','BAR001');
        
select * from Paquetes;

create table Conduce (
	DNI_Camionero char(9) not null,
    Matricula_Camion varchar(10) not null,
    Fecha datetime not null,
    
    primary key (DNI_Camionero, Matricula_Camion, fecha),
    
    foreign key (DNI_Camionero) references Camioneros (DNI),
    foreign key (Matricula_Camion) references Camiones (Matricula)
);

insert into Conduce (DNI_Camionero, Matricula_Camion, Fecha)
values ('24567890Z','1245BJN', '2025/10/7'),
		('23456578Z','1354ABC', '2025/11/4');

select * from Conduce;