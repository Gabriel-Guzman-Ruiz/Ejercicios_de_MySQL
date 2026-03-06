-- CREAR CURSORES
use employees;
-- eliminar prosedimiento
drop procedure if exists cursotTest;

-- crear cursor
DELIMITER $$
create procedure cursotTest()
begin
-- variables
	declare v_emp_no int;
    declare v_first_name varchar(20);
    declare v_last_name varchar(25);
    declare v_email varchar(100);
    
-- variable fin de bucle
	declare fin bool default false;
    
-- El SELECT a ejecutar
	declare employees_cursor cursor for
		select employee_id, first_name, last_name, email from employees.employees
        order by employee_id limit 20;

-- Condicion de salida
	declare continue handler for not found set fin=true;
    
	open employees_cursor;
    get_employees: loop
		fetch employees_cursor into v_emp_no, v_first_name, v_last_name, v_email;
        if fin = 1 then
			leave get_employees;
		end if;
        
        select v_emp_no, v_first_name, v_last_name, v_email;
	end loop get_employees;
    
    close employees_cursor;
end $$
DELIMITER ;

call cursotTest();


