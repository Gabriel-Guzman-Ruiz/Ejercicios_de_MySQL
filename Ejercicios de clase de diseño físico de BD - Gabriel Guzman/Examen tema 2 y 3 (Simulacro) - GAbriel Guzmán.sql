/*
Script: Examen Simulacro
Estudiante: Gabriel Guzmán
*/

/************************************************************
 PARTE A – DISEÑO FÍSICO DE BASES DE DATOS (6 puntos)

 Crea la base de datos llamada plataforma_proyectos con las
 siguientes tablas:
************************************************************/

-- Eliminamos la base de datos si existe (opcional para pruebas)
DROP DATABASE IF EXISTS plataforma_proyectos;

-- Creación de la base de datos
CREATE DATABASE plataforma_proyectos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE plataforma_proyectos;

/************************************************************
 1. Tabla desarrolladores (2 puntos)

 Almacena la información de los desarrolladores registrados
 en la plataforma.
 - id_desarrollador: PK
 - usuario: obligatorio, único
 - email: obligatorio, único
 - fecha_registro: obligatoria
 - nivel_experiencia: Junior, Mid o Senior (obligatorio)
************************************************************/

CREATE TABLE desarrolladores (
    id_desarrollador INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL,
    nivel_experiencia ENUM('Junior', 'Mid', 'Senior') NOT NULL,
    CONSTRAINT uq_desarrolladores_usuario UNIQUE (usuario),
    CONSTRAINT uq_desarrolladores_email UNIQUE (email)
);

/************************************************************
 2. Tabla proyectos (2 puntos)

 Guarda la información de los proyectos software.
 - id_proyecto: PK
 - nombre: obligatorio
 - descripcion: opcional
 - fecha_inicio: obligatoria
 - fecha_fin: opcional
 - estado: Planificado, En desarrollo o Finalizado
************************************************************/

CREATE TABLE proyectos (
    id_proyecto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado ENUM('Planificado', 'En desarrollo', 'Finalizado') NOT NULL
    );

/************************************************************
 3. Tabla asignaciones (2 puntos)

 Representa la asignación de desarrolladores a proyectos.
 - id_asignacion: PK
 - id_desarrollador: FK a desarrolladores
 - id_proyecto: FK a proyectos
 - rol: obligatorio
 - fecha_asignacion: obligatoria

 Un desarrollador no puede estar asignado dos veces
 al mismo proyecto.
************************************************************/

CREATE TABLE asignaciones (
    id_asignacion INT PRIMARY KEY AUTO_INCREMENT,
    id_desarrollador INT NOT NULL,
    id_proyecto INT NOT NULL,
    rol VARCHAR(50) NOT NULL,
    fecha_asignacion DATE NOT NULL,
    CONSTRAINT fk_asignaciones_desarrolladores
        FOREIGN KEY (id_desarrollador)
        REFERENCES desarrolladores(id_desarrollador),
    CONSTRAINT fk_asignaciones_proyectos
        FOREIGN KEY (id_proyecto)
        REFERENCES proyectos(id_proyecto),
    CONSTRAINT uq_desarrollador_proyecto
        UNIQUE (id_desarrollador, id_proyecto)
);

/************************************************************
 DATOS DE PRUEBA
************************************************************/

-- Desarrolladores
INSERT INTO desarrolladores (usuario, email, fecha_registro, nivel_experiencia) VALUES
('juan_dev', 'juan@correo.com', '2024-01-10', 'Junior'),
('maria_code', 'maria@correo.com', '2023-11-05', 'Mid'),
('carlos_ai', 'carlos@correo.com', '2022-06-20', 'Senior'),
('laura_web', 'laura@correo.com', '2024-02-01', 'Mid');

SELECT * FROM desarrolladores;

-- Proyectos
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, estado) VALUES
('Plataforma E-learning', 'Sistema de formación online', '2024-01-15', NULL, 'En desarrollo'),
('App de gestión médica', 'Aplicación para clínicas privadas', '2023-09-01', '2024-03-31', 'Finalizado'),
('Web corporativa', 'Página institucional de empresa', '2024-02-10', NULL, 'Planificado');

SELECT * FROM proyectos;

-- Asignaciones
INSERT INTO asignaciones (id_desarrollador, id_proyecto, rol, fecha_asignacion) VALUES
(1, 1, 'Frontend', '2024-01-16'),
(2, 1, 'Backend', '2024-01-16'),
(3, 1, 'Arquitecto', '2024-01-20'),
(2, 2, 'Backend', '2023-09-02'),
(4, 3, 'Diseño UI', '2024-02-11');

SELECT * FROM asignaciones;

/************************************************************
 PARTE B – GESTIÓN DE USUARIOS Y ROLES (4 puntos)
************************************************************/

-- Por seguridad, eliminamos previamente usuario y roles si existen
DROP USER IF EXISTS 'proyectos_app'@'localhost';
DROP ROLE IF EXISTS rol_lectura;
DROP ROLE IF EXISTS rol_edicion;

/************************************************************
 1. Crear un usuario llamado proyectos_app que solo pueda
 conectarse desde localhost y cuya contraseña sea DevPass$2026
 (0,5 puntos)
************************************************************/

CREATE USER 'proyectos_app'@'localhost'
IDENTIFIED BY 'DevPass$2026';

/************************************************************
 2. Crear un rol llamado rol_lectura con permisos SELECT
 sobre todas las tablas de plataforma_proyectos (1 punto)
************************************************************/

CREATE ROLE rol_lectura;

GRANT SELECT
ON plataforma_proyectos.*
TO rol_lectura;

/************************************************************
 3. Crear un rol llamado rol_edicion con permisos INSERT y
 UPDATE sobre todas las tablas (1 punto)
************************************************************/

CREATE ROLE rol_edicion;

GRANT INSERT, UPDATE
ON plataforma_proyectos.*
TO rol_edicion;

/************************************************************
 4. Asignar ambos roles al usuario proyectos_app y dejar
 activo por defecto únicamente el rol de lectura (1 punto)
************************************************************/

GRANT rol_lectura, rol_edicion
TO 'proyectos_app'@'localhost';

SET DEFAULT ROLE rol_lectura
TO 'proyectos_app'@'localhost';

/************************************************************
 5. Elimina la cuenta del usuario proyectos_app y todos los
 roles creados anteriormente (0,5 puntos)
************************************************************/

DROP USER 'proyectos_app'@'localhost';
DROP ROLE rol_lectura;
DROP ROLE rol_edicion;