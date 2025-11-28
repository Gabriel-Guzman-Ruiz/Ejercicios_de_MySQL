/*
Script: Ejercicio DDL de clase Numero 2
Creamos la vase de datos fisica del ejercicio:
	Ejercicio 2 - Instituto
*/

drop database if exists Instituto;

create database Instituto;

use Instituto;

create table Profesores (
	DNI char(9) not null primary key unique,
    Nombre varchar(50) not null,
    Dirección varchar (50) not null,
	Telefono varchar (20) not null
);

insert into Profesores (DNI, Nombre, Dirección, Telefono)
values ('12345678A','Marta López','C/ Mayor 12, Madrid','600111222'),
		('87654321B','Juan Pérez','Av. Sol 45, Madrid','611222333'),
        ('11223344C','Laura Sánchez','C/ Luna 9, Getafe','622333444');

select * from Profesores;

create table Módulos (
	ID_Modulo char(3) not null primary key unique,
    DNI_Profesor char(9) not null,
    Nombre varchar (50) not null,
    
    foreign key (DNI_Profesor) references Profesores (DNI)
);

insert into Módulos (ID_Modulo, DNI_Profesor, Nombre)
values ('M01','12345678A','Programación'),
		('M02','11223344C','Bases de Datos'),
        ('M03','87654321B','Sistemas Operativos'),
        ('M04','12345678A','Lenguajes de Marcas');

select * from Módulos;

create table Alumnos (
	N_Expediente char(10) not null primary key unique,
    Nombre varchar (20) not null,
    Apellido varchar (20) not null,
    Fecha_Nacimiento date not null,
    Curso varchar (20) not null,
    N_Expediente_Delegado char (10),
    
	foreign key (N_Expediente_Delegado) references Alumnos (N_Expediente)
);

insert into Alumnos (N_Expediente, Nombre, Apellido, Fecha_Nacimiento, Curso, N_Expediente_Delegado)
values ('A001','Pedro','García Martín','2005/03/12','C1','A001'),
		('A002','Lucía','Torres Díaz','2004/11/07','C1','A001'),
        ('A003','Ana','Ruiz Fernández','2005/06/25','C1','A001'),
        ('A004','Mario','López Sánchez','2004/02/18','C2','A004');
        
select * from Alumnos;	

create table Cursando (
	ID_Modulo char(3) not null,
    N_Expediente_Alumno char(10) not null,
    
    primary key (ID_Modulo, N_Expediente_Alumno),
    
    foreign key (ID_Modulo) references Módulos (ID_Modulo),
    foreign key (N_Expediente_Alumno) references Alumnos (N_Expediente)
);

insert into Cursando (N_Expediente_Alumno, ID_Modulo)
values ('A001','M01'),
		('A001','M02'),
        ('A002','M01'),
        ('A002','M03'),
        ('A003','M02'),
        ('A003','M04'),
        ('A004','M01'),
        ('A004','M02');
        
select * from Cursando;	

