-- MULTICONSULTA
-- OPERACION UNION: Muestra los resiltados de dos consultas en una.
use reservas;

-- 
select  id_pista  
from pistas_abiertas
union
select  id  
from pistas;

-- Mustra los nobres de los polideportivos u usuarios que vivien en 'Huesca'
select  nombre  
from polideportivos
where ciudad = 'Huesca'
union
select  nombre  
from usuarios
where ciudad = 'Huesca';

-- OPERACION EXCEPT: Muestra los datos de la promera consulta que no estan repetidos en la segunda.
-- Lista los id de losusuarios que ni isiaron reservas
select  id  
from usuarios
except
select  id_usuario  
from usuario_reserva;

-- Los id de los polideportivos que no tienen pista de 'Tenis'
select  id  
from polideportivos
except
select  id_polideportivo  
from pistas
where tipo = 'tenis';

-- OPERACION INTERSECT: Muestra solo los datos en comon e las dos consultas
-- Encuentra las ciudades donde viven usuarios
select  ciudad  
from usuarios
intersect
select  ciudad  
from polideportivos;

-- Los id de pistas que estan en la tabla general de pistas y tambien marcadas expresamente como abiertas.
select  id  
from pistas
intersect
select  id_pista  
from pistas_abiertas;

-- OPERACION CATERCIANO: 
-- Jenera todas las combinaciones posibles entre nombres de los usuarios y nombre de polidaportivos polideportivos
select  u.nombre, p.nombre
from usuarios u, polideportivos p;

-- Todos los tipos de pistas existentes con todas las ciudades donde hay polideportivos.
select distinct p.tipo, po.ciudad
from pistas p
cross join polideportivos po;

-- OPERACION INTERNA (INER JOIN): Sirve para relacionar dos tablas entre si.
-- Los datos de pistas (codigo y precio) junto con la fecha de su proxima revisión si estan abiertas.
select  p.codigo, p. precio, pa.proxima_revision
from pistas p
inner join pistas_abiertas pa on p.id = pa. id_pista;

-- Listas del nombre polideportivos y el tipo depistas que contienen
select  po.nombre, p.tipo
from pistas p, polideportivos po
where p.id_polideportivo = po.id
order by po.nombre;

select  po.nombre, p.tipo
from pistas p
inner join polideportivos po on p.id_polideportivo = po.id
order by po.nombre;

-- Listas del nombre polideportivos y el tipo depistas que contienen, solo para los que tienen pistas de Baloncesto
select  po.nombre, p.tipo
from pistas p
inner join polideportivos po on p.id_polideportivo = po.id
where p.tipo = 'Baloncesto'
order by po.nombre;

-- LEFT JOIN: muestra todas las dilas incuso las que no tenga algun dato, muestra los que tiene tatos nulos
-- Mustra una fecha de ultima reserva (Las que esten en pistas_abiertas)
select  p.* , p. precio, pa.fecha_ultima_reserva
from pistas p
left join pistas_abiertas pa on p.id = pa. id_pista;

-- RIGHT JOIN: 
-- Dodos los polideportivos y las pistas asisiadas, incluso los que no tiene pistas asociadas
select  p.* , p. precio, pa.fecha_ultima_reserva
from pistas p
right join pistas_abiertas pa on p.id = pa. id_pista;

-- full JOIN: . MySQL no acepta este comando 
-- Dodos los polideportivos y las pistas asisiadas, incluso los que no tiene pistas asociadas
select  u.nombre, r.id_reserva as id_reservas
from usuarios u
left join usuario_reserva r on u.id = id_usuario;
union
select  u.nombre, r.id_reserva as id_reservas
from usuarios u
right join usuario_reserva r on u.id = id_usuario;