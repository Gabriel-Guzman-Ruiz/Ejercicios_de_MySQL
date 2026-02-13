-- Eliminamos la base de datos si existe 
DROP DATABASE IF EXISTS gimnasio_fitlife;

-- Creación de la base de datos
CREATE DATABASE gimnasio_fitlife
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;
  
  USE gimnasio_fitlife;
  
  -- Creacion de tablas
  
  CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    dni VARCHAR(9) NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100),
    fecha_registro DATE NOT NULL,
    CONSTRAINT uq_cliente_dni UNIQUE (dni),
    CONSTRAINT uq_cliente_email UNIQUE (email)
);

  CREATE TABLE actividades (
    id_actividad INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    intencidad ENUM('Baja', 'Media', 'Alta'),
    precio_mensual numeric (6,2) NOT NULL,
    plazas_maximas int,
    fecha_registro DATE NOT NULL,
    
    CONSTRAINT chk_precio_mensual CHECK ( precio_mensual > 0),
    CONSTRAINT chk_plazas_maximas CHECK ( plazas_maximas BETWEEN 0 AND 100)
);

  CREATE TABLE incripciones (
    id_incripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente int not null,
    id_actividad int not null,
    fecha_inscripcion DATE NOT NULL,
    actiba boolean NOT NULL,
    
    CONSTRAINT fk_incripciones_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_incripciones_actividad
        FOREIGN KEY (id_actividad)
        REFERENCES actividades(id_actividad),
    
    CONSTRAINT uq_cliente_actividad UNIQUE (id_cliente, id_actividad)
);

  -- Creacion de usuarios y roles
CREATE USER 'gimnasio_app'@'localhost' IDENTIFIED BY 'FitPass!456';
  
CREATE ROLE rol_lectura;
CREATE ROLE rol_gestion;

-- Asignar permisos a los roles y usuarios

GRANT SELECT ON gimnasio_fitlife.* TO rol_lectura;

GRANT insert, update ON gimnasio_fitlife.* TO rol_gestion;

GRANT rol_lectura, rol_gestion TO 'gimnasio_app'@'localhost';

-- Mustrar los roles de el usuario

show grants for 'gimnasio_app'@'localhost';

-- Eliminar roles

DROP ROLE IF EXISTS rol_lectura;
DROP ROLE IF EXISTS rol_gestion;
DROP USER IF EXISTS 'gimnasio_app'@'localhost';

  
  