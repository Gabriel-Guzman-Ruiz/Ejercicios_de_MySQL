-- Cursor: número de empleados por departamento
USE employees;

-- Eliminar el procedimiento si ya existe
DROP PROCEDURE IF EXISTS cursorEmpleadosPorDepartamento;

DELIMITER $$

CREATE PROCEDURE cursorEmpleadosPorDepartamento()
BEGIN
    -- Variables donde se guardan los valores del cursor
    DECLARE v_department_id INT;
    DECLARE v_num_empleados INT;

    -- Variable de control de fin de cursor
    DECLARE fin BOOL DEFAULT FALSE;

    -- Cursor: devuelve departamento y número de empleados
    DECLARE dept_cursor CURSOR FOR
        SELECT department_id, COUNT(*) AS num_empleados
        FROM employees
        GROUP BY department_id
        ORDER BY department_id;

    -- Handler: cuando no haya más filas, activa fin
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    -- Abrir cursor
    OPEN dept_cursor;

    -- Bucle de lectura
    leer_departamentos: LOOP
        FETCH dept_cursor INTO v_department_id, v_num_empleados;

        IF fin THEN
            LEAVE leer_departamentos;
        END IF;

        -- Mostrar los valores de cada fila recorrida
        SELECT v_department_id AS department_id,
               v_num_empleados AS num_empleados;
    END LOOP leer_departamentos;

    -- Cerrar cursor
    CLOSE dept_cursor;
END $$

DELIMITER ;

-- Llamada al procedimiento
CALL cursorEmpleadosPorDepartamento();