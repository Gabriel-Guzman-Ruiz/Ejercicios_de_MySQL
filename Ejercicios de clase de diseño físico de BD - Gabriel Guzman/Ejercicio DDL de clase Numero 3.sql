/*
Script: Ejercicio DDL de clase Numero 3
Creamos la vase de datos fisica del ejercicio:
	Ejercicio de clase 3.- Tienda de móviles
*/

drop database if exists Tienda_de_móviles;

create database Tienda_de_móviles;

use Tienda_de_móviles;

create table Móviles (
	Modelo varchar(10) not null primary key unique,
    Fabricante varchar(20) not null,
    Marca varchar (20) not null,
	Precio_Coste numeric (4,2) not null,
    Precio_Venta numeric (4,2) not null
);

create table Empleados (
	DNI char(9) not null primary key unique,
    Nombre varchar(20) not null,
    Apellidos varchar (20) not null,
	Fecha_Alta date not null,
    Cuenta_Bancaria varchar (20) not null
);

create table Clientes (
	DNI char(9) not null primary key unique,
	Nombre varchar(20) not null,
    Apellidos varchar (20) not null,
	Tarjeta_Credito varchar (20) not null
);

create table Ventas (
	ID int unsigned auto_increment not null primary key unique,
    DNI_Empleado char(9) not null,
    DNI_Cliente char(9) not null,
	Fecha_Alta datetime not null,
    Móvil_Color varchar (10) not null,
    
    foreign key (DNI_Empleado) references Empleados (DNI),
    foreign key (DNI_Cliente) references Clientes (DNI)
);

create table Móviles_Ventas (
	Modelo_Móvil varchar(10) not null,
    ID_Venta int unsigned auto_increment not null,
    
     primary key (Modelo_Móvil, ID_Venta),
    
    foreign key (Modelo_Móvil) references Móviles (Modelo),
    foreign key (ID_Venta) references Ventas (ID)
);