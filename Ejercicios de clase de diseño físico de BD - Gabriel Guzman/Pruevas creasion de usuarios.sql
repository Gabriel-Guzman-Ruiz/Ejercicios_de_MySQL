# Creamos usuario
create user if not exists 'miguel'@'localhost' identified by '1234';

# bisualizamos los usuarios en la base de datos
select user, host from mysql.user;

# Le damos todos los provilegios
grant all privileges on  jardineria.* to 'miguel'@'localhost';
# Actualizar los privilegios.
flush privileges;

# Le damos algunos de los provilegios
create user 'antonio'@'localhost' identified by '1234';
grant select, insert, update, delete
on jardineria.* to 'antonio'@'localhost';

# Le damos algunos de los provilegios solo una tabla.
create user 'pepe'@'localhost' identified by '1234';
grant select on jardineria.cliente

#le damos la capasidad de dar sus permisos a otros usuarios.
to 'pepe'@'localhost' with grant option;

#para quitar permisos.
revoke select, insert, update, delete
on jardineria.* from 'antonio'@'localhost';

#Para ver los permisos de una cuenta.
show grants for 'antonio'@'localhost';

#boramos un rol
drop role if exists 'rol_lectura_escritura','rol_lectura','rol-escritura';
#creamos un rol
create role 'rol_lectura_escritura','rol_lectura','rol-escritura';

#Le damos los permisos al rol
grant all on jardineria.* TO 'rol_lectura_escritura';
grant select on jardineria.* TO 'rol_lectura';
grant insert, update, delete on jardineria.* TO 'rol-escritura';

#creamos los usuarios
create user 'admin'@'localhost' identified by 'pasword1';

create user 'usuario_lectura_1'@'localhost' identified by 'pasword2';
create user 'usuario_lectura_2'@'localhost' identified by 'pasword3';

create user 'usuario_escritura_1'@'localhost' identified by 'pasword4';
create user 'usuario_escritura_2'@'localhost' identified by 'pasword5';

#Le damos un rol a cada usuario.
grant 'rol_lectura_escritura' to 'admin'@'localhost';
grant 'rol_lectura' to 'usuario_lectura_1'@'localhost', 'usuario_lectura_2'@'localhost';
grant 'rol-escritura' to 'usuario_escritura_1'@'localhost', 'usuario_escritura_2'@'localhost';

revoke 'rol_lectura_escritura' from 'admin'@'localhost';

set default role'rol_lectura_escritura' to'admin'@'localhost';
set default role'rol_lectura' to 'usuario_lectura_1'@'localhost', 'usuario_lectura_2'@'localhost';
set default role'rol-escritura' to 'usuario_escritura_1'@'localhost', 'usuario_escritura_2'@'localhost';