/*
Script: Ejercicio DDL de clase Numero 4
Creamos la vase de datos fisica del ejercicio:
	Ejercicio de clase 4.- Cadena editorial
*/

drop database if exists Cadena_editorial;

create database Cadena_editorial;

use Cadena_editorial;

create table Sucursales (
	ID char(3) not null primary key unique,
    Domicilio varchar(20) not null,
    Teléfono varchar (20) not null
);

create table Periodistas (
	NIF char(9) not null primary key unique,
    Nombre varchar(20) not null,
    Apellidos varchar (20) not null,
	Teléfono varchar(20) not null,
    Especialidad varchar(20) not null
);

create table Empleados (
	NIF char(9) not null primary key unique,
    ID_Sucursal char(3) not null,
    Nombre varchar(20) not null,
    Apellidos varchar (20) not null,
	Teléfono varchar(20) not null,
    
    foreign key (ID_Sucursal) references Sucursales (ID)
);

create table Artículos (
	ID int unsigned auto_increment not null primary key unique,
    NIF_Periodista char(9) not null,
    Nombre varchar (20) not null,
	Definición varchar (100) not null,
    
    foreign key (NIF_Periodista) references Periodistas (NIF)
);

create table Revistas (
	N_Registro int unsigned auto_increment not null,
    ID_Sección varchar(20) not null,
    Titulo varchar (20) not null,
	Periodicidad varchar (20) not null,
    Tipo varchar (20) not null,
    
    primary key (N_Registro, ID_Sección)
);

create table Secciones_fijas (
	ID_Sección varchar(20) not null,
    N_Registro int unsigned auto_increment not null,
    Titulo varchar (20) not null,
	Extensión varchar (20) not null,
    
    primary key (N_Registro, ID_Sección)
);

create table Ejemplares (
	ID_Ejemplar int unsigned auto_increment not null primary key unique,
    N_Registro int unsigned not null,
    Fecha date not null,
	N_Páginas varchar (10) not null,
    N_Ejem_Vendidos varchar (20) not null,

    foreign key (N_Registro) references Revistas (N_Registro)
);

create table Sucursales_Revistas (
	ID_Sucursal char(3) not null,
    N_Registro int unsigned auto_increment not null,
    
	primary key (ID_Sucursal, N_Registro),
    
    foreign key (ID_Sucursal) references Sucursales (ID),
    foreign key (N_Registro) references Revistas (N_Registro)
);

create table Articulos_Revistas (
	ID_Articulo int unsigned auto_increment not null,
    N_Registro int unsigned not null,
    
	primary key (ID_Articulo, N_Registro),
    
    foreign key (ID_Articulo) references Artículos (ID),
    foreign key (N_Registro) references Revistas (N_Registro)
);
