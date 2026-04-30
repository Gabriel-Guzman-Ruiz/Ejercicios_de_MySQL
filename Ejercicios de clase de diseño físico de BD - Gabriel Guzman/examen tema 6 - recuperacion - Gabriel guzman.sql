USE jardineria;

# EXAMEN – BASE DE DATOS TEMA 6 - 1º CURSO DAM (RECUPERACIÓN)

# Se usará la base de datos jardinería

## 1) PROCEDIMIENTOS Y FUNCIONES

-- Ejercicio 1. Procedimiento almacenado

-- Crea un procedimiento almacenado llamado `resumenPedidosAnuales`.
-- El procedimiento deberá mostrar el número total de pedidos realizados en un año determinado, agrupados por su estado.
-- Por tanto, los campos a mostrar serán: año, estado, cantidad total
-- Los datos deberán mostrarse ordenados ascendentemente por el campo estado.
-- El procedimiento deberá recibir como parámetro el año sobre el que se desea realizar el resumen.

drop procedure if exists resumenPedidosAnuales;

DELIMITER $$
create procedure resumenPedidosAnuales(in r_anno year)
begin
select r_anno as año , estado,  COUNT(codigo_pedido) as numeroPedidos
from pedido
where r_anno = year(fecha_pedido)
group by estado
order by estado;
end $$
DELIMITER ;

call resumenPedidosAnuales(2008);

## 2) TRIGGERS

-- Ejercicio 2. Trigger

-- Crea un trigger llamado `alarma_clientes_pagos_minimos`.

-- Este trigger deberá almacenar en una tabla llamada `clientes_pagos_minimos` aquellos clientes que tengan algún pago inferior a 50 euros.
-- La inserción deberá realizarse automáticamente cada vez que se inserte un nuevo pago en la tabla `pago`.
-- La tabla `clientes_pagos_minimos` deberá contener los siguientes campos: codigoCliente, fechaPago, formaPago, total, mensaje
-- Donde el campo `mensaje` almacenará el texto: 'Pago inferior al mínimo permitido'

-- Tabla de auditoría (necesaria)
CREATE TABLE clientes_pagos_minimos (
    codigoCliente int,
    fechaPago date,
    formaPago varchar(40),
    total DECIMAL(15,2),
    mensaje VARCHAR(50)
);

drop TRIGGER if exists alarma_clientes_pagos_minimos;

DELIMITER //
-- 1. log_cambios_precio
CREATE TRIGGER alarma_clientes_pagos_minimos
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    IF new.total < 50 THEN
        INSERT INTO clientes_pagos_minimos (codigoCliente, fechaPago, formaPago, total, mensaje)
        VALUES ( new.codigo_Cliente,  new.fechaPago,  new.formaPago,  new.total, "Pago inferior al mínimo permitido");
    END IF;
END //
DELIMITER ;

INSERT INTO pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total) VALUES (1,"PayPal", "ak-std-000033", '2026-01-01', 30.00);

## 3) VISTAS O EVENTOS

-- Ejercicio 3. Vista

-- Crea una vista llamada productosGamaOrnamentales que muestre únicamente los productos cuya gama sea Ornamentales.
-- La vista debe contener los siguientes campos: codigo_producto, nombre, gama, dimensiones, cantidad_en_stock, precio_venta
-- La vista debe mostrar los resultados ordenados ascendentemente por el nombre del producto.
-- Además, configura la vista para que cualquier inserción o modificación realizada a través de ella mantenga siempre la condición de pertenecer a la gama Ornamentales.

drop view productosGamaOrnamentales;

create view productosGamaOrnamentales as 
select codigo_producto, nombre, gama , dimensiones, cantidad_en_stock, precio_venta
from producto
where gama = "Ornamentales"
order by  nombre ASC;

select * from productosGamaOrnamentales;

-- Intenta insertar un nuevo producto de la gama Ornamentales utilizando dicha vista.
-- ¿Qué ocurriría si intentaras insertar un producto con otra gama distinta? Razona la respuesta.