use reservas;

-- muestra el nombre de los usuarios
select nombre
from usuarios
order by nombre;

-- muestra el apellido y nombre de los usuarios ordenados por ambos campos
select distinct apellidos, nombre
from usuarios
order by apellidos, nombre;

-- muestra el apellido en orden desendente y nombre de los usuarios, ordenados por ambos campos
select distinct apellidos, nombre
from usuarios
order by apellidos desc, nombre;

-- mustra todos los datos de la tabla
select * from usuarios;

-- muestra el nombre, la direcion y la ciudad de los polideportivos de zaragoza
select nombre, direccion, ciudad
from polideportivos
where ciudad = 'Zaragoza';

-- operadores de where: (>, <, =, >=, <=, !=), (and, or), (% (una cadena de caracteres), _ (un caracter)), (IN (una lista de valores que deseas ver))

-- podemos poner un alias a la hora que nos muestren los datos
select nombre "mom", apellidos "ape"
from usuarios
order by nombre asc;

-- podemos unir colupnas para que se nos muestre
select concat(apellidos, ', ', nombre) "apellidos y nombre"
from usuarios
order by nombre asc;

-- muestra todos los usuarios donde el desciento es diferente a 10%
select *
from usuarios
where round(descuento, 2) != 0.1;

-- 
select *
from usuarios
where ciudad != 'Zaragoza';

-- Muestra a todos los usuarios que son de Zaragoza y Soria
select *
from usuarios
where ciudad  = 'Zaragoza' or ciudad = 'Soria';

-- Muestra a todos los usuarios que son de Zaragoza y Soria, que nacio en o despues de 2013
select *
from usuarios
where (ciudad  = 'Zaragoza' or ciudad = 'Soria') and fecha_nacimiento >= '2013-01-01';

-- Muestra a todos los usuarios que 
select *
from usuarios
where nombre like 'B%a';

-- Muestra a todos los usuarios que tengan nombre de 6 caracteres
select *
from usuarios
where nombre like '______';

-- Muestra a todos los usuarios que no sean de Huesca y Teruel
select *
from usuarios
where ciudad not in ('Huesca', 'Teruel');

-- Muestra a todos los usuarios que 
select *
from usuarios
where fecha_nacimiento between '2013-01-01' and '2014-12-31';

-- muestra los primeros 10 usuarios ordenados por apellido y nombre
select *
from usuarios
order by apellidos, nombre
limit 10;

-- muestrame el ultimo usuario de la tabla ordenada por apellido y nombre
select *
from usuarios
order by apellidos desc, nombre desc
limit 1;

-- Cuenta el numero de pistas
select count(*)
from pistas;

-- Cuantos plodeportivos hay en zaragoza
select count(*)
from polideportivos
where ciudad = 'Zaragoza';

-- sum: suma los datos indicados
select sum(precio)
from pistas	
where id_polideportivo = '23';

-- cuanto vale la pista mas varata
select MIN(precio)
from pistas;

-- cuanto vale la pista mas cara
select max(precio)
from pistas;

-- El precio promedio de las pistas
select round(avg(precio),2)
from pistas;

-- FUNCIONES ESCALARES

-- Combierte una cadena de texto en mayuscula
select upper('hola');

select upper(nombre)
from usuarios;

-- Combierte una cadena de texto en mayuscula
select lower('HOLA');

-- devuelve la lonjitud de unacadena de caracteres
select length('HOLA');

-- junta varias cadena de caracteres
select concat('HOLA', ' mundo');

-- elimina los espacios en blanco de una cadena
select trim('	hola	');

-- una parte de una cadena de carcteres por otra cadena de caracteres
select replace('abc abc abc', 'a', 'c');

-- invierte una cadena de caracteres
select reverse('agalam');

-- Devuelven la hora del sistema
select sysdate();
select now();

-- puedes sumar tiempo a una fecha con date_add, y datediff resta tiempo
select *
from usuarios
where fecha_nacimiento >= '2013-01-01' and fecha_nacimiento < date_add('2013-01-01', interval 2 year)
order by fecha_nacimiento;

-- CONSULTAS DE AGRUPAMIENTO

-- el numero de polideportivos en cada ciudad
select ciudad, count(*) as "Numero de polideportivos"
from reservas.polideportivos
group by ciudad
order by ciudad;

-- el numero de usuarios en cada ciudad
select ciudad, count(*) as "Numero de usuarios"
from reservas.usuarios
group by ciudad
order by ciudad;

-- el numero de polideportivos hay en cada ciudad, solo en las siudades donde hay mas de 10 polideportivos
select ciudad, count(*) as "Numero de usuarios"
from reservas.polideportivos
group by ciudad
having count(*) > 10
order by ciudad;

-- Cuantas pistas hayen en cada deporte
select tipo, count(*) 
from reservas.pistas
group by tipo
order by tipo;

-- Cuantas pistas hayen en baloncesto
select tipo, count(*) 
from reservas.pistas
group by tipo
having tipo like 'baloncesto'
order by tipo;

-- CONSULTAS DE MULTITABLA
-- Las consultas se realizan con 2 o mas tablas
-- Nesesitaremoss relacionar las tablas atraves de un campo comun

-- muestra la informacion del id, codigo, tipo y precio de la pista,
-- y ademas, la fecha de las reservas el precio de las reservas 
select pistas.id, pistas.codigo, pistas.tipo, pistas.precio, 
		reservas.fecha_reserva, reservas.precio
from  pistas, reservas
where pistas.id = reservas.id_pista
order by id;

-- EJERCICIOS

-- Cual es el precio de las pistas mas varatas de cada deporte.
select tipo, min(precio)
from  reservas.pistas
group by tipo
order by tipo;

-- Cual es el precio de las pistas con un precio promedio de cada deporte.
select tipo, round(avg(precio),2)
from  reservas.pistas
group by tipo
order by tipo;

-- Cuantas reservas a realizado un usuario
select id_usuario, count(id_reserva)
from  reservas.usuario_reserva
group by id_usuario
order by id_usuario;

-- Cuantos usuarios an realizado cada reserva
select id_reserva, count(id_usuario)
from  reservas.usuario_reserva
group by id_reserva
order by id_reserva;