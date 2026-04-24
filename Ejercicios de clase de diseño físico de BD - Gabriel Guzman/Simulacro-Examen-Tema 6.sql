-- EXAMEN BD SIMULACRO SOBRE EL TEMA 6: PROGRAMACIÓN DE BASES DE DATOS

USE jardineria;

-- Ejercicio 1: Cursores
-- Enunciado: Crea un procedimiento almacenado llamado listar_clientes_por_region que reciba como parámetro el nombre de una región (o ciudad). 
-- El procedimiento debe utilizar un cursor para recorrer todos los clientes de esa zona y mostrar un mensaje por cada uno con el formato:
-- "Cliente: [nombre_cliente] - Contacto: [nombre_contacto] [apellido_contacto]".

DELIMITER $$

DROP PROCEDURE IF EXISTS listar_clientes_por_region$$

CREATE PROCEDURE listar_clientes_por_region(IN p_region VARCHAR(50))
BEGIN
    -- Declaración de variables para el cursor
    DECLARE v_nombre VARCHAR(50);
    DECLARE v_contacto_nombre VARCHAR(30);
    DECLARE v_contacto_apellido VARCHAR(30);
    DECLARE fin INTEGER DEFAULT 0;
    
    -- Declaración del cursor
    DECLARE cur_clientes CURSOR FOR 
        SELECT nombre_cliente, nombre_contacto, apellido_contacto 
        FROM cliente 
        WHERE region = p_region OR ciudad = p_region;
    
    -- Manejador de error para el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
    
    OPEN cur_clientes;
    
    bucle: LOOP
        FETCH cur_clientes INTO v_nombre, v_contacto_nombre, v_contacto_apellido;
        IF fin = 1 THEN
            LEAVE bucle;
        END IF;
        
        -- Mostramos el resultado
        SELECT CONCAT('Cliente: ', v_nombre, ' - Contacto: ', v_contacto_nombre, ' ', v_contacto_apellido) AS Info;
    END LOOP;
    
    CLOSE cur_clientes;
END$$

DELIMITER ;

-- Ejemplo de uso:
CALL listar_clientes_por_region('Madrid');

-- Ejercicio 2: Triggers (Disparadores)
-- Enunciado: Para llevar un control de seguridad, crea una tabla llamada auditoria_pagos. Después, crea un trigger llamado pago_insert que, 
-- cada vez que se inserte un nuevo registro en la tabla pago, guarde de forma automática en la tabla de auditoría el ID del cliente, la fecha del pago, 
-- el total y la fecha/hora exacta en la que se realizó la inserción en el sistema.
    
    -- Primero creamos la tabla de auditoría
CREATE TABLE auditoria_pagos (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    codigo_cliente INT,
    fecha_pago DATE,
    total_pago DECIMAL(15,2),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER pago_insert
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_pagos (codigo_cliente, fecha_pago, total_pago)
    VALUES (NEW.codigo_cliente, NEW.fecha_pago, NEW.total);
END$$

DELIMITER ;

-- Ejercicio 3: Eventos
-- Enunciado: La empresa quiere un sistema de limpieza automática. Crea un evento en MySQL llamado limpiar_auditoria_vieja que se ejecute una vez al mes, 
-- empezando a partir de mañana. Este evento debe borrar todos los registros de la tabla auditoria_pagos (creada en el ejercicio anterior) que tengan más de 6 meses de antigüedad.

SET GLOBAL event_scheduler = ON;

DELIMITER $$

CREATE EVENT limpiar_auditoria_vieja
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY -- Empieza mañana
DO
BEGIN
    DELETE FROM auditoria_pagos 
    WHERE fecha_registro < NOW() - INTERVAL 6 MONTH;
END$$

DELIMITER ;
