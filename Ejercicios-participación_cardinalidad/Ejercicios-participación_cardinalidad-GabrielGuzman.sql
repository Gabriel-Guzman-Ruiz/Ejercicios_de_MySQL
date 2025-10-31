-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: univercidad
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `ID_Curso` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Definición` varchar(200) NOT NULL,
  `ID_Departamento` int NOT NULL,
  PRIMARY KEY (`ID_Curso`),
  KEY `ID_Departamento_idx` (`ID_Departamento`),
  CONSTRAINT `ID_Departamento` FOREIGN KEY (`ID_Departamento`) REFERENCES `departamentos` (`ID_Departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

LOCK TABLES `cursos` WRITE;
/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
INSERT INTO `cursos` VALUES (2,'Biología','Estudia los seres vivos, su estructura, funciones, evolución y relación con el ambiente.',1),(3,'Física','Analiza la materia, la energía y las leyes que explican el movimiento y el comportamiento del universo.',1),(4,'Química','Examina la composición, propiedades y transformaciones de la materia.',1),(5,'Historia','Examina los hechos y procesos del pasado para comprender el presente y proyectar el futuro.',2),(6,'Geografía','Estudia la Tierra, sus paisajes, climas, recursos y la relación entre las personas y su entorno.',2),(7,'Economía','Analiza la producción, distribución y consumo de bienes y servicios, y cómo se gestionan los recursos.',2),(8,'Artes Plásticas','Desarrolla la creatividad mediante técnicas de dibujo, pintura, escultura y otras expresiones visuales.',3),(9,'Música','Enseña teoría, apreciación e interpretación musical con distintos instrumentos y estilos.',3),(10,'Teatro','Fomenta la expresión corporal, vocal y emocional a través de la actuación y la puesta en escena.',3);
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamentos`
--

DROP TABLE IF EXISTS `departamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamentos` (
  `ID_Departamento` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Definición` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_Departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamentos`
--

LOCK TABLES `departamentos` WRITE;
/*!40000 ALTER TABLE `departamentos` DISABLE KEYS */;
INSERT INTO `departamentos` VALUES (1,'Ciencias','Los estudios ligados a las ciencias naturales.'),(2,'Sociales','Los estudios ligados a las materias sociales.'),(3,'Artes','Los estudios ligados a las diferentes topos de expresiones artisticas.');
/*!40000 ALTER TABLE `departamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `ID_Estudiante` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellidos` varchar(45) NOT NULL,
  PRIMARY KEY (`ID_Estudiante`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
INSERT INTO `estudiantes` VALUES (1,'Andrea','Pérez Mendoza'),(2,'Marcos','Silva Romero'),(3,'Elena','Castro Núñez'),(4,'Javier','Herrera Lozano'),(5,'Laura','Campos Aguilar'),(6,'Rodrigo','Méndez Pardo'),(7,'Paula','Reyes Domínguez'),(8,'Gabriel','Ortega Salas'),(9,'Claudia','Ibáñez Correa'),(10,'Nicolás','Suárez Cabrera'),(11,'Fernanda','Vega Rosales'),(12,'Tomás','Luna Serrano'),(13,'Isabel','Molina Duarte'),(14,'Adrián','Bravo Cordero'),(15,'Carolina','Fuentes Varela'),(16,'Martín','Arroyo Benítez'),(17,'Julieta','León Aranda'),(18,'Francisco','Rivas Godoy'),(19,'Emma','Carrillo Solís'),(20,'Samuel','Ponce Acosta'),(21,'Daniela','Medina Escobar'),(22,'Luis','Cabrera Quintana'),(23,'Valentina','Cornejo Sáenz'),(24,'Jorge','Padilla Bustos'),(25,'Alejandra','Rivera Llamas'),(26,'Ricardo','Peña Calderón'),(27,'María','Soto Villalobos'),(28,'Esteban','Flores Zamora'),(29,'Renata','Delgado Pizarro'),(30,'Ignacio','Marín Barrios'),(31,'Luciana','Esquivel Rojas'),(32,'Sergio','Lozano Pineda'),(33,'Camilo','Ramírez Ocampo'),(34,'Jimena','Torres Valdés'),(35,'Patricia','Gutiérrez Lara'),(36,'Andrés','Navarro Castaño');
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modulos_estudiantes`
--

DROP TABLE IF EXISTS `modulos_estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modulos_estudiantes` (
  `ID_Estudiante` int NOT NULL,
  `ID_Módulo` int NOT NULL,
  PRIMARY KEY (`ID_Estudiante`,`ID_Módulo`),
  KEY `ID_Modulos_idx` (`ID_Módulo`),
  CONSTRAINT `ID_Estudiante` FOREIGN KEY (`ID_Estudiante`) REFERENCES `estudiantes` (`ID_Estudiante`),
  CONSTRAINT `ID_Modulos` FOREIGN KEY (`ID_Módulo`) REFERENCES `módulos` (`ID_Módulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modulos_estudiantes`
--

LOCK TABLES `modulos_estudiantes` WRITE;
/*!40000 ALTER TABLE `modulos_estudiantes` DISABLE KEYS */;
INSERT INTO `modulos_estudiantes` VALUES (1,1),(2,1),(19,1),(20,1),(1,2),(2,2),(20,2),(21,2),(3,3),(4,3),(21,3),(22,3),(3,4),(4,4),(22,4),(23,4),(5,5),(6,5),(23,5),(24,5),(5,6),(6,6),(24,6),(25,6),(7,7),(8,7),(25,7),(26,7),(7,8),(8,8),(26,8),(27,8),(9,9),(10,9),(27,9),(28,9),(9,10),(10,10),(28,10),(29,10),(11,11),(12,11),(29,11),(30,11),(11,12),(12,12),(30,12),(31,12),(13,13),(14,13),(31,13),(32,13),(13,14),(14,14),(32,14),(33,14),(15,15),(16,15),(33,15),(34,15),(15,16),(17,16),(34,16),(35,16),(17,17),(18,17),(35,17),(36,17),(18,18),(19,18),(36,18);
/*!40000 ALTER TABLE `modulos_estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `módulos`
--

DROP TABLE IF EXISTS `módulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `módulos` (
  `ID_Módulo` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Definición` varchar(200) NOT NULL,
  `ID_Profesor` int NOT NULL,
  `ID_Curso` int NOT NULL,
  PRIMARY KEY (`ID_Módulo`),
  KEY `ID_Profesor` (`ID_Profesor`),
  KEY `ID_Cursos_idx` (`ID_Curso`),
  CONSTRAINT `ID_Cursos` FOREIGN KEY (`ID_Curso`) REFERENCES `cursos` (`ID_Curso`),
  CONSTRAINT `ID_Profesores` FOREIGN KEY (`ID_Profesor`) REFERENCES `profesores` (`ID_Profesor`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `módulos`
--

LOCK TABLES `módulos` WRITE;
/*!40000 ALTER TABLE `módulos` DISABLE KEYS */;
INSERT INTO `módulos` VALUES (1,'Estructura celular','Estudia las partes y funciones de la célula.',1,2),(2,'Genética básica','Analiza cómo se heredan las características.',1,2),(3,'Movimiento y fuerza','Examina las leyes del movimiento y la gravedad.',2,3),(4,'Energía y trabajo','Explica cómo se transforma y conserva la energía.',2,3),(5,'Materia y sus propiedades','Clasificación y cambios de la materia.',3,4),(6,'Reacciones químicas','Cómo interactúan y se transforman las sustancias.',3,4),(7,'Civilizaciones antiguas','Egipto, Grecia, Roma y sus aportes.',4,5),(8,'Historia moderna','Revoluciones, independencia y globalización.',4,5),(9,'Geografía física','Relieve, clima y recursos naturales.',5,6),(10,'Geografía humana','Población, economía y cultura.',5,6),(11,'Principios económicos','Producción, consumo y mercado.',6,7),(12,'Economía global','Comercio internacional y desarrollo.',6,7),(13,'Dibujo y color','Técnicas básicas de representación visual.',7,8),(14,'Escultura y volumen','Creación de formas tridimensionales.',7,8),(15,'Teoría musical','Notas, ritmo y armonía.',8,9),(16,'Práctica instrumental','Ejecución y expresión musical.',8,9),(17,'Expresión corporal:','Movimiento y comunicación escénica.',9,10),(18,'Interpretación dramática:','Creación y actuación de personajes.',9,10);
/*!40000 ALTER TABLE `módulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesores`
--

DROP TABLE IF EXISTS `profesores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesores` (
  `ID_Profesor` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellidos` varchar(45) NOT NULL,
  `ID_Departamento` int NOT NULL,
  `ID_Curso` int NOT NULL,
  PRIMARY KEY (`ID_Profesor`),
  KEY `ID_Departamento_idx` (`ID_Departamento`),
  KEY `ID_Curso_idx` (`ID_Curso`),
  CONSTRAINT `ID_Curso` FOREIGN KEY (`ID_Curso`) REFERENCES `cursos` (`ID_Curso`),
  CONSTRAINT `ID_Departamentos` FOREIGN KEY (`ID_Departamento`) REFERENCES `departamentos` (`ID_Departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesores`
--

LOCK TABLES `profesores` WRITE;
/*!40000 ALTER TABLE `profesores` DISABLE KEYS */;
INSERT INTO `profesores` VALUES (1,'Valeria','Gómez Martínez',1,2),(2,'Sebastián','López Ramírez',1,3),(3,'Camila','Torres Hernández',1,4),(4,'Diego','Fernández Cruz',2,5),(5,'Lucía','Morales García',2,6),(6,'Mateo','Castillo Rivera',2,7),(7,'Sofía','Rojas Delgado',3,8),(8,'Alejandro','Vargas Peña',3,9),(9,'Natalia','Herrera Soto',3,10);
/*!40000 ALTER TABLE `profesores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-10 20:38:59
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: escuela2
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alumnos`
--

DROP TABLE IF EXISTS `alumnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumnos` (
  `ID_Alumnos` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(20) NOT NULL,
  `Apellido` varchar(20) NOT NULL,
  `Edad` int NOT NULL,
  `ID_Cursos` int NOT NULL,
  PRIMARY KEY (`ID_Alumnos`,`ID_Cursos`),
  KEY `ID_Curso_idx` (`ID_Cursos`),
  CONSTRAINT `ID_Cursos` FOREIGN KEY (`ID_Cursos`) REFERENCES `cursos` (`ID_Cursos`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumnos`
--

LOCK TABLES `alumnos` WRITE;
/*!40000 ALTER TABLE `alumnos` DISABLE KEYS */;
INSERT INTO `alumnos` VALUES (1,'Gabriel','Guzman',21,1),(2,'Samuel','Enrique',22,2),(3,'Pele','Alverto',16,1);
/*!40000 ALTER TABLE `alumnos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asignatura`
--

DROP TABLE IF EXISTS `asignatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignatura` (
  `ID_Asignatura` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `ID_Profesor` int NOT NULL,
  `ID_Curso` int NOT NULL,
  PRIMARY KEY (`ID_Asignatura`,`ID_Profesor`,`ID_Curso`),
  KEY `ID_Profesor_idx` (`ID_Profesor`),
  KEY `ID_Curso_idx` (`ID_Curso`),
  CONSTRAINT `ID_Curso` FOREIGN KEY (`ID_Curso`) REFERENCES `cursos` (`ID_Cursos`),
  CONSTRAINT `ID_Profesor` FOREIGN KEY (`ID_Profesor`) REFERENCES `profesor` (`ID_Profesor`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignatura`
--

LOCK TABLES `asignatura` WRITE;
/*!40000 ALTER TABLE `asignatura` DISABLE KEYS */;
INSERT INTO `asignatura` VALUES (1,'Matematical',1,1),(2,'Ingles',3,1),(3,'Historia',3,2),(4,'Lengua',2,3),(6,'Cosina',3,2);
/*!40000 ALTER TABLE `asignatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `ID_Cursos` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Fecha` int NOT NULL,
  PRIMARY KEY (`ID_Cursos`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

LOCK TABLES `cursos` WRITE;
/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
INSERT INTO `cursos` VALUES (1,'ESO1',2025),(2,'ESO2',2025),(3,'ESO3',2025);
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesor`
--

DROP TABLE IF EXISTS `profesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesor` (
  `ID_Profesor` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(20) NOT NULL,
  `Apellido` varchar(20) NOT NULL,
  `Edad` int NOT NULL,
  PRIMARY KEY (`ID_Profesor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesor`
--

LOCK TABLES `profesor` WRITE;
/*!40000 ALTER TABLE `profesor` DISABLE KEYS */;
INSERT INTO `profesor` VALUES (1,'Jose','Antonio',40),(2,'Paulo','Manuel',24),(3,'Elver','Marmol',54);
/*!40000 ALTER TABLE `profesor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-10 20:38:59
