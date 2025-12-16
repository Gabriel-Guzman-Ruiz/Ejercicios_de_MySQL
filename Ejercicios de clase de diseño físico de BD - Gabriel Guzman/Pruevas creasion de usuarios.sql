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