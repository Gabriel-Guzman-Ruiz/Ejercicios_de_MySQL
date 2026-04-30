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

-- =====================================
-- PROCEDIMIENTOS ALMACENADOS (Stored Procedures)
-- =====================================

-- 1. obtener_pedidos_cliente:
-- Un procedimiento que reciba el código de un cliente y devuelva todos sus pedidos.

drop procedure if exists obtener_pedidos_cliente;

DELIMITER $$
create procedure obtener_pedidos_cliente(in r_codigo_cliente int)
begin
select *
from pedido
where codigo_cliente = r_codigo_cliente
order by codigo_pedido;
end $$
DELIMITER ;

call obtener_pedidos_cliente(1);

-- 2. actualizar_precio_gama:
-- Un procedimiento que reciba el nombre de una gama (ej. 'Frutales')
-- y un porcentaje (ej. 10.50), e incremente el precio de venta de
-- todos los productos de esa gama.

drop procedure if exists actualizar_precio_gama;

DELIMITER $$
create procedure actualizar_precio_gama(in r_game varchar(50), in porcentaje decimal(5,2))
begin
    UPDATE producto
    SET precio_venta = precio_venta * (1 + porcentaje / 100)
    WHERE gama = r_game;
end $$
DELIMITER ;

call actualizar_precio_gama();

-- 3. calcular_total_pedido:
-- Un procedimiento que reciba un código de pedido y devuelva
-- (mediante un parámetro OUT) el importe total del mismo
-- (suma de precio unidad * cantidad).

drop procedure if exists calcular_total_pedido;

DELIMITER $$
create procedure calcular_total_pedido(in r_codigo_pedido int, OUT total DECIMAL(10,2))
begin
    SELECT SUM(precio_unidad * cantidad)
    INTO total
    FROM detalle_pedido
    WHERE codigo_pedido = r_codigo_pedido;
end $$
DELIMITER ;

call calcular_total_pedido(1);

-- 4. eliminar_cliente_sin_pagos:
-- Un procedimiento que reciba un código de cliente y lo elimine de la base de datos,
-- pero solo si no tiene pagos registrados.

drop procedure if exists eliminar_cliente_sin_pagos;

DELIMITER $$
create procedure eliminar_cliente_sin_pagos(IN r_cod_cliente INT)
begin
    IF NOT EXISTS (
        SELECT 1 FROM pagos WHERE codigo_cliente = r_cod_cliente
    ) THEN
        DELETE FROM clientes WHERE codigo_cliente = r_cod_cliente;
    END IF;
end $$
DELIMITER ;

call eliminar_cliente_sin_pagos(1);

-- =====================================
-- TRIGGERS (Disparadores)
-- =====================================

-- 1. log_cambios_precio:
-- Cada vez que se actualice el precio de un producto, se debe insertar
-- un registro en una tabla de auditoría llamada historial_precios
-- (debes crearla) con el código, el precio viejo y el nuevo.

-- Tabla de auditoría (necesaria)
CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(15),
    precio_antiguo DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
-- 1. log_cambios_precio
CREATE TRIGGER log_cambios_precio
BEFORE UPDATE ON producto
FOR EACH ROW
BEGIN
    IF OLD.precio_venta <> NEW.precio_venta THEN
        INSERT INTO historial_precios (codigo_producto, precio_antiguo, precio_nuevo)
        VALUES (OLD.codigo_producto, OLD.precio_venta, NEW.precio_venta);
    END IF;
END //

-- 2. validar_stock_pedido:
-- Antes de insertar un nuevo detalle de pedido, comprueba si hay stock suficiente.
-- Si no lo hay, lanza un error.

CREATE TRIGGER validar_stock_pedido
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    SELECT cantidad_en_stock INTO stock_actual
    FROM producto
    WHERE codigo_producto = NEW.codigo_producto;

    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END //

-- 3. actualizar_stock_venta:
-- Después de insertar un nuevo detalle de pedido, resta automáticamente
-- la cantidad vendida del stock actual del producto.

CREATE TRIGGER actualizar_stock_venta
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE producto
    SET cantidad_en_stock = cantidad_en_stock - NEW.cantidad
    WHERE codigo_producto = NEW.codigo_producto;
END //

-- 4. limpiar_pagos_cliente:
-- Al eliminar un cliente, elimina automáticamente todos sus pagos asociados
-- para mantener la integridad (simulando un ON DELETE CASCADE manual).

CREATE TRIGGER limpiar_pagos_cliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    DELETE FROM pagos WHERE codigo_cliente = OLD.codigo_cliente;
END //

DELIMITER ;

-- =====================================
-- EVENTOS
-- =====================================

-- 1. limpiar_historial_precios:
-- Crea un evento que se ejecute una vez al mes y que elimine todos los registros
-- de la tabla historial_precios que tengan más de un año de antigüedad.

SET GLOBAL event_scheduler = ON;

DELIMITER //

-- 1. limpiar_historial_precios
CREATE EVENT limpiar_historial_precios
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DELETE FROM historial_precios
    WHERE fecha < NOW() - INTERVAL 1 YEAR;
END //

-- 2. backup_diario_stock:
-- Crea un evento que cada 24 horas inserte en una tabla llamada log_stock_diario
-- el nombre de los productos y su stock actual (para tener un histórico de inventario).

CREATE TABLE log_stock_diario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    stock INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE EVENT backup_diario_stock
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO log_stock_diario (nombre_producto, stock)
    SELECT nombre, cantidad_en_stock
    FROM producto;
END //

-- 3. desactivar_clientes_inactivos:
-- Crea un evento que se ejecute cada semana y actualice una supuesta columna estado
-- a 'Inactivo' para aquellos clientes que no hayan realizado ningún pedido en los últimos 2 años.

CREATE EVENT desactivar_clientes_inactivos
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    UPDATE cliente
    SET estado = 'Inactivo'
    WHERE codigo_cliente NOT IN (
        SELECT DISTINCT codigo_cliente
        FROM pedido
        WHERE fecha_pedido >= NOW() - INTERVAL 2 YEAR
    );
END //

-- 4. notificar_pedidos_retrasados:
-- Crea un evento que se ejecute cada hora y que inserte en una tabla de alertas
-- el código de pedido de aquellos pedidos que sigan en estado 'Pendiente'
-- pero cuya fecha esperada ya haya pasado.

CREATE TABLE alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_pedido INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE EVENT notificar_pedidos_retrasados
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    INSERT INTO alertas (codigo_pedido)
    SELECT codigo_pedido
    FROM pedido
    WHERE estado = 'Pendiente'
    AND fecha_esperada < NOW();
END //

DELIMITER ;

