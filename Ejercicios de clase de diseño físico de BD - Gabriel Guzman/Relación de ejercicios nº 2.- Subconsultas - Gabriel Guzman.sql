use jardineria;

-- 1) Obtener el nombre del producto más caro. Realizar el ejercicio como una 
-- subconsulta y luego como una consulta simple para que dicha consulta sea 
-- más eficiente. 

select nombre 
from producto
where precio_venta = (select max(precio_venta) from  producto);

select  nombre 
from producto
order by precio_venta desc limit 1;

-- 2) Obtener el nombre del producto del que más unidades se hayan vendido en 
-- un mismo pedido. 

select p.nombre 
from producto p
where d.cantidad > (select max(cantidad) from  detalle_pedido d where p.codigo_producto = d.codigo_producto);

-- 3) Obtener el nombre de los clientes que hayan hecho pedidos en 2008. 

-- 4) Obtener los clientes que han pedido más de 200 unidades de cualquier 
-- producto. 

-- 5) Obtener los clientes que residen en ciudades donde no hay oficinas. 

-- 6) Obtener el nombre, los apellidos y el email de los empleados a cargo de 
-- Alberto Soria. 

-- 7) Obtener el nombre de los clientes a los que no se les ha entregado a tiempo 
-- algún pedido. 

-- 8) Obtener el nombre y teléfono de los clientes que hicieron algún pago en 
-- 2007, ordenados alfabéticamente por nombre. 

-- 9) Obtener la gama, el proveedor y la cantidad de aquellos productos cuyo 
-- estado sea pendiente.

select gama, proveedor, sum(cantidad) "total de productos pendientes"
from producto p inner join detalle_pedido dp on p.codigo_producto = dp.codigo_producto
where dp.codigo_pedido in (select codigo_pedido from pedido where estado = 'Pendiente');