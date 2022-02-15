-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: library
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `add_log`
--

DROP TABLE IF EXISTS `add_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `add_log` (
  `bid` char(15) NOT NULL,
  `bname` text,
  `add_date` date NOT NULL,
  `add_days` int DEFAULT NULL,
  PRIMARY KEY (`bid`,`add_date`),
  CONSTRAINT `FK_add_log` FOREIGN KEY (`bid`) REFERENCES `book` (`BID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `add_log`
--

/*!40000 ALTER TABLE `add_log` DISABLE KEYS */;
INSERT INTO `add_log` VALUES ('0000003','数据库','2021-12-27',0);
/*!40000 ALTER TABLE `add_log` ENABLE KEYS */;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrator` (
  `AID` char(15) NOT NULL,
  `PASSWORD` char(70) DEFAULT NULL,
  PRIMARY KEY (`AID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES ('admin','91b4d142823f7d20c5f08df69122de43f35f057a988d9619f6d3138485c9a203');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `BID` char(15) NOT NULL,
  `BNAME` text,
  `AUTHOR` text,
  `PUBLICATION_DATE` char(17) DEFAULT NULL,
  `PRESS` char(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `POSITION` char(10) DEFAULT NULL,
  `SUM` int DEFAULT NULL,
  `NUM` int DEFAULT NULL,
  PRIMARY KEY (`BID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('0000001','数据库原理','王珊 萨师煊','2005-01-01-00:00','高等教育出版社','A01',100,100),('0000002','计算机原理','张三','2021-01-01-00:00','华电出版社','A99',200,200),('0000003','数据库','李四','2020-01-01-00:00','河北出版社','B99',60,60),('0000203','计算机组成原理','王晓霞','2003-03-06-00:00','华电出版社','D02',56,56),('1088045','Windows核心编程','Jeffrey Richter','2000-06-26-14:03','机械工业出版社','A30',200,179),('1139336','C程序设计语言','（美）Brian W. Kernighan （美）Dennis M. Ritchie','2004-03-27-00:22','机械工业出版社','A20',30,20),('1148282','计算机程序的构造和解释','Harold Abelson Gerald Jay Sussman Julie Sussman','2004-03-27-00:21','机械工业出版社','B10',60,33),('1477390','代码大全（第2版）','[美] 史蒂夫·迈克康奈尔','2006-04-27-00:22','电子工业出版社','B11',69,38),('3004255','编程之美','《编程之美》小组 编','2008-04-26-14:03','电子工业出版社','B92',30,18),('3561811','大学物理学','张三慧','2008-04-26-14:03','电子工业出版社','B67',50,38);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `add_his` AFTER INSERT ON `book` FOR EACH ROW begin
                    insert 
                    into add_log
                    values(new.bid,new.bname,CurDate(),0);
                end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `borrowing_book`
--

DROP TABLE IF EXISTS `borrowing_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrowing_book` (
  `BID` char(15) NOT NULL,
  `SID` char(15) NOT NULL,
  `BORROW_DATE` char(17) DEFAULT NULL,
  `DEADLINE` char(17) DEFAULT NULL,
  `PUNISH` int DEFAULT NULL,
  PRIMARY KEY (`BID`,`SID`),
  KEY `FK_borrowing_book_student` (`SID`),
  CONSTRAINT `FK_borrowing_book_book` FOREIGN KEY (`BID`) REFERENCES `book` (`BID`),
  CONSTRAINT `FK_borrowing_book_student` FOREIGN KEY (`SID`) REFERENCES `student` (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrowing_book`
--

/*!40000 ALTER TABLE `borrowing_book` DISABLE KEYS */;
INSERT INTO `borrowing_book` VALUES ('1088045','220191090418','2021-12-27-09:01','2022-02-27-09:01',0);
/*!40000 ALTER TABLE `borrowing_book` ENABLE KEYS */;

--
-- Table structure for table `classification`
--

DROP TABLE IF EXISTS `classification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classification` (
  `BID` char(15) NOT NULL,
  `CLASSIFICATION` char(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`BID`,`CLASSIFICATION`),
  KEY `BID` (`BID`),
  CONSTRAINT `FK_classification_book` FOREIGN KEY (`BID`) REFERENCES `book` (`BID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification`
--

/*!40000 ALTER TABLE `classification` DISABLE KEYS */;
INSERT INTO `classification` VALUES ('0000001','数据库'),('0000002','工具类'),('0000002','科学类'),('0000002','计算机类'),('0000003','计算机类'),('0000203','计算机类'),('1088045','编程类'),('1139336','编程类'),('1148282','计算机类'),('1477390','编程类'),('3004255','编程类'),('3561811','物理学类');
/*!40000 ALTER TABLE `classification` ENABLE KEYS */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `BID` char(15) NOT NULL,
  `SID` char(15) NOT NULL,
  `BORROW_DATE` char(17) NOT NULL,
  `BACK_DATE` char(17) NOT NULL,
  `PUNISHED` int DEFAULT NULL,
  PRIMARY KEY (`BID`,`SID`,`BORROW_DATE`,`BACK_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

/*!40000 ALTER TABLE `log` DISABLE KEYS */;
INSERT INTO `log` VALUES ('0000001','220191090418','2021-12-26-10:21','2021-12-26-10:52',0),('0000001','220191090902','2021-12-22-11:19','2021-12-26-17:29',0),('0000203','220191090418','2021-12-19-16:43','2021-12-19-16:44',0),('0000203','220191090902','2021-12-22-11:19','2021-12-22-11:19',0),('0000203','220191090904','2021-12-21-15:19','2021-12-21-15:19',0),('1088045','220191090418','2021-12-19-16:43','2021-12-19-16:43',0),('1088045','220191090418','2021-12-19-16:43','2021-12-19-16:44',0),('1088045','220191090418','2021-12-19-16:49','2021-12-19-16:56',0),('1088045','220191091111','2021-12-19-17:19','2021-12-19-17:20',0),('1139336','220191090418','2021-12-19-16:49','2021-12-19-16:50',0),('1139336','220191090418','2021-12-21-12:04','2021-12-21-18:48',0),('1148282','220191090901','2021-12-22-11:08','2021-12-22-11:08',0),('1477390','220191091111','2021-12-19-17:19','2021-12-19-17:19',0),('3004255','220191091111','2021-12-21-17:35','2021-12-21-17:46',0),('3561811','220191090908','2021-12-21-18:50','2021-12-21-18:51',0),('3561811','220191091111','2021-12-21-17:50','2021-12-21-17:50',0);
/*!40000 ALTER TABLE `log` ENABLE KEYS */;

--
-- Temporary view structure for view `sel_add_book_info`
--

DROP TABLE IF EXISTS `sel_add_book_info`;
/*!50001 DROP VIEW IF EXISTS `sel_add_book_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sel_add_book_info` AS SELECT 
 1 AS `bid`,
 1 AS `bname`,
 1 AS `add_date`,
 1 AS `add_days`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `sel_borrowing_info`
--

DROP TABLE IF EXISTS `sel_borrowing_info`;
/*!50001 DROP VIEW IF EXISTS `sel_borrowing_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sel_borrowing_info` AS SELECT 
 1 AS `SID`,
 1 AS `BID`,
 1 AS `BNAME`,
 1 AS `BORROW_DATE`,
 1 AS `DEADLINE`,
 1 AS `PUNISH`,
 1 AS `NUM`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `SID` char(15) NOT NULL,
  `PASSWORD` char(70) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `SNAME` text,
  `DEPARTMENT` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `MAJOR` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES ('220191090418','5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5','穆文翰','计算机系','网络工程'),('220191090901','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','张三','计算机系','计算机科学与技术'),('220191090902','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','李四','计算机系','计算机科学与技术'),('220191090904','91b4d142823f7d20c5f08df69122de43f35f057a988d9619f6d3138485c9a203','邓茜','计算机系','计科'),('220191090908','96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e','姜雯','计算机系','网络工程'),('220191091101','91b4d142823f7d20c5f08df69122de43f35f057a988d9619f6d3138485c9a203','张懿凡一','计算机系','网络工程'),('220191091111','91b4d142823f7d20c5f08df69122de43f35f057a988d9619f6d3138485c9a203','马景怡一','计算机系','网络工程');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;

--
-- Final view structure for view `sel_add_book_info`
--

/*!50001 DROP VIEW IF EXISTS `sel_add_book_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sel_add_book_info` AS select `book`.`BID` AS `bid`,`book`.`BNAME` AS `bname`,`add_log`.`add_date` AS `add_date`,`add_log`.`add_days` AS `add_days` from (`book` join `add_log`) where (`book`.`BID` = `add_log`.`bid`) order by `add_log`.`add_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sel_borrowing_info`
--

/*!50001 DROP VIEW IF EXISTS `sel_borrowing_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sel_borrowing_info` AS select `borrowing_book`.`SID` AS `SID`,`book`.`BID` AS `BID`,`book`.`BNAME` AS `BNAME`,`borrowing_book`.`BORROW_DATE` AS `BORROW_DATE`,`borrowing_book`.`DEADLINE` AS `DEADLINE`,`borrowing_book`.`PUNISH` AS `PUNISH`,`book`.`NUM` AS `NUM` from (`borrowing_book` join `book`) where (`book`.`BID` = `borrowing_book`.`BID`) */;
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

-- Dump completed on 2021-12-27 23:07:30
