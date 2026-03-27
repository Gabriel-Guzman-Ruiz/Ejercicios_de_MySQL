-- Eventos en MySQL
-- Son procesos que se guardan en memoria y puedes desidir cuando se ejecuta, cuantas veses, su duracion.

USE employees;


CREATE TABLE test( 
evento VARCHAR(50), 
fecha DATETIME  
);  

-- Lo primero que debemos de hacer es habilitar nuestro servidor para que pueda 
-- ejecutar eventos. 

select @@event_scheduler;

SET GLOBAL event_scheduler = ON; 


-- Crea 3 filas en la tabla test en un minuto
DELIMITER // 
CREATE EVENT insertion_event 
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE 
DO 
BEGIN 
INSERT INTO test VALUES ('Evento 1', NOW()); 
INSERT INTO test VALUES ('Evento 2', NOW()); 
INSERT INTO test VALUES ('Evento 3', NOW()); 
END 
// DELIMITER ; 


-- Mustra los eventos que estan activos.
SHOW EVENTS FROM  employees ; 

-- Eliminar eventos
 DROP EVENT insertion_event;
 
 -- detener todos los eventos
 SET GLOBAL event_scheduler = off; 
 
 -- ejemplos:
 
 -- Crear tabla
 
 create table empleado_numero (
	fecha datetime ,
    numEmpleados int
    );
    
-- un evento que guarde cada cada 4 segundos por un minuto el numero de empleados en la nueva table.alter

DELIMITER // 
CREATE EVENT numero_empleados 
ON schedule every 4 second starts now() ends current_timestamp + interval 1 minute 
DO 
BEGIN 
	declare numEmp int default 0;
    select count(*) from employees into numEmp;
    insert into empleado_numero values (now(), numEmp);
END 
// DELIMITER ; 

DROP EVENT numero_empleados;

alter event numero_empleados disable;

--  creamos otro evento que aga lo mismo

CREATE EVENT numero_empleados_2
ON schedule every 4 second starts now() ends current_timestamp + interval 1 minute 
DO insert empleado_numero select now(), count(*) from employees; 

-- lo paramos

alter event numero_empleados_2 disable;

-- lo eliminamos

DROP EVENT numero_empleados_2;

 -- Crear tabla
 
 create table historico_accesos (
	user char(50) ,
    host char(50) ,
    time int
    );
    
-- guarda quien entra el servidor cada segundo durante un minuto.

DELIMITER // 
CREATE EVENT historico_accesos_minuto 
ON schedule every 1 second starts now() ends current_timestamp + interval 1 minute 
on completion preserve do
insert into historico_accesos select user, host, time from information_schema.processlist;
// DELIMITER ; 

show events from employees;

select * from historico_accesos;


create table employees_copia like employees;

 DROP EVENT copia_tabla_employees;

DELIMITER // 
CREATE EVENT copia_tabla_employees
ON schedule at "2026-03-27-20:08" on completion preserve do insert into employees_copia select*from employees;
// DELIMITER ; 

select * from employees_copia;