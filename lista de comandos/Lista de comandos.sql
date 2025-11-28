
-- crea una base de datos que no exista
create database if not exists ejemplo;

-- Mustra las vases de datos almasenadas
show databases;

-- Elimina una vase de datos existente
drop database if exists ejemplo;

-- Seleciona la base de datos
use ejemplo;

-- Mostar la orden SQL que creo la base de datos
show create database ejemplo;



-- ejemplo:

drop database if exists  provedores;
-- crea y seleciona el juego de caracteres de la base de datos
create database provedores charset utf8mb4;

use provedores;

create table categoria (
	id int unsigned auto_increment not null primary key unique,
    nombre varchar(100) not null
);

create table pieza (
	id int unsigned auto_increment primary key,
    nombre varchar(100) not null,
    color varchar(50) not null,
    precio decimal(7,2) not null check(precio > 0),
    id_categoria int unsigned ,
    foreign key (id_categoria) references categoria(id)
    on delete set null
    on update set null
);

-- para insertar valores a la tabla
insert into categoria values (1,'Categoria A');
insert into categoria values (2,'Categoria B');
insert into categoria values (3,'Categoria C');

insert into pieza values (1,'Pieza1','Blanco',25.90,1);

-- bisualizar la tabla
select * from pieza;

-- elimimar categorias
delete from categoria where id = 1;

create table usuario (
	id int unsigned auto_increment primary key,
    nombre varchar(25),
    rol enum('Estudiante','Profesor') not null
);

describe usuario;

-- modificar una colupna
alter table usuario modify nombre varchar(50) not null;

alter table usuario change nombre nombre_de_usuario varchar(50) not null;

alter table usuario alter rol set default 'Estudiante';
-- crea una nueva columna
alter table usuario add fecha_nacimiento date not null;