use jardineria;

-- 1. Obtener la ciudad y el teléfono de las oficinas de EEUU.

select pais, telefono
from  oficina
where pais = 'EEUU';

-- 2. Obtener el cargo, nombre, apellidos e email del jefe de la empresa.

select nombre, apellido1, apellido2, email
from  empleado
where puesto = 'Director General' ;

-- 3. Obtener el nombre, apellidos y cargo de aquellos que no sean representantes de ventas.

select nombre, apellido1, apellido2, puesto
from  empleado
where puesto != 'Representante Ventas' ;

-- 4. Obtener el número de clientes que tiene la empresa.

select count(codigo_cliente) "Numero de clientes"
from  jardineria.cliente;

-- 5. Obtener el nombre de los clientes españoles.

select nombre_cliente "nombre clientes Españoles"
from  jardineria.cliente
where pais = 'Spain';

-- 6. Obtener cuántos clientes tiene la empresa en cada país.

select pais , count(codigo_cliente) "numero de clientes"
from  jardineria.cliente
group by pais
order by pais;

-- 7. Obtener cuántos clientes tiene la empresa en la ciudad de Madrid.

select count(codigo_cliente) "numero de clientes en Madrid"
from  jardineria.cliente
where ciudad = 'Madrid';

-- 8. Obtener el código de empleado y el número de clientes al que atiende cada representante de ventas.

select codigo_empleado_rep_ventas, count(codigo_cliente) "numero de clientes"
from  cliente
group by codigo_empleado_rep_ventas
order by codigo_empleado_rep_ventas;

-- 9. Obtener cuál fue el primer y último pago que hizo el cliente cuyo código es el número 3.

select codigo_cliente, max(fecha_pago) "Ultimo pago del cliente"
from  pago
where codigo_cliente = 3;

-- 10. Obtener el código de cliente de aquellos clientes que hicieron pagos en 2008.

select codigo_cliente "Clientes que realizaron pagos el 2008"
from  pago
where fecha_pago >= '2008-01-01' && fecha_pago <= '2008-12-31'
order by codigo_cliente;

-- 11. Obtener los distintos estados por los que puede pasar un pedido.

select estado "Los estados en los que puede estar un pedido"
from  pedido
group by estado
order by estado;

-- 12. Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos que no han sido entregados a tiempo.

select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega 
from  pedido
where estado = 'Entregado' && fecha_esperada < fecha_entrega
order by estado;

-- 13. Obtener cuántos productos existen en cada línea de pedido.

select numero_linea , count(cantidad) "Numero deproductos por linia de pedido"
from  detalle_pedido
group by numero_linea
order by numero_linea;

-- 14. Obtener un listado de los 20 códigos de productos más pedidos ordenado por cantidad pedida.

SELECT codigo_producto, SUM(cantidad) AS total_pedido
FROM detalle_pedido
GROUP BY codigo_producto
ORDER BY total_pedido DESC LIMIT 20;

-- 15. Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha requerida. (Usar la función addDate)

select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega 
from  pedido
where fecha_entrega <= ADDDATE(fecha_esperada, -2);

-- 16. Obtener el nombre, apellidos, oficina y cargo de aquellos que no sean representantes de ventas.

select nombre, apellido1, apellido2, codigo_oficina ,puesto
from  empleado
where puesto != 'Representante Ventas' ;

-- 17. Obtener el número de clientes que tiene asignado cada representante de ventas.

select empleado.nombre, empleado.apellido1, empleado.apellido2, count(codigo_cliente) "numero de clientes"
from  cliente, empleado
where codigo_empleado_rep_ventas = codigo_empleado
group by codigo_empleado_rep_ventas
order by empleado.nombre;

-- 18. Obtener un listado con el precio total de cada pedido.

select codigo_pedido,  sum(precio_unidad) "Presio total del pedido"
from  detalle_pedido
group by codigo_pedido
order by codigo_pedido;

-- 19. Obtener cuántos pedidos tiene cada cliente en cada estado.

select cliente.nombre_cliente, cliente.apellido_contacto, count(pedido.codigo_pedido) "numero de clientes"
from  cliente, pedido
where cliente.codigo_cliente = pedido.codigo_cliente
order by cliente.nombre_cliente;

-- 20. Obtener una lista con el código de oficina, ciudad, región y país de aquellas oficinas que estén en países que cuyo nombre empiece por “E”.

SELECT codigo_oficina, ciudad, region, pais
FROM oficina
WHERE pais LIKE 'E%';

-- 21. Obtener el nombre, gama, dimensiones, cantidad en stock y el precio de venta de los cinco productos más caros.

SELECT nombre, gama, dimensiones, cantidad_en_stock, precio_venta
FROM producto
ORDER BY precio_venta DESC
LIMIT 5;

-- 22. Obtener el código y la facturación de aquellos pedidos mayores de 2000 euros.

SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS facturacion
FROM detalle_pedido
GROUP BY codigo_pedido
HAVING facturacion > 2000
order by facturacion desc;

-- 23. Obtener una lista de los productos mostrando el stock total, la gama y el proveedor.

SELECT nombre, cantidad_en_stock AS stock_total, gama, proveedor
FROM producto;

-- 24. Obtener el número de pedidos y código de cliente de aquellos pedidos cuya fecha de pedido sea igual a la de la fecha de entrega.

SELECT codigo_cliente, COUNT(codigo_pedido) AS numero_pedidos
FROM pedido
WHERE fecha_pedido = fecha_entrega
GROUP BY codigo_cliente;