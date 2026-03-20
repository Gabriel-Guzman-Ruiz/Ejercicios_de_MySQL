-- RELACIÓN DE EJERCICIOS SOBRE PROCEDIMIENTOS Y FUNCIONES

USE employees;

-- RELACIÓN DE EJERCICIOS SOBRE PROCEDIMIENTOS Y FUNCIONES

	-- 1) Realiza un procedimiento que muestre el texto “hola mundo” sobre la base de datos MySQL.
    
		DROP PROCEDURE IF EXISTS hola_mundo;
    
		DELIMITER $$
		CREATE PROCEDURE hola_mundo()
		BEGIN
			SELECT 'hola mundo' AS mensaje;
		END $$
		DELIMITER ;

		CALL hola_mundo();
        
	-- 2) Crea un procedimiento que muestre la versión de MySQL.
    
		DROP PROCEDURE IF EXISTS version_mysql;
		
		DELIMITER $$
		CREATE PROCEDURE version_mysql()
		BEGIN
			SELECT VERSION() AS version_mysql;
		END $$
		DELIMITER ;

		CALL version_mysql();
		
		-- 3) Crea un procedimiento que muestre el año actual.
		
		DROP PROCEDURE IF EXISTS anio_actual;
		
		DELIMITER $$
		CREATE PROCEDURE anio_actual()
		BEGIN
			SELECT YEAR(CURDATE()) AS anio;
		END $$
		DELIMITER ;

		CALL anio_actual();
    
	-- 4) Crea una función, llamado incrementa_en_uno, que incremente en uno un número entero que le pasemos a la función.
    
		DROP FUNCTION IF EXISTS incrementa_en_uno;
		
		DELIMITER $$
		CREATE FUNCTION incrementa_en_uno(num INT) RETURNS INT DETERMINISTIC
		BEGIN
			RETURN num + 1;
		END $$
		DELIMITER ;

		SELECT incrementa_en_uno(5);
		
	-- 5) Crea una función que reciba como parámetro un número y devuelva TRUE si el número es impar y FALSE si el número es par.
    
		DROP FUNCTION IF EXISTS es_impar;
		
		DELIMITER $$
		CREATE FUNCTION es_impar(num INT) RETURNS BOOLEAN DETERMINISTIC
		BEGIN
			IF num % 2 <> 0 THEN
				RETURN TRUE;
			ELSE
				RETURN FALSE;
			END IF;
		END $$
		DELIMITER ;

		SELECT es_impar(6);
        
-- RELACIÓN DE EJERCICIOS SOBRE TRIGGERS

USE employees;
-- 1) Haz que no se pueda añadir un nuevo departamento si el número de caracteres del nombre a añadir es inferior a 5 caracteres.

DROP TRIGGER IF EXISTS tr_departments_nombre_min_5;

DELIMITER $$
CREATE TRIGGER tr_departments_nombre_min_5
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.department_name)) < 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del departamento debe tener al menos 5 caracteres';
    END IF;
END$$
DELIMITER ;

-- =========================================================
-- EJERCICIO 2
-- Asignar automáticamente manager al crear departamento
-- (Se añade previamente el campo manager_id)
-- =========================================================

ALTER TABLE departments
ADD COLUMN manager_id INT NULL,
ADD CONSTRAINT fk_departments_manager
FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

DROP TRIGGER IF EXISTS tr_departments_asignar_manager_bi;

DELIMITER $$

CREATE TRIGGER tr_departments_asignar_manager_bi
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    DECLARE v_manager_id INT;

    SELECT e.employee_id
    INTO v_manager_id
    FROM employees e
    WHERE e.department_id IS NOT NULL
      AND e.employee_id NOT IN (
          SELECT d.manager_id
          FROM departments d
          WHERE d.manager_id IS NOT NULL
      )
    ORDER BY e.hire_date ASC, e.employee_id ASC
    LIMIT 1;

    SET NEW.manager_id = v_manager_id;
END$$

DELIMITER ;

-- =========================================================
-- EJERCICIO 3
-- REGISTRO + usuario + auditoría + control de salario
-- =========================================================

-- Tabla REGISTRO
CREATE TABLE IF NOT EXISTS REGISTRO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(100),
    tabla_nombre VARCHAR(100),
    operacion VARCHAR(10),
    fecha_hora DATETIME
);

-- Usuario
CREATE USER IF NOT EXISTS 'Gestiona_Triggers'@'localhost' IDENTIFIED BY '1234';

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON employees.* TO 'Gestiona_Triggers'@'localhost';

FLUSH PRIVILEGES;

-- Triggers auditoría
DROP TRIGGER IF EXISTS tr_departments_registro_ai;
DROP TRIGGER IF EXISTS tr_departments_registro_au;
DROP TRIGGER IF EXISTS tr_departments_registro_ad;

DELIMITER $$

CREATE TRIGGER tr_departments_registro_ai
AFTER INSERT ON departments
FOR EACH ROW
BEGIN
    INSERT INTO REGISTRO(usuario, tabla_nombre, operacion, fecha_hora)
    VALUES (CURRENT_USER(), 'departments', 'ALTA', NOW());
END$$

CREATE TRIGGER tr_departments_registro_au
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    INSERT INTO REGISTRO(usuario, tabla_nombre, operacion, fecha_hora)
    VALUES (CURRENT_USER(), 'departments', 'MODIFICA', NOW());
END$$

CREATE TRIGGER tr_departments_registro_ad
AFTER DELETE ON departments
FOR EACH ROW
BEGIN
    INSERT INTO REGISTRO(usuario, tabla_nombre, operacion, fecha_hora)
    VALUES (CURRENT_USER(), 'departments', 'BAJA', NOW());
END$$

DELIMITER ;

-- Control de salario
DROP TRIGGER IF EXISTS tr_employees_salario_rango_bi;
DROP TRIGGER IF EXISTS tr_employees_salario_rango_bu;

DELIMITER $$

CREATE TRIGGER tr_employees_salario_rango_bi
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 300000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salario debe estar entre 30000 y 300000';
    END IF;
END$$

CREATE TRIGGER tr_employees_salario_rango_bu
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 OR NEW.salary > 300000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salario debe estar entre 30000 y 300000';
    END IF;
END$$

DELIMITER ;

-- =========================================================
-- EJERCICIO 4
-- CONTADOR automático de empleados y departamentos
-- =========================================================

-- Tabla CONTADOR
CREATE TABLE IF NOT EXISTS CONTADOR (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100),
    valor INT
);

DELETE FROM CONTADOR;

INSERT INTO CONTADOR (id, tipo, valor) VALUES
(1, 'numEmpleados', 0),
(2, 'numDepartamentos', 0);

-- Inicialización
UPDATE CONTADOR
SET valor = (SELECT COUNT(*) FROM employees)
WHERE tipo = 'numEmpleados';

UPDATE CONTADOR
SET valor = (SELECT COUNT(*) FROM departments)
WHERE tipo = 'numDepartamentos';

-- Triggers contador
DROP TRIGGER IF EXISTS tr_employees_contador_ai;
DROP TRIGGER IF EXISTS tr_employees_contador_ad;
DROP TRIGGER IF EXISTS tr_departments_contador_ai;
DROP TRIGGER IF EXISTS tr_departments_contador_ad;

DELIMITER $$

CREATE TRIGGER tr_employees_contador_ai
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    UPDATE CONTADOR
    SET valor = valor + 1
    WHERE tipo = 'numEmpleados';
END$$

CREATE TRIGGER tr_employees_contador_ad
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    UPDATE CONTADOR
    SET valor = valor - 1
    WHERE tipo = 'numEmpleados';
END$$

CREATE TRIGGER tr_departments_contador_ai
AFTER INSERT ON departments
FOR EACH ROW
BEGIN
    UPDATE CONTADOR
    SET valor = valor + 1
    WHERE tipo = 'numDepartamentos';
END$$

CREATE TRIGGER tr_departments_contador_ad
AFTER DELETE ON departments
FOR EACH ROW
BEGIN
    UPDATE CONTADOR
    SET valor = valor - 1
    WHERE tipo = 'numDepartamentos';
END$$

DELIMITER ;
        
