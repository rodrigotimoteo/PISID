-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for osx10.10 (x86_64)
--
-- Host: localhost    Database: PISID
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Alerta`
--

DROP TABLE IF EXISTS `Alerta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Alerta` (
  `id_alerta` int(11) NOT NULL AUTO_INCREMENT,
  `id_experiencia` int(11) DEFAULT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `sala` int(11) DEFAULT NULL,
  `sensor` int(11) DEFAULT NULL,
  `leitura` decimal(4,2) DEFAULT NULL,
  `tipo_alerta` enum('TemperaturaDesvioExcedido','TemperaturaProximaDeExcederMax','NumeroRatos','AusensiaMovimento','TempoMaxExcedido') NOT NULL,
  `mensagem` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_alerta`),
  KEY `alerta_id_exp` (`id_experiencia`),
  CONSTRAINT `alerta_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alerta`
--

LOCK TABLES `Alerta` WRITE;
/*!40000 ALTER TABLE `Alerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alerta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Experiencia`
--

DROP TABLE IF EXISTS `Experiencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Experiencia` (
  `id_experiencia` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` text DEFAULT NULL,
  `estado_experiencia` enum('Por Iniciar','A decorrer','Terminada') NOT NULL,
  `investigador` varchar(50) NOT NULL,
  `data_hora_criacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `data_hora_ult_edicao` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data_hora_inicio` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data_hora_conclusao` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `numero_ratos` int(11) NOT NULL,
  `limite_ratos_sala` int(11) NOT NULL,
  `segundos_sem_movimento` int(11) NOT NULL,
  `temperatura_ideal` decimal(4,2) NOT NULL,
  `variacao_temperatura_maxima` decimal(4,2) NOT NULL,
  `num_movimentos_ratos` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_experiencia`),
  KEY `utilizador_id_exp` (`investigador`),
  CONSTRAINT `utilizador_id_exp` FOREIGN KEY (`investigador`) REFERENCES `Utilizador` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Experiencia`
--

LOCK TABLES `Experiencia` WRITE;
/*!40000 ALTER TABLE `Experiencia` DISABLE KEYS */;
INSERT INTO `Experiencia` VALUES (1,'TestExp','A decorrer','rmnto@iscte-iul.pt','2024-04-25 17:27:11','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,30,10.00,20.00,NULL);
/*!40000 ALTER TABLE `Experiencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExperienciaSubstancia`
--

DROP TABLE IF EXISTS `ExperienciaSubstancia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExperienciaSubstancia` (
  `id_substancia_exp` int(11) NOT NULL AUTO_INCREMENT,
  `id_experiencia` int(11) NOT NULL,
  `substancia` varchar(20) NOT NULL,
  `num_ratos_administrada` int(11) NOT NULL,
  PRIMARY KEY (`id_substancia_exp`,`id_experiencia`),
  KEY `substancia_id_exp` (`id_experiencia`),
  CONSTRAINT `substancia_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExperienciaSubstancia`
--

LOCK TABLES `ExperienciaSubstancia` WRITE;
/*!40000 ALTER TABLE `ExperienciaSubstancia` DISABLE KEYS */;
/*!40000 ALTER TABLE `ExperienciaSubstancia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MedicoesPassagens`
--

DROP TABLE IF EXISTS `MedicoesPassagens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MedicoesPassagens` (
  `id_medicao` int(11) NOT NULL AUTO_INCREMENT,
  `id_experiencia` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `sala_origem` int(11) NOT NULL,
  `sala_destino` int(11) NOT NULL,
  PRIMARY KEY (`id_medicao`) USING BTREE,
  KEY `med_passagem_exp` (`id_experiencia`),
  CONSTRAINT `med_passagem_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesPassagens`
--

LOCK TABLES `MedicoesPassagens` WRITE;
/*!40000 ALTER TABLE `MedicoesPassagens` DISABLE KEYS */;
INSERT INTO `MedicoesPassagens` VALUES (1,1,'2024-04-25 17:27:31',2,5),(2,1,'2024-04-25 17:27:40',2,5),(3,1,'2024-04-25 17:27:41',5,6),(4,1,'2024-04-25 17:27:44',5,7),(5,1,'2024-04-25 17:27:49',6,8),(6,1,'2024-04-25 17:28:59',1,3),(7,1,'2024-04-25 17:29:02',1,3),(8,1,'2024-04-25 17:29:02',3,2),(9,1,'2024-04-25 17:29:05',3,2),(10,1,'2024-04-25 17:29:05',1,3),(11,1,'2024-04-25 17:29:05',3,10),(12,1,'2024-04-25 17:29:05',3,10),(13,1,'2024-04-25 17:29:08',3,2),(14,1,'2024-04-25 17:29:11',1,2),(15,1,'2024-04-25 17:29:11',1,3),(16,1,'2024-04-25 17:29:12',2,4),(17,1,'2024-04-25 17:29:14',3,2),(18,1,'2024-04-25 17:29:15',2,4),(19,1,'2024-04-25 17:29:18',2,4),(20,1,'2024-04-25 17:29:21',2,4),(21,1,'2024-04-25 17:29:24',2,4),(22,1,'2024-04-25 17:29:29',4,5),(23,1,'2024-04-25 17:29:32',5,7),(24,1,'2024-04-26 10:48:16',7,5),(25,1,'2024-04-26 10:48:26',5,6),(26,1,'2024-04-26 10:48:33',6,8),(27,1,'2024-04-26 10:48:46',1,3),(28,1,'2024-04-26 10:48:49',3,2),(29,1,'2024-04-26 10:48:52',1,2),(30,1,'2024-04-26 10:48:52',1,3),(31,1,'2024-04-26 10:48:55',3,2),(32,1,'2024-04-26 10:48:55',1,3),(33,1,'2024-04-26 10:48:58',3,2),(34,1,'2024-04-26 10:48:59',1,3),(35,1,'2024-04-26 10:49:02',3,2),(36,1,'2024-04-26 10:49:03',2,5),(37,1,'2024-04-26 10:49:03',2,4),(38,1,'2024-04-26 12:37:35',8,10),(39,1,'2024-04-26 12:37:36',8,10),(40,1,'2024-04-26 12:37:36',6,8),(41,1,'2024-04-26 12:37:37',5,6),(42,1,'2024-04-26 12:37:39',8,9),(43,1,'2024-04-26 12:47:31',5,7),(44,1,'2024-04-26 12:54:01',1,2),(45,1,'2024-04-26 12:54:01',3,10),(46,1,'2024-04-26 12:54:01',1,3),(47,1,'2024-04-26 12:54:04',3,2),(48,1,'2024-04-26 12:54:05',2,4),(49,1,'2024-04-26 12:54:07',1,2),(50,1,'2024-04-26 12:54:08',2,4),(51,1,'2024-04-26 18:01:32',8,10),(52,1,'2024-04-26 18:01:37',8,10),(53,1,'2024-04-26 18:01:53',1,2),(54,1,'2024-04-26 18:01:53',1,3);
/*!40000 ALTER TABLE `MedicoesPassagens` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BeforeInsert_MouseMovement` BEFORE INSERT ON `MedicoesPassagens` FOR EACH ROW BEGIN	
	DECLARE originalValue INT;
    
    IF NEW.sala_origem = 1 THEN
    	SELECT sala_0 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 2 THEN
    	SELECT sala_1 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 3 THEN
    	SELECT sala_2 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 4 THEN
    	SELECT sala_3 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 5 THEN
    	SELECT sala_4 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 6 THEN
    	SELECT sala_5 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 7 THEN
    	SELECT sala_6 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 8 THEN
    	SELECT sala_7 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 9 THEN
    	SELECT sala_8 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 10 THEN
    	SELECT sala_9 into originalValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSE
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Room.';
	END IF;
    
    IF originalValue = 0 THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid movement, room already at 0 mouses';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `AfterInsert_MouseMovement` AFTER INSERT ON `MedicoesPassagens` FOR EACH ROW BEGIN	
	DECLARE finalMouseValue INT;
    DECLARE maxMouseValue INT;
    
    IF NEW.sala_destino = 1 THEN
    	SELECT sala_0 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 2 THEN
    	SELECT sala_1 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 3 THEN
    	SELECT sala_2 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 4 THEN
    	SELECT sala_3 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 5 THEN
    	SELECT sala_4 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 6 THEN
    	SELECT sala_5 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 7 THEN
    	SELECT sala_6 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 8 THEN
    	SELECT sala_7 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 9 THEN
    	SELECT sala_8 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 10 THEN
    	SELECT sala_9 into finalMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSE
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Room.';
	END IF;
    
    SELECT limite_ratos_sala INTO maxMouseValue FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    
    IF finalMouseValue >= maxMouseValue THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid movement, room already at 0 mouses';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `MedicoesSalas`
--

DROP TABLE IF EXISTS `MedicoesSalas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MedicoesSalas` (
  `id_experiencia` int(11) NOT NULL,
  `sala_0` int(11) NOT NULL,
  `sala_1` int(11) NOT NULL,
  `sala_2` int(11) NOT NULL,
  `sala_3` int(11) NOT NULL,
  `sala_4` int(11) NOT NULL,
  `sala_5` int(11) NOT NULL,
  `sala_6` int(11) NOT NULL,
  `sala_7` int(11) NOT NULL,
  `sala_8` int(11) NOT NULL,
  `sala_9` int(11) NOT NULL,
  PRIMARY KEY (`id_experiencia`),
  CONSTRAINT `medicoes_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesSalas`
--

LOCK TABLES `MedicoesSalas` WRITE;
/*!40000 ALTER TABLE `MedicoesSalas` DISABLE KEYS */;
/*!40000 ALTER TABLE `MedicoesSalas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MedicoesTemperatura`
--

DROP TABLE IF EXISTS `MedicoesTemperatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MedicoesTemperatura` (
  `id_medicao` int(11) NOT NULL AUTO_INCREMENT,
  `id_experiencia` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `leitura` decimal(4,2) NOT NULL,
  `sensor` int(11) NOT NULL,
  PRIMARY KEY (`id_medicao`),
  KEY `med_temperatura_exp` (`id_experiencia`),
  CONSTRAINT `med_temperatura_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesTemperatura`
--

LOCK TABLES `MedicoesTemperatura` WRITE;
/*!40000 ALTER TABLE `MedicoesTemperatura` DISABLE KEYS */;
INSERT INTO `MedicoesTemperatura` VALUES (92,1,'2024-04-26 12:37:35',14.00,1),(93,1,'2024-04-26 12:37:36',14.00,1),(94,1,'2024-04-26 12:37:37',14.00,1),(95,1,'2024-04-26 12:37:38',13.70,1),(96,1,'2024-04-26 12:37:39',13.40,1),(97,1,'2024-04-26 12:37:40',13.10,1),(98,1,'2024-04-26 12:37:35',12.20,2),(99,1,'2024-04-26 12:37:36',12.20,2),(100,1,'2024-04-26 12:37:38',12.20,2),(101,1,'2024-04-26 12:37:39',12.20,2),(102,1,'2024-04-26 12:37:41',12.20,2),(103,1,'2024-04-26 12:37:41',12.80,1),(104,1,'2024-04-26 12:37:42',12.50,1),(105,1,'2024-04-26 12:37:43',12.20,1),(106,1,'2024-04-26 12:37:43',12.20,2),(107,1,'2024-04-26 12:47:29',11.00,1),(108,1,'2024-04-26 12:47:29',11.60,2),(109,1,'2024-04-26 12:47:30',11.00,1),(110,1,'2024-04-26 12:47:30',11.60,2),(111,1,'2024-04-26 12:47:31',11.00,1),(112,1,'2024-04-26 12:47:31',11.60,2),(113,1,'2024-04-26 12:47:32',11.00,1),(114,1,'2024-04-26 12:47:33',11.00,1),(115,1,'2024-04-26 12:47:33',11.60,2),(116,1,'2024-04-26 12:47:34',11.00,1),(117,1,'2024-04-26 12:53:27',5.00,1),(118,1,'2024-04-26 12:54:00',5.30,1),(119,1,'2024-04-26 12:54:01',5.60,1),(120,1,'2024-04-26 12:54:02',5.90,1),(121,1,'2024-04-26 12:54:03',6.20,1),(122,1,'2024-04-26 12:54:04',6.50,1),(123,1,'2024-04-26 12:54:05',6.80,1),(124,1,'2024-04-26 12:54:06',7.10,1),(125,1,'2024-04-26 12:53:27',14.00,2),(126,1,'2024-04-26 12:54:00',14.00,2),(127,1,'2024-04-26 12:54:01',14.00,2),(128,1,'2024-04-26 12:54:03',14.00,2),(129,1,'2024-04-26 12:54:05',14.00,2),(130,1,'2024-04-26 12:54:06',14.00,2),(131,1,'2024-04-26 12:54:07',14.00,2),(132,1,'2024-04-26 12:54:07',7.40,1),(133,1,'2024-04-26 12:54:08',7.70,1),(134,1,'2024-04-26 12:54:09',8.00,1),(135,1,'2024-04-26 12:54:08',14.00,2),(136,1,'2024-04-26 12:54:09',14.00,2),(137,1,'2024-04-26 12:54:10',8.00,1),(138,1,'2024-04-26 12:54:11',8.00,1),(139,1,'2024-04-26 17:46:50',14.00,2),(140,1,'2024-04-26 17:46:50',14.00,2),(141,1,'2024-04-26 17:46:50',14.00,2),(142,1,'2024-04-26 17:46:50',14.00,2),(143,1,'2024-04-26 17:46:50',14.00,2),(144,1,'2024-04-26 17:46:50',14.00,2),(145,1,'2024-04-26 17:46:50',14.00,2),(146,1,'2024-04-26 17:46:50',14.00,2),(147,1,'2024-04-26 17:46:50',14.00,2),(148,1,'2024-04-26 17:46:50',14.00,2),(149,1,'2024-04-26 17:46:50',14.00,2),(150,1,'2024-04-26 17:46:50',14.00,2),(151,1,'2024-04-26 17:46:50',14.00,2),(152,1,'2024-04-26 17:46:50',14.00,2),(153,1,'2024-04-26 17:46:50',14.00,2),(154,1,'2024-04-26 17:46:50',14.00,2),(155,1,'2024-04-26 17:46:50',14.00,2),(156,1,'2024-04-26 17:46:50',14.00,2),(157,1,'2024-04-26 17:46:50',14.00,2),(158,1,'2024-04-26 17:46:50',14.00,2),(159,1,'2024-04-26 17:46:50',14.00,2),(160,1,'2024-04-26 17:46:50',14.00,2),(161,1,'2024-04-26 17:46:50',14.00,2),(162,1,'2024-04-26 17:46:50',14.00,2),(163,1,'2024-04-26 17:46:50',14.00,2),(164,1,'2024-04-26 17:46:50',14.00,2),(165,1,'2024-04-26 17:46:50',14.00,2),(166,1,'2024-04-26 17:46:50',14.00,2),(167,1,'2024-04-26 17:46:50',14.00,2),(168,1,'2024-04-26 17:46:50',14.00,2),(169,1,'2024-04-26 17:46:50',14.00,2),(170,1,'2024-04-26 17:46:50',14.00,2),(171,1,'2024-04-26 17:46:50',14.00,2),(172,1,'2024-04-26 17:46:50',14.00,2),(173,1,'2024-04-26 17:46:50',14.00,2),(174,1,'2024-04-26 17:46:50',14.00,2),(175,1,'2024-04-26 17:46:50',14.00,2),(176,1,'2024-04-26 17:46:50',14.00,2),(177,1,'2024-04-26 17:46:50',14.00,2),(178,1,'2024-04-26 17:46:50',14.00,2),(179,1,'2024-04-26 17:46:50',14.00,2),(180,1,'2024-04-26 17:46:50',14.00,2),(181,1,'2024-04-26 17:46:50',14.00,2),(182,1,'2024-04-26 17:46:50',14.00,2),(183,1,'2024-04-26 17:46:50',14.00,2),(184,1,'2024-04-26 17:46:50',14.00,2),(185,1,'2024-04-26 17:46:50',14.00,2),(186,1,'2024-04-26 17:46:50',14.00,2),(187,1,'2024-04-26 17:46:50',14.00,2),(188,1,'2024-04-26 17:46:50',14.00,2),(189,1,'2024-04-26 17:46:50',14.00,2),(190,1,'2024-04-26 17:46:50',14.00,2),(191,1,'2024-04-26 17:46:50',14.00,2),(192,1,'2024-04-26 17:46:50',14.00,2),(193,1,'2024-04-26 17:46:50',14.00,2),(194,1,'2024-04-26 17:46:50',14.00,2),(195,1,'2024-04-26 17:46:50',14.00,2),(196,1,'2024-04-26 18:01:27',11.60,1),(197,1,'2024-04-26 18:01:27',14.00,2),(198,1,'2024-04-26 18:01:28',11.30,1),(199,1,'2024-04-26 18:01:28',14.00,2),(200,1,'2024-04-26 18:01:29',11.00,1),(201,1,'2024-04-26 18:01:30',11.00,1),(202,1,'2024-04-26 18:01:30',14.00,2),(203,1,'2024-04-26 18:01:31',11.00,1),(204,1,'2024-04-26 18:01:32',11.00,1),(205,1,'2024-04-26 18:01:32',14.00,2),(206,1,'2024-04-26 18:01:33',11.00,1),(207,1,'2024-04-26 18:01:33',14.00,2),(208,1,'2024-04-26 18:01:34',11.00,1),(209,1,'2024-04-26 18:01:34',14.00,2),(210,1,'2024-04-26 18:01:35',11.00,1),(211,1,'2024-04-26 18:01:36',11.00,1),(212,1,'2024-04-26 18:01:36',14.00,2),(213,1,'2024-04-26 18:01:37',11.00,1),(214,1,'2024-04-26 18:01:38',11.00,1),(215,1,'2024-04-26 18:01:39',11.00,1),(216,1,'2024-04-26 18:01:40',11.30,1),(217,1,'2024-04-26 18:01:40',14.00,2),(218,1,'2024-04-26 18:01:41',11.60,1),(219,1,'2024-04-26 18:01:41',14.00,2),(220,1,'2024-04-26 18:01:42',11.90,1),(221,1,'2024-04-26 18:01:42',14.00,2),(222,1,'2024-04-26 18:01:43',12.20,1),(223,1,'2024-04-26 18:01:44',12.50,1),(224,1,'2024-04-26 18:01:44',14.00,2),(225,1,'2024-04-26 18:01:45',12.80,1),(226,1,'2024-04-26 18:01:46',13.10,1),(227,1,'2024-04-26 18:01:47',13.40,1),(228,1,'2024-04-26 18:01:47',14.00,2),(229,1,'2024-04-26 18:01:48',13.70,1),(230,1,'2024-04-26 18:01:48',14.00,2),(231,1,'2024-04-26 18:01:49',14.00,1),(232,1,'2024-04-26 18:01:49',14.00,2),(233,1,'2024-04-26 18:01:50',14.00,1),(234,1,'2024-04-26 18:01:50',14.00,2),(235,1,'2024-04-26 18:01:51',14.00,1),(236,1,'2024-04-26 18:01:51',14.00,2),(237,1,'2024-04-26 18:01:52',14.00,1),(238,1,'2024-04-26 18:01:52',14.00,2),(239,1,'2024-04-26 18:01:53',14.00,1),(240,1,'2024-04-26 18:01:54',14.00,1),(241,1,'2024-04-26 18:01:55',14.00,1);
/*!40000 ALTER TABLE `MedicoesTemperatura` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `AfterInsert_TemperatureReading` AFTER INSERT ON `MedicoesTemperatura` FOR EACH ROW BEGIN

	DECLARE average_temp INT;
    DECLARE base_temp INT;
    DECLARE max_deviation INT;
    
    DECLARE running_time INT;
    
    SELECT GetAverageTemperature() INTO average_temp;
    SELECT temperatura_ideal INTO base_temp FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    SELECT variacao_temperatura_maxima INTO max_deviation FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    
    SELECT GetRunningTime() INTO running_time;
    

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Utilizador`
--

DROP TABLE IF EXISTS `Utilizador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Utilizador` (
  `email` varchar(50) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(12) NOT NULL,
  `tipo` enum('Investigador','Administrador') NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utilizador`
--

LOCK TABLES `Utilizador` WRITE;
/*!40000 ALTER TABLE `Utilizador` DISABLE KEYS */;
INSERT INTO `Utilizador` VALUES ('rmnto@iscte-iul.pt','Rodrigo Timoteo','123456789','Investigador');
/*!40000 ALTER TABLE `Utilizador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'PISID'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetAverageTemperature` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAverageTemperature`() RETURNS decimal(4,2)
BEGIN
	DECLARE averageTemperature DECIMAL(4,2);
    
    SELECT AVG(leitura) INTO averageTemperature
    FROM (
        SELECT leitura
        FROM MedicoesTemperatura
        ORDER BY hora DESC
        LIMIT 10
    ) AS last_ten_entries;
    
    RETURN averageTemperature;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetRunningTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetRunningTest`() RETURNS int(11)
BEGIN
    DECLARE experience_id INT;
    
    SELECT id_experiencia INTO experience_id FROM Experiencia WHERE estado_experiencia = "A decorrer";
    
    RETURN experience_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetRunningTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetRunningTime`() RETURNS int(11)
BEGIN
	DECLARE elapsedSeconds INT DEFAULT 0;
    DECLARE testCount INT;
    DECLARE testId INT;
    DECLARE startTime TIMESTAMP;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE estado_experiencia = "A decorrer";
  
	IF testCount > 0 THEN
    	SELECT id_experiencia INTO testId FROM Experiencia WHERE estado_experiencia = "A decorrer" LIMIT 1;
        SELECT data_hora_inicio INTO startTime FROM Experiencia WHERE id_experiencia = testId;

    	SET elapsedSeconds = TIMESTAMPDIFF(SECOND, startTime, CURRENT_TIMESTAMP);
        
    END IF;
    
    RETURN elapsedSeconds;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssignInvestigator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignInvestigator`(IN `investigador_email` INT, IN `test_id` INT)
BEGIN
    DECLARE testCount INT;
    DECLARE userCount INT;

    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
	SELECT COUNT(*) INTO userCount FROM Utilizador WHERE email = investigador_email;

    IF testCount > 0 THEN
    	
        IF userCount > 0 THEN
    		UPDATE Experiencia SET investigador = investigador_email WHERE id_experiencia = test_id;
        	SELECT CONCAT('Test with ID ', test_id, ' has been updated and attributed user with email .', investigador_email) AS 'Message';
        ELSE
        	SELECT 'User not found.' AS 'Message';
        END IF;
    ELSE
        SELECT 'Test not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateExpSubstance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateExpSubstance`(IN `test_id` INT, IN `test_substance` VARCHAR(20), IN `test_num_ratos_administrada` INT)
BEGIN

	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
		INSERT INTO ExperienciaSubstancia (id_experiencia, substancia, num_ratos_administrada)
   		VALUES (test_id, test_substance, test_num_ratos_administrada);
	END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewUser`(IN `user_email` VARCHAR(50), IN `user_password` VARCHAR(255), IN `user_nome` VARCHAR(100), IN `user_telemovel` VARCHAR(12))
BEGIN
	INSERT INTO Utilizador (email, nome, telefone, tipo)
    VALUES (user_email, user_nome, user_telemovel, "Investigador");
    
    CALL mysql.CreateNewUser(user_email, user_password);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteExpSubstance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteExpSubstance`(IN `substance_id` INT)
BEGIN
	DECLARE substanceCount INT;
    
    SELECT COUNT(*) INTO substanceCount FROM Experiencia WHERE id_substancia_exp = substance_id;
    
    IF substanceCount > 0 THEN
    	DELETE FROM ExperienciaSubstancia WHERE id_substancia_exp = substance_id;
        SELECT 'Substance has been deleted.' AS 'Message';
    ELSE
    	SELECT 'Substance not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTest`(IN `delete_id_exp` INT)
BEGIN
	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = delete_id_exp;
    
    IF testCount > 0 THEN
    	DELETE FROM Experiencia WHERE id_experiencia = delete_id_exp;
        SELECT CONCAT('Test with ID ', delete_id_exp, ' has been deleted.') AS 'Message';
    ELSE
    	SELECT 'Test does not exist' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser`(IN `test_id` VARCHAR(50))
BEGIN
	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
    	DELETE FROM Experiencia WHERE id_experiencia = test_id;
        SELECT 'Test has been deleted.' AS 'Message';
    ELSE
    	SELECT 'Test not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EditExpSubstance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditExpSubstance`(IN `substance_id` INT, IN `test_substance` VARCHAR(20), IN `test_num_ratos_adm` INT)
BEGIN
	DECLARE substanceCount INT;
    
    SELECT COUNT(*) INTO substanceCount FROM ExperienciaSubstancia WHERE id_substancia_exp = substance_id;
    
    IF substanceCount > 0 THEN
        UPDATE ExperienciaSubstancia SET substancia = test_substance, num_ratos_administrada = test_num_ratos_adm WHERE email = userEmail;
        SELECT 'Substance has been updated.' AS 'Message';
    ELSE
        SELECT 'Substance not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EditTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditTest`(IN `test_description` TEXT, IN `test_number_of_rats` INT, IN `test_limit_per_room` INT, IN `test_id` INT, IN `test_seconds_without_movement` INT, IN `test_ideal_temperature` INT, IN `test_max_temp_deviation` INT)
BEGIN
	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
        UPDATE Experiencia SET data_hora_ult_edicao = CURRENT_TIMESTAMP, descricao = test_description, limite_ratos_sala = test_limit_per_room, numero_ratos = test_number_of_rats, segundos_sem_movimento = test_seconds_without_movement, temperatura_ideal = test_ideal_temperature, variacao_temperatura = test_max_temp_deviation WHERE id_experiencia = test_id;
        SELECT 'Test has been updated.' AS 'Message';
    ELSE
        SELECT 'Test not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EditUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EditUser`(IN `user_password` VARCHAR(255), IN `user_nome` VARCHAR(100), IN `user_telefone` VARCHAR(12), IN `user_email` VARCHAR(50))
BEGIN
	DECLARE userCount INT;
    
    SELECT COUNT(*) INTO userCount FROM Utilizador WHERE email = userEmail;
    
    IF userCount > 0 THEN
        UPDATE Utilizador SET name = user_nome, telefone = user_telefone, password = user_password WHERE email = userEmail;
        SELECT CONCAT('User with email ', userEmail, ' has been updated.') AS 'Message';
    ELSE
        SELECT 'User not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FinishTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FinishTest`(IN `test_id` INT)
BEGIN
	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
        UPDATE Experiencia SET estado_experiencia = "Terminada" WHERE id_experiencia = test_id;
        SELECT CONCAT('Ended test with ID ', test_id) AS 'Message';
    ELSE
        SELECT 'Test not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertNewAlert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertNewAlert`(IN `test_id` INT, IN `test_reading` INT, IN `test_message` VARCHAR(100), IN `test_room` INT, IN `test_sensor` INT, IN `alert_type` VARCHAR(20))
BEGIN

	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
		INSERT INTO Alerta (id_experiencia, hora, leitura, mensagem, sala, sensor, tipo_alerta)
   		VALUES (test_id, CURRENT_TIMESTAMP, test_reading, test_message, test_room, test_sensor, alert_type);
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertNewMedicaoPassagem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertNewMedicaoPassagem`(IN `new_hora` TIMESTAMP, IN `new_sala_origem` INT, IN `new_sala_destino` INT)
BEGIN
    DECLARE testId INT;

    SELECT GetRunningTest() INTO testId;

	INSERT INTO MedicoesPassagens (hora, id_experiencia, sala_origem, sala_destino)
   	VALUES (new_hora, testId, new_sala_origem, new_sala_destino);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertNewMedicaoTemperatura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertNewMedicaoTemperatura`(IN `new_hora` TIMESTAMP, IN `new_leitura` DECIMAL(4,2), IN `new_sensor` INT)
BEGIN
	DECLARE testId INT;

    SELECT GetRunningTest() INTO testId;

	INSERT INTO MedicoesTemperatura (hora, id_experiencia, leitura, sensor)
    VALUES (new_hora, testId, new_leitura, new_sensor);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertNewTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertNewTest`(IN `test_description` TEXT, IN `test_number_of_rats` INT, IN `test_limit_per_room` INT, IN `test_time_without_movement` INT, IN `test_ideal_temperature` INT, IN `test_max_temperature_deviation` INT, IN `test_investigador` VARCHAR(50))
BEGIN
    INSERT INTO experiencia (descricao, estado_experiencia, numero_ratos, limite_ratos_sala, segundos_sem_movimento, temperatura_ideal, variacao_temperatura_maxima, investigador, data_hora_criacao)
    VALUES (test_description, "Por Iniciar", test_number_of_rats, test_limit_per_room, test_time_without_movement, test_ideal_temperature, test_max_temperature_deviation, test_investigador, CURRENT_TIMESTAMP);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StartTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StartTest`(IN `test_id` INT)
BEGIN
	DECLARE testCount INT;
    
    SELECT COUNT(*) INTO testCount FROM Experiencia WHERE id_experiencia = test_id;
    
    IF testCount > 0 THEN
        UPDATE Experiencia SET estado_experiencia = "A decorrer" WHERE id_experiencia = test_id;
        SELECT CONCAT('Started test with ID ', test_id) AS 'Message';
    ELSE
        SELECT 'Test not found.' AS 'Message';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-29 14:49:15
