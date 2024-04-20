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
  `id_alerta` int(11) NOT NULL,
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
  `id_experiencia` int(11) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Experiencia`
--

LOCK TABLES `Experiencia` WRITE;
/*!40000 ALTER TABLE `Experiencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `Experiencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExperienciaSubstancia`
--

DROP TABLE IF EXISTS `ExperienciaSubstancia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExperienciaSubstancia` (
  `id_substancia_exp` int(11) NOT NULL,
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
  `id_medicao` int(11) NOT NULL,
  `id_experiencia` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `sala_origem` int(11) NOT NULL,
  `sala_destino` int(11) NOT NULL,
  PRIMARY KEY (`id_medicao`) USING BTREE,
  KEY `med_passagem_exp` (`id_experiencia`),
  CONSTRAINT `med_passagem_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesPassagens`
--

LOCK TABLES `MedicoesPassagens` WRITE;
/*!40000 ALTER TABLE `MedicoesPassagens` DISABLE KEYS */;
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
    
    IF NEW.sala_origem = 0 THEN
    	SELECT sala_0 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 1 THEN
    	SELECT sala_1 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 2 THEN
    	SELECT sala_2 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 3 THEN
    	SELECT sala_3 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 4 THEN
    	SELECT sala_4 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 5 THEN
    	SELECT sala_5 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 6 THEN
    	SELECT sala_6 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 7 THEN
    	SELECT sala_7 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_origem = 8 THEN
    	SELECT sala_8 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_origem = 9 THEN
    	SELECT sala_9 into originalValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
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
    
    IF NEW.sala_destino = 0 THEN
    	SELECT sala_0 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 1 THEN
    	SELECT sala_1 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 2 THEN
    	SELECT sala_2 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 3 THEN
    	SELECT sala_3 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 4 THEN
    	SELECT sala_4 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 5 THEN
    	SELECT sala_5 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 6 THEN
    	SELECT sala_6 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 7 THEN
    	SELECT sala_7 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
	ELSEIF NEW.sala_destino = 8 THEN
    	SELECT sala_8 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
    ELSEIF NEW.sala_destino = 9 THEN
    	SELECT sala_9 into finalMouseValue FROM MedicoesPassagens WHERE id_experiencia = NEW.id_experiencia;
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
  `id_medicao` int(11) NOT NULL,
  `id_experiencia` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `leitura` decimal(4,2) NOT NULL,
  `sensor` int(11) NOT NULL,
  PRIMARY KEY (`id_medicao`),
  KEY `med_temperatura_exp` (`id_experiencia`),
  CONSTRAINT `med_temperatura_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `Experiencia` (`id_experiencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedicoesTemperatura`
--

LOCK TABLES `MedicoesTemperatura` WRITE;
/*!40000 ALTER TABLE `MedicoesTemperatura` DISABLE KEYS */;
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
    SELECT variacao_temperatura_maximo INTO max_deviation FROM Experiencia WHERE id_experiencia = NEW.id_experiencia;
    
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
  `password` varchar(255) NOT NULL,
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
	INSERT INTO Utilizador (email, password, nome, telefone, tipo)
    VALUES (user_email, user_password, user_nome, user_telemovel, "Investigador");
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

-- Dump completed on 2024-04-19 17:52:40
