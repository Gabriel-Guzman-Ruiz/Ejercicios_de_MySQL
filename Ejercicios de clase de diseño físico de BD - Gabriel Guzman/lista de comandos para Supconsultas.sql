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

-- Ejemplo 1: Lista usuarios cuyo id sea mayor que alguno de los ids de usuarios de la ciudad de Huesca
select  * 
from usuarios
where id > any (select id from usuarios where ciudad = 'Huesca' );

-- Ejemplo 1: Selecionar reservas cuyo fecha de uso sea posterior a alguna de las fechas de revisión programadas en pistas_abiertas
select  * 
from reservas
where fecha_uso > any (select proxima_revision from pistas_abiertas );

-- Ejemplo 1: obtener las pisstas cuyo precio sea mayor o igual que todas las demas pistas
select  * 
from pistas
where precio >= all (select precio from pistas );

-- Ejemplo 1: obtener las pisstas cuyo precio sea mayor caro que todas las pistas de tipo ping-pong
select  * 
from pistas
where precio > all (select precio from pistas where tipo = 'Ping-pong');

-- El EXISTS: solo comprueva si la consulta devualve solo una fila
-- Ejemplo 1: Muestra los usuarios que an asistido como invitados a una reserva
select  * 
from usuarios u
where exists (select 1 from usuario_reserva uu where uu.id_usuario = u.id);

-- Ejemplo 1: Muestra las pistas de las pistas que estan aviertas
select  * 
from pistas p
where exists (select 1 from pistas_abiertas pa where pa.id_pista = p.id);

-- Ejemplo 1: Muestra las pistas de las pistas que estan aviertas
select  * 
from pistas p
where exists (select 1 from pistas_abiertas pa where pa.id_pista = p.id);

-- Ejemplo 1: Muestra las pistas de las pistas que estan aviertas
select  * 
from pistas p
where exists (select 1 from pistas_abiertas pa where pa.id_pista = p.id);