-- Apuntes de DML: codigos para alterar una tabla ya creada.
use reservas;

INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_nacimiento, fecha_alta)
 VALUES (100, '12345678A', 'Antonio', 'García', 'agarcia@gmail.com', 'Málaga', 0.25, 
 '1990-12-12', '2020-12-04'); 
 
 -- Como se inserta una fila con todos los valores de los campos, no haría falta especificar 
 -- los nombres de los campos. Aunque el orden de los valores debe coincidir con el orden 
 -- que tienen los campos cuando se creó la tabla. 
 
 INSERT INTO usuarios 
 VALUES (200, '12345677A', 'Miguel', 'García', 'magarcia@gmail.com', 'Zaragoza', 
 '1990-12-12', 0.3, '2003-02-01'); 
 
 -- Inserta una fila con todos los valores de los campos, excepto el campo fecha de nacimiento 
 -- que no es obligatorio. 
 
 INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_alta) 
 VALUES (45, '12345679A', 'Luis', 'García', 'lgarcia@gmail.com', 'Málaga', 0.15, '1990-12-12'); 
 
 -- Para insertar varias filas en una tabla 
 INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_alta) 
 VALUES (300, '12345678A', 'Pepe', 'Sanz', 'psanz@gmail.com', 'Málaga', 0.25, '1990-12-12'),  
 (301, '98765432Z', 'Luis', 'Peréz', 'lperez@gmail.com', 'Málaga', 0.25, '1988-010-3'); 
 
 -- creamos la tabla otros_usuarios col la misma estructura de usuarios.
 create table otros_usuarios like usuarios;
 select* from otros_usuarios;
 
 -- Le pasamos los datos de la tabla usuario.
 INSERT INTO otros_usuarios (id, dni, nombre, apellidos, email,  ciudad, descuento, fecha_alta) 
 SELECT id, dni, nombre, apellidos, email, ciudad ,descuento, fecha_alta  
 FROM usuarios; 
 
 -- SENTENCIAS DELETE (eliminar fila de una tabla)
 
 -- Veamos algunos ejemplos: 
 
 -- ▪ Elimina todos los usuarios 
 DELETE FROM usuarios; 
 
 -- ▪ Borrar una fila estableciendo una condición 
 DELETE FROM pistas 
 WHERE id = 10; 
 
 -- ▪ Borrar varias filas estableciendo varias condiciones 
 DELETE FROM pistas 
 WHERE tipo = 'baloncesto' 
 OR codigo = 'BAL001'; 
 
 -- ▪ Borrar filas relacionando varias tablas 
 -- Elimina los usuarios que se dieron de alta antes de 2014 
 -- y aún no han reservado ninguna pista 
 DELETE FROM usuarios 
 WHERE id 
 NOT IN (SELECT id_usuario FROM usuario_reserva) 
 AND fecha_alta < '2014-01-01'; 
 
 -- SENTENCIA UPDATE (Introduse filas en una tabla)
 
 UPDATE usuarios SET nombre = 'Felipe' WHERE id = 12; 
 
 -- ▪ Actualizar varias columnas de una fila 
 UPDATE usuarios SET nombre = 'Felipe', dni = '12365478H'  WHERE id = 15; 
 
 -- ▪ Actualizar una columna de varias filas.Se actualizarán aquellas filas de la tabla 
 -- pistas que cumplan la condición de la cláusula WHERE. 
 -- Incrementa el precio en un 10% de las pistas de tenis que tengan un precio actual 
 -- inferior a 20 € 
 UPDATE pistas SET precio = precio + precio * 0.10 
 WHERE precio < 20 
 AND tipo = 'tenis'; 
 -- ▪ Actualizar una columna utilizando una subconsulta: 
 -- Reduce el precio de las pistas que no se han reservado todavía en un 10% 
 UPDATE pistas SET precio = precio - precio * 0.1 
 WHERE id 
 NOT IN (SELECT id_pista FROM reservas); 
 