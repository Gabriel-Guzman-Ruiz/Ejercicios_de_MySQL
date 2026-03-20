-- Ejercicio.- Gestión de errores --

use employees;

DELIMITER //
CREATE PROCEDURE employee_insert(
    idEmpleado INT,
    nombre VARCHAR(20),
    apellido VARCHAR(25),
    emailEmp VARCHAR(100),
    telefono VARCHAR(20),
    fechaContrat DATE,
    idTrabajo INT,
    salario DECIMAL(8,2),
    idManager INT,
    idDepartamento INT
)

BEGIN

    DECLARE error BOOLEAN DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    BEGIN
        SET error = TRUE;
    END;

    INSERT INTO employees
    (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
    VALUES
    (idEmpleado, nombre, apellido, emailEmp, telefono, fechaContrat, idTrabajo, salario, idManager, idDepartamento);

    IF (error) THEN
        SELECT -1 AS codigo, 'Clave primaria duplicada';
    ELSE
        SELECT 0 AS codigo, 'Fila añadida correctamente';
    END IF;

END //

DELIMITER ;

CALL employee_insert(
200,
'Carlos',
'Lopez',
'carlos.lopez@empresa.com',
'600123456',
'2024-01-10',
9,
5000,
101,
6
);