-- Relación de ejercicios sobre consultas multitabla

-- Para la realización de estas consultas deberás usar la base de datos jardinería. Las consultas se deberán 
-- hacer usando los operadores de combinación (inner join, right join, left join, full join). 

use jardineria;

-- 1) Selecciona aquellos clientes que hayan hecho algún pedido a partir de 2008. 

select distinct c.*
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
where p.fecha_pedido >= '2008-01-01';


-- 2) Selecciona aquellos clientes que hayan hecho pedidos que contengan algún 
-- producto con una cantidad menor a 10 unidades. 

select distinct c.*
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
inner join detalle_pedido dp on dp.codigo_pedido = p.codigo_pedido
where dp.cantidad < 10;


-- 3) Selecciona aquellos empleados que trabajen en la oficina de Madrid. 

select e.*
from empleado e
inner join oficina o on o.codigo_oficina = e.codigo_oficina
where o.ciudad = 'Madrid';


-- 4) Selecciona aquellos clientes que hayan efectuado pagos con PayPal. 

select distinct c.*
from cliente c
inner join pago pa on pa.codigo_cliente = c.codigo_cliente
where pa.forma_pago = 'PayPal';


-- 5) Selecciona aquellos clientes que hayan efectuado pagos que no sea con PayPal. 

select distinct c.*
from cliente c
inner join pago pa on pa.codigo_cliente = c.codigo_cliente
where pa.forma_pago <> 'PayPal';


-- 6) Selecciona aquellos empleados que sean jefes. 

select distinct j.*
from empleado j
inner join empleado e on e.codigo_jefe = j.codigo_empleado;


-- 7) Selecciona aquellos empleados que no sean jefes. 

select e.*
from empleado e
left join empleado sub on sub.codigo_jefe = e.codigo_empleado
where sub.codigo_empleado is null;


-- 8) Selecciona todos los empleados que sean jefes en España. 

select distinct j.*
from empleado j
inner join empleado e on e.codigo_jefe = j.codigo_empleado
inner join oficina o on o.codigo_oficina = j.codigo_oficina
where o.pais = 'España';

-- 9) Selecciona aquellos clientes cuyo límite de crédito sea superior, 
-- al menos, al de algunos de los clientes de su mismo país. 

select distinct c1.*
from cliente c1
inner join cliente c2
  on c1.pais = c2.pais
 and c1.codigo_cliente <> c2.codigo_cliente
 and c1.limite_credito > c2.limite_credito;

-- 10) Selecciona aquellos clientes que hayan hecho, al menos, 5 pedidos durante el año 2009.
 
 select c.codigo_cliente, c.nombre_cliente, count(*) as num_pedidos
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
where p.fecha_pedido >= '2009-01-01' and p.fecha_pedido < '2010-01-01'
group by c.codigo_cliente, c.nombre_cliente
having count(*) >= 5;

-- 11) Mostrar aquellos empleados que sean representantes de ventas de algún cliente de Madrid.
 
 select distinct e.*
from empleado e
inner join cliente c on c.codigo_empleado_rep_ventas = e.codigo_empleado
where c.ciudad = 'Madrid';

-- 12) Mostrar aquellos clientes que tengan algún pedido pendiente. 

select distinct c.*
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
where p.estado = 'Pendiente';

-- 13) Mostrar aquellos clientes que tengan algún pedido rechazado desde 2006. 

select distinct c.*
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
where p.estado = 'Rechazado'
  and p.fecha_pedido >= '2006-01-01';

-- 14) Mostrar aquellos pedidos que tengan al menos 6 productos distintos. 

select dp.codigo_pedido, count(distinct dp.codigo_producto) as productos_distintos
from detalle_pedido dp
group by dp.codigo_pedido
having count(distinct dp.codigo_producto) >= 6;

-- 15) Mostrar aquellos clientes cuyos representantes de ventas alguno tenga su oficina en España.
 
 select distinct c.*
from cliente c
inner join empleado e on e.codigo_empleado = c.codigo_empleado_rep_ventas
inner join oficina o on o.codigo_oficina = e.codigo_oficina
where o.pais = 'España';

-- 16) Mostrar aquellos empleados que no tengan como jefe a Carlos Soria. 

select e.*
from empleado e
left join empleado j on j.codigo_empleado = e.codigo_jefe
where j.codigo_empleado is null
   or not (j.nombre = 'Carlos' and j.apellido1 = 'Soria');

-- 17) Mostrar aquellos productos de los que se hayan pedido más de 50 unidades. 

select p.* , sum(dp.cantidad) as total_unidades
from producto p
inner join detalle_pedido dp on dp.codigo_producto = p.codigo_producto
group by p.codigo_producto, p.nombre
having sum(dp.cantidad) > 50;

-- 18) Mostrar aquellos empleados que no son jefes. 

select e.*
from empleado e
left join empleado sub on sub.codigo_jefe = e.codigo_empleado
where sub.codigo_empleado is null;

-- 19) Muestra aquellos productos cuyo precio de venta sea mayor que el de la media. 

select p.*
from producto p
join (
  select avg(precio_venta) as media
  from producto
) m
where p.precio_venta > m.media;
