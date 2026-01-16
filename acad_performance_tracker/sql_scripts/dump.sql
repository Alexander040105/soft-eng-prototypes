-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: academic_tracker
-- ------------------------------------------------------
-- Server version	8.0.38

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `Admin_ID` int NOT NULL AUTO_INCREMENT,
  `Admin_Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Admin_Role` varchar(50) NOT NULL,
  `Department` varchar(100) DEFAULT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`Admin_ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Admin User','admin@university.edu','System Administrator','CCS','admin','admin123');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `Assignment_ID` int NOT NULL AUTO_INCREMENT,
  `Assignment_Number` int NOT NULL,
  `Score` decimal(5,2) NOT NULL,
  `Total_Items` int NOT NULL,
  `Remarks` enum('Passed','Failed','Late') DEFAULT 'Passed',
  `Term` enum('Prelim','Midterm','Finals') NOT NULL,
  `Student_ID` varchar(20) NOT NULL,
  `Subject_ID` varchar(20) NOT NULL,
  `Instructor_ID` varchar(20) NOT NULL,
  `Date_Submitted` date NOT NULL,
  `Date_Recorded` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Assignment_ID`),
  KEY `Student_ID` (`Student_ID`),
  KEY `Subject_ID` (`Subject_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE,
  CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`Subject_ID`) REFERENCES `courses` (`Subject_ID`) ON DELETE CASCADE,
  CONSTRAINT `assignments_ibfk_3` FOREIGN KEY (`Instructor_ID`) REFERENCES `professors` (`Instructor_ID`),
  CONSTRAINT `assignments_chk_1` CHECK ((`Total_Items` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignments`
--

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `Subject_ID` varchar(20) NOT NULL,
  `Section` varchar(20) DEFAULT NULL,
  `Subject_Name` varchar(150) NOT NULL,
  `Units` int NOT NULL,
  `Schedule` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Subject_ID`),
  CONSTRAINT `courses_chk_1` CHECK ((`Units` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES ('CS101','9411-AY225','Introduction to Programming',3,'MWF 10:00-11:00'),('CS102','9412-AY225','Data Structures',3,'TTH 13:00-14:30');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `Enrollment_ID` int NOT NULL AUTO_INCREMENT,
  `Student_ID` varchar(20) NOT NULL,
  `Subject_ID` varchar(20) NOT NULL,
  `Instructor_ID` varchar(20) NOT NULL,
  `Academic_Year` varchar(20) NOT NULL,
  `Semester` varchar(20) NOT NULL,
  PRIMARY KEY (`Enrollment_ID`),
  UNIQUE KEY `unique_enrollment` (`Student_ID`,`Subject_ID`,`Academic_Year`,`Semester`),
  KEY `Subject_ID` (`Subject_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE,
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`Subject_ID`) REFERENCES `courses` (`Subject_ID`) ON DELETE CASCADE,
  CONSTRAINT `enrollments_ibfk_3` FOREIGN KEY (`Instructor_ID`) REFERENCES `professors` (`Instructor_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams`
--

DROP TABLE IF EXISTS `exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exams` (
  `Exam_ID` int NOT NULL AUTO_INCREMENT,
  `Score` decimal(5,2) NOT NULL,
  `Total_Items` int NOT NULL,
  `Remarks` enum('Passed','Failed') DEFAULT 'Passed',
  `Term` enum('Prelim','Midterm','Finals') NOT NULL,
  `Student_ID` varchar(20) NOT NULL,
  `Subject_ID` varchar(20) NOT NULL,
  `Instructor_ID` varchar(20) NOT NULL,
  `Date_Taken` date NOT NULL,
  `Date_Recorded` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Exam_ID`),
  UNIQUE KEY `unique_exam` (`Student_ID`,`Subject_ID`,`Term`),
  KEY `Subject_ID` (`Subject_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE,
  CONSTRAINT `exams_ibfk_2` FOREIGN KEY (`Subject_ID`) REFERENCES `courses` (`Subject_ID`) ON DELETE CASCADE,
  CONSTRAINT `exams_ibfk_3` FOREIGN KEY (`Instructor_ID`) REFERENCES `professors` (`Instructor_ID`),
  CONSTRAINT `exams_chk_1` CHECK ((`Total_Items` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exams`
--

LOCK TABLES `exams` WRITE;
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grades` (
  `Grade_ID` int NOT NULL AUTO_INCREMENT,
  `Grade` decimal(3,2) DEFAULT NULL,
  `Term` enum('Prelim','Midterm','Finals') NOT NULL,
  `Remarks` enum('Passed','Failed','Incomplete') DEFAULT 'Incomplete',
  `Student_ID` varchar(20) NOT NULL,
  `Subject_ID` varchar(20) NOT NULL,
  `Instructor_ID` varchar(20) NOT NULL,
  `Academic_Year` varchar(20) NOT NULL,
  `Semester` varchar(20) NOT NULL,
  `Date_Recorded` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Grade_ID`),
  UNIQUE KEY `unique_grade` (`Student_ID`,`Subject_ID`,`Term`,`Academic_Year`,`Semester`),
  KEY `Subject_ID` (`Subject_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`Subject_ID`) REFERENCES `courses` (`Subject_ID`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_3` FOREIGN KEY (`Instructor_ID`) REFERENCES `professors` (`Instructor_ID`),
  CONSTRAINT `grades_chk_1` CHECK (((`Grade` >= 1.00) and (`Grade` <= 5.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professors`
--

DROP TABLE IF EXISTS `professors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `professors` (
  `Instructor_ID` varchar(20) NOT NULL,
  `Instructor_Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Department` varchar(100) DEFAULT 'CCS',
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`Instructor_ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professors`
--

LOCK TABLES `professors` WRITE;
/*!40000 ALTER TABLE `professors` DISABLE KEYS */;
INSERT INTO `professors` VALUES ('CCS001','Dr. Maria Santos','maria.santos@university.edu','CCS','maria_santos','prof123'),('CCS002','Prof. Juan Dela Cruz','juan.dela.cruz@university.edu','CCS','juan_dela_cruz','prof456');
/*!40000 ALTER TABLE `professors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `Program_ID` int NOT NULL AUTO_INCREMENT,
  `Program_Name` varchar(50) NOT NULL,
  `Department` varchar(100) DEFAULT 'CCS',
  PRIMARY KEY (`Program_ID`),
  UNIQUE KEY `Program_Name` (`Program_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'BS Computer Science','CCS'),(2,'BS Information Technology','CCS');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `Quiz_ID` int NOT NULL AUTO_INCREMENT,
  `Quiz_Number` int NOT NULL,
  `Score` decimal(5,2) NOT NULL,
  `Total_Items` int NOT NULL,
  `Remarks` enum('Passed','Failed') DEFAULT 'Passed',
  `Term` enum('Prelim','Midterm','Finals') NOT NULL,
  `Student_ID` varchar(20) NOT NULL,
  `Subject_ID` varchar(20) NOT NULL,
  `Instructor_ID` varchar(20) NOT NULL,
  `Date_Taken` date NOT NULL,
  `Date_Recorded` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Quiz_ID`),
  KEY `Student_ID` (`Student_ID`),
  KEY `Subject_ID` (`Subject_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE,
  CONSTRAINT `quizzes_ibfk_2` FOREIGN KEY (`Subject_ID`) REFERENCES `courses` (`Subject_ID`) ON DELETE CASCADE,
  CONSTRAINT `quizzes_ibfk_3` FOREIGN KEY (`Instructor_ID`) REFERENCES `professors` (`Instructor_ID`),
  CONSTRAINT `quizzes_chk_1` CHECK ((`Total_Items` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholars`
--

DROP TABLE IF EXISTS `scholars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholars` (
  `Scholar_ID` int NOT NULL AUTO_INCREMENT,
  `Student_ID` varchar(20) NOT NULL,
  `Student_Rank` int DEFAULT NULL,
  `Scholarship_Type` varchar(100) DEFAULT NULL,
  `Academic_Year` varchar(20) NOT NULL,
  `Semester` varchar(20) NOT NULL,
  `Date_Awarded` date DEFAULT (curdate()),
  PRIMARY KEY (`Scholar_ID`),
  UNIQUE KEY `Student_ID` (`Student_ID`),
  CONSTRAINT `scholars_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholars`
--

LOCK TABLES `scholars` WRITE;
/*!40000 ALTER TABLE `scholars` DISABLE KEYS */;
/*!40000 ALTER TABLE `scholars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `Student_ID` varchar(20) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Year` int NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `GWA` decimal(3,2) DEFAULT NULL,
  `Program_ID` int NOT NULL,
  PRIMARY KEY (`Student_ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`),
  KEY `Program_ID` (`Program_ID`),
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`Program_ID`) REFERENCES `programs` (`Program_ID`),
  CONSTRAINT `students_chk_1` CHECK ((`Year` between 1 and 5)),
  CONSTRAINT `students_chk_2` CHECK (((`GWA` >= 1.00) and (`GWA` <= 5.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-16  8:23:14
