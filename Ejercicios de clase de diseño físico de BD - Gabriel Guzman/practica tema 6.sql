-- Vistas
-- 1) Cliente madrid: Mustre el nombre del contacto y ciudad de todos los clientes que residen en madrid.

USE Jardineria;

create view Cliente_madrid as 
select nombre_cliente, ciudad
from cliente 
where ciudad = "Madrid"
order by  nombre_cliente
with check option; 

select * from Cliente_madrid; 

update Cliente_madrid
set ciudad = "Malaga"
where nombre_cliente = "Javier";

-- 2) pedido pendiente: mustra codigo de pedido, fecha de pedido y nombre del cliente de todos los pedidos cuyo estado cea pendiente.

drop view pedido_pendiente;

create view pedido_pendiente as 
select p.codigo_pedido, p.fecha_pedido, c.nombre_cliente
from cliente c inner join pedido p
where p.codigo_cliente = c.codigo_cliente and estado = "Pendiente"
order by  p.codigo_pedido;

select * from pedido_pendiente; 



-- 3) resumen_pagos_2008: npmbre cliente y suma total de los pagos realizados el 2008

drop view resumen_pagos_2008;

create view resumen_pagos_2008 as 
select c.nombre_cliente , sum(p.total)
from cliente c inner join pago p
where p.codigo_cliente = c.codigo_cliente and year(p.fecha_pago) = "2008"
group by c.nombre_cliente
order by nombre_cliente;

select * from resumen_pagos_2008; 

-- 4) stock_bajo: nombre producto y la cantidad de estock de apellos productos que tengan menos de 10 de stock

drop view stock_bajo;

create view stock_bajo as 
select nombre , cantidad_en_stock
from producto
where cantidad_en_stock < 10
order by nombre;

select * from stock_bajo; 