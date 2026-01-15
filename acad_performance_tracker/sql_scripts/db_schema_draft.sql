CREATE DATABASE IF NOT EXISTS academic_tracker;
USE academic_tracker;

CREATE TABLE Programs (
    Program_ID INT PRIMARY KEY AUTO_INCREMENT,
    Program_Name VARCHAR(50) NOT NULL UNIQUE,
    Department VARCHAR(100) DEFAULT 'CCS'
);


CREATE TABLE Students (
    Student_ID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    GWA DECIMAL(3,2) DEFAULT NULL CHECK (GWA >= 1.00 AND GWA <= 5.00),
    Program_ID INT NOT NULL,
    FOREIGN KEY (Program_ID) REFERENCES Programs(Program_ID)
);

CREATE TABLE Professors (
    Instructor_ID VARCHAR(20) PRIMARY KEY,
    Instructor_Name VARCHAR(100) NOT NULL,
    Department VARCHAR(100) DEFAULT 'CCS',
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE Admins (
    Admin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Admin_Name VARCHAR(100) NOT NULL,
    Admin_Role VARCHAR(50) NOT NULL,
    Department VARCHAR(100),
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE Courses (
    Subject_ID VARCHAR(20) PRIMARY KEY,
    Section VARCHAR(20),
    Subject_Name VARCHAR(150) NOT NULL,
    Units INT NOT NULL CHECK (Units > 0),
    Schedule VARCHAR(100)
);

-- Enrollment Table (NEW - tracks which students are taking which courses)
CREATE TABLE Enrollments (
    Enrollment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Student_ID VARCHAR(20) NOT NULL,
    Subject_ID VARCHAR(20) NOT NULL,
    Instructor_ID VARCHAR(20) NOT NULL,
    Academic_Year VARCHAR(20) NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Courses(Subject_ID) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_ID) REFERENCES Professors(Instructor_ID),
    UNIQUE KEY unique_enrollment (Student_ID, Subject_ID, Academic_Year, Semester)
);

-- Grades Table
CREATE TABLE Grades (
    Grade_ID INT PRIMARY KEY AUTO_INCREMENT,
    Grade DECIMAL(3,2) CHECK (Grade >= 1.00 AND Grade <= 5.00),
    Term ENUM('Prelim', 'Midterm', 'Finals') NOT NULL,
    Remarks ENUM('Passed', 'Failed', 'Incomplete') DEFAULT 'Incomplete',
    Student_ID VARCHAR(20) NOT NULL,
    Subject_ID VARCHAR(20) NOT NULL,
    Instructor_ID VARCHAR(20) NOT NULL,
    Academic_Year VARCHAR(20) NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Date_Recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Courses(Subject_ID) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_ID) REFERENCES Professors(Instructor_ID),
    UNIQUE KEY unique_grade (Student_ID, Subject_ID, Term, Academic_Year, Semester)
);

-- Quizzes Table
CREATE TABLE Quizzes (
    Quiz_ID INT PRIMARY KEY AUTO_INCREMENT,
    Quiz_Number INT NOT NULL,
    Score DECIMAL(5,2) NOT NULL,
    Total_Items INT NOT NULL CHECK (Total_Items > 0),
    Remarks ENUM('Passed', 'Failed') DEFAULT 'Passed',
    Term ENUM('Prelim', 'Midterm', 'Finals') NOT NULL,
    Student_ID VARCHAR(20) NOT NULL,
    Subject_ID VARCHAR(20) NOT NULL,
    Instructor_ID VARCHAR(20) NOT NULL,
    Date_Taken DATE NOT NULL,
    Date_Recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Courses(Subject_ID) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_ID) REFERENCES Professors(Instructor_ID)
);

-- Assignments Table
CREATE TABLE Assignments (
    Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Assignment_Number INT NOT NULL,
    Score DECIMAL(5,2) NOT NULL,
    Total_Items INT NOT NULL CHECK (Total_Items > 0),
    Remarks ENUM('Passed', 'Failed', 'Late') DEFAULT 'Passed',
    Term ENUM('Prelim', 'Midterm', 'Finals') NOT NULL,
    Student_ID VARCHAR(20) NOT NULL,
    Subject_ID VARCHAR(20) NOT NULL,
    Instructor_ID VARCHAR(20) NOT NULL,
    Date_Submitted DATE NOT NULL,
    Date_Recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Courses(Subject_ID) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_ID) REFERENCES Professors(Instructor_ID)
);

-- Exams Table
CREATE TABLE Exams (
    Exam_ID INT PRIMARY KEY AUTO_INCREMENT,
    Score DECIMAL(5,2) NOT NULL,
    Total_Items INT NOT NULL CHECK (Total_Items > 0),
    Remarks ENUM('Passed', 'Failed') DEFAULT 'Passed',
    Term ENUM('Prelim', 'Midterm', 'Finals') NOT NULL,
    Student_ID VARCHAR(20) NOT NULL,
    Subject_ID VARCHAR(20) NOT NULL,
    Instructor_ID VARCHAR(20) NOT NULL,
    Date_Taken DATE NOT NULL,
    Date_Recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Courses(Subject_ID) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_ID) REFERENCES Professors(Instructor_ID),
    UNIQUE KEY unique_exam (Student_ID, Subject_ID, Term)
);

CREATE TABLE Scholars (
    Scholar_ID INT PRIMARY KEY AUTO_INCREMENT,
    Student_ID VARCHAR(20) NOT NULL UNIQUE,
    Rank INT,
    Scholarship_Type VARCHAR(100),
    Academic_Year VARCHAR(20) NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Date_Awarded DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE
);


-- Insert Sample Data for Programs
INSERT INTO Programs (Program_Name, Department) VALUES
('BS Computer Science', 'CCS'),
('BS Information Technology', 'CCS');

-- Insert Sample Professors
INSERT INTO Professors (Instructor_ID, Instructor_Name, Department, Username, Password) VALUES
('CCS001', 'Dr. Maria Santos', 'CCS', 'maria_santos', 'prof123'),
('CCS002', 'Prof. Juan Dela Cruz', 'CCS', 'juan_dela_cruz', 'prof456');

-- Insert Sample Admin
INSERT INTO Admins (Admin_Name, Admin_Role, Department, Username, Password) VALUES
('Admin User', 'System Administrator', 'CCS', 'admin', 'admin123');

-- Insert Sample Courses
INSERT INTO Courses (Subject_ID, Subject_Name, Units, Schedule, Section) VALUES
('CS101', 'Introduction to Programming', 3, 'MWF 10:00-11:00', '9411-AY225'),
('CS102', 'Data Structures', 3, 'TTH 13:00-14:30', '9412-AY225');