-- TRIGGERS 
-- base de datos prueva

drop database if exists prueba;
create database prueba; 
use prueba;

-- tabla account, para almasenar numeros
create table account (
	acct_num int,
    amount decimal(10,2)
);

-- devuelve la suma de todos los numeros (amount) triggers
create trigger ins_sum before insert on account
for each row
set @sum = @sum + new.amount;

-- inicializamos variable
set @sum=0;

-- agregamos datos a la table
insert into account values(137,14.95), (138,192.33), (139,50.00);

-- bisualizamos el resultado
select @sum;


-- muestra los triggers de la vase de datos
show triggers;

-- muestra los triggers creado por un usuario
show triggers where `definer` like 'root%';

-- muestra la sentencia que creo el trigger
show create trigger ins_sum;

-- borrar un trigger
drop trigger ins_sum;

-- creamos la tabla usuarios
create table usuarios (
	id int auto_increment primary key,
    nombre varchar(100)
);

-- creamos la tabla logs_usuarios
create table logs_usuarios (
	id int auto_increment primary key,
    mensaje varchar(255),
    fecha datetime
);

-- trigger para registrar en la tabla logs_usuarios que fueron dados de alta en la tabla usuarios

delimiter //

create trigger tras_insertat_usuario
after insert on usuarios
for each row
begin
	insert into logs_usuarios (mensaje, fecha)
    values (concat('Nuevo usuario creado: ', new.nombre), now());
end//

delimiter ;

-- 
insert into usuarios(nombre) values ('Alejandro');

--
select * from logs_usuarios;

--
create table productos (
	id int auto_increment primary key,
     nombre varchar(100),
     stock int
);

-- trigger la cantidad de stock deve tener mas o igual que 0

delimiter //

create trigger validar_stock_negatovo
before update on productos
for each row
begin
	if new.stock < 0 then
		set new.stock = 0;
    end if;
end//

delimiter ;

-- 
insert into productos(nombre, stock) values ('Laptop', 10);

update productos set stock = -5 where nombre = 'Laptop';

select * from productos;

-- trigger se activa cuando se ace una actualizacion, si el estock es negativo salta un error y no se realia el proseso.

drop trigger validar_stock_negatovo;

delimiter //
create trigger cancelar_stock_negatovo
before update on productos
for each row
begin
	if new.stock < 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'el stock no puede ser negatovo';
    end if;
end//
delimiter ;

update productos set stock = -10 where nombre = 'Laptop';

select * from productos;

-- baase de datos empresa_db
create database if not exists empresa_db;
use empresa_db;

-- tabla empleados
create table if not exists empleados (
	id int auto_increment primary key,
    nombre varchar(100),
    dni char(9)
);

-- dunciones
select char_length('Esto es SQL');
select upper('Esto es SQL');
select lower('Esto es SQL');
select right('Esto es SQL', 1);
select left('Esto es SQL', 4);

-- trigger: dni tiene 9 dijitos y el ultomo es una letra

drop trigger cancelar_dni_invalido_insercion;
drop trigger cancelar_dni_invalido_modificacion;

delimiter //
create trigger cancelar_dni_invalido_insercion
before insert on empleados
for each row
begin
	if  NEW.dni NOT REGEXP '^[0-9]{8}[A-Za-z]$' then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El DNI debe tener 8 números y 1 letra al final';
    end if;
end//
delimiter ;

delimiter //
create trigger cancelar_dni_invalido_modificacion
before update on empleados
for each row
begin
	if  NEW.dni NOT REGEXP '^[0-9]{8}[A-Za-z]$' then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El DNI debe tener 8 números y 1 letra al final';
    end if;
end//
delimiter ;

insert into empleados(nombre, dni) values ('Gabriel', '12345678u');

update empleados set dni = '12345678i' where nombre = 'Gabriel';
