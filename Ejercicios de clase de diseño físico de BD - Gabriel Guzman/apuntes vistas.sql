USE employees;

create view `empleados_departamentos`
as 
select d.department_name, e.employee_id, e.hire_date
from employees e inner join departments d
on (d.department_id = e.department_id) 
order by  d.department_name, e.employee_id;

select * from employees.empleados_departamentos;



select table_name, view_definition
from information_schema.viens
where table_schema ='employeer'; 

drop view empleados_departamentos;

USE jardineria;

create view clientes_empleados as 
select c.codigo_cliente, c.nombre_cliente, c.ciudad, e.nombre as nombreRep,
e.apellido1 as apellido1Rep,
e.apellido2 as apellido2Rep
from cliente c join empleado e on (c.codigo_empleado_rep_ventas = e.codigo_empleado)
where c.ciudad = 'Madrid';

select * from clientes_empleados;

update cliente set ciudad = 'Malega' where nombre_cliente = 'Beragua';

alter view clientes_empleados as 
select c.codigo_cliente, c.nombre_cliente, c.ciudad, e.nombre as nombreRep,
e.apellido1 as apellido1Rep,
e.apellido2 as apellido2Rep
from cliente c join empleado e on (c.codigo_empleado_rep_ventas = e.codigo_empleado)
where c.ciudad = 'Madrid'
with check option;

create user creador_vista identified by '1234';
grant create view, select on jardineria.* to creador_vista;

grant insert, delete, update on jardineria.clientes_empleados to creador_vista;
grant insert, delete, update on jardineria.cliente to creador_vista;
grant insert, delete, update on jardineria.empleado to creador_vista;




