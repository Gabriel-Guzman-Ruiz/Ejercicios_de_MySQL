-- Práctica sobre transacciones en MySQL

use jardineria;

-- Enunciado:
-- Desarrolla un procedimiento llamado realizar_pago_con_stock que reciba: código de 
-- cliente, ID de transacción, importe del pago, código de producto y cantidad comprada.

-- Requisitos:

	-- Transaccionalidad: Debe asegurar que si el pago se registra, el stock se descuente, 
	-- y viceversa.

	-- Validación de Stock: Si tras la actualización el stock del producto queda por 
	-- debajo de 0, la transacción debe deshacerse por completo.

	-- Control de Errores: Debe incluir un DECLARE EXIT HANDLER 
	-- para evitar inconsistencias ante errores inesperados de SQL.
    
drop PROCEDURE realizar_pago_con_stock;
    
DELIMITER // 
CREATE PROCEDURE  realizar_pago_con_stock(
	IN p_codigo_cliente INT,
    IN p_codigo_pedido INT,
    IN p_codigo_producto VARCHAR(15),
    IN p_cantidad INT,
    IN p_precio_unidad DECIMAL(15,2) 
) 

BEGIN
    DECLARE v_limite_credito DECIMAL(15,2);
    DECLARE v_total_pedido DECIMAL(15,2);
    DECLARE v_limite_stock int;
    
    -- MANEJADOR DE ERRORES TÉCNICOS
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    ROLLBACK;
    SELECT 'Error técnico: Transacción anulada.' AS Estado;
    END;
    
    START TRANSACTION;
    
    -- Obtener límite de crédito para validación de negocio
    SELECT limite_credito INTO v_limite_credito
    FROM cliente WHERE codigo_cliente = p_codigo_cliente;
    
	SELECT cantidad_en_stock INTO v_limite_stock
    FROM producto WHERE codigo_producto = p_codigo_producto;
   
   SET v_total_pedido = p_cantidad * p_precio_unidad;
    
    IF v_total_pedido > v_limite_credito or v_limite_stock - p_cantidad < 0 THEN
		-- Validación de negocio fallida
		SELECT 'Límite de crédito excedido o no hay soficiente stock. Cancelando...' AS Estado;
		ROLLBACK;
    ELSE
    
		UPDATE producto
		SET cantidad_en_stock = v_limite_stock - p_cantidad
		WHERE  codigo_producto = p_codigo_producto;
    
    
		-- Operación 1: Insertar cabecera
		INSERT INTO pedido (codigo_pedido, fecha_pedido, fecha_esperada, estado, codigo_cliente)
		VALUES (p_codigo_pedido, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Pendiente', p_codigo_cliente);
		
        -- Operación 2: Insertar detalle
		INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)
		VALUES (p_codigo_pedido, p_codigo_producto, p_cantidad, p_precio_unidad, 1);
		
        COMMIT;
		SELECT 'Pedido registrado con éxito' AS Estado;
    END IF; 
END // 
DELIMITER ;

call realizar_pago_con_stock();

call realizar_pago_con_stock(10, 132, "AR-001", 5, 1);

call realizar_pago_con_stock(10, 10, "FR-101", 400, 13);