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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alerta`
--

LOCK TABLES `Alerta` WRITE;
/*!40000 ALTER TABLE `Alerta` DISABLE KEYS */;
INSERT INTO `Alerta` VALUES (1,1,'2024-05-02 10:11:04',NULL,1,25.00,'TemperaturaDesvioExcedido','Desvio Maximo Excedido. Terminar Experiencia!'),(2,11,'2024-05-05 17:10:48',NULL,NULL,NULL,'TemperaturaDesvioExcedido',NULL);
/*!40000 ALTER TABLE `Alerta` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BeforeInsert_NewAlert` BEFORE INSERT ON `Alerta` FOR EACH ROW BEGIN 
	DECLARE last_alert_time TIMESTAMP;

    SELECT MAX(Alerta.hora) INTO last_alert_time FROM Alerta WHERE tipo_alerta = NEW.tipo_alerta AND id_experiencia = NEW.id_experiencia;

	IF last_alert_time IS NOT NULL AND TIMESTAMPDIFF(SECOND, last_alert_time, NEW.hora) < 30 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alerta Spam';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Experiencia`
--

LOCK TABLES `Experiencia` WRITE;
/*!40000 ALTER TABLE `Experiencia` DISABLE KEYS */;
INSERT INTO `Experiencia` VALUES (1,'TestExp','Terminada','rmnto@iscte-iul.pt','2024-04-25 17:27:11','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,30,10.00,20.00,NULL),(6,'Teste Numero 2','Terminada','rmnto@iscte-iul.pt','2024-05-03 15:11:39','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,50.00,NULL),(7,'Teste 3','Terminada','rmnto@iscte-iul.pt','2024-05-03 15:19:35','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,10,10.00,50.00,NULL),(11,'Experiencia 11','Terminada','computadorGestor','2024-05-05 16:08:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(12,'Experiencia 12','Terminada','computadorGestor','2024-05-05 16:09:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(13,'Experiencia 13','Terminada','computadorGestor','2024-05-05 16:12:02','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(14,'Experiencia 14','Terminada','computadorGestor','2024-05-05 16:14:30','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(15,'Experiencia 15','Terminada','computadorGestor','2024-05-05 16:15:15','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(20,'Experiencia 16','Por Iniciar','computadorGestor','2024-05-05 16:31:19','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(21,'Experiencia 21','Por Iniciar','computadorGestor','2024-05-05 16:31:19','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(22,'Experiencia 22','Por Iniciar','computadorGestor','2024-05-05 16:31:20','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(23,'Experiencia 23','Por Iniciar','computadorGestor','2024-05-05 16:31:20','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(24,'Experiencia 24','Por Iniciar','computadorGestor','2024-05-05 16:31:21','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(25,'Experiencia 25','Por Iniciar','computadorGestor','2024-05-05 16:31:21','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(26,'Experiencia 26','Por Iniciar','computadorGestor','2024-05-05 16:31:21','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(27,'Experiencia 27','Por Iniciar','computadorGestor','2024-05-05 16:31:21','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(28,'Experiencia 28','Por Iniciar','computadorGestor','2024-05-05 16:31:22','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(29,'Experiencia 29','Por Iniciar','computadorGestor','2024-05-05 16:31:22','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(30,'Experiencia 30','Por Iniciar','computadorGestor','2024-05-05 16:31:22','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(31,'Experiencia 31','Por Iniciar','computadorGestor','2024-05-05 16:31:23','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(32,'Experiencia 32','Por Iniciar','computadorGestor','2024-05-05 16:31:24','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(33,'Experiencia 33','Por Iniciar','computadorGestor','2024-05-05 16:31:24','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(34,'Experiencia 34','Por Iniciar','computadorGestor','2024-05-05 16:31:24','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(35,'Experiencia 35','Por Iniciar','computadorGestor','2024-05-05 16:31:24','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(36,'Experiencia 36','Por Iniciar','computadorGestor','2024-05-05 16:31:26','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(37,'Experiencia 37','Por Iniciar','computadorGestor','2024-05-05 16:31:26','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(38,'Experiencia 38','Por Iniciar','computadorGestor','2024-05-05 16:31:26','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(39,'Experiencia 39','Por Iniciar','computadorGestor','2024-05-05 16:31:27','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(40,'Experiencia 40','Por Iniciar','computadorGestor','2024-05-05 16:31:27','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(41,'Experiencia 41','Por Iniciar','computadorGestor','2024-05-05 16:31:27','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(42,'Experiencia 42','Por Iniciar','computadorGestor','2024-05-05 16:31:28','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(43,'Experiencia 43','Por Iniciar','computadorGestor','2024-05-05 16:31:30','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(44,'Experiencia 44','Por Iniciar','computadorGestor','2024-05-05 16:31:30','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(45,'Experiencia 45','Por Iniciar','computadorGestor','2024-05-05 16:31:30','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(46,'Experiencia 46','Por Iniciar','computadorGestor','2024-05-05 16:31:31','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(47,'Experiencia 47','Por Iniciar','computadorGestor','2024-05-05 16:31:31','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(48,'Experiencia 48','Por Iniciar','computadorGestor','2024-05-05 16:31:31','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(49,'Experiencia 49','Por Iniciar','computadorGestor','2024-05-05 16:31:32','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(50,'Experiencia 50','Por Iniciar','computadorGestor','2024-05-05 16:31:32','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(51,'Experiencia 51','Por Iniciar','computadorGestor','2024-05-05 16:31:33','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(52,'Experiencia 52','Por Iniciar','computadorGestor','2024-05-05 16:31:34','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(53,'Experiencia 53','Por Iniciar','computadorGestor','2024-05-05 16:31:34','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(54,'Experiencia 54','Por Iniciar','computadorGestor','2024-05-05 16:31:34','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(55,'Experiencia 55','Por Iniciar','computadorGestor','2024-05-05 16:31:34','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(56,'Experiencia 56','Por Iniciar','computadorGestor','2024-05-05 16:31:35','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(57,'Experiencia 57','Por Iniciar','computadorGestor','2024-05-05 16:31:35','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(58,'Experiencia 58','Por Iniciar','computadorGestor','2024-05-05 16:31:35','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(59,'Experiencia 59','Por Iniciar','computadorGestor','2024-05-05 16:31:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(60,'Experiencia 60','Por Iniciar','computadorGestor','2024-05-05 16:31:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(61,'Experiencia 61','Por Iniciar','computadorGestor','2024-05-05 16:31:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(62,'Experiencia 62','Por Iniciar','computadorGestor','2024-05-05 16:31:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(63,'Experiencia 63','Por Iniciar','computadorGestor','2024-05-05 16:31:37','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(64,'Experiencia 64','Por Iniciar','computadorGestor','2024-05-05 16:31:50','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(65,'Experiencia 65','Por Iniciar','computadorGestor','2024-05-05 16:34:06','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(66,'Experiencia 65','Terminada','computadorGestor','2024-05-05 16:36:39','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(67,'Experiencia 66','Por Iniciar','computadorGestor','2024-05-05 16:38:23','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(68,'Experiencia 66','Por Iniciar','computadorGestor','2024-05-05 16:40:41','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(69,'Experiencia 68','Terminada','computadorGestor','2024-05-05 16:42:58','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(70,'Experiencia 69','Terminada','computadorGestor','2024-05-05 16:45:28','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(71,'Experiencia 70','Terminada','computadorGestor','2024-05-05 16:46:18','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(72,'Experiencia 71','Terminada','computadorGestor','2024-05-05 16:48:50','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(73,'Experiencia 72','Terminada','computadorGestor','2024-05-05 16:51:23','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(74,'Experiencia 73','Terminada','computadorGestor','2024-05-05 16:53:57','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(75,'Experiencia 74','Terminada','computadorGestor','2024-05-05 16:56:17','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(76,'Experiencia 75','Terminada','computadorGestor','2024-05-05 17:14:34','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL),(77,'Experiencia 76','A decorrer','computadorGestor','2024-05-05 17:15:59','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',5,5,15,10.00,20.00,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=763 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesPassagens`
--

LOCK TABLES `MedicoesPassagens` WRITE;
/*!40000 ALTER TABLE `MedicoesPassagens` DISABLE KEYS */;
INSERT INTO `MedicoesPassagens` VALUES (1,1,'2024-05-02 14:50:54',1,2),(288,1,'2024-05-02 17:45:05',1,2),(289,1,'2024-05-02 17:45:08',1,2),(290,1,'2024-05-02 17:45:09',2,4),(291,1,'2024-05-02 17:45:25',1,2),(292,1,'2024-05-02 17:45:34',1,2),(293,1,'2024-05-02 17:45:38',2,4),(294,1,'2024-05-02 17:45:44',2,5),(295,1,'2024-05-02 17:45:47',4,5),(296,1,'2024-05-02 17:45:47',2,5),(297,1,'2024-05-02 17:45:48',2,4),(298,6,'2024-05-03 15:14:29',1,2),(299,6,'2024-05-03 15:14:35',1,2),(300,6,'2024-05-03 15:14:36',2,4),(301,6,'2024-05-03 15:14:36',2,5),(302,6,'2024-05-03 15:15:08',4,5),(303,6,'2024-05-03 15:16:14',5,7),(304,6,'2024-05-03 15:16:29',7,5),(305,7,'2024-05-03 16:05:52',1,2),(306,7,'2024-05-03 16:05:59',2,4),(307,7,'2024-05-03 16:06:07',4,5),(308,7,'2024-05-03 16:06:21',5,6),(309,7,'2024-05-03 16:06:28',6,8),(310,7,'2024-05-03 16:06:43',8,10),(311,7,'2024-05-03 16:08:29',1,2),(312,7,'2024-05-03 16:08:32',1,2),(313,7,'2024-05-03 16:08:35',1,2),(314,7,'2024-05-03 16:08:38',1,2),(315,7,'2024-05-03 16:08:42',2,5),(316,7,'2024-05-03 16:08:42',2,4),(317,7,'2024-05-03 16:08:48',2,5),(318,7,'2024-05-03 16:08:50',4,5),(319,7,'2024-05-03 16:08:51',2,5),(320,7,'2024-05-03 16:08:53',5,7),(321,7,'2024-05-03 16:08:58',5,6),(322,7,'2024-05-03 16:09:05',6,8),(323,7,'2024-05-03 16:09:08',7,5),(324,7,'2024-05-03 16:09:18',5,6),(325,7,'2024-05-03 16:09:26',6,8),(326,7,'2024-05-03 16:10:10',5,6),(327,7,'2024-05-03 16:10:17',5,6),(328,7,'2024-05-03 16:10:17',6,8),(329,7,'2024-05-03 16:10:20',8,9),(330,7,'2024-05-03 16:10:24',6,8),(331,7,'2024-05-03 16:10:27',8,9),(332,7,'2024-05-03 16:11:25',8,10),(333,7,'2024-05-03 16:11:29',8,9),(334,11,'2024-05-05 16:08:39',1,2),(335,11,'2024-05-05 16:08:42',1,2),(336,11,'2024-05-05 16:08:42',1,3),(337,11,'2024-05-05 16:08:45',1,3),(338,11,'2024-05-05 16:08:45',3,2),(339,11,'2024-05-05 16:08:52',2,5),(340,11,'2024-05-05 16:08:55',2,5),(341,11,'2024-05-05 16:08:58',2,5),(342,11,'2024-05-05 16:09:02',5,6),(343,11,'2024-05-05 16:09:05',5,6),(344,11,'2024-05-05 16:09:08',5,6),(345,11,'2024-05-05 16:09:09',6,8),(346,11,'2024-05-05 16:09:24',8,10),(347,12,'2024-05-05 16:09:40',1,2),(348,12,'2024-05-05 16:09:43',1,2),(349,12,'2024-05-05 16:09:46',1,2),(350,12,'2024-05-05 16:09:49',1,2),(351,12,'2024-05-05 16:09:50',2,4),(352,12,'2024-05-05 16:09:52',1,2),(353,12,'2024-05-05 16:09:53',2,4),(354,12,'2024-05-05 16:09:58',4,5),(355,12,'2024-05-05 16:09:59',2,4),(356,12,'2024-05-05 16:10:01',4,5),(357,12,'2024-05-05 16:10:02',5,7),(358,12,'2024-05-05 16:10:07',4,5),(359,12,'2024-05-05 16:10:10',5,7),(360,12,'2024-05-05 16:10:11',5,3),(361,12,'2024-05-05 16:10:15',3,2),(362,12,'2024-05-05 16:10:17',7,5),(363,12,'2024-05-05 16:10:20',5,7),(364,12,'2024-05-05 16:10:26',7,5),(365,12,'2024-05-05 16:10:28',2,5),(366,12,'2024-05-05 16:10:31',5,7),(367,12,'2024-05-05 16:10:35',7,5),(368,12,'2024-05-05 16:10:36',5,3),(369,12,'2024-05-05 16:10:39',3,2),(370,12,'2024-05-05 16:10:45',5,3),(371,12,'2024-05-05 16:10:46',7,5),(372,12,'2024-05-05 16:10:48',3,2),(373,12,'2024-05-05 16:10:49',2,4),(374,12,'2024-05-05 16:10:56',5,6),(375,12,'2024-05-05 16:10:57',4,5),(376,12,'2024-05-05 16:10:58',2,4),(377,12,'2024-05-05 16:11:00',5,7),(378,12,'2024-05-05 16:11:03',6,8),(379,12,'2024-05-05 16:11:06',8,9),(380,12,'2024-05-05 16:11:06',4,5),(381,12,'2024-05-05 16:11:09',5,7),(382,12,'2024-05-05 16:11:15',7,5),(383,12,'2024-05-05 16:11:18',5,7),(384,12,'2024-05-05 16:11:24',7,5),(385,12,'2024-05-05 16:11:33',7,5),(386,12,'2024-05-05 16:11:34',5,6),(387,12,'2024-05-05 16:11:41',6,8),(388,12,'2024-05-05 16:11:43',5,6),(389,12,'2024-05-05 16:11:51',6,8),(390,13,'2024-05-05 16:12:07',1,2),(391,13,'2024-05-05 16:12:10',1,2),(392,13,'2024-05-05 16:12:10',1,3),(393,13,'2024-05-05 16:12:13',3,2),(394,13,'2024-05-05 16:12:16',1,2),(396,13,'2024-05-05 16:12:20',2,5),(397,13,'2024-05-05 16:12:20',2,4),(398,13,'2024-05-05 16:12:23',2,4),(399,13,'2024-05-05 16:12:28',4,5),(400,13,'2024-05-05 16:12:29',2,5),(401,13,'2024-05-05 16:12:31',4,5),(402,13,'2024-05-05 16:12:34',5,7),(403,13,'2024-05-05 16:12:38',5,3),(404,13,'2024-05-05 16:12:39',5,3),(405,13,'2024-05-05 16:12:41',3,2),(406,13,'2024-05-05 16:12:42',3,2),(407,13,'2024-05-05 16:12:49',7,5),(408,13,'2024-05-05 16:12:54',2,5),(409,13,'2024-05-05 16:12:55',2,5),(410,13,'2024-05-05 16:12:59',5,6),(411,13,'2024-05-05 16:13:04',5,3),(412,13,'2024-05-05 16:13:05',5,6),(413,13,'2024-05-05 16:13:06',6,8),(414,13,'2024-05-05 16:13:07',3,2),(415,13,'2024-05-05 16:13:09',8,9),(416,13,'2024-05-05 16:13:12',6,8),(417,13,'2024-05-05 16:13:15',8,9),(418,13,'2024-05-05 16:13:17',2,4),(419,13,'2024-05-05 16:13:25',4,5),(420,13,'2024-05-05 16:13:27',9,7),(421,13,'2024-05-05 16:13:28',5,7),(422,13,'2024-05-05 16:13:42',7,5),(423,13,'2024-05-05 16:13:44',7,5),(424,13,'2024-05-05 16:13:45',5,7),(425,13,'2024-05-05 16:13:54',5,6),(426,13,'2024-05-05 16:14:01',7,5),(427,13,'2024-05-05 16:14:01',6,8),(428,13,'2024-05-05 16:14:04',8,9),(429,13,'2024-05-05 16:14:11',5,6),(430,13,'2024-05-05 16:14:18',6,8),(431,14,'2024-05-05 16:14:31',1,3),(432,14,'2024-05-05 16:14:34',3,2),(433,14,'2024-05-05 16:14:34',1,3),(434,14,'2024-05-05 16:14:37',1,3),(435,14,'2024-05-05 16:14:37',3,2),(436,14,'2024-05-05 16:14:40',3,2),(437,14,'2024-05-05 16:14:43',1,2),(439,14,'2024-05-05 16:14:47',2,5),(440,14,'2024-05-05 16:14:50',2,5),(441,14,'2024-05-05 16:14:53',2,5),(442,14,'2024-05-05 16:14:53',5,7),(443,14,'2024-05-05 16:14:56',2,5),(444,14,'2024-05-05 16:14:57',5,6),(445,14,'2024-05-05 16:14:59',5,7),(446,14,'2024-05-05 16:15:03',5,6),(447,15,'2024-05-05 16:15:16',1,3),(448,15,'2024-05-05 16:15:19',3,2),(449,15,'2024-05-05 16:15:22',1,2),(450,15,'2024-05-05 16:15:22',1,3),(451,15,'2024-05-05 16:15:25',3,2),(452,15,'2024-05-05 16:15:28',1,2),(453,15,'2024-05-05 16:15:28',1,3),(454,15,'2024-05-05 16:15:29',2,4),(455,15,'2024-05-05 16:15:31',3,2),(456,15,'2024-05-05 16:15:35',2,4),(457,15,'2024-05-05 16:15:37',4,5),(458,15,'2024-05-05 16:15:43',4,5),(459,15,'2024-05-05 16:15:44',2,5),(460,15,'2024-05-05 16:15:47',5,3),(461,15,'2024-05-05 16:15:47',5,7),(462,15,'2024-05-05 16:15:50',3,2),(463,15,'2024-05-05 16:15:53',5,6),(464,15,'2024-05-05 16:16:00',6,8),(465,15,'2024-05-05 16:16:02',7,5),(466,15,'2024-05-05 16:16:03',8,9),(467,15,'2024-05-05 16:16:03',2,5),(468,15,'2024-05-05 16:16:05',5,7),(469,15,'2024-05-05 16:16:14',5,6),(470,15,'2024-05-05 16:16:21',7,5),(471,15,'2024-05-05 16:16:21',6,8),(472,15,'2024-05-05 16:16:24',8,9),(473,15,'2024-05-05 16:16:31',5,3),(474,15,'2024-05-05 16:16:34',3,2),(475,15,'2024-05-05 16:16:36',9,7),(476,15,'2024-05-05 16:16:47',2,5),(477,15,'2024-05-05 16:16:51',7,5),(478,15,'2024-05-05 16:16:54',5,7),(479,15,'2024-05-05 16:16:57',5,3),(480,15,'2024-05-05 16:17:00',3,2),(481,15,'2024-05-05 16:17:09',7,5),(482,15,'2024-05-05 16:17:13',2,5),(483,15,'2024-05-05 16:17:16',5,7),(484,15,'2024-05-05 16:17:19',5,6),(485,15,'2024-05-05 16:17:31',7,5),(504,66,'2024-05-05 16:36:43',1,2),(505,66,'2024-05-05 16:36:46',1,2),(506,66,'2024-05-05 16:36:46',1,3),(507,66,'2024-05-05 16:36:52',1,2),(508,66,'2024-05-05 16:36:52',1,3),(509,66,'2024-05-05 16:36:53',2,4),(510,66,'2024-05-05 16:36:56',2,4),(511,66,'2024-05-05 16:37:01',4,5),(512,66,'2024-05-05 16:37:02',2,4),(513,66,'2024-05-05 16:37:04',4,5),(514,66,'2024-05-05 16:37:04',5,7),(515,66,'2024-05-05 16:37:07',5,7),(516,66,'2024-05-05 16:37:20',7,5),(517,66,'2024-05-05 16:37:23',7,5),(518,66,'2024-05-05 16:37:30',5,3),(519,66,'2024-05-05 16:37:33',5,3),(520,66,'2024-05-05 16:37:33',3,2),(521,66,'2024-05-05 16:37:36',3,2),(522,66,'2024-05-05 16:37:46',2,5),(523,66,'2024-05-05 16:37:46',2,4),(524,66,'2024-05-05 16:37:54',4,5),(525,66,'2024-05-05 16:37:56',5,6),(526,66,'2024-05-05 16:38:03',6,8),(527,66,'2024-05-05 16:38:04',5,6),(528,66,'2024-05-05 16:38:06',8,9),(529,66,'2024-05-05 16:38:11',6,8),(530,66,'2024-05-05 16:38:30',3,2),(531,66,'2024-05-05 16:38:33',3,2),(532,66,'2024-05-05 16:38:37',2,4),(533,66,'2024-05-05 16:38:43',2,5),(534,66,'2024-05-05 16:38:45',4,5),(535,66,'2024-05-05 16:38:52',5,7),(536,66,'2024-05-05 16:38:53',5,6),(537,66,'2024-05-05 16:39:02',6,8),(538,66,'2024-05-05 16:39:06',8,9),(539,66,'2024-05-05 16:39:07',7,5),(540,66,'2024-05-05 16:39:11',5,7),(541,66,'2024-05-05 16:39:11',7,5),(542,66,'2024-05-05 16:39:15',5,7),(543,66,'2024-05-05 16:39:18',4,5),(544,66,'2024-05-05 16:39:18',9,7),(545,66,'2024-05-05 16:39:21',5,7),(546,66,'2024-05-05 16:39:26',7,5),(547,66,'2024-05-05 16:39:30',7,5),(548,66,'2024-05-05 16:39:33',7,5),(549,66,'2024-05-05 16:39:36',5,3),(550,66,'2024-05-05 16:39:36',5,7),(551,66,'2024-05-05 16:39:39',3,2),(552,66,'2024-05-05 16:39:40',5,6),(553,66,'2024-05-05 16:39:47',6,8),(554,66,'2024-05-05 16:39:49',2,4),(555,66,'2024-05-05 16:39:51',7,5),(556,66,'2024-05-05 16:39:57',4,5),(557,66,'2024-05-05 16:40:01',5,6),(558,66,'2024-05-05 16:40:02',8,10),(559,66,'2024-05-05 16:40:07',5,6),(560,66,'2024-05-05 16:40:08',6,8),(561,66,'2024-05-05 16:40:11',8,9),(562,66,'2024-05-05 16:40:14',6,8),(563,66,'2024-05-05 16:40:23',9,7),(564,66,'2024-05-05 16:40:29',8,10),(565,69,'2024-05-05 16:42:59',1,3),(566,69,'2024-05-05 16:43:02',3,2),(567,69,'2024-05-05 16:43:05',1,2),(568,69,'2024-05-05 16:43:08',1,2),(569,69,'2024-05-05 16:43:08',1,3),(570,69,'2024-05-05 16:43:11',3,2),(571,69,'2024-05-05 16:43:12',2,4),(572,69,'2024-05-05 16:43:14',1,2),(573,69,'2024-05-05 16:43:18',2,5),(574,69,'2024-05-05 16:43:20',4,5),(575,69,'2024-05-05 16:43:21',2,5),(576,69,'2024-05-05 16:43:21',2,4),(577,69,'2024-05-05 16:43:23',5,7),(578,69,'2024-05-05 16:43:24',2,4),(579,69,'2024-05-05 16:43:28',5,3),(580,69,'2024-05-05 16:43:29',4,5),(581,69,'2024-05-05 16:43:31',5,3),(582,69,'2024-05-05 16:43:31',3,2),(583,69,'2024-05-05 16:43:32',4,5),(584,69,'2024-05-05 16:43:34',3,2),(585,69,'2024-05-05 16:43:38',7,5),(586,69,'2024-05-05 16:43:39',5,6),(587,69,'2024-05-05 16:43:41',2,4),(588,69,'2024-05-05 16:43:42',5,3),(589,69,'2024-05-05 16:43:44',2,4),(590,69,'2024-05-05 16:43:45',3,2),(591,69,'2024-05-05 16:43:48',5,6),(592,69,'2024-05-05 16:43:49',4,5),(593,69,'2024-05-05 16:43:52',4,5),(594,69,'2024-05-05 16:43:52',5,7),(595,69,'2024-05-05 16:43:55',6,8),(596,69,'2024-05-05 16:43:58',2,5),(597,69,'2024-05-05 16:44:01',5,7),(598,69,'2024-05-05 16:44:02',5,3),(599,69,'2024-05-05 16:44:05',3,2),(600,69,'2024-05-05 16:44:07',7,5),(601,69,'2024-05-05 16:44:10',8,10),(602,69,'2024-05-05 16:44:15',2,4),(603,69,'2024-05-05 16:44:16',7,5),(604,69,'2024-05-05 16:44:17',5,3),(605,69,'2024-05-05 16:44:19',5,7),(606,69,'2024-05-05 16:44:20',3,2),(607,69,'2024-05-05 16:44:23',4,5),(608,69,'2024-05-05 16:44:33',5,6),(609,69,'2024-05-05 16:44:33',2,5),(610,69,'2024-05-05 16:44:34',7,5),(611,69,'2024-05-05 16:44:40',6,8),(612,69,'2024-05-05 16:44:43',5,6),(613,69,'2024-05-05 16:44:44',5,3),(614,69,'2024-05-05 16:44:48',3,2),(615,69,'2024-05-05 16:44:51',6,8),(616,69,'2024-05-05 16:44:56',8,10),(617,69,'2024-05-05 16:44:58',2,4),(618,69,'2024-05-05 16:45:06',8,10),(619,69,'2024-05-05 16:45:06',4,5),(620,69,'2024-05-05 16:45:16',5,6),(621,70,'2024-05-05 16:45:32',1,2),(622,70,'2024-05-05 16:45:35',1,2),(623,70,'2024-05-05 16:45:35',1,3),(624,70,'2024-05-05 16:45:38',3,2),(625,70,'2024-05-05 16:45:41',1,2),(627,70,'2024-05-05 16:45:48',2,4),(628,70,'2024-05-05 16:45:56',4,5),(629,70,'2024-05-05 16:46:06',5,6),(630,71,'2024-05-05 16:46:19',1,3),(631,71,'2024-05-05 16:46:22',3,2),(632,71,'2024-05-05 16:46:22',1,3),(633,71,'2024-05-05 16:46:25',3,2),(634,71,'2024-05-05 16:46:25',1,3),(635,71,'2024-05-05 16:46:28',3,2),(636,71,'2024-05-05 16:46:28',1,3),(637,71,'2024-05-05 16:46:31',3,2),(639,71,'2024-05-05 16:46:35',2,4),(640,71,'2024-05-05 16:46:36',2,5),(641,71,'2024-05-05 16:46:38',2,4),(642,71,'2024-05-05 16:46:43',4,5),(643,71,'2024-05-05 16:46:44',2,5),(644,71,'2024-05-05 16:46:46',4,5),(645,71,'2024-05-05 16:46:46',5,3),(646,71,'2024-05-05 16:46:49',3,2),(647,71,'2024-05-05 16:46:49',5,7),(648,71,'2024-05-05 16:46:53',5,3),(649,71,'2024-05-05 16:46:54',5,3),(650,71,'2024-05-05 16:46:57',3,2),(651,71,'2024-05-05 16:46:58',3,2),(652,71,'2024-05-05 16:47:03',2,5),(653,71,'2024-05-05 16:47:06',7,5),(654,71,'2024-05-05 16:47:10',2,5),(655,71,'2024-05-05 16:47:11',2,5),(656,71,'2024-05-05 16:47:13',5,6),(657,71,'2024-05-05 16:47:14',5,7),(658,71,'2024-05-05 16:47:16',5,6),(659,71,'2024-05-05 16:47:20',5,6),(660,71,'2024-05-05 16:47:20',6,8),(661,71,'2024-05-05 16:47:23',6,8),(662,71,'2024-05-05 16:47:23',8,9),(663,71,'2024-05-05 16:47:27',6,8),(664,71,'2024-05-05 16:47:29',7,5),(665,71,'2024-05-05 16:47:32',5,7),(666,71,'2024-05-05 16:47:35',7,5),(667,71,'2024-05-05 16:47:38',8,10),(668,71,'2024-05-05 16:47:42',8,10),(684,74,'2024-05-05 16:53:58',1,3),(685,74,'2024-05-05 16:54:01',3,2),(686,74,'2024-05-05 16:54:04',1,2),(687,74,'2024-05-05 16:54:07',1,2),(688,74,'2024-05-05 16:54:07',1,3),(689,74,'2024-05-05 16:54:10',3,2),(690,74,'2024-05-05 16:54:10',1,3),(692,74,'2024-05-05 16:54:14',2,5),(693,74,'2024-05-05 16:54:17',2,4),(694,74,'2024-05-05 16:54:17',2,5),(695,74,'2024-05-05 16:54:17',5,7),(696,74,'2024-05-05 16:54:20',2,4),(697,74,'2024-05-05 16:54:25',4,5),(698,74,'2024-05-05 16:54:27',5,3),(699,74,'2024-05-05 16:54:28',4,5),(700,74,'2024-05-05 16:54:28',5,7),(701,74,'2024-05-05 16:54:30',3,2),(702,74,'2024-05-05 16:54:33',7,5),(703,74,'2024-05-05 16:54:38',5,3),(704,74,'2024-05-05 16:54:41',3,2),(705,74,'2024-05-05 16:54:43',5,3),(706,74,'2024-05-05 16:54:43',2,5),(707,74,'2024-05-05 16:54:43',7,5),(708,74,'2024-05-05 16:54:46',5,7),(709,74,'2024-05-05 16:54:46',3,2),(710,74,'2024-05-05 16:54:47',5,7),(711,74,'2024-05-05 16:54:54',2,5),(712,74,'2024-05-05 16:54:59',2,5),(713,74,'2024-05-05 16:55:01',7,5),(714,74,'2024-05-05 16:55:02',7,5),(715,74,'2024-05-05 16:55:04',5,6),(716,74,'2024-05-05 16:55:05',5,7),(717,74,'2024-05-05 16:55:09',5,3),(718,74,'2024-05-05 16:55:11',5,6),(719,74,'2024-05-05 16:55:11',6,8),(720,74,'2024-05-05 16:55:12',3,2),(721,74,'2024-05-05 16:55:18',6,8),(722,74,'2024-05-05 16:55:20',7,5),(723,74,'2024-05-05 16:55:25',2,5),(724,74,'2024-05-05 16:55:30',5,3),(725,74,'2024-05-05 16:55:33',3,2),(726,74,'2024-05-05 16:55:36',5,6),(727,74,'2024-05-05 16:55:43',6,8),(728,74,'2024-05-05 16:55:47',2,5),(729,74,'2024-05-05 16:55:50',5,7),(730,74,'2024-05-05 16:56:05',7,5),(731,76,'2024-05-05 17:14:38',1,2),(732,76,'2024-05-05 17:14:38',1,3),(733,76,'2024-05-05 17:14:41',1,3),(734,76,'2024-05-05 17:14:41',3,2),(735,76,'2024-05-05 17:14:44',3,2),(736,76,'2024-05-05 17:14:47',1,2),(737,76,'2024-05-05 17:14:47',1,3),(738,76,'2024-05-05 17:14:51',2,5),(739,76,'2024-05-05 17:14:54',2,5),(740,76,'2024-05-05 17:14:54',5,7),(741,76,'2024-05-05 17:14:57',2,5),(742,76,'2024-05-05 17:14:57',2,4),(743,76,'2024-05-05 17:15:09',7,5),(744,76,'2024-05-05 17:15:12',5,7),(745,76,'2024-05-05 17:15:27',7,5),(746,76,'2024-05-05 17:15:37',5,6),(747,76,'2024-05-05 17:15:44',6,8),(748,76,'2024-05-05 17:15:47',8,9),(749,77,'2024-05-05 17:16:03',1,2),(750,77,'2024-05-05 17:16:03',1,3),(751,77,'2024-05-05 17:16:06',3,2),(752,77,'2024-05-05 17:16:09',1,2),(753,77,'2024-05-05 17:16:09',1,3),(754,77,'2024-05-05 17:16:12',3,2),(755,77,'2024-05-05 17:16:13',2,4),(756,77,'2024-05-05 17:16:15',1,2),(757,77,'2024-05-05 17:16:19',2,5),(758,77,'2024-05-05 17:16:22',2,5),(759,77,'2024-05-05 17:16:25',2,5),(760,77,'2024-05-05 17:16:25',2,4),(761,77,'2024-05-05 17:16:33',4,5),(762,77,'2024-05-05 17:16:44',5,6);
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
    DECLARE firstMouseValue INT;
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
    
    IF NEW.sala_origem = 1 THEN
    	SELECT sala_0 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 2 THEN
    	SELECT sala_1 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 3 THEN
    	SELECT sala_2 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 4 THEN
    	SELECT sala_3 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 5 THEN
    	SELECT sala_4 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 6 THEN
    	SELECT sala_5 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 7 THEN
    	SELECT sala_6 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 8 THEN
    	SELECT sala_7 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 9 THEN
    	SELECT sala_8 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 10 THEN
    	SELECT sala_9 into firstMouseValue FROM MedicoesSalas WHERE id_experiencia = NEW.id_experiencia;
	ELSE
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Room.';
	END IF;
    
    SELECT limite_ratos_sala INTO maxMouseValue FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    
    IF (finalMouseValue + 1) >= maxMouseValue THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid movement, room already at 0 mouses';
    END IF;
    
    IF NEW.sala_destino = 1 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_0 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 2 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_1 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 3 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_2 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 4 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_3 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 5 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_4 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 6 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_5 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 7 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_6 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 8 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_7 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 9 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_8 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 10 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_9 = (finalMouseValue + 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSE
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Room.';
	END IF;
    
    IF NEW.sala_origem = 1 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_0 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 2 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_1 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 3 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_2 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 4 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_3 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 5 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_4 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 6 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_5 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 7 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_6 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 8 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_7 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 9 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_8 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 10 THEN
    	UPDATE MedicoesSalas SET MedicoesSalas.sala_9 = (firstMouseValue - 1) WHERE MedicoesSalas.id_experiencia = NEW.id_experiencia;
	ELSE
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Room.';
	END IF;
    
    IF finalMouseValue > maxMouseValue THEN
    CALL InsertNewAlert(NEW.id_experiencia, NULL, NEW.sala_destino, NULL, 'NumeroRatos');
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
INSERT INTO `MedicoesSalas` VALUES (1,0,0,0,2,3,0,0,0,0,0),(6,3,0,0,0,2,0,0,0,0,0),(7,0,0,0,0,0,0,0,0,3,2),(11,1,0,1,0,0,2,0,0,0,1),(12,0,2,0,0,0,0,0,2,1,0),(13,1,0,0,0,1,0,0,1,2,0),(14,1,0,0,0,0,2,2,0,0,0),(15,0,2,0,0,1,1,0,0,1,0),(20,5,0,0,0,0,0,0,0,0,0),(22,5,0,0,0,0,0,0,0,0,0),(24,5,0,0,0,0,0,0,0,0,0),(28,5,0,0,0,0,0,0,0,0,0),(31,5,0,0,0,0,0,0,0,0,0),(32,5,0,0,0,0,0,0,0,0,0),(36,5,0,0,0,0,0,0,0,0,0),(39,5,0,0,0,0,0,0,0,0,0),(42,5,0,0,0,0,0,0,0,0,0),(43,5,0,0,0,0,0,0,0,0,0),(46,5,0,0,0,0,0,0,0,0,0),(49,5,0,0,0,0,0,0,0,0,0),(51,5,0,0,0,0,0,0,0,0,0),(52,5,0,0,0,0,0,0,0,0,0),(56,5,0,0,0,0,0,0,0,0,0),(59,5,0,0,0,0,0,0,0,0,0),(63,5,0,0,0,0,0,0,0,0,0),(64,5,0,0,0,0,0,0,0,0,0),(65,5,0,0,0,0,0,0,0,0,0),(66,0,0,0,0,0,0,1,1,1,2),(67,5,0,0,0,0,0,0,0,0,0),(68,5,0,0,0,0,0,0,0,0,0),(69,0,0,0,0,0,2,0,0,0,3),(70,1,3,0,0,0,1,0,0,0,0),(71,1,0,0,0,1,0,0,0,1,2),(72,5,0,0,0,0,0,0,0,0,0),(73,5,0,0,0,0,0,0,0,0,0),(74,0,0,1,0,1,0,0,3,0,0),(75,5,0,0,0,0,0,0,0,0,0),(76,0,0,1,1,2,0,0,0,1,0),(77,0,0,0,1,3,1,0,0,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=3611 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesTemperatura`
--

LOCK TABLES `MedicoesTemperatura` WRITE;
/*!40000 ALTER TABLE `MedicoesTemperatura` DISABLE KEYS */;
INSERT INTO `MedicoesTemperatura` VALUES (2159,1,'2024-05-02 17:44:28',12.20,2),(2160,1,'2024-05-02 17:44:33',12.20,2),(2161,1,'2024-05-02 17:44:34',12.20,2),(2162,1,'2024-05-02 17:44:35',12.50,2),(2163,1,'2024-05-02 17:44:36',12.80,2),(2164,1,'2024-05-02 17:44:37',13.10,2),(2165,1,'2024-05-02 17:44:41',14.00,2),(2166,1,'2024-05-02 17:44:41',14.00,2),(2167,1,'2024-05-02 17:44:42',14.00,2),(2168,1,'2024-05-02 17:44:43',14.00,2),(2169,1,'2024-05-02 17:44:45',14.00,2),(2170,1,'2024-05-02 17:44:45',14.00,2),(2171,1,'2024-05-02 17:44:46',14.00,2),(2172,1,'2024-05-02 17:44:47',14.00,2),(2173,1,'2024-05-02 17:44:48',14.00,2),(2174,1,'2024-05-02 17:44:49',14.00,2),(2175,1,'2024-05-02 17:44:51',13.70,2),(2176,1,'2024-05-02 17:44:51',13.70,2),(2177,1,'2024-05-02 17:44:52',13.40,2),(2178,1,'2024-05-02 17:44:53',13.10,2),(2179,1,'2024-05-02 17:44:54',12.80,2),(2180,1,'2024-05-02 17:44:56',12.20,2),(2181,1,'2024-05-02 17:44:56',12.20,2),(2182,1,'2024-05-02 17:44:57',11.90,2),(2183,1,'2024-05-02 17:44:59',11.60,2),(2184,1,'2024-05-02 17:44:59',11.60,2),(2185,1,'2024-05-02 17:45:00',11.60,2),(2186,1,'2024-05-02 17:45:01',11.60,2),(2187,1,'2024-05-02 17:45:02',11.60,2),(2188,1,'2024-05-02 17:45:04',11.60,2),(2189,1,'2024-05-02 17:45:04',11.60,2),(2190,1,'2024-05-02 17:45:05',11.60,2),(2191,1,'2024-05-02 17:45:06',11.60,2),(2192,1,'2024-05-02 17:45:09',10.70,2),(2193,1,'2024-05-02 17:45:10',10.40,2),(2194,1,'2024-05-02 17:45:11',10.10,2),(2195,1,'2024-05-02 17:45:12',9.80,2),(2196,1,'2024-05-02 17:45:13',9.50,2),(2197,1,'2024-05-02 17:45:14',9.20,2),(2198,1,'2024-05-02 17:45:15',9.20,2),(2199,1,'2024-05-02 17:45:16',9.20,2),(2200,1,'2024-05-02 17:45:17',9.20,2),(2201,1,'2024-05-02 17:45:19',9.20,2),(2202,1,'2024-05-02 17:45:21',9.20,2),(2203,1,'2024-05-02 17:45:21',9.20,2),(2204,1,'2024-05-02 17:45:28',6.20,1),(2205,1,'2024-05-02 17:45:29',6.50,1),(2206,1,'2024-05-02 17:45:30',6.80,1),(2207,1,'2024-05-02 17:45:31',7.10,1),(2208,1,'2024-05-02 17:45:32',7.40,1),(2209,1,'2024-05-02 17:45:33',7.70,1),(2210,1,'2024-05-02 17:45:34',8.00,1),(2211,1,'2024-05-02 17:45:35',8.00,1),(2212,1,'2024-05-02 17:45:36',8.00,1),(2213,1,'2024-05-02 17:45:37',8.00,1),(2214,1,'2024-05-02 17:45:38',8.00,1),(2215,1,'2024-05-02 17:45:39',8.00,1),(2216,1,'2024-05-02 17:45:40',8.00,1),(2217,1,'2024-05-02 17:45:41',8.00,1),(2218,1,'2024-05-02 17:45:42',8.00,1),(2219,1,'2024-05-02 17:45:43',8.00,1),(2220,1,'2024-05-02 17:45:44',8.00,1),(2221,1,'2024-05-02 17:45:45',8.30,1),(2222,1,'2024-05-02 17:45:46',8.60,1),(2223,1,'2024-05-02 17:45:46',9.20,2),(2224,1,'2024-05-02 17:45:47',8.90,1),(2225,1,'2024-05-02 17:45:48',9.20,1),(2226,1,'2024-05-02 17:45:48',9.20,2),(2227,6,'2024-05-03 15:14:25',6.20,2),(2228,6,'2024-05-03 15:14:28',7.10,2),(2229,6,'2024-05-03 15:14:28',7.10,2),(2230,6,'2024-05-03 15:14:29',7.40,2),(2231,6,'2024-05-03 15:14:29',7.40,2),(2232,6,'2024-05-03 15:14:32',7.40,2),(2233,6,'2024-05-03 15:14:32',7.40,2),(2234,6,'2024-05-03 15:14:32',7.40,2),(2235,6,'2024-05-03 15:14:33',7.40,2),(2236,6,'2024-05-03 15:14:35',7.40,2),(2237,6,'2024-05-03 15:14:35',7.40,2),(2238,6,'2024-05-03 15:14:37',7.40,2),(2239,6,'2024-05-03 15:14:37',7.40,2),(2240,6,'2024-05-03 15:14:38',7.70,2),(2241,6,'2024-05-03 15:14:39',8.00,2),(2242,6,'2024-05-03 15:14:53',11.00,1),(2243,6,'2024-05-03 15:14:54',11.00,1),(2244,6,'2024-05-03 15:14:55',11.00,1),(2245,6,'2024-05-03 15:14:56',11.00,1),(2246,6,'2024-05-03 15:14:57',11.00,1),(2247,6,'2024-05-03 15:14:58',11.00,1),(2248,6,'2024-05-03 15:14:59',11.00,1),(2249,6,'2024-05-03 15:15:00',11.00,1),(2250,6,'2024-05-03 15:15:01',11.00,1),(2251,6,'2024-05-03 15:15:01',7.40,2),(2252,6,'2024-05-03 15:15:02',7.40,2),(2253,6,'2024-05-03 15:15:03',7.40,2),(2254,6,'2024-05-03 15:15:05',7.40,2),(2255,6,'2024-05-03 15:15:05',7.40,2),(2256,6,'2024-05-03 15:15:06',7.40,2),(2257,6,'2024-05-03 15:15:07',7.40,2),(2258,6,'2024-05-03 15:15:08',7.40,2),(2259,6,'2024-05-03 15:15:10',7.10,2),(2260,6,'2024-05-03 15:15:10',7.10,2),(2261,6,'2024-05-03 15:15:11',6.80,2),(2262,6,'2024-05-03 15:15:13',6.20,2),(2263,6,'2024-05-03 15:15:13',6.20,2),(2264,6,'2024-05-03 15:15:15',5.60,2),(2265,6,'2024-05-03 15:15:15',5.60,2),(2266,6,'2024-05-03 15:15:16',5.30,2),(2267,6,'2024-05-03 15:15:18',5.00,2),(2268,6,'2024-05-03 15:15:18',5.00,2),(2269,6,'2024-05-03 15:15:20',5.00,2),(2270,6,'2024-05-03 15:15:20',5.00,2),(2271,6,'2024-05-03 15:15:21',5.00,2),(2272,6,'2024-05-03 15:15:22',5.00,2),(2273,6,'2024-05-03 15:15:25',5.00,2),(2274,6,'2024-05-03 15:15:25',5.00,2),(2275,6,'2024-05-03 15:15:26',5.30,2),(2276,6,'2024-05-03 15:15:29',6.20,2),(2277,6,'2024-05-03 15:15:30',6.50,2),(2278,6,'2024-05-03 15:15:31',6.80,2),(2279,6,'2024-05-03 15:15:33',7.40,2),(2280,6,'2024-05-03 15:15:33',7.40,2),(2281,6,'2024-05-03 15:15:34',7.40,2),(2282,6,'2024-05-03 15:15:36',7.40,2),(2283,6,'2024-05-03 15:15:37',7.40,2),(2284,6,'2024-05-03 15:15:39',7.40,2),(2285,6,'2024-05-03 15:15:43',6.80,2),(2286,6,'2024-05-03 15:15:43',6.80,2),(2287,6,'2024-05-03 15:15:43',6.80,2),(2288,6,'2024-05-03 15:15:44',6.50,2),(2289,6,'2024-05-03 15:15:44',6.50,2),(2290,6,'2024-05-03 15:15:45',6.20,2),(2291,6,'2024-05-03 15:15:46',5.90,2),(2292,6,'2024-05-03 15:15:47',5.60,2),(2293,6,'2024-05-03 15:15:50',5.00,2),(2294,6,'2024-05-03 15:15:51',5.00,2),(2295,6,'2024-05-03 15:15:52',5.00,2),(2296,6,'2024-05-03 15:15:53',8.00,1),(2297,6,'2024-05-03 15:15:53',5.00,2),(2298,6,'2024-05-03 15:15:54',8.00,1),(2299,6,'2024-05-03 15:15:54',5.00,2),(2300,6,'2024-05-03 15:15:55',8.00,1),(2301,6,'2024-05-03 15:15:55',5.00,2),(2302,6,'2024-05-03 15:15:56',8.00,1),(2303,6,'2024-05-03 15:15:56',5.00,2),(2304,6,'2024-05-03 15:15:57',8.00,1),(2305,6,'2024-05-03 15:15:58',8.00,1),(2306,6,'2024-05-03 15:15:59',8.00,1),(2307,6,'2024-05-03 15:15:59',5.60,2),(2308,6,'2024-05-03 15:15:59',5.60,2),(2309,6,'2024-05-03 15:16:00',8.00,1),(2310,6,'2024-05-03 15:16:01',8.00,1),(2311,6,'2024-05-03 15:16:01',6.20,2),(2312,6,'2024-05-03 15:16:01',6.20,2),(2313,6,'2024-05-03 15:16:02',8.00,1),(2314,6,'2024-05-03 15:16:03',8.00,1),(2315,6,'2024-05-03 15:16:03',6.80,2),(2316,6,'2024-05-03 15:16:03',6.80,2),(2317,6,'2024-05-03 15:16:04',8.30,1),(2318,6,'2024-05-03 15:16:04',7.10,2),(2319,6,'2024-05-03 15:16:05',8.60,1),(2320,6,'2024-05-03 15:16:06',8.90,1),(2321,6,'2024-05-03 15:16:07',9.20,1),(2322,6,'2024-05-03 15:16:08',9.50,1),(2323,6,'2024-05-03 15:16:09',9.80,1),(2324,6,'2024-05-03 15:16:09',7.40,2),(2325,6,'2024-05-03 15:16:09',7.40,2),(2326,6,'2024-05-03 15:16:10',10.10,1),(2327,6,'2024-05-03 15:16:09',7.40,2),(2328,6,'2024-05-03 15:16:11',10.40,1),(2329,6,'2024-05-03 15:16:11',7.40,2),(2330,6,'2024-05-03 15:16:13',7.40,2),(2331,6,'2024-05-03 15:16:13',7.40,2),(2332,6,'2024-05-03 15:16:14',7.10,2),(2333,6,'2024-05-03 15:16:15',6.80,2),(2334,6,'2024-05-03 15:16:16',6.50,2),(2335,6,'2024-05-03 15:16:17',6.20,2),(2336,6,'2024-05-03 15:16:18',5.90,2),(2337,6,'2024-05-03 15:16:20',5.30,2),(2338,6,'2024-05-03 15:16:22',5.00,2),(2339,6,'2024-05-03 15:16:22',5.00,2),(2340,6,'2024-05-03 15:16:23',5.00,2),(2341,6,'2024-05-03 15:16:24',5.00,2),(2342,6,'2024-05-03 15:16:26',5.00,2),(2343,6,'2024-05-03 15:16:27',5.00,2),(2344,6,'2024-05-03 15:16:29',5.00,2),(2345,6,'2024-05-03 15:16:30',5.30,2),(2346,6,'2024-05-03 15:16:31',5.60,2),(2347,6,'2024-05-03 15:16:32',8.30,1),(2348,6,'2024-05-03 15:16:32',5.90,2),(2349,6,'2024-05-03 15:16:33',8.00,1),(2350,6,'2024-05-03 15:16:33',6.20,2),(2351,6,'2024-05-03 15:16:34',8.00,1),(2352,6,'2024-05-03 15:16:35',8.00,1),(2353,6,'2024-05-03 15:16:35',6.80,2),(2354,6,'2024-05-03 15:16:35',6.80,2),(2355,6,'2024-05-03 15:16:36',8.00,1),(2356,6,'2024-05-03 15:16:37',8.00,1),(2357,6,'2024-05-03 15:16:37',7.40,2),(2358,6,'2024-05-03 15:16:37',7.40,2),(2359,6,'2024-05-03 15:16:38',8.00,1),(2360,6,'2024-05-03 15:16:38',7.40,2),(2361,6,'2024-05-03 15:16:39',8.00,1),(2362,6,'2024-05-03 15:16:39',7.40,2),(2363,6,'2024-05-03 15:16:40',8.00,1),(2364,6,'2024-05-03 15:16:40',7.40,2),(2365,6,'2024-05-03 15:16:41',8.00,1),(2366,6,'2024-05-03 15:16:41',7.40,2),(2367,6,'2024-05-03 15:16:42',8.00,1),(2368,6,'2024-05-03 15:16:42',7.40,2),(2369,6,'2024-05-03 15:16:43',8.00,1),(2370,6,'2024-05-03 15:16:43',7.40,2),(2371,6,'2024-05-03 15:16:44',7.70,1),(2372,7,'2024-05-03 16:04:54',11.30,1),(2373,7,'2024-05-03 16:04:54',7.70,2),(2374,7,'2024-05-03 16:04:54',7.70,2),(2375,7,'2024-05-03 16:04:55',7.40,2),(2376,7,'2024-05-03 16:04:56',7.40,2),(2377,7,'2024-05-03 16:04:57',7.40,2),(2378,7,'2024-05-03 16:04:59',7.40,2),(2379,7,'2024-05-03 16:05:03',7.40,2),(2380,7,'2024-05-03 16:05:05',6.80,2),(2381,7,'2024-05-03 16:05:05',6.80,2),(2382,7,'2024-05-03 16:05:08',5.90,2),(2383,7,'2024-05-03 16:05:08',5.90,2),(2384,7,'2024-05-03 16:05:08',5.90,2),(2385,7,'2024-05-03 16:05:09',5.60,2),(2386,7,'2024-05-03 16:05:11',5.00,2),(2387,7,'2024-05-03 16:05:12',5.00,2),(2388,7,'2024-05-03 16:05:13',5.00,2),(2389,7,'2024-05-03 16:05:15',8.00,1),(2390,7,'2024-05-03 16:05:15',5.00,2),(2391,7,'2024-05-03 16:05:16',8.00,1),(2392,7,'2024-05-03 16:05:16',5.00,2),(2393,7,'2024-05-03 16:05:17',8.00,1),(2394,7,'2024-05-03 16:05:17',5.00,2),(2395,7,'2024-05-03 16:05:18',8.00,1),(2396,7,'2024-05-03 16:05:19',8.00,1),(2397,7,'2024-05-03 16:05:19',5.00,2),(2398,7,'2024-05-03 16:05:19',5.00,2),(2399,7,'2024-05-03 16:05:20',8.00,1),(2400,7,'2024-05-03 16:05:21',8.00,1),(2401,7,'2024-05-03 16:05:21',5.00,2),(2402,7,'2024-05-03 16:05:21',5.00,2),(2403,7,'2024-05-03 16:05:22',8.00,1),(2404,7,'2024-05-03 16:05:23',8.00,1),(2405,7,'2024-05-03 16:05:24',8.00,1),(2406,7,'2024-05-03 16:05:24',5.00,2),(2407,7,'2024-05-03 16:05:24',5.00,2),(2408,7,'2024-05-03 16:05:25',8.00,1),(2409,7,'2024-05-03 16:05:24',5.00,2),(2410,7,'2024-05-03 16:05:25',5.00,2),(2411,7,'2024-05-03 16:05:26',7.70,1),(2412,7,'2024-05-03 16:05:26',5.00,2),(2413,7,'2024-05-03 16:05:27',7.40,1),(2414,7,'2024-05-03 16:05:27',5.00,2),(2415,7,'2024-05-03 16:05:28',7.10,1),(2416,7,'2024-05-03 16:05:28',5.00,2),(2417,7,'2024-05-03 16:05:29',6.80,1),(2418,7,'2024-05-03 16:05:29',5.00,2),(2419,7,'2024-05-03 16:05:30',6.50,1),(2420,7,'2024-05-03 16:05:30',5.00,2),(2421,7,'2024-05-03 16:05:31',6.20,1),(2422,7,'2024-05-03 16:05:31',5.00,2),(2423,7,'2024-05-03 16:05:32',5.90,1),(2424,7,'2024-05-03 16:05:33',5.60,1),(2425,7,'2024-05-03 16:05:34',5.30,1),(2426,7,'2024-05-03 16:05:34',5.00,2),(2427,7,'2024-05-03 16:05:34',5.00,2),(2428,7,'2024-05-03 16:05:35',5.00,1),(2429,7,'2024-05-03 16:05:36',5.00,1),(2430,7,'2024-05-03 16:05:36',5.30,2),(2431,7,'2024-05-03 16:05:36',5.30,2),(2432,7,'2024-05-03 16:05:37',5.00,1),(2433,7,'2024-05-03 16:05:37',5.60,2),(2434,7,'2024-05-03 16:05:38',5.00,1),(2435,7,'2024-05-03 16:05:38',5.90,2),(2436,7,'2024-05-03 16:05:39',5.00,1),(2437,7,'2024-05-03 16:05:40',5.00,1),(2438,7,'2024-05-03 16:05:40',6.50,2),(2439,7,'2024-05-03 16:05:41',5.00,1),(2440,7,'2024-05-03 16:05:42',5.00,1),(2441,7,'2024-05-03 16:05:42',7.10,2),(2442,7,'2024-05-03 16:05:42',7.10,2),(2443,7,'2024-05-03 16:05:43',5.00,1),(2444,7,'2024-05-03 16:05:43',7.40,2),(2445,7,'2024-05-03 16:05:44',5.00,1),(2446,7,'2024-05-03 16:05:44',7.40,2),(2447,7,'2024-05-03 16:05:45',5.00,1),(2448,7,'2024-05-03 16:05:45',7.40,2),(2449,7,'2024-05-03 16:05:46',5.00,1),(2450,7,'2024-05-03 16:05:47',5.00,1),(2451,7,'2024-05-03 16:05:48',5.00,1),(2452,7,'2024-05-03 16:05:48',7.40,2),(2453,7,'2024-05-03 16:05:48',7.40,2),(2454,7,'2024-05-03 16:05:49',5.00,1),(2455,7,'2024-05-03 16:05:50',5.00,1),(2456,7,'2024-05-03 16:05:50',7.40,2),(2457,7,'2024-05-03 16:05:51',5.00,1),(2458,7,'2024-05-03 16:05:51',7.40,2),(2459,7,'2024-05-03 16:05:52',5.00,1),(2460,7,'2024-05-03 16:05:52',7.10,2),(2461,7,'2024-05-03 16:05:53',5.00,1),(2462,7,'2024-05-03 16:05:54',5.00,1),(2463,7,'2024-05-03 16:05:55',5.00,1),(2464,7,'2024-05-03 16:05:56',5.00,1),(2465,7,'2024-05-03 16:05:56',5.90,2),(2466,7,'2024-05-03 16:05:57',5.00,1),(2467,7,'2024-05-03 16:05:57',5.60,2),(2468,7,'2024-05-03 16:05:58',5.00,1),(2469,7,'2024-05-03 16:05:59',5.00,1),(2470,7,'2024-05-03 16:05:59',5.00,2),(2471,7,'2024-05-03 16:05:59',5.00,2),(2472,7,'2024-05-03 16:06:00',5.00,1),(2473,7,'2024-05-03 16:06:00',5.00,2),(2474,7,'2024-05-03 16:06:01',5.00,1),(2475,7,'2024-05-03 16:06:02',5.00,1),(2476,7,'2024-05-03 16:06:02',5.00,2),(2477,7,'2024-05-03 16:06:02',5.00,2),(2478,7,'2024-05-03 16:06:03',5.00,1),(2479,7,'2024-05-03 16:06:03',5.00,2),(2480,7,'2024-05-03 16:06:04',5.00,1),(2481,7,'2024-05-03 16:06:05',5.00,1),(2482,7,'2024-05-03 16:06:06',5.30,1),(2483,7,'2024-05-03 16:06:06',5.00,2),(2484,7,'2024-05-03 16:06:07',5.60,1),(2485,7,'2024-05-03 16:06:08',5.90,1),(2486,7,'2024-05-03 16:06:08',5.30,2),(2487,7,'2024-05-03 16:06:08',5.30,2),(2488,7,'2024-05-03 16:06:09',6.20,1),(2489,7,'2024-05-03 16:06:09',5.60,2),(2490,7,'2024-05-03 16:06:10',6.50,1),(2491,7,'2024-05-03 16:06:10',5.90,2),(2492,7,'2024-05-03 16:06:11',6.80,1),(2493,7,'2024-05-03 16:06:12',7.10,1),(2494,7,'2024-05-03 16:06:12',6.50,2),(2495,7,'2024-05-03 16:06:12',6.50,2),(2496,7,'2024-05-03 16:06:13',7.40,1),(2497,7,'2024-05-03 16:06:14',7.70,1),(2498,7,'2024-05-03 16:06:14',7.10,2),(2499,7,'2024-05-03 16:06:14',7.10,2),(2500,7,'2024-05-03 16:06:15',8.00,1),(2501,7,'2024-05-03 16:06:16',8.00,1),(2502,7,'2024-05-03 16:06:16',7.40,2),(2503,7,'2024-05-03 16:06:16',7.40,2),(2504,7,'2024-05-03 16:06:17',8.00,1),(2505,7,'2024-05-03 16:06:18',8.00,1),(2506,7,'2024-05-03 16:06:18',7.40,2),(2507,7,'2024-05-03 16:06:18',7.40,2),(2508,7,'2024-05-03 16:06:19',8.00,1),(2509,7,'2024-05-03 16:06:20',8.00,1),(2510,7,'2024-05-03 16:06:20',7.40,2),(2511,7,'2024-05-03 16:06:21',8.00,1),(2512,7,'2024-05-03 16:06:22',8.00,1),(2513,7,'2024-05-03 16:06:23',8.00,1),(2514,7,'2024-05-03 16:06:23',7.40,2),(2515,7,'2024-05-03 16:06:23',7.40,2),(2516,7,'2024-05-03 16:06:24',8.00,1),(2517,7,'2024-05-03 16:06:24',7.70,2),(2518,7,'2024-05-03 16:06:25',8.00,1),(2519,7,'2024-05-03 16:06:26',8.30,1),(2520,7,'2024-05-03 16:06:26',8.30,2),(2521,7,'2024-05-03 16:06:27',8.60,1),(2522,7,'2024-05-03 16:06:27',8.60,2),(2523,7,'2024-05-03 16:06:28',8.90,1),(2524,7,'2024-05-03 16:06:29',9.20,1),(2525,7,'2024-05-03 16:06:29',9.20,2),(2526,7,'2024-05-03 16:06:30',9.50,1),(2527,7,'2024-05-03 16:06:31',9.80,1),(2528,7,'2024-05-03 16:06:31',9.80,2),(2529,7,'2024-05-03 16:06:31',9.80,2),(2530,7,'2024-05-03 16:06:32',10.10,1),(2531,7,'2024-05-03 16:06:32',9.80,2),(2532,7,'2024-05-03 16:06:33',10.40,1),(2533,7,'2024-05-03 16:06:33',9.80,2),(2534,7,'2024-05-03 16:06:34',10.70,1),(2535,7,'2024-05-03 16:06:34',9.80,2),(2536,7,'2024-05-03 16:06:35',11.00,1),(2537,7,'2024-05-03 16:06:35',9.80,2),(2538,7,'2024-05-03 16:06:36',11.00,1),(2539,7,'2024-05-03 16:06:36',9.80,2),(2540,7,'2024-05-03 16:06:37',11.00,1),(2541,7,'2024-05-03 16:06:37',9.80,2),(2542,7,'2024-05-03 16:06:38',11.00,1),(2543,7,'2024-05-03 16:06:38',9.80,2),(2544,7,'2024-05-03 16:06:39',11.00,1),(2545,7,'2024-05-03 16:06:40',11.00,1),(2546,7,'2024-05-03 16:06:41',11.00,1),(2547,7,'2024-05-03 16:06:42',11.00,1),(2548,7,'2024-05-03 16:06:43',11.00,1),(2549,7,'2024-05-03 16:06:44',11.00,1),(2550,7,'2024-05-03 16:06:45',11.00,1),(2551,7,'2024-05-03 16:06:46',11.30,1),(2552,7,'2024-05-03 16:06:47',11.60,1),(2553,7,'2024-05-03 16:06:48',11.90,1),(2554,7,'2024-05-03 16:06:49',12.20,1),(2555,7,'2024-05-03 16:06:50',12.50,1),(2556,7,'2024-05-03 16:06:51',12.80,1),(2557,7,'2024-05-03 16:06:52',13.10,1),(2558,7,'2024-05-03 16:06:53',13.40,1),(2559,7,'2024-05-03 16:06:54',13.70,1),(2560,7,'2024-05-03 16:06:55',14.00,1),(2561,7,'2024-05-03 16:06:56',14.00,1),(2562,7,'2024-05-03 16:06:57',14.00,1),(2563,7,'2024-05-03 16:06:58',14.00,1),(2564,7,'2024-05-03 16:06:59',14.00,1),(2565,7,'2024-05-03 16:07:00',14.00,1),(2566,7,'2024-05-03 16:07:01',14.00,1),(2567,7,'2024-05-03 16:07:02',14.00,1),(2568,7,'2024-05-03 16:07:03',14.00,1),(2569,7,'2024-05-03 16:07:04',14.00,1),(2570,7,'2024-05-03 16:07:05',14.00,1),(2571,7,'2024-05-03 16:07:06',14.00,1),(2572,7,'2024-05-03 16:07:07',14.00,1),(2573,7,'2024-05-03 16:07:08',14.00,1),(2574,7,'2024-05-03 16:07:09',14.00,1),(2575,7,'2024-05-03 16:07:10',14.00,1),(2576,7,'2024-05-03 16:07:11',14.00,1),(2577,7,'2024-05-03 16:07:12',14.00,1),(2578,7,'2024-05-03 16:07:13',14.00,1),(2579,7,'2024-05-03 16:07:14',14.00,1),(2580,7,'2024-05-03 16:07:15',14.00,1),(2581,7,'2024-05-03 16:07:16',14.00,1),(2582,7,'2024-05-03 16:07:17',14.00,1),(2583,7,'2024-05-03 16:07:18',14.00,1),(2584,7,'2024-05-03 16:07:19',14.00,1),(2585,7,'2024-05-03 16:07:20',14.00,1),(2586,7,'2024-05-03 16:07:21',14.00,1),(2587,7,'2024-05-03 16:07:22',14.00,1),(2588,7,'2024-05-03 16:07:23',14.00,1),(2589,7,'2024-05-03 16:07:24',14.00,1),(2590,7,'2024-05-03 16:07:25',14.00,1),(2591,7,'2024-05-03 16:07:26',14.00,1),(2592,7,'2024-05-03 16:07:27',14.00,1),(2593,7,'2024-05-03 16:07:28',14.00,1),(2594,7,'2024-05-03 16:07:29',14.00,1),(2595,7,'2024-05-03 16:07:30',14.00,1),(2596,7,'2024-05-03 16:07:31',14.00,1),(2597,7,'2024-05-03 16:07:32',14.00,1),(2598,7,'2024-05-03 16:07:33',14.00,1),(2599,7,'2024-05-03 16:07:34',14.00,1),(2600,7,'2024-05-03 16:07:35',14.00,1),(2601,7,'2024-05-03 16:07:36',14.00,1),(2602,7,'2024-05-03 16:07:37',14.00,1),(2603,7,'2024-05-03 16:07:38',14.00,1),(2604,7,'2024-05-03 16:07:39',14.00,1),(2605,7,'2024-05-03 16:07:40',14.00,1),(2606,7,'2024-05-03 16:07:41',14.00,1),(2607,7,'2024-05-03 16:07:42',14.00,1),(2608,7,'2024-05-03 16:07:43',14.00,1),(2609,7,'2024-05-03 16:07:44',14.00,1),(2610,7,'2024-05-03 16:07:45',14.00,1),(2611,7,'2024-05-03 16:07:46',13.70,1),(2612,7,'2024-05-03 16:07:47',13.40,1),(2613,7,'2024-05-03 16:07:47',10.40,2),(2614,7,'2024-05-03 16:07:48',13.10,1),(2615,7,'2024-05-03 16:07:48',10.10,2),(2616,7,'2024-05-03 16:07:49',12.80,1),(2617,7,'2024-05-03 16:07:50',12.50,1),(2618,7,'2024-05-03 16:07:50',9.50,2),(2619,7,'2024-05-03 16:07:50',9.50,2),(2620,7,'2024-05-03 16:07:51',12.20,1),(2621,7,'2024-05-03 16:07:51',9.20,2),(2622,7,'2024-05-03 16:07:52',11.90,1),(2623,7,'2024-05-03 16:07:53',11.60,1),(2624,7,'2024-05-03 16:07:54',11.30,1),(2625,7,'2024-05-03 16:07:54',9.20,2),(2626,7,'2024-05-03 16:07:55',11.00,1),(2627,7,'2024-05-03 16:07:56',11.00,1),(2628,7,'2024-05-03 16:07:56',9.20,2),(2629,7,'2024-05-03 16:07:56',9.20,2),(2630,7,'2024-05-03 16:07:57',11.00,1),(2631,7,'2024-05-03 16:07:57',9.20,2),(2632,7,'2024-05-03 16:07:58',11.00,1),(2633,7,'2024-05-03 16:07:58',9.20,2),(2634,7,'2024-05-03 16:07:59',11.00,1),(2635,7,'2024-05-03 16:07:59',9.20,2),(2636,7,'2024-05-03 16:08:00',11.00,1),(2637,7,'2024-05-03 16:08:00',8.90,2),(2638,7,'2024-05-03 16:08:01',11.00,1),(2639,7,'2024-05-03 16:08:02',11.00,1),(2640,7,'2024-05-03 16:08:02',8.30,2),(2641,7,'2024-05-03 16:08:02',8.30,2),(2642,7,'2024-05-03 16:08:03',11.00,1),(2643,7,'2024-05-03 16:08:03',8.00,2),(2644,7,'2024-05-03 16:08:04',7.70,2),(2645,7,'2024-05-03 16:08:06',7.10,2),(2646,7,'2024-05-03 16:08:07',6.80,2),(2647,7,'2024-05-03 16:08:07',6.80,2),(2648,7,'2024-05-03 16:08:08',6.80,2),(2649,7,'2024-05-03 16:08:09',6.80,2),(2650,7,'2024-05-03 16:08:10',6.80,2),(2651,7,'2024-05-03 16:08:12',6.80,2),(2652,7,'2024-05-03 16:08:13',6.80,2),(2653,7,'2024-05-03 16:08:15',6.80,2),(2654,7,'2024-05-03 16:08:15',6.80,2),(2655,7,'2024-05-03 16:08:16',7.10,2),(2656,7,'2024-05-03 16:08:17',7.40,2),(2657,7,'2024-05-03 16:08:18',7.70,2),(2658,7,'2024-05-03 16:08:19',8.00,2),(2659,7,'2024-05-03 16:08:20',8.30,2),(2660,7,'2024-05-03 16:08:23',9.20,2),(2661,7,'2024-05-03 16:08:23',9.20,2),(2662,7,'2024-05-03 16:08:23',9.20,2),(2663,7,'2024-05-03 16:08:24',9.20,2),(2664,7,'2024-05-03 16:08:25',9.20,2),(2665,7,'2024-05-03 16:08:26',9.20,2),(2666,7,'2024-05-03 16:08:27',9.20,2),(2667,7,'2024-05-03 16:08:28',9.20,2),(2668,7,'2024-05-03 16:08:29',9.20,2),(2669,7,'2024-05-03 16:08:30',9.20,2),(2670,7,'2024-05-03 16:08:31',9.20,2),(2671,7,'2024-05-03 16:08:32',11.90,1),(2672,7,'2024-05-03 16:08:32',8.90,2),(2673,7,'2024-05-03 16:08:33',11.60,1),(2674,7,'2024-05-03 16:08:33',8.60,2),(2675,7,'2024-05-03 16:08:34',11.30,1),(2676,7,'2024-05-03 16:08:34',8.30,2),(2677,7,'2024-05-03 16:08:35',11.00,1),(2678,7,'2024-05-03 16:08:36',11.00,1),(2679,7,'2024-05-03 16:08:36',7.70,2),(2680,7,'2024-05-03 16:08:36',7.70,2),(2681,7,'2024-05-03 16:08:37',7.40,2),(2682,7,'2024-05-03 16:08:38',7.10,2),(2683,7,'2024-05-03 16:08:39',6.80,2),(2684,7,'2024-05-03 16:08:40',6.80,2),(2685,7,'2024-05-03 16:08:41',6.80,2),(2686,7,'2024-05-03 16:08:42',6.80,2),(2687,7,'2024-05-03 16:08:44',6.80,2),(2688,7,'2024-05-03 16:08:47',6.80,2),(2689,7,'2024-05-03 16:08:48',6.50,2),(2690,7,'2024-05-03 16:08:49',6.20,2),(2691,7,'2024-05-03 16:08:50',5.90,2),(2692,7,'2024-05-03 16:08:52',5.30,2),(2693,7,'2024-05-03 16:08:52',5.30,2),(2694,7,'2024-05-03 16:08:53',5.00,2),(2695,7,'2024-05-03 16:08:54',5.00,2),(2696,7,'2024-05-03 16:08:56',5.00,2),(2697,7,'2024-05-03 16:08:57',5.00,2),(2698,7,'2024-05-03 16:08:58',5.00,2),(2699,7,'2024-05-03 16:08:59',5.00,2),(2700,7,'2024-05-03 16:09:04',5.00,2),(2701,7,'2024-05-03 16:09:04',5.00,2),(2702,7,'2024-05-03 16:09:05',5.00,2),(2703,7,'2024-05-03 16:09:05',5.00,2),(2704,7,'2024-05-03 16:09:07',5.00,2),(2705,7,'2024-05-03 16:09:07',5.00,2),(2706,7,'2024-05-03 16:09:08',5.00,2),(2707,7,'2024-05-03 16:09:11',5.00,2),(2708,7,'2024-05-03 16:09:11',5.00,2),(2709,7,'2024-05-03 16:09:12',5.00,2),(2710,7,'2024-05-03 16:09:15',5.00,2),(2711,7,'2024-05-03 16:09:15',5.00,2),(2712,7,'2024-05-03 16:09:16',5.00,2),(2713,7,'2024-05-03 16:09:19',5.00,2),(2714,7,'2024-05-03 16:09:19',5.00,2),(2715,7,'2024-05-03 16:09:19',5.00,2),(2716,7,'2024-05-03 16:09:20',5.30,2),(2717,7,'2024-05-03 16:09:24',6.50,2),(2718,7,'2024-05-03 16:09:26',7.10,2),(2719,7,'2024-05-03 16:09:28',7.40,2),(2720,7,'2024-05-03 16:09:30',7.40,2),(2721,7,'2024-05-03 16:09:31',7.40,2),(2722,7,'2024-05-03 16:09:32',7.40,2),(2723,7,'2024-05-03 16:09:33',7.40,2),(2724,7,'2024-05-03 16:09:34',7.40,2),(2725,7,'2024-05-03 16:09:37',6.80,2),(2726,7,'2024-05-03 16:09:37',6.80,2),(2727,7,'2024-05-03 16:09:37',6.80,2),(2728,7,'2024-05-03 16:09:38',6.50,2),(2729,7,'2024-05-03 16:09:40',5.90,2),(2730,7,'2024-05-03 16:09:40',5.90,2),(2731,7,'2024-05-03 16:09:41',5.60,2),(2732,7,'2024-05-03 16:09:42',5.30,2),(2733,7,'2024-05-03 16:09:44',5.00,2),(2734,7,'2024-05-03 16:09:48',5.00,2),(2735,7,'2024-05-03 16:09:48',5.00,2),(2736,7,'2024-05-03 16:09:49',5.00,2),(2737,7,'2024-05-03 16:09:51',5.00,2),(2738,7,'2024-05-03 16:09:54',5.00,2),(2739,7,'2024-05-03 16:09:56',5.00,2),(2740,7,'2024-05-03 16:09:56',5.00,2),(2741,7,'2024-05-03 16:09:58',5.00,2),(2742,7,'2024-05-03 16:10:00',5.00,2),(2743,7,'2024-05-03 16:10:01',5.00,2),(2744,7,'2024-05-03 16:10:02',5.00,2),(2745,7,'2024-05-03 16:10:03',5.00,2),(2746,7,'2024-05-03 16:10:04',5.00,2),(2747,7,'2024-05-03 16:10:06',5.00,2),(2748,7,'2024-05-03 16:10:07',5.00,2),(2749,7,'2024-05-03 16:10:07',5.00,2),(2750,7,'2024-05-03 16:10:08',5.30,2),(2751,7,'2024-05-03 16:10:09',5.60,2),(2752,7,'2024-05-03 16:10:11',6.20,2),(2753,7,'2024-05-03 16:10:12',6.50,2),(2754,7,'2024-05-03 16:10:14',7.10,2),(2755,7,'2024-05-03 16:10:14',7.10,2),(2756,7,'2024-05-03 16:10:15',7.40,2),(2757,7,'2024-05-03 16:10:16',7.40,2),(2758,7,'2024-05-03 16:10:17',7.40,2),(2759,7,'2024-05-03 16:10:18',7.40,2),(2760,7,'2024-05-03 16:10:20',7.40,2),(2761,7,'2024-05-03 16:10:20',7.40,2),(2762,7,'2024-05-03 16:10:23',7.40,2),(2763,7,'2024-05-03 16:10:23',7.40,2),(2764,7,'2024-05-03 16:10:24',7.70,2),(2765,7,'2024-05-03 16:10:24',7.70,2),(2766,7,'2024-05-03 16:10:25',8.00,2),(2767,7,'2024-05-03 16:10:26',8.30,2),(2768,7,'2024-05-03 16:10:27',8.60,2),(2769,7,'2024-05-03 16:10:28',8.90,2),(2770,7,'2024-05-03 16:10:29',9.20,2),(2771,7,'2024-05-03 16:10:30',9.50,2),(2772,7,'2024-05-03 16:10:31',9.80,2),(2773,7,'2024-05-03 16:10:32',9.80,2),(2774,7,'2024-05-03 16:10:33',9.80,2),(2775,7,'2024-05-03 16:10:34',9.80,2),(2776,7,'2024-05-03 16:10:35',9.80,2),(2777,7,'2024-05-03 16:10:36',9.80,2),(2778,7,'2024-05-03 16:10:37',9.80,2),(2779,7,'2024-05-03 16:10:38',9.80,2),(2780,7,'2024-05-03 16:10:39',9.80,2),(2781,7,'2024-05-03 16:10:40',10.10,2),(2782,7,'2024-05-03 16:11:05',9.80,2),(2783,7,'2024-05-03 16:11:05',9.80,2),(2784,7,'2024-05-03 16:11:05',9.80,2),(2785,7,'2024-05-03 16:11:07',9.80,2),(2786,7,'2024-05-03 16:11:07',9.80,2),(2787,7,'2024-05-03 16:11:08',9.80,2),(2788,7,'2024-05-03 16:11:12',10.10,2),(2789,7,'2024-05-03 16:11:28',13.10,1),(2790,7,'2024-05-03 16:11:29',12.80,1),(2791,7,'2024-05-03 16:11:30',12.50,1),(2792,7,'2024-05-03 16:11:31',12.20,1),(2793,7,'2024-05-03 16:11:32',11.90,1),(2794,7,'2024-05-03 16:11:33',11.60,1),(2795,7,'2024-05-03 16:11:34',11.30,1),(2796,7,'2024-05-03 16:11:35',11.00,1),(2797,7,'2024-05-03 16:11:35',9.80,2),(2798,7,'2024-05-03 16:11:35',9.80,2),(2799,7,'2024-05-03 16:11:36',11.00,1),(2800,7,'2024-05-03 16:11:36',9.80,2),(2801,7,'2024-05-03 16:11:37',11.00,1),(2802,7,'2024-05-03 16:11:37',9.80,2),(2803,7,'2024-05-03 16:11:38',11.00,1),(2804,7,'2024-05-03 16:11:39',11.00,1),(2805,7,'2024-05-03 16:11:40',11.00,1),(2806,7,'2024-05-03 16:11:40',9.80,2),(2807,7,'2024-05-03 16:11:40',9.80,2),(2808,7,'2024-05-03 16:11:41',11.00,1),(2809,7,'2024-05-03 16:11:41',9.80,2),(2810,7,'2024-05-03 16:11:42',11.00,1),(2811,7,'2024-05-03 16:11:43',11.00,1),(2812,7,'2024-05-03 16:11:44',11.00,1),(2813,7,'2024-05-03 16:11:44',10.10,2),(2814,7,'2024-05-03 16:11:44',10.10,2),(2815,7,'2024-05-03 16:11:45',11.00,1),(2816,7,'2024-05-03 16:11:46',10.70,1),(2817,7,'2024-05-03 16:11:47',10.40,1),(2818,7,'2024-05-03 16:11:48',10.10,1),(2819,7,'2024-05-03 16:11:49',9.80,1),(2820,7,'2024-05-03 16:11:50',9.50,1),(2821,7,'2024-05-03 16:11:51',9.20,1),(2822,7,'2024-05-03 16:11:52',8.90,1),(2823,7,'2024-05-03 16:11:53',8.60,1),(2824,7,'2024-05-03 16:11:54',8.30,1),(2825,7,'2024-05-03 16:11:55',8.00,1),(2826,7,'2024-05-03 16:11:56',8.00,1),(2827,7,'2024-05-03 16:11:57',8.00,1),(2828,7,'2024-05-03 16:11:58',8.00,1),(2829,7,'2024-05-03 16:11:59',8.00,1),(2830,7,'2024-05-03 16:12:00',8.00,1),(2831,7,'2024-05-03 16:12:01',8.00,1),(2832,7,'2024-05-03 16:12:02',8.00,1),(2833,7,'2024-05-03 16:12:03',8.00,1),(2834,7,'2024-05-03 16:12:04',8.00,1),(2835,7,'2024-05-03 16:12:05',8.00,1),(2836,7,'2024-05-03 16:12:06',8.30,1),(2837,7,'2024-05-03 16:12:07',8.60,1),(2838,7,'2024-05-03 16:12:08',8.90,1),(2839,7,'2024-05-03 16:12:09',9.20,1),(2840,7,'2024-05-03 16:12:10',9.50,1),(2841,7,'2024-05-03 16:12:11',9.80,1),(2842,7,'2024-05-03 16:12:12',10.10,1),(2843,7,'2024-05-03 16:12:13',10.40,1),(2844,7,'2024-05-03 16:12:14',10.70,1),(2845,7,'2024-05-03 16:12:15',11.00,1),(2846,7,'2024-05-03 16:12:16',11.00,1),(2847,7,'2024-05-03 16:12:17',11.00,1),(2848,7,'2024-05-03 16:12:18',11.00,1),(2849,7,'2024-05-03 16:12:19',11.00,1),(2850,7,'2024-05-03 16:12:20',11.00,1),(2851,7,'2024-05-03 16:12:21',11.00,1),(2852,7,'2024-05-03 16:12:22',11.00,1),(2853,7,'2024-05-03 16:12:23',11.00,1),(2854,7,'2024-05-03 16:12:24',11.00,1),(2855,7,'2024-05-03 16:12:25',11.00,1),(2856,7,'2024-05-03 16:12:26',10.70,1),(2857,7,'2024-05-03 16:12:27',10.40,1),(2858,7,'2024-05-03 16:12:28',10.10,1),(2859,7,'2024-05-03 16:12:29',9.80,1),(2860,7,'2024-05-03 16:12:31',9.50,1),(2861,7,'2024-05-03 16:12:32',9.20,1),(2862,7,'2024-05-03 16:12:33',8.90,1),(2863,7,'2024-05-03 16:12:34',8.60,1),(2864,7,'2024-05-03 16:12:35',8.30,1),(2865,7,'2024-05-03 16:12:36',8.00,1),(2866,7,'2024-05-03 16:12:37',8.00,1),(2867,7,'2024-05-03 16:12:38',8.00,1),(2868,7,'2024-05-03 16:12:39',8.00,1),(2869,7,'2024-05-03 16:12:40',8.00,1),(2870,7,'2024-05-03 16:12:41',8.00,1),(2871,7,'2024-05-03 16:12:42',8.00,1),(2872,7,'2024-05-03 16:12:43',8.00,1),(2873,7,'2024-05-03 16:12:44',8.00,1),(2874,7,'2024-05-03 16:12:45',8.00,1),(2875,7,'2024-05-03 16:12:46',8.00,1),(2876,7,'2024-05-03 16:12:47',7.70,1),(2877,7,'2024-05-03 16:12:48',7.40,1),(2878,7,'2024-05-03 16:12:49',7.10,1),(2879,7,'2024-05-03 16:12:50',6.80,1),(2880,7,'2024-05-03 16:12:51',6.50,1),(2881,7,'2024-05-03 16:12:52',6.20,1),(2882,7,'2024-05-03 16:12:53',5.90,1),(2883,7,'2024-05-03 16:12:54',5.60,1),(2884,7,'2024-05-03 16:12:55',5.30,1),(2885,7,'2024-05-03 16:12:56',5.00,1),(2886,7,'2024-05-03 16:12:57',5.00,1),(2887,7,'2024-05-03 16:12:58',5.00,1),(2888,7,'2024-05-03 16:12:59',5.00,1),(2889,7,'2024-05-03 16:13:00',5.00,1),(2890,7,'2024-05-03 16:13:01',5.00,1),(2891,7,'2024-05-03 16:13:02',5.00,1),(2892,7,'2024-05-03 16:13:03',5.00,1),(2893,7,'2024-05-03 16:13:04',5.00,1),(2894,7,'2024-05-03 16:13:05',5.00,1),(2895,7,'2024-05-03 16:13:06',5.00,1),(2896,7,'2024-05-03 16:13:07',5.30,1),(2897,7,'2024-05-03 16:13:08',5.60,1),(2898,7,'2024-05-03 16:13:08',10.40,2),(2899,7,'2024-05-03 16:13:09',10.10,2),(2900,7,'2024-05-03 16:13:10',9.80,2),(2901,7,'2024-05-03 16:13:11',9.50,2),(2902,7,'2024-05-03 16:13:12',6.80,1),(2903,7,'2024-05-03 16:13:13',7.10,1),(2904,7,'2024-05-03 16:13:13',9.20,2),(2905,7,'2024-05-03 16:13:14',7.40,1),(2906,7,'2024-05-03 16:13:14',9.20,2),(2907,7,'2024-05-03 16:13:15',7.70,1),(2908,7,'2024-05-03 16:13:15',9.20,2),(2909,7,'2024-05-03 16:13:16',8.00,1),(2910,7,'2024-05-03 16:13:16',9.20,2),(2911,7,'2024-05-03 16:13:17',8.00,1),(2912,7,'2024-05-03 16:13:18',8.00,1),(2913,7,'2024-05-03 16:13:18',9.20,2),(2914,7,'2024-05-03 16:13:18',9.20,2),(2915,7,'2024-05-03 16:13:19',8.00,1),(2916,7,'2024-05-03 16:13:19',9.20,2),(2917,7,'2024-05-03 16:13:20',8.00,1),(2918,7,'2024-05-03 16:13:20',9.20,2),(2919,7,'2024-05-03 16:13:21',8.00,1),(2920,7,'2024-05-03 16:13:22',8.00,1),(2921,7,'2024-05-03 16:13:22',9.80,2),(2922,7,'2024-05-03 16:13:23',8.00,1),(2923,7,'2024-05-03 16:13:23',10.10,2),(2924,7,'2024-05-03 16:13:24',8.00,1),(2925,7,'2024-05-03 16:13:24',10.40,2),(2926,7,'2024-05-03 16:13:25',8.00,1),(2927,7,'2024-05-03 16:13:26',8.00,1),(2928,7,'2024-05-03 16:13:27',7.70,1),(2929,7,'2024-05-03 16:13:28',7.40,1),(2930,7,'2024-05-03 16:13:29',7.10,1),(2931,7,'2024-05-03 16:13:30',6.80,1),(2932,7,'2024-05-03 16:13:31',6.50,1),(2933,7,'2024-05-03 16:13:32',6.20,1),(2934,7,'2024-05-03 16:13:33',5.90,1),(2935,7,'2024-05-03 16:13:34',5.60,1),(2936,7,'2024-05-03 16:13:35',5.30,1),(2937,7,'2024-05-03 16:13:36',5.00,1),(2938,7,'2024-05-03 16:13:37',5.00,1),(2939,7,'2024-05-03 16:13:38',5.00,1),(2940,7,'2024-05-03 16:13:39',5.00,1),(2941,7,'2024-05-03 16:13:40',5.00,1),(2942,7,'2024-05-03 16:13:41',5.00,1),(2943,7,'2024-05-03 16:13:42',5.00,1),(2944,7,'2024-05-03 16:13:43',5.00,1),(2945,7,'2024-05-03 16:13:44',5.00,1),(2946,7,'2024-05-03 16:13:45',5.00,1),(2947,7,'2024-05-03 16:13:46',5.00,1),(2948,7,'2024-05-03 16:13:47',5.00,1),(2949,7,'2024-05-03 16:13:48',5.00,1),(2950,7,'2024-05-03 16:13:49',5.00,1),(2951,7,'2024-05-03 16:13:50',5.00,1),(2952,7,'2024-05-03 16:13:51',5.00,1),(2953,7,'2024-05-03 16:13:52',5.00,1),(2954,7,'2024-05-03 16:13:53',5.00,1),(2955,7,'2024-05-03 16:13:54',5.00,1),(2956,7,'2024-05-03 16:13:55',5.00,1),(2957,7,'2024-05-03 16:13:56',5.00,1),(2958,7,'2024-05-03 16:13:57',5.00,1),(2959,7,'2024-05-03 16:13:58',5.00,1),(2960,7,'2024-05-03 16:13:59',5.00,1),(2961,7,'2024-05-03 16:14:00',5.00,1),(2962,7,'2024-05-03 16:14:01',5.00,1),(2963,7,'2024-05-03 16:14:02',5.00,1),(2964,7,'2024-05-03 16:14:03',5.00,1),(2965,7,'2024-05-03 16:14:04',5.00,1),(2966,7,'2024-05-03 16:14:05',5.00,1),(2967,7,'2024-05-03 16:14:06',5.00,1),(2968,7,'2024-05-03 16:14:07',5.00,1),(2969,7,'2024-05-03 16:14:08',5.00,1),(2970,7,'2024-05-03 16:14:09',5.00,1),(2971,7,'2024-05-03 16:14:10',5.00,1),(2972,7,'2024-05-03 16:14:11',5.00,1),(2973,7,'2024-05-03 16:14:12',5.00,1),(2974,7,'2024-05-03 16:14:13',5.00,1),(2975,7,'2024-05-03 16:14:14',5.00,1),(2976,7,'2024-05-03 16:14:15',5.00,1),(2977,7,'2024-05-03 16:14:16',5.00,1),(2978,7,'2024-05-03 16:14:17',5.00,1),(2979,7,'2024-05-03 16:14:18',5.00,1),(2980,7,'2024-05-03 16:14:19',5.00,1),(2981,7,'2024-05-03 16:14:20',5.00,1),(2982,7,'2024-05-03 16:14:21',5.00,1),(2983,7,'2024-05-03 16:14:22',5.00,1),(2984,7,'2024-05-03 16:14:23',5.00,1),(2985,7,'2024-05-03 16:14:24',5.00,1),(2986,7,'2024-05-03 16:14:25',5.00,1),(2987,7,'2024-05-03 16:14:26',5.00,1),(2988,7,'2024-05-03 16:14:27',5.30,1),(2989,7,'2024-05-03 16:14:28',5.60,1),(2990,7,'2024-05-03 16:14:29',5.90,1),(2991,7,'2024-05-03 16:14:30',6.20,1),(2992,7,'2024-05-03 16:14:31',6.50,1),(2993,7,'2024-05-03 16:14:32',6.80,1),(2994,7,'2024-05-03 16:14:33',7.10,1),(2995,7,'2024-05-03 16:14:34',7.40,1),(2996,7,'2024-05-03 16:14:35',7.70,1),(2997,7,'2024-05-03 16:14:36',8.00,1),(2998,7,'2024-05-03 16:14:37',8.00,1),(2999,7,'2024-05-03 16:14:38',8.00,1),(3000,7,'2024-05-03 16:14:39',8.00,1),(3001,7,'2024-05-03 16:14:40',8.00,1),(3002,7,'2024-05-03 16:14:41',8.00,1),(3003,7,'2024-05-03 16:14:42',8.00,1),(3004,7,'2024-05-03 16:14:43',8.00,1),(3005,7,'2024-05-03 16:14:44',8.00,1),(3006,7,'2024-05-03 16:14:45',8.00,1),(3007,7,'2024-05-03 16:14:46',8.00,1),(3008,7,'2024-05-03 16:14:47',7.70,1),(3009,7,'2024-05-03 16:14:48',7.40,1),(3010,7,'2024-05-03 16:14:49',7.10,1),(3011,7,'2024-05-03 16:14:50',6.80,1),(3012,7,'2024-05-03 16:14:51',6.50,1),(3013,7,'2024-05-03 16:14:52',6.20,1),(3014,7,'2024-05-03 16:14:53',5.90,1),(3015,7,'2024-05-03 16:14:54',5.60,1),(3016,7,'2024-05-03 16:14:55',5.30,1),(3017,7,'2024-05-03 16:14:56',5.00,1),(3018,7,'2024-05-03 16:14:57',5.00,1),(3019,7,'2024-05-03 16:14:58',5.00,1),(3020,7,'2024-05-03 16:14:59',5.00,1),(3021,7,'2024-05-03 16:15:00',5.00,1),(3022,7,'2024-05-03 16:15:01',5.00,1),(3023,7,'2024-05-03 16:15:02',5.00,1),(3024,7,'2024-05-03 16:15:03',5.00,1),(3025,7,'2024-05-03 16:15:04',5.00,1),(3026,7,'2024-05-03 16:15:05',5.00,1),(3027,7,'2024-05-03 16:15:06',5.00,1),(3028,7,'2024-05-03 16:15:07',5.30,1),(3029,7,'2024-05-03 16:15:08',5.60,1),(3030,7,'2024-05-03 16:15:09',5.90,1),(3031,7,'2024-05-03 16:15:10',6.20,1),(3032,7,'2024-05-03 16:15:11',6.50,1),(3033,7,'2024-05-03 16:15:12',6.80,1),(3034,7,'2024-05-03 16:15:13',7.10,1),(3035,7,'2024-05-03 16:15:14',7.40,1),(3036,7,'2024-05-03 16:15:15',7.70,1),(3037,7,'2024-05-03 16:15:16',8.00,1),(3038,7,'2024-05-03 16:15:17',8.00,1),(3039,7,'2024-05-03 16:15:18',8.00,1),(3040,7,'2024-05-03 16:15:19',8.00,1),(3041,7,'2024-05-03 16:15:20',8.00,1),(3042,7,'2024-05-03 16:15:21',8.00,1),(3043,7,'2024-05-03 16:15:22',8.00,1),(3044,7,'2024-05-03 16:15:23',8.00,1),(3045,7,'2024-05-03 16:15:24',8.00,1),(3046,7,'2024-05-03 16:15:25',8.00,1),(3047,7,'2024-05-03 16:15:26',8.00,1),(3048,7,'2024-05-03 16:15:27',8.30,1),(3049,7,'2024-05-03 16:15:28',8.60,1),(3050,7,'2024-05-03 16:15:29',8.90,1),(3051,7,'2024-05-03 16:15:30',9.20,1),(3052,7,'2024-05-03 16:15:31',9.50,1),(3053,7,'2024-05-03 16:15:32',9.80,1),(3054,7,'2024-05-03 16:15:33',10.10,1),(3055,7,'2024-05-03 16:15:34',10.40,1),(3056,7,'2024-05-03 16:15:35',10.70,1),(3057,7,'2024-05-03 16:15:36',11.00,1),(3058,7,'2024-05-03 16:15:37',11.00,1),(3059,7,'2024-05-03 16:15:38',11.00,1),(3060,7,'2024-05-03 16:15:39',11.00,1),(3061,7,'2024-05-03 16:15:40',11.00,1),(3062,7,'2024-05-03 16:15:41',11.00,1),(3063,7,'2024-05-03 16:15:42',11.00,1),(3064,7,'2024-05-03 16:15:43',11.00,1),(3065,7,'2024-05-03 16:15:44',11.00,1),(3066,7,'2024-05-03 16:15:45',11.00,1),(3067,7,'2024-05-03 16:15:46',11.00,1),(3068,7,'2024-05-03 16:15:47',10.70,1),(3069,7,'2024-05-03 16:15:48',10.40,1),(3070,7,'2024-05-03 16:15:49',10.10,1),(3071,7,'2024-05-03 16:15:50',9.80,1),(3072,7,'2024-05-03 16:15:51',9.50,1),(3073,7,'2024-05-03 16:15:52',9.20,1),(3074,7,'2024-05-03 16:15:53',8.90,1),(3075,7,'2024-05-03 16:15:54',8.60,1),(3076,7,'2024-05-03 16:15:55',8.30,1),(3077,7,'2024-05-03 16:15:56',8.00,1),(3078,7,'2024-05-03 16:15:57',8.00,1),(3079,7,'2024-05-03 16:15:58',8.00,1),(3080,7,'2024-05-03 16:15:59',8.00,1),(3081,7,'2024-05-03 16:16:00',8.00,1),(3082,7,'2024-05-03 16:16:01',8.00,1),(3083,7,'2024-05-03 16:16:02',8.00,1),(3084,7,'2024-05-03 16:16:03',8.00,1),(3085,7,'2024-05-03 16:16:04',8.00,1),(3086,7,'2024-05-03 16:16:05',8.00,1),(3087,7,'2024-05-03 16:16:05',10.10,2),(3088,7,'2024-05-03 16:16:05',10.10,2),(3089,7,'2024-05-03 16:16:06',8.00,1),(3090,7,'2024-05-03 16:16:07',7.70,1),(3091,7,'2024-05-03 16:16:07',9.50,2),(3092,7,'2024-05-03 16:16:08',7.40,1),(3093,7,'2024-05-03 16:16:08',9.20,2),(3094,7,'2024-05-03 16:16:09',7.10,1),(3095,7,'2024-05-03 16:16:10',6.80,1),(3096,7,'2024-05-03 16:16:11',6.50,1),(3097,7,'2024-05-03 16:16:11',9.20,2),(3098,7,'2024-05-03 16:16:12',6.20,1),(3099,7,'2024-05-03 16:16:12',9.20,2),(3100,7,'2024-05-03 16:16:13',9.20,2),(3101,7,'2024-05-03 16:16:15',9.20,2),(3102,7,'2024-05-03 16:16:15',9.20,2),(3103,7,'2024-05-03 16:16:16',9.20,2),(3104,7,'2024-05-03 16:16:17',8.90,2),(3105,7,'2024-05-03 16:16:18',8.60,2),(3106,7,'2024-05-03 16:16:19',8.30,2),(3107,7,'2024-05-03 16:16:20',8.00,2),(3108,7,'2024-05-03 16:16:21',5.00,1),(3109,7,'2024-05-03 16:16:21',7.70,2),(3110,7,'2024-05-03 16:16:22',5.00,1),(3111,7,'2024-05-03 16:16:22',7.40,2),(3112,7,'2024-05-03 16:16:23',5.00,1),(3113,7,'2024-05-03 16:16:23',7.10,2),(3114,7,'2024-05-03 16:16:24',5.00,1),(3115,7,'2024-05-03 16:16:24',6.80,2),(3116,7,'2024-05-03 16:16:25',5.00,1),(3117,7,'2024-05-03 16:16:25',6.80,2),(3118,7,'2024-05-03 16:16:26',5.00,1),(3119,7,'2024-05-03 16:16:26',6.80,2),(3120,7,'2024-05-03 16:16:27',5.30,1),(3121,7,'2024-05-03 16:16:27',6.80,2),(3122,7,'2024-05-03 16:16:28',5.60,1),(3123,7,'2024-05-03 16:16:28',6.80,2),(3124,7,'2024-05-03 16:16:29',5.90,1),(3125,7,'2024-05-03 16:16:29',6.80,2),(3126,7,'2024-05-03 16:16:30',6.20,1),(3127,7,'2024-05-03 16:16:30',6.80,2),(3128,7,'2024-05-03 16:16:31',6.50,1),(3129,7,'2024-05-03 16:16:32',6.80,1),(3130,7,'2024-05-03 16:16:32',6.80,2),(3131,7,'2024-05-03 16:16:33',7.10,1),(3132,7,'2024-05-03 16:16:33',6.50,2),(3133,7,'2024-05-03 16:16:34',7.40,1),(3134,7,'2024-05-03 16:16:35',7.70,1),(3135,7,'2024-05-03 16:16:35',5.90,2),(3136,7,'2024-05-03 16:16:35',5.90,2),(3137,7,'2024-05-03 16:16:36',8.00,1),(3138,7,'2024-05-03 16:16:36',5.60,2),(3139,7,'2024-05-03 16:16:37',8.00,1),(3140,7,'2024-05-03 16:16:37',5.30,2),(3141,7,'2024-05-03 16:16:38',8.00,1),(3142,7,'2024-05-03 16:16:38',5.00,2),(3143,7,'2024-05-03 16:16:39',8.00,1),(3144,7,'2024-05-03 16:16:40',8.00,1),(3145,7,'2024-05-03 16:16:41',8.00,1),(3146,7,'2024-05-03 16:16:42',8.00,1),(3147,7,'2024-05-03 16:16:42',5.00,2),(3148,7,'2024-05-03 16:16:42',5.00,2),(3149,7,'2024-05-03 16:16:43',8.00,1),(3150,7,'2024-05-03 16:16:44',8.00,1),(3151,7,'2024-05-03 16:16:45',8.00,1),(3152,7,'2024-05-03 16:16:45',5.00,2),(3153,7,'2024-05-03 16:16:46',8.00,1),(3154,7,'2024-05-03 16:16:46',5.00,2),(3155,7,'2024-05-03 16:16:47',5.00,2),(3156,7,'2024-05-03 16:16:48',5.00,2),(3157,7,'2024-05-03 16:16:51',5.00,2),(3158,7,'2024-05-03 16:16:52',5.00,2),(3159,7,'2024-05-03 16:16:53',5.00,2),(3160,7,'2024-05-03 16:16:54',5.00,2),(3161,7,'2024-05-03 16:16:55',5.00,2),(3162,7,'2024-05-03 16:16:56',5.00,2),(3163,7,'2024-05-03 16:16:57',5.00,2),(3164,7,'2024-05-03 16:16:59',5.00,2),(3165,7,'2024-05-03 16:17:00',5.00,2),(3166,7,'2024-05-03 16:17:01',5.00,2),(3167,7,'2024-05-03 16:17:02',5.00,2),(3168,7,'2024-05-03 16:17:04',5.00,2),(3169,7,'2024-05-03 16:17:05',5.30,2),(3170,7,'2024-05-03 16:17:06',5.60,2),(3171,7,'2024-05-03 16:17:08',6.20,2),(3172,7,'2024-05-03 16:17:10',6.80,2),(3173,7,'2024-05-03 16:17:11',7.10,2),(3174,7,'2024-05-03 16:17:12',7.40,2),(3175,7,'2024-05-03 16:17:15',7.40,2),(3176,7,'2024-05-03 16:17:16',7.40,2),(3177,7,'2024-05-03 16:17:17',7.40,2),(3178,7,'2024-05-03 16:17:18',7.40,2),(3179,7,'2024-05-03 16:17:19',7.40,2),(3180,7,'2024-05-03 16:17:20',7.40,2),(3181,7,'2024-05-03 16:17:21',7.10,2),(3182,7,'2024-05-03 16:17:22',6.80,2),(3183,7,'2024-05-03 16:17:23',6.50,2),(3184,7,'2024-05-03 16:17:24',6.20,2),(3185,7,'2024-05-03 16:17:25',5.90,2),(3186,7,'2024-05-03 16:17:26',5.60,2),(3187,7,'2024-05-03 16:17:28',5.00,2),(3188,7,'2024-05-03 16:17:28',5.00,2),(3189,7,'2024-05-03 16:17:29',5.00,2),(3190,7,'2024-05-03 16:17:30',5.00,2),(3191,7,'2024-05-03 16:17:31',5.00,2),(3192,7,'2024-05-03 16:17:33',5.00,2),(3193,7,'2024-05-03 16:17:33',5.00,2),(3194,7,'2024-05-03 16:17:36',5.00,2),(3195,7,'2024-05-03 16:17:36',5.00,2),(3196,7,'2024-05-03 16:17:36',5.00,2),(3197,7,'2024-05-03 16:17:37',5.30,2),(3198,7,'2024-05-03 16:17:39',5.90,2),(3199,7,'2024-05-03 16:17:41',6.50,2),(3200,7,'2024-05-03 16:17:44',7.40,2),(3201,7,'2024-05-03 16:17:46',7.40,2),(3202,7,'2024-05-03 16:17:46',7.40,2),(3203,7,'2024-05-03 16:17:47',7.40,2),(3204,7,'2024-05-03 16:17:48',7.40,2),(3205,7,'2024-05-03 16:17:50',7.40,2),(3206,7,'2024-05-03 16:17:53',7.10,2),(3207,7,'2024-05-03 16:17:56',6.20,2),(3208,7,'2024-05-03 16:17:57',5.90,2),(3209,7,'2024-05-03 16:17:59',5.30,2),(3210,7,'2024-05-03 16:18:00',5.00,2),(3211,7,'2024-05-03 16:18:01',5.00,2),(3212,7,'2024-05-03 16:18:02',5.00,2),(3213,7,'2024-05-03 16:18:03',5.00,2),(3214,7,'2024-05-03 16:18:04',5.00,2),(3215,7,'2024-05-03 16:18:05',5.00,2),(3216,7,'2024-05-03 16:18:07',5.00,2),(3217,7,'2024-05-03 16:18:07',5.00,2),(3218,7,'2024-05-03 16:18:08',5.00,2),(3219,7,'2024-05-03 16:18:09',5.30,2),(3220,7,'2024-05-03 16:18:12',6.20,2),(3221,7,'2024-05-03 16:18:12',6.20,2),(3222,7,'2024-05-03 16:18:13',6.50,2),(3223,7,'2024-05-03 16:18:14',6.80,2),(3224,7,'2024-05-03 16:18:18',7.40,2),(3225,7,'2024-05-03 16:18:18',7.40,2),(3226,7,'2024-05-03 16:18:20',7.40,2),(3227,7,'2024-05-03 16:18:20',7.40,2),(3228,7,'2024-05-03 16:18:22',7.40,2),(3229,7,'2024-05-03 16:18:23',7.40,2),(3230,7,'2024-05-03 16:18:24',7.40,2),(3231,7,'2024-05-03 16:18:25',7.10,2),(3232,7,'2024-05-03 16:18:27',6.50,2),(3233,7,'2024-05-03 16:18:27',6.50,2),(3234,7,'2024-05-03 16:18:28',6.20,2),(3235,7,'2024-05-03 16:18:31',5.30,2),(3236,7,'2024-05-03 16:18:33',5.00,2),(3237,7,'2024-05-03 16:18:34',5.00,2),(3238,7,'2024-05-03 16:18:35',5.00,2),(3239,7,'2024-05-03 16:18:40',5.00,2),(3240,7,'2024-05-03 16:18:42',5.60,2),(3241,7,'2024-05-03 16:18:42',5.60,2),(3242,7,'2024-05-03 16:18:43',5.90,2),(3243,7,'2024-05-03 16:18:44',6.20,2),(3244,7,'2024-05-03 16:18:45',6.50,2),(3245,7,'2024-05-03 16:18:46',6.80,2),(3246,7,'2024-05-03 16:18:47',7.10,2),(3247,7,'2024-05-03 16:18:48',7.40,2),(3248,7,'2024-05-03 16:18:50',7.40,2),(3249,7,'2024-05-03 16:18:50',7.40,2),(3250,7,'2024-05-03 16:18:51',7.40,2),(3251,7,'2024-05-03 16:18:55',7.40,2),(3252,7,'2024-05-03 16:18:55',7.40,2),(3253,7,'2024-05-03 16:18:56',7.40,2),(3254,7,'2024-05-03 16:18:58',8.00,2),(3255,7,'2024-05-03 16:18:58',8.00,2),(3256,7,'2024-05-03 16:18:59',8.30,2),(3257,7,'2024-05-03 16:19:00',8.60,2),(3258,7,'2024-05-03 16:19:02',9.20,2),(3259,7,'2024-05-03 16:19:03',9.50,2),(3260,7,'2024-05-03 16:19:04',9.80,2),(3261,7,'2024-05-03 16:19:05',9.80,2),(3262,7,'2024-05-03 16:19:06',9.80,2),(3263,7,'2024-05-03 16:19:07',9.80,2),(3264,7,'2024-05-03 16:19:08',9.80,2),(3265,7,'2024-05-03 16:19:10',9.80,2),(3266,7,'2024-05-03 16:19:11',9.80,2),(3267,7,'2024-05-03 16:19:12',9.80,2),(3268,7,'2024-05-03 16:19:13',9.50,2),(3269,7,'2024-05-03 16:19:16',8.60,2),(3270,7,'2024-05-03 16:19:17',8.30,2),(3271,7,'2024-05-03 16:19:18',8.00,2),(3272,7,'2024-05-03 16:19:19',7.70,2),(3273,7,'2024-05-03 16:19:20',7.40,2),(3274,7,'2024-05-03 16:19:23',7.40,2),(3275,7,'2024-05-03 16:19:23',7.40,2),(3276,7,'2024-05-03 16:19:23',7.40,2),(3277,7,'2024-05-03 16:19:24',7.40,2),(3278,7,'2024-05-03 16:19:25',7.40,2),(3279,7,'2024-05-03 16:19:26',7.40,2),(3280,7,'2024-05-03 16:19:30',6.80,2),(3281,7,'2024-05-03 16:19:33',5.90,2),(3282,7,'2024-05-03 16:19:33',5.90,2),(3283,7,'2024-05-03 16:19:34',5.60,2),(3284,7,'2024-05-03 16:19:35',5.30,2),(3285,7,'2024-05-03 16:19:36',5.00,2),(3286,7,'2024-05-03 16:19:37',5.00,2),(3287,7,'2024-05-03 16:19:38',5.00,2),(3288,7,'2024-05-03 16:19:40',5.00,2),(3289,7,'2024-05-03 16:19:42',5.00,2),(3290,7,'2024-05-03 16:19:42',5.00,2),(3291,7,'2024-05-03 16:19:44',5.00,2),(3292,7,'2024-05-03 16:19:44',5.00,2),(3293,7,'2024-05-03 16:19:47',5.00,2),(3294,7,'2024-05-03 16:19:47',5.00,2),(3295,7,'2024-05-03 16:19:50',5.00,2),(3296,7,'2024-05-03 16:19:50',5.00,2),(3297,7,'2024-05-03 16:19:50',5.00,2),(3298,7,'2024-05-03 16:19:51',5.00,2),(3299,7,'2024-05-03 16:19:52',5.00,2),(3300,7,'2024-05-03 16:19:54',5.00,2),(3301,7,'2024-05-03 16:19:54',5.00,2),(3302,7,'2024-05-03 16:19:55',5.00,2),(3303,7,'2024-05-03 16:19:56',5.00,2),(3304,7,'2024-05-03 16:19:57',5.00,2),(3305,7,'2024-05-03 16:19:59',5.00,2),(3306,7,'2024-05-03 16:20:00',5.00,2),(3307,7,'2024-05-03 16:20:02',5.00,2),(3308,7,'2024-05-03 16:20:05',5.00,2),(3309,7,'2024-05-03 16:20:06',5.00,2),(3310,7,'2024-05-03 16:20:08',5.00,2),(3311,7,'2024-05-03 16:20:08',5.00,2),(3312,7,'2024-05-03 16:20:09',5.00,2),(3313,7,'2024-05-03 16:20:13',5.00,2),(3314,7,'2024-05-03 16:20:13',5.00,2),(3315,7,'2024-05-03 16:20:13',5.00,2),(3316,7,'2024-05-03 16:20:17',5.30,2),(3317,7,'2024-05-03 16:20:17',5.30,2),(3318,7,'2024-05-03 16:20:18',5.60,2),(3319,7,'2024-05-03 16:20:18',5.60,2),(3320,7,'2024-05-03 16:20:19',5.90,2),(3321,7,'2024-05-03 16:20:20',6.20,2),(3322,7,'2024-05-03 16:20:22',6.80,2),(3323,7,'2024-05-03 16:20:24',7.40,2),(3324,7,'2024-05-03 16:20:25',7.40,2),(3325,7,'2024-05-03 16:20:26',7.40,2),(3326,7,'2024-05-03 16:20:31',7.40,2),(3327,7,'2024-05-03 16:20:31',7.40,2),(3328,7,'2024-05-03 16:20:33',7.70,2),(3329,7,'2024-05-03 16:20:33',7.70,2),(3330,7,'2024-05-03 16:20:35',8.30,2),(3331,7,'2024-05-03 16:20:35',8.30,2),(3332,7,'2024-05-03 16:20:36',8.60,2),(3333,7,'2024-05-03 16:20:37',8.90,2),(3334,7,'2024-05-03 16:20:38',9.20,2),(3335,7,'2024-05-03 16:20:39',9.50,2),(3336,7,'2024-05-03 16:20:42',9.80,2),(3337,7,'2024-05-03 16:20:42',9.80,2),(3338,7,'2024-05-03 16:20:44',9.80,2),(3339,7,'2024-05-03 16:20:46',9.80,2),(3340,7,'2024-05-03 16:20:46',9.80,2),(3341,7,'2024-05-03 16:20:47',9.80,2),(3342,7,'2024-05-03 16:20:49',9.50,2),(3343,7,'2024-05-03 16:20:51',8.90,2),(3344,7,'2024-05-03 16:20:53',8.30,2),(3345,7,'2024-05-03 16:20:55',7.70,2),(3346,7,'2024-05-03 16:20:57',7.40,2),(3347,7,'2024-05-03 16:21:01',7.40,2),(3348,7,'2024-05-03 16:21:01',7.40,2),(3349,7,'2024-05-03 16:21:01',7.40,2),(3350,7,'2024-05-03 16:21:02',7.40,2),(3351,7,'2024-05-03 16:21:02',7.40,2),(3352,7,'2024-05-03 16:21:03',7.40,2),(3353,7,'2024-05-03 16:21:05',7.70,2),(3354,7,'2024-05-03 16:21:05',7.70,2),(3355,7,'2024-05-03 16:21:06',8.00,2),(3356,7,'2024-05-03 16:21:07',8.30,2),(3357,7,'2024-05-03 16:21:08',8.60,2),(3358,7,'2024-05-03 16:21:10',9.20,2),(3359,7,'2024-05-03 16:21:11',9.50,2),(3360,7,'2024-05-03 16:21:13',9.80,2),(3361,7,'2024-05-03 16:21:13',9.80,2),(3362,7,'2024-05-03 16:21:14',9.80,2),(3363,7,'2024-05-03 16:21:16',9.80,2),(3364,7,'2024-05-03 16:21:18',9.80,2),(3365,7,'2024-05-03 16:21:18',9.80,2),(3366,7,'2024-05-03 16:21:20',9.80,2),(3367,7,'2024-05-03 16:21:43',10.10,2),(3368,7,'2024-05-03 16:21:45',9.80,2),(3369,7,'2024-05-03 16:21:45',9.80,2),(3370,7,'2024-05-03 16:21:46',9.80,2),(3371,7,'2024-05-03 16:21:47',9.80,2),(3372,7,'2024-05-03 16:21:51',9.80,2),(3373,7,'2024-05-03 16:21:52',9.80,2),(3374,7,'2024-05-03 16:22:10',12.80,1),(3375,7,'2024-05-03 16:22:11',12.50,1),(3376,7,'2024-05-03 16:22:12',12.20,1),(3377,7,'2024-05-03 16:22:13',11.90,1),(3378,7,'2024-05-03 16:22:14',11.60,1),(3379,7,'2024-05-03 16:22:15',11.30,1),(3380,7,'2024-05-03 16:22:15',10.10,2),(3381,7,'2024-05-03 16:22:16',11.00,1),(3382,7,'2024-05-03 16:22:17',11.00,1),(3383,7,'2024-05-03 16:22:18',11.00,1),(3384,7,'2024-05-03 16:22:18',9.80,2),(3385,7,'2024-05-03 16:22:19',11.00,1),(3386,7,'2024-05-03 16:22:20',11.00,1),(3387,7,'2024-05-03 16:22:21',11.00,1),(3388,7,'2024-05-03 16:22:21',9.80,2),(3389,7,'2024-05-03 16:22:21',9.80,2),(3390,7,'2024-05-03 16:22:22',11.00,1),(3391,7,'2024-05-03 16:22:21',9.80,2),(3392,7,'2024-05-03 16:22:22',9.80,2),(3393,7,'2024-05-03 16:22:23',11.00,1),(3394,7,'2024-05-03 16:22:23',9.80,2),(3395,7,'2024-05-03 16:22:24',11.00,1),(3396,7,'2024-05-03 16:22:24',9.80,2),(3397,7,'2024-05-03 16:22:25',11.00,1),(3398,7,'2024-05-03 16:22:25',10.10,2),(3399,7,'2024-05-03 16:22:26',11.00,1),(3400,7,'2024-05-03 16:22:27',11.30,1),(3401,7,'2024-05-03 16:22:28',11.60,1),(3402,7,'2024-05-03 16:22:29',11.90,1),(3403,7,'2024-05-03 16:22:30',12.20,1),(3404,7,'2024-05-03 16:22:31',12.50,1),(3405,7,'2024-05-03 16:22:32',12.80,1),(3406,7,'2024-05-03 16:22:33',13.10,1),(3407,7,'2024-05-03 16:22:34',13.40,1),(3408,7,'2024-05-03 16:22:35',13.70,1),(3409,7,'2024-05-03 16:22:36',14.00,1),(3410,7,'2024-05-03 16:22:37',14.00,1),(3411,7,'2024-05-03 16:22:38',14.00,1),(3412,7,'2024-05-03 16:22:39',14.00,1),(3413,7,'2024-05-03 16:22:40',14.00,1),(3414,7,'2024-05-03 16:22:41',14.00,1),(3415,7,'2024-05-03 16:22:42',14.00,1),(3416,7,'2024-05-03 16:22:43',14.00,1),(3417,7,'2024-05-03 16:22:44',14.00,1),(3418,7,'2024-05-03 16:22:45',14.00,1),(3419,7,'2024-05-03 16:22:46',14.00,1),(3420,7,'2024-05-03 16:22:47',14.00,1),(3421,7,'2024-05-03 16:22:48',14.00,1),(3422,7,'2024-05-03 16:22:49',14.00,1),(3423,7,'2024-05-03 16:22:50',14.00,1),(3424,7,'2024-05-03 16:22:51',14.00,1),(3425,7,'2024-05-03 16:22:52',14.00,1),(3426,7,'2024-05-03 16:22:53',14.00,1),(3427,7,'2024-05-03 16:22:54',14.00,1),(3428,7,'2024-05-03 16:22:55',14.00,1),(3429,7,'2024-05-03 16:22:56',14.00,1),(3430,7,'2024-05-03 16:22:57',14.00,1),(3431,7,'2024-05-03 16:22:58',14.00,1),(3432,7,'2024-05-03 16:22:59',14.00,1),(3433,7,'2024-05-03 16:23:00',14.00,1),(3434,7,'2024-05-03 16:23:01',14.00,1),(3435,7,'2024-05-03 16:23:02',14.00,1),(3436,7,'2024-05-03 16:23:03',14.00,1),(3437,7,'2024-05-03 16:23:04',14.00,1),(3438,7,'2024-05-03 16:23:05',14.00,1),(3439,7,'2024-05-03 16:23:06',14.00,1),(3440,7,'2024-05-03 16:23:07',14.00,1),(3441,7,'2024-05-03 16:23:08',14.00,1),(3442,7,'2024-05-03 16:23:09',14.00,1),(3443,7,'2024-05-03 16:23:10',14.00,1),(3444,7,'2024-05-03 16:23:11',14.00,1),(3445,7,'2024-05-03 16:23:12',14.00,1),(3446,7,'2024-05-03 16:23:13',14.00,1),(3447,7,'2024-05-03 16:23:14',14.00,1),(3448,7,'2024-05-03 16:23:15',14.00,1),(3449,7,'2024-05-03 16:23:16',14.00,1),(3450,7,'2024-05-03 16:23:17',14.00,1),(3451,7,'2024-05-03 16:23:18',14.00,1),(3452,7,'2024-05-03 16:23:19',14.00,1),(3453,7,'2024-05-03 16:23:20',14.00,1),(3454,7,'2024-05-03 16:23:21',14.00,1),(3455,7,'2024-05-03 16:23:22',14.00,1),(3456,7,'2024-05-03 16:23:23',14.00,1),(3457,7,'2024-05-03 16:23:24',14.00,1),(3458,7,'2024-05-03 16:23:25',14.00,1),(3459,7,'2024-05-03 16:23:26',14.00,1),(3460,7,'2024-05-03 16:23:27',13.70,1),(3461,7,'2024-05-03 16:23:28',13.40,1),(3462,7,'2024-05-03 16:23:29',13.10,1),(3463,7,'2024-05-03 16:23:30',12.80,1),(3464,7,'2024-05-03 16:23:31',12.50,1),(3465,7,'2024-05-03 16:23:32',12.20,1),(3466,7,'2024-05-03 16:23:33',11.90,1),(3467,7,'2024-05-03 16:23:34',11.60,1),(3468,7,'2024-05-03 16:23:35',11.30,1),(3469,7,'2024-05-03 16:23:36',11.00,1),(3470,7,'2024-05-03 16:23:37',11.00,1),(3471,7,'2024-05-03 16:23:38',11.00,1),(3472,7,'2024-05-03 16:23:39',11.00,1),(3473,7,'2024-05-03 16:23:40',11.00,1),(3474,7,'2024-05-03 16:23:41',11.00,1),(3475,7,'2024-05-03 16:23:42',11.00,1),(3476,7,'2024-05-03 16:23:43',11.00,1),(3477,7,'2024-05-03 16:23:44',11.00,1),(3478,7,'2024-05-03 16:23:45',11.00,1),(3479,7,'2024-05-03 16:23:46',11.00,1),(3480,7,'2024-05-03 16:23:47',10.70,1),(3481,7,'2024-05-03 16:23:48',10.40,1),(3482,7,'2024-05-03 16:23:49',10.10,1),(3483,7,'2024-05-03 16:23:50',9.80,1),(3484,7,'2024-05-03 16:23:51',9.50,1),(3485,7,'2024-05-03 16:23:52',9.20,1),(3486,7,'2024-05-03 16:23:53',8.90,1),(3487,7,'2024-05-03 16:23:54',8.60,1),(3488,7,'2024-05-03 16:23:55',8.30,1),(3489,7,'2024-05-03 16:23:56',8.00,1),(3490,7,'2024-05-03 16:23:57',8.00,1),(3491,7,'2024-05-03 16:23:58',8.00,1),(3492,7,'2024-05-03 16:23:59',8.00,1),(3493,7,'2024-05-03 16:24:00',8.00,1),(3494,7,'2024-05-03 16:24:01',8.00,1),(3495,7,'2024-05-03 16:24:02',8.00,1),(3496,7,'2024-05-03 16:24:03',8.00,1),(3497,7,'2024-05-03 16:24:04',8.00,1),(3498,7,'2024-05-03 16:24:05',8.00,1),(3499,7,'2024-05-03 16:24:06',8.00,1),(3500,7,'2024-05-03 16:24:07',7.70,1),(3501,7,'2024-05-03 16:24:08',7.40,1),(3502,7,'2024-05-03 16:24:09',7.10,1),(3503,7,'2024-05-03 16:24:10',6.80,1),(3504,7,'2024-05-03 16:24:11',6.50,1),(3505,7,'2024-05-03 16:24:12',6.20,1),(3506,7,'2024-05-03 16:24:13',5.90,1),(3507,7,'2024-05-03 16:24:14',5.60,1),(3508,7,'2024-05-03 16:24:15',5.30,1),(3509,7,'2024-05-03 16:24:16',5.00,1),(3510,7,'2024-05-03 16:24:17',5.00,1),(3511,7,'2024-05-03 16:24:18',5.00,1),(3512,7,'2024-05-03 16:24:19',5.00,1),(3513,7,'2024-05-03 16:24:20',5.00,1),(3514,7,'2024-05-03 16:24:21',5.00,1),(3515,7,'2024-05-03 16:24:22',5.00,1),(3516,7,'2024-05-03 16:24:23',5.00,1),(3517,7,'2024-05-03 16:24:24',5.00,1),(3518,7,'2024-05-03 16:24:25',5.00,1),(3519,7,'2024-05-03 16:24:26',5.00,1),(3520,7,'2024-05-03 16:24:27',5.00,1),(3521,7,'2024-05-03 16:24:28',5.00,1),(3522,7,'2024-05-03 16:24:29',5.00,1),(3523,7,'2024-05-03 16:24:30',5.00,1),(3524,7,'2024-05-03 16:24:31',5.00,1),(3525,7,'2024-05-03 16:24:32',5.00,1),(3526,7,'2024-05-03 16:24:33',5.00,1),(3527,7,'2024-05-03 16:24:34',5.00,1),(3528,7,'2024-05-03 16:24:35',5.00,1),(3529,7,'2024-05-03 16:24:36',5.00,1),(3530,7,'2024-05-03 16:24:37',5.00,1),(3531,7,'2024-05-03 16:24:38',5.00,1),(3532,7,'2024-05-03 16:24:39',5.00,1),(3533,7,'2024-05-03 16:24:40',5.00,1),(3534,7,'2024-05-03 16:24:41',5.00,1),(3535,7,'2024-05-03 16:24:42',5.00,1),(3536,7,'2024-05-03 16:24:43',5.00,1),(3537,7,'2024-05-03 16:24:44',5.00,1),(3538,7,'2024-05-03 16:24:45',5.00,1),(3539,7,'2024-05-03 16:24:46',5.00,1),(3540,7,'2024-05-03 16:24:47',5.30,1),(3541,7,'2024-05-03 16:24:48',5.60,1),(3542,7,'2024-05-03 16:24:49',5.90,1),(3543,7,'2024-05-03 16:24:50',6.20,1),(3544,7,'2024-05-03 16:24:51',6.50,1),(3545,7,'2024-05-03 16:24:52',6.80,1),(3546,7,'2024-05-03 16:24:53',7.10,1),(3547,7,'2024-05-03 16:24:54',7.40,1),(3548,7,'2024-05-03 16:24:55',7.70,1),(3549,7,'2024-05-03 16:24:56',8.00,1),(3550,7,'2024-05-03 16:24:57',8.00,1),(3551,7,'2024-05-03 16:24:58',8.00,1),(3552,7,'2024-05-03 16:24:59',8.00,1),(3553,7,'2024-05-03 16:25:00',8.00,1),(3554,7,'2024-05-03 16:25:01',8.00,1),(3555,7,'2024-05-03 16:25:02',8.00,1),(3556,7,'2024-05-03 16:25:03',8.00,1),(3557,7,'2024-05-03 16:25:04',8.00,1),(3558,7,'2024-05-03 16:25:05',8.00,1),(3559,7,'2024-05-03 16:25:06',8.00,1),(3560,7,'2024-05-03 16:25:07',8.30,1),(3561,7,'2024-05-03 16:25:08',8.60,1),(3562,7,'2024-05-03 16:25:09',8.90,1),(3563,7,'2024-05-03 16:25:10',9.20,1),(3564,7,'2024-05-03 16:25:11',9.50,1),(3565,7,'2024-05-03 16:25:12',9.80,1),(3566,7,'2024-05-03 16:25:13',10.10,1),(3567,7,'2024-05-03 16:25:14',10.40,1),(3568,7,'2024-05-03 16:25:15',10.70,1),(3569,7,'2024-05-03 16:25:16',11.00,1),(3570,7,'2024-05-03 16:25:17',11.00,1),(3571,7,'2024-05-03 16:25:18',11.00,1),(3572,7,'2024-05-03 16:25:19',11.00,1),(3573,7,'2024-05-03 16:25:20',11.00,1),(3574,7,'2024-05-03 16:25:21',11.00,1),(3575,7,'2024-05-03 16:25:22',11.00,1),(3576,7,'2024-05-03 16:25:23',11.00,1),(3577,7,'2024-05-03 16:25:24',11.00,1),(3578,7,'2024-05-03 16:25:25',11.00,1),(3579,7,'2024-05-03 16:25:26',11.00,1),(3580,7,'2024-05-03 16:25:27',11.30,1),(3581,7,'2024-05-03 16:25:28',11.60,1),(3582,7,'2024-05-03 16:25:29',11.90,1),(3583,7,'2024-05-03 16:25:30',12.20,1),(3584,7,'2024-05-03 16:25:31',12.50,1),(3585,7,'2024-05-03 16:25:32',12.80,1),(3586,7,'2024-05-03 16:25:33',13.10,1),(3587,7,'2024-05-03 16:25:34',13.40,1),(3588,7,'2024-05-03 16:25:35',13.70,1),(3589,7,'2024-05-03 16:25:36',14.00,1),(3590,7,'2024-05-03 16:25:37',14.00,1),(3591,7,'2024-05-03 16:25:38',14.00,1),(3592,7,'2024-05-03 16:25:39',14.00,1),(3593,7,'2024-05-03 16:25:40',14.00,1),(3594,7,'2024-05-03 16:25:40',10.40,2),(3595,7,'2024-05-03 16:25:41',10.10,2),(3596,7,'2024-05-03 16:25:42',9.80,2),(3597,7,'2024-05-03 16:25:43',9.50,2),(3598,7,'2024-05-03 16:25:45',9.20,2),(3599,7,'2024-05-03 16:25:46',9.20,2),(3600,7,'2024-05-03 16:25:50',9.20,2),(3601,7,'2024-05-03 16:25:52',9.20,2),(3602,7,'2024-05-03 16:25:53',11.90,1),(3603,7,'2024-05-03 16:25:53',8.90,2),(3604,7,'2024-05-03 16:25:54',11.60,1),(3605,7,'2024-05-03 16:25:54',8.60,2),(3606,7,'2024-05-03 16:25:55',11.30,1),(3607,7,'2024-05-03 16:25:56',11.00,1),(3608,7,'2024-05-03 16:25:56',8.00,2),(3609,7,'2024-05-03 16:25:57',7.70,2),(3610,7,'2024-05-03 16:25:58',7.40,2);
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
    DECLARE max_time_without_movement INT;
    
    SET average_temp = GetAverageTemperature();
    SELECT temperatura_ideal INTO base_temp FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    SELECT variacao_temperatura_maxima INTO max_deviation FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    
    SELECT GetRunningTime() INTO running_time;
	SELECT Experiencia.segundos_sem_movimento INTO max_time_without_movement FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;    

	IF running_time > 600 THEN
    	CALL InsertNewAlert(NEW.id_experiencia, NULL, NULL, NULL, NULL, 'TempoMaxExcedido');
    END IF;
    
    IF NEW.leitura > (base_temp + (max_deviation - 1)) OR NEW.leitura < (base_temp - (max_deviation + 1)) THEN
    	CALL InsertNewAlert(NEW.id_experiencia, NEW.leitura, NULL, NULL, NEW.sensor, 'TemperaturaProximaDeExcederMax');
    END IF;
    
	IF NEW.leitura > (base_temp + max_deviation) OR NEW.leitura < (base_temp - max_deviation) THEN
    	CALL InsertNewAlert(NEW.id_experiencia, NEW.leitura, NULL, NULL, NEW.sensor, 'TemperaturaDesvioExcedido');
    END IF;
   

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
INSERT INTO `Utilizador` VALUES ('computadorGestor','computadorGestor','0','Investigador'),('olatudo@iscte-iul.pt','Ola','222333444','Investigador'),('rmnto@iscte-iul.pt','Rodrigo Timoteo','123456789','Investigador');
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
/*!50003 DROP FUNCTION IF EXISTS `GetLatestTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetLatestTest`() RETURNS int(11)
BEGIN
	DECLARE experience_id INT;

	SELECT Experiencia.id_experiencia INTO experience_id FROM Experiencia ORDER BY Experiencia.id_experiencia DESC LIMIT 1;
    
    RETURN experience_id;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `FinishTest`()
BEGIN
	DECLARE test_id INT;
    
    SET test_id = GetRunningTest();
    
    IF test_id IS NOT NULL THEN
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
/*!50003 DROP PROCEDURE IF EXISTS `InsertMedicaoSala` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertMedicaoSala`(IN `id_exp` INT, IN `num_ratos` INT)
BEGIN
   INSERT INTO MedicoesSalas(id_experiencia, sala_0, sala_1, sala_2, sala_3, sala_4, sala_5, sala_6, sala_7, sala_8, sala_9)
   VALUES(id_exp, num_ratos, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
	DECLARE tempo TIMESTAMP DEFAULT NOW();
    DECLARE id_exp INT;

    INSERT INTO experiencia (descricao, estado_experiencia, numero_ratos, limite_ratos_sala, segundos_sem_movimento, temperatura_ideal, variacao_temperatura_maxima, investigador, data_hora_criacao)
    VALUES (test_description, "Por Iniciar", test_number_of_rats, test_limit_per_room, test_time_without_movement, test_ideal_temperature, test_max_temperature_deviation, test_investigador, tempo);
    
    SELECT id_experiencia INTO id_exp FROM Experiencia WHERE Experiencia.data_hora_criacao = tempo;
    
	CALL InsertMedicaoSala(id_exp, test_number_of_rats);    
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

-- Dump completed on 2024-05-05 18:16:51
