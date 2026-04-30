/* PRÁCTICA DE TRANSACCIONES EN MYSQL
Objetivo: Crear un sistema de pago que actualice el stock de forma segura.

Enunciado:
Desarrolla un procedimiento llamado realizar_pago_con_stock que reciba: código de cliente, ID de transacción, importe del pago, código de producto y cantidad comprada.

Requisitos:

- Transaccionalidad: Debe asegurar que si el pago se registra, el stock se descuente, y viceversa.

- Validación de Stock: Si tras la actualización el stock del producto queda por debajo de 0, la transacción debe deshacerse por completo.

- Control de Errores: Debe incluir un DECLARE EXIT HANDLER para evitar inconsistencias ante errores inesperados de SQL.

*/

-- Solución Sugerida 

USE jardineria;

DELIMITER //

CREATE PROCEDURE realizar_pago_con_stock(
    IN p_cod_cliente INT,
    IN p_id_pago VARCHAR(50),
    IN p_importe DECIMAL(15,2),
    IN p_cod_producto VARCHAR(15),
    IN p_cantidad_restar INT
)
BEGIN
    DECLARE v_stock_final INT;

    -- Handler para errores de integridad (ej. producto inexistente)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Fallo de integridad o error SQL. Operación deshecha.' AS Log;
    END;

    START TRANSACTION;

    -- 1. Registrar el pago
    INSERT INTO pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total)
    VALUES (p_cod_cliente, 'Transferencia', p_id_pago, CURDATE(), p_importe);

    -- 2. Actualizar stock del producto
    UPDATE producto 
    SET cantidad_en_stock = cantidad_en_stock - p_cantidad_restar
    WHERE codigo_producto = p_cod_producto;

    -- 3. Comprobar si el stock es válido (>= 0)
    SELECT cantidad_en_stock INTO v_stock_final 
    FROM producto 
    WHERE codigo_producto = p_cod_producto;

    IF v_stock_final < 0 THEN
        -- Deshacer todo si no hay stock suficiente
        ROLLBACK;
        SELECT 'ERROR: Stock insuficiente. Transacción cancelada.' AS Log;
    ELSE
        -- Confirmar cambios
        COMMIT;
        SELECT 'ÉXITO: Transacción completada correctamente.' AS Log;
    END IF;

END //

DELIMITER ;
-- Pruebas de Verificación
-- Caso Éxito: Registra un pago y resta stock correctamente.
CALL realizar_pago_con_stock(1, 'TR-100', 50.00, 'OR-179', 2);

-- Caso Rollback (Stock): Intenta comprar más unidades de las disponibles.
CALL realizar_pago_con_stock(1, 'TR-200', 50.00, 'OR-179', 5000);

-- Caso Rollback (Error SQL): Código de cliente inexistente.
CALL realizar_pago_con_stock(999, 'TR-300', 10.00, 'OR-179', 1);

-- =====================================
-- 1. VISTAS COMPLEJAS
-- =====================================

-- Vista 1: resumen de ventas por cliente
CREATE VIEW vista_resumen_clientes AS
SELECT 
    c.id_cliente,
    c.nombre,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.total) AS dinero_gastado,
    AVG(p.total) AS media_por_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre;


-- Vista 2: productos con información de categoría y proveedor
CREATE VIEW vista_productos_detallados AS
SELECT 
    pr.id_producto,
    pr.nombre AS producto,
    pr.precio,
    pr.stock,
    ca.nombre AS categoria,
    pv.nombre AS proveedor,
    CASE
        WHEN pr.stock = 0 THEN 'Sin stock'
        WHEN pr.stock < 10 THEN 'Stock bajo'
        ELSE 'Stock suficiente'
    END AS estado_stock
FROM productos pr
JOIN categorias ca ON pr.id_categoria = ca.id_categoria
JOIN proveedores pv ON pr.id_proveedor = pv.id_proveedor;


-- Vista 3: pedidos pendientes con días de retraso
CREATE VIEW vista_pedidos_retrasados AS
SELECT
    p.id_pedido,
    c.nombre AS cliente,
    p.fecha_pedido,
    p.fecha_entrega,
    DATEDIFF(CURDATE(), p.fecha_entrega) AS dias_retraso,
    p.estado
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'Pendiente'
AND p.fecha_entrega < CURDATE();

-- =====================================
-- 2. PROCEDIMIENTOS COMPLEJOS
-- =====================================

DELIMITER //

-- Procedimiento 1: registrar un pedido y actualizar stock
CREATE PROCEDURE registrar_pedido(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    SELECT precio, stock
    INTO v_precio, v_stock
    FROM productos
    WHERE id_producto = p_id_producto
    FOR UPDATE;

    IF v_stock < p_cantidad THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay stock suficiente';
    ELSE
        SET v_total = v_precio * p_cantidad;

        INSERT INTO pedidos(id_cliente, fecha_pedido, total, estado)
        VALUES(p_id_cliente, NOW(), v_total, 'Pendiente');

        INSERT INTO detalle_pedido(id_pedido, id_producto, cantidad, precio_unitario)
        VALUES(LAST_INSERT_ID(), p_id_producto, p_cantidad, v_precio);

        UPDATE productos
        SET stock = stock - p_cantidad
        WHERE id_producto = p_id_producto;

        COMMIT;
    END IF;
END //


-- Procedimiento 2: aplicar descuento a productos con poco movimiento
CREATE PROCEDURE aplicar_descuento_baja_venta(
    IN p_porcentaje DECIMAL(5,2)
)
BEGIN
    UPDATE productos
    SET precio = precio - (precio * p_porcentaje / 100)
    WHERE id_producto NOT IN (
        SELECT DISTINCT id_producto
        FROM detalle_pedido dp
        JOIN pedidos p ON dp.id_pedido = p.id_pedido
        WHERE p.fecha_pedido >= CURDATE() - INTERVAL 6 MONTH
    );
END //


-- Procedimiento 3: calcular estadísticas de un cliente
CREATE PROCEDURE estadisticas_cliente(
    IN p_id_cliente INT,
    OUT total_pedidos INT,
    OUT total_gastado DECIMAL(10,2),
    OUT ultimo_pedido DATE
)
BEGIN
    SELECT 
        COUNT(*),
        IFNULL(SUM(total), 0),
        MAX(fecha_pedido)
    INTO total_pedidos, total_gastado, ultimo_pedido
    FROM pedidos
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;

-- =====================================
-- 3. TRIGGERS COMPLEJOS
-- =====================================

DELIMITER //

-- Trigger 1: auditar cambios de precio
CREATE TRIGGER trg_auditar_precio_producto
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios(
            id_producto,
            precio_anterior,
            precio_nuevo,
            fecha_cambio
        )
        VALUES(
            OLD.id_producto,
            OLD.precio,
            NEW.precio,
            NOW()
        );
    END IF;
END //


-- Trigger 2: impedir eliminar clientes con pedidos pendientes
CREATE TRIGGER trg_evitar_borrar_cliente_pendiente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pedidos
        WHERE id_cliente = OLD.id_cliente
        AND estado = 'Pendiente'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un cliente con pedidos pendientes';
    END IF;
END //


-- Trigger 3: validar email antes de insertar cliente
CREATE TRIGGER trg_validar_email_cliente
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El email no tiene un formato válido';
    END IF;

    IF EXISTS (
        SELECT 1 FROM clientes WHERE email = NEW.email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un cliente con ese email';
    END IF;
END //

DELIMITER ;

-- =====================================
-- 4. EVENTOS COMPLEJOS
-- =====================================

SET GLOBAL event_scheduler = ON;

DELIMITER //

-- Evento 1: generar resumen diario de ventas
CREATE EVENT evento_resumen_ventas_diario
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO resumen_ventas_diario(
        fecha,
        total_pedidos,
        total_facturado
    )
    SELECT
        CURDATE(),
        COUNT(*),
        IFNULL(SUM(total), 0)
    FROM pedidos
    WHERE DATE(fecha_pedido) = CURDATE();
END //


-- Evento 2: marcar clientes inactivos
CREATE EVENT evento_clientes_inactivos
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    UPDATE clientes
    SET estado = 'Inactivo'
    WHERE id_cliente NOT IN (
        SELECT DISTINCT id_cliente
        FROM pedidos
        WHERE fecha_pedido >= CURDATE() - INTERVAL 1 YEAR
    );
END //


-- Evento 3: limpiar auditorías antiguas
CREATE EVENT evento_limpiar_auditorias
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DELETE FROM auditoria_precios
    WHERE fecha_cambio < NOW() - INTERVAL 2 YEAR;

    DELETE FROM logs_sistema
    WHERE fecha < NOW() - INTERVAL 6 MONTH;
END //

DELIMITER ;

