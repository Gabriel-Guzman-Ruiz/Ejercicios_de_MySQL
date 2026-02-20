-- CREAR PROSEDIMIENTO
-- CREATE PROCEDURE
-- Crear prosedimiento
use employees;
DELIMITER $$
create procedure employees.department_getlist()
begin
select departmnet_id,department_name
from departments;
end $$
DELIMITER ;

-- eliminar prosedimiento
drop procedure if exists employees.department_getlist;

-- ejecitar prosedimiento
call employees.department_getlist();

-- Los procedimientos de la base de datos
show procedure status;

-- ver codigo de un prosedimiento
show create  employees.department_getlist();

-- Declarar variblables
DELIMITED \\
create definer='root'@'localhost' procedure 'department_getCount'()

--
--
--

-- Crea un prosedimiento que pida ccomo dato de entrada uno que tetermine el salario minimo,
-- el prosedimiento muestra todos los empleados que cobran mas del salario minimo

DELIMITER $$
create procedure employees.get_employees_salary_greater(in salario_min int)
begin
select *
from employees
where salary > salario_min;
end$$
DELIMITER ;

call employees.get_employees_salary_greater(1000);

-- eliminar prosedimiento
drop procedure if exists employees.get_employees_salary_greater;

-- PROSEDIMIENTOS QUE USAN PARAMETROS DE ENTRADA Y SALIDA
DELIMITER //
create procedure employees.obtener_salario
(in paran_id_empleado int, out param_salario decimal(8,2))
begin
select salary
into param_salario
from employees.employees
where employee_id = param_id_empleado;
end//
DELIMITER ;

call employees.obtener_salario (100, @salario);
select @salario;

-- eliminar prosedimiento
drop procedure if exists employees.obtener_salario;

DELIMITER //
create procedure aumentar_salario
(inout p_salario decimal(10,2))
begin
	set p_salario = p_salario * 1.10;
end//
DELIMITER ;

set @salario = 2000;
call aumentar_salario(@salario);
select @salario;

-- eliminar prosedimiento
drop procedure if exists employees.obtener_salario;

-- un numero es positivo o negativo
DELIMITER $$
create procedure es_positivo_o_negativo(in valor int)
begin
	-- declare respueste text;
	if valor = 0 then
		select valor 'El numero es nulo';
        -- set respuesta = "x";
	else
		if valor < 0 then
			select valor 'Es negativo';
            -- set respuesta = concat(valor,"x");
		else
        select valor 'Es positivo';
        end if;
    end if;
    -- select respuesta
end$$
DELIMITER ;

set @valor = 0;
call es_positivo_o_negativo(@valor);

-- eliminar prosedimiento
drop procedure if exists es_positivo_o_negativo;

-- un numero es positivo o negativo
DELIMITER $$
create procedure nota_cualitativa(in valor int, out prueva varchar(20))
begin
    if valor < 0 then
		set prueva = 'No es valido';
    elseif valor > 10 then
		set prueva = 'No es valido';
    else
		case valor
			when 10 then  set prueva = 'Sobresaliente';
			when 9 then  set prueva = 'Sobresaliente';
			when 8 then  set prueva = 'Notable';
			when 7 then  set prueva = 'Notable';
			when 6 then  set prueva = 'bien';
			when 5 then  set prueva = 'aprovado';
			else set prueva = 'suspenso';
		end case;
	end if;
end$$
DELIMITER ;

set @valor = 0;
call es_positivo_o_negativo(@valor);

-- eliminar prosedimiento
drop procedure if exists es_positivo_o_negativo;

-- BUCLES while
DELIMITER $$
create procedure employees.ejemplo_while(inout val int)
begin
    declare i int default 1;
    while i<=5 do
		set val = val+1;
        set i = i +1;
    end while;
end$$
DELIMITER ;

set @valor = 10;
call employees.ejemplo_while(@valor);
select @valor;

-- eliminar prosedimiento
drop procedure if exists employees.ejemplo_while;


-- BUCLES repeat
DELIMITER $$
create procedure employees.ejemplo_repeat(inout val int)
begin
    declare i int default 1;
    repeat 
		set val = val+1;
        set i = i +1;
	until i > 5
    end repeat;
end$$
DELIMITER ;

set @valor = 10;
call employees.ejemplo_while(@valor);
select @valor;

-- eliminar prosedimiento
drop procedure if exists employees.ejemplo_while;

-- BUCLES repeat
DELIMITER $$
create procedure employees.ejemplo_loop()
begin
    declare counter int default o;
    my_loop: loop 
		set counter=+1;
        if counter=10 then leave my_loop;
        end if;
        select counter;
	end loop my_loop;
end$$
DELIMITER ;

set @valor = 10;
call employees.ejemplo_while(@valor);
select @valor;

-- eliminar prosedimiento
drop procedure if exists employees.ejemplo_while;

