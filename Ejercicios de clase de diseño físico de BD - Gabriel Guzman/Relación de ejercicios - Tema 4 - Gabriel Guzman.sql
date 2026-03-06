-- RELACIÓN DE EJERCICIOS SOBRE PROCEDIMIENTOS Y FUNCIONES

USE employees;

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