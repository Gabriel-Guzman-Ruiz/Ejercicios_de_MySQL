-- Supconsultas:
-- son consultas anidadas dentro de otra sentencia SQL

-- Ejemplo 1: obtener todas las pistas coyo precio sea superior al precio medio de todas las pistas
select * 
from pistas
where precio > (select avg(precio) from pista);

-- Ejemplo 2: obtener todas las pistas coyo precio sea superior al precio medio de todas las pistas
select * 
from usuarios
where ciudad = (select ciudad from usuarios where id = 1);

-- Ejemplo 3: Mostrar los polideportivos situados en la misma ciudad donde se encuentra el polideportivo san jose
select * 
from polideportivos
where ciudad = (select ciudad from polideportivos where nombre = 'San José');

-- Ejemplo 4: Mostrar los polideportivos situados en la misma ciudad donde se encuentra el polideportivo san jose
select * 
from polideportivos
where ciudad = (select ciudad from polideportivos where nombre = 'San José');

-- Supconsultas de resultado unico:
-- solo devuelve una fila y columna.

-- Ejemplo 1: obten el codigo, tipo y precio de la pista mas cara
select id, tipo, precio
from pistas
where precio = (select max(precio) from pistas );

-- Ejemplo 2: Mustra los datos del usuario que realizo la primera reserva registrada.
select *
from usuarios
where usuarios.id = (select id_usuario from usuario_reserva order by id_reserva limit 1);

-- Ejemplo 3: Listar las.
select *
from pistas
where tipo = (select tipo from pistas where codigo = 'MUVF2634');

-- Supconsultas de lista de valores:
-- solo devuelve una columna pero varias filas. usa el operador IN

-- Ejemplo 1: listar los nombres y apellidos de los usuarios que han realizado alguna reserva
select  nombre, apellidos 
from usuarios
where id in (select id_usuario from usuario_reserva );

-- Ejemplo 1: Muestra los polideportivos que tienen 
select  nombre, apellidos 
from usuarios
where id in (select id_usuario from usuario_reserva );