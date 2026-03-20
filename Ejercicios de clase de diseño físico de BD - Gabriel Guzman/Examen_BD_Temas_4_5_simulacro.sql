/**********************************************************
*             EXAMEN BD TEMA 4 y 5 (SIMULACRO)
**********************************************************

-- Todos los ejercicios se realizarán sobre la base de datos jardinería 

/* PARTE A – Tema 4.- REALIZACIÓN DE CONSULTAS */

use jardineria;

-- 1) Selecciona a aquellos empleados que sean directores de oficinas cuyos códigos terminen en "USA"

SELECT *
FROM empleado 
WHERE codigo_oficina LIKE '%USA' and puesto like 'Director Oficina';

-- 2) Selecciona a aquellos clientes que residan en España. Ordena la consulta por el nombre del cliente ascendentemente.

select *
from  cliente
where pais = 'spain' 
order by nombre_cliente ;

-- 3) Muestra la media de la cantidad en stock de cada gama de productos. Ordena la consulta por la media de la cantidad en stock descendentemente.

select gama, avg(cantidad_en_stock) "media stock"
from producto
group by gama
order by avg(cantidad_en_stock) desc ;


-- 4) Selecciona aquellos empleados que tengan como jefe a Ruben López.

select *
from empleado
where codigo_jefe in (
  select codigo_empleado
  from empleado
  where nombre = "Ruben" and apellido1 = "López"
);

-- 5) Muestra los códigos de los clientes cuyas cantidades pagadas en cada una de sus transacciones
-- estén por encima de la media.

SELECT DISTINCT c.codigo_cliente
FROM cliente c
JOIN pago p ON p.codigo_cliente = c.codigo_cliente
WHERE p.total > (
    SELECT AVG(total)
    FROM pago
);

/* PARTE B – Tema 5.- TRATAMIENTO DE DATOS (DML) */

-- 1) Inserta un nuevo cliente (usa datos ficticios).
-- Inserta solo los datos que sean obligatorios

INSERT INTO cliente (codigo_cliente, nombre_cliente, telefono,fax, linea_direccion1, ciudad)
 VALUES (39, 'Gabriel', '0808080808', '3838383838', 'calle naranga 4 c 5', 'Toremolinos'); 

-- 2) Incrementa en un 10% el precio de venta de los productos cuyo precio esté por debajo de 20

UPDATE producto
SET precio_venta = precio_venta * 1.10
WHERE precio_venta < 20;

-- 3) Elimina los clientes que sean de Madrid y Barcelona

DELETE FROM cliente
WHERE ciudad IN ('Madrid', 'Barcelona');