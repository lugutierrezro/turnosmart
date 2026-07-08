-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: turnosmart
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `appointment_documents`
--

DROP TABLE IF EXISTS `appointment_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `appointment_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKn7lv8h7u72pl2n3iqr1jrbugt` (`appointment_id`),
  CONSTRAINT `FKn7lv8h7u72pl2n3iqr1jrbugt` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment_documents`
--

LOCK TABLES `appointment_documents` WRITE;
/*!40000 ALTER TABLE `appointment_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment_logs`
--

DROP TABLE IF EXISTS `appointment_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `appointment_id` bigint NOT NULL,
  `old_status` varchar(30) DEFAULT NULL,
  `new_status` varchar(30) NOT NULL,
  `changed_by` bigint NOT NULL COMMENT 'user_id quien cambió el estado',
  `comments` longtext,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_log_appointment` (`appointment_id`),
  KEY `fk_log_user` (`changed_by`),
  CONSTRAINT `fk_log_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_log_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment_logs`
--

LOCK TABLES `appointment_logs` WRITE;
/*!40000 ALTER TABLE `appointment_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_number` varchar(20) NOT NULL COMMENT 'Ej: TRN-2026-00245',
  `client_id` bigint NOT NULL,
  `lawyer_id` bigint DEFAULT NULL COMMENT 'NULL = cualquier abogado disponible',
  `procedure_type_id` bigint NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `client_dni` varchar(255) DEFAULT NULL,
  `notes` text,
  `status` enum('SOLICITADO','REVISION','REDACCION','LISTO_FIRMA','FIRMADO','PROTOCOLIZACION','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'SOLICITADO',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `priority` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `client_notes` text,
  `identifier` varchar(255) DEFAULT NULL,
  `is_paid` bit(1) DEFAULT NULL,
  `lawyer_notes` text,
  `operation_number` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `representation_type` varchar(255) DEFAULT NULL,
  `carta_generada_url` text,
  `client_observation` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticket_number` (`ticket_number`),
  KEY `fk_appt_lawyer` (`lawyer_id`),
  KEY `fk_appt_procedure` (`procedure_type_id`),
  KEY `idx_appt_date` (`appointment_date`),
  KEY `idx_appt_status` (`status`),
  KEY `idx_appt_client` (`client_id`),
  CONSTRAINT `fk_appt_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_appt_lawyer` FOREIGN KEY (`lawyer_id`) REFERENCES `lawyers` (`id`),
  CONSTRAINT `fk_appt_procedure` FOREIGN KEY (`procedure_type_id`) REFERENCES `procedure_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `holidays`
--

DROP TABLE IF EXISTS `holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holidays` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `holiday_date` date NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `holiday_date` (`holiday_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holidays`
--

LOCK TABLES `holidays` WRITE;
/*!40000 ALTER TABLE `holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `holidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lawyer_schedules`
--

DROP TABLE IF EXISTS `lawyer_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lawyer_schedules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lawyer_id` bigint NOT NULL,
  `day_of_week` int NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `slot_minutes` int NOT NULL DEFAULT '30' COMMENT 'Duración de cada turno en minutos',
  PRIMARY KEY (`id`),
  KEY `fk_sched_lawyer` (`lawyer_id`),
  CONSTRAINT `fk_sched_lawyer` FOREIGN KEY (`lawyer_id`) REFERENCES `lawyers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lawyer_schedules`
--

LOCK TABLES `lawyer_schedules` WRITE;
/*!40000 ALTER TABLE `lawyer_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `lawyer_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lawyers`
--

DROP TABLE IF EXISTS `lawyers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lawyers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `colegiatura` varchar(30) DEFAULT NULL COMMENT 'Número de colegiatura',
  `specialization` varchar(200) DEFAULT NULL,
  `bio` longtext,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `colegiatura` (`colegiatura`),
  CONSTRAINT `fk_lawyer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lawyers`
--

LOCK TABLES `lawyers` WRITE;
/*!40000 ALTER TABLE `lawyers` DISABLE KEYS */;
/*!40000 ALTER TABLE `lawyers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedure_types`
--

DROP TABLE IF EXISTS `procedure_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedure_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext,
  `duration_minutes` int NOT NULL DEFAULT '30' COMMENT 'Tiempo estimado del trámite',
  `active` tinyint(1) DEFAULT '1',
  `price` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedure_types`
--

LOCK TABLES `procedure_types` WRITE;
/*!40000 ALTER TABLE `procedure_types` DISABLE KEYS */;
INSERT INTO `procedure_types` VALUES (1,'Carta de Poder','Documento que otorga facultades de representación a otra persona',30,1,150),(2,'Carta de Representación Legal de Persona Jurídica','Documento que acredita la representación de una empresa u organización',45,1,140),(3,'Carta de Representación Legal de Persona Natural','Documento que acredita la representación de una persona natural',60,1,130);
/*!40000 ALTER TABLE `procedure_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'ROLE_CLIENTE, ROLE_RECEPCION, ROLE_NOTARIO, ROLE_ADMIN',
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ROLE_CLIENTE','Cliente externo que solicita turnos','2026-06-18 19:32:45'),(2,'ROLE_RECEPCION','Personal de recepción que gestiona turnos','2026-06-18 19:32:45'),(3,'ROLE_NOTARIO','Notario o abogado asignado al trámite','2026-06-18 19:32:45'),(4,'ROLE_ADMIN','Administrador del sistema','2026-06-18 19:32:45');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_ur_role` (`role_id`),
  CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (2,1),(4,1),(3,3),(1,4);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `enabled` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `birth_date` date DEFAULT NULL,
  `civil_status` varchar(255) DEFAULT NULL,
  `dni` varchar(20) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `account_locked` bit(1) NOT NULL,
  `failed_attempts` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `UK6aphui3g30h49muho4c91n0yl` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Administrador','TurnoSmart','admin@turnosmart.com','999888777','$2a$12$K3v9X7pYmR7f7wEctWOZe.8M3vK6kXkqfHvQ4jZyCqEAKqmX2Y.rG',1,'2026-06-18 19:45:16','2026-07-06 20:52:28',NULL,NULL,'12345678',NULL,_binary '\0',0),(2,'Carlos','Cliente','cliente@turnosmart.com','999111222','123456',1,'2026-06-18 19:55:20','2026-07-06 20:05:51',NULL,NULL,'87654321',NULL,_binary '\0',1),(3,'Juan','Notario','notario@turnosmart.com','999333444','123456',1,'2026-06-18 19:58:45','2026-06-18 19:58:45',NULL,NULL,'11223344',NULL,_binary '\0',0),(4,'UTP_Anthony','Yabar','anthonyabar@gmail.com','986648408','$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2',1,'2026-07-06 20:07:12','2026-07-06 20:07:11','1984-07-03','Casado/a','44403548','M',_binary '\0',0),(5,'Admin Principal','TurnoSmart','admin2@turnosmart.com','999111222','$2a$10$7Xb1Z9M5YfKwRtEctWOZe.uG9vK6kXkqfHvQ4jZyCqEAKqmX2Y.mS',4,'2026-07-06 21:09:57','2026-07-06 21:09:57',NULL,NULL,'77778888',NULL,_binary '\0',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_appointment_summary`
--

DROP TABLE IF EXISTS `v_appointment_summary`;
/*!50001 DROP VIEW IF EXISTS `v_appointment_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_appointment_summary` AS SELECT 
 1 AS `id`,
 1 AS `ticket_number`,
 1 AS `client_name`,
 1 AS `client_email`,
 1 AS `client_dni`,
 1 AS `procedure_name`,
 1 AS `lawyer_name`,
 1 AS `appointment_date`,
 1 AS `appointment_time`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_appointment_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_appointment_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_appointment_summary` AS select `a`.`id` AS `id`,`a`.`ticket_number` AS `ticket_number`,concat(`u`.`first_name`,' ',`u`.`last_name`) AS `client_name`,`u`.`email` AS `client_email`,`a`.`client_dni` AS `client_dni`,`pt`.`name` AS `procedure_name`,concat(`lu`.`first_name`,' ',`lu`.`last_name`) AS `lawyer_name`,`a`.`appointment_date` AS `appointment_date`,`a`.`appointment_time` AS `appointment_time`,`a`.`status` AS `status`,`a`.`created_at` AS `created_at` from ((((`appointments` `a` join `users` `u` on((`a`.`client_id` = `u`.`id`))) join `procedure_types` `pt` on((`a`.`procedure_type_id` = `pt`.`id`))) left join `lawyers` `l` on((`a`.`lawyer_id` = `l`.`id`))) left join `users` `lu` on((`l`.`user_id` = `lu`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-07 15:13:10
