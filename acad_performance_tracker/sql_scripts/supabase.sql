-- PostgreSQL script for Supabase
-- Academic Tracker Database

-- Drop existing tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS scholars CASCADE;
DROP TABLE IF EXISTS exams CASCADE;
DROP TABLE IF EXISTS assignments CASCADE;
DROP TABLE IF EXISTS quizzes CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS professors CASCADE;
DROP TABLE IF EXISTS admins CASCADE;
DROP TABLE IF EXISTS programs CASCADE;

-- Create custom ENUM types for PostgreSQL
CREATE TYPE term_enum AS ENUM ('Prelim', 'Midterm', 'Finals');
CREATE TYPE grade_remarks_enum AS ENUM ('Passed', 'Failed', 'Incomplete');
CREATE TYPE assignment_remarks_enum AS ENUM ('Passed', 'Failed', 'Late');
CREATE TYPE quiz_remarks_enum AS ENUM ('Passed', 'Failed');
CREATE TYPE exam_remarks_enum AS ENUM ('Passed', 'Failed');

-- Programs Table
CREATE TABLE programs (
  program_id SERIAL PRIMARY KEY,
  program_name VARCHAR(50) NOT NULL UNIQUE,
  department VARCHAR(100) DEFAULT 'CCS'
);

-- Admins Table
CREATE TABLE admins (
  admin_id SERIAL PRIMARY KEY,
  admin_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  admin_role VARCHAR(50) NOT NULL,
  department VARCHAR(100),
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL
);

-- Professors Table
CREATE TABLE professors (
  instructor_id VARCHAR(20) PRIMARY KEY,
  instructor_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  department VARCHAR(100) DEFAULT 'CCS',
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL
);

-- Courses Table
CREATE TABLE courses (
  subject_id VARCHAR(20) PRIMARY KEY,
  section VARCHAR(20),
  subject_name VARCHAR(150) NOT NULL,
  units INT NOT NULL CHECK (units > 0),
  schedule VARCHAR(100)
);

-- Students Table
CREATE TABLE students (
  student_id VARCHAR(20) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  year INT NOT NULL CHECK (year BETWEEN 1 AND 5),
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  gwa NUMERIC(3,2) CHECK (gwa >= 1.00 AND gwa <= 5.00),
  program_id INT NOT NULL,
  FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

-- Enrollments Table
CREATE TABLE enrollments (
  enrollment_id SERIAL PRIMARY KEY,
  student_id VARCHAR(20) NOT NULL,
  subject_id VARCHAR(20) NOT NULL,
  instructor_id VARCHAR(20) NOT NULL,
  academic_year VARCHAR(20) NOT NULL,
  semester VARCHAR(20) NOT NULL,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES courses(subject_id) ON DELETE CASCADE,
  FOREIGN KEY (instructor_id) REFERENCES professors(instructor_id),
  UNIQUE (student_id, subject_id, academic_year, semester)
);

-- Grades Table
CREATE TABLE grades (
  grade_id SERIAL PRIMARY KEY,
  grade NUMERIC(3,2) CHECK (grade >= 1.00 AND grade <= 5.00),
  term term_enum NOT NULL,
  remarks grade_remarks_enum DEFAULT 'Incomplete',
  student_id VARCHAR(20) NOT NULL,
  subject_id VARCHAR(20) NOT NULL,
  instructor_id VARCHAR(20) NOT NULL,
  academic_year VARCHAR(20) NOT NULL,
  semester VARCHAR(20) NOT NULL,
  date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES courses(subject_id) ON DELETE CASCADE,
  FOREIGN KEY (instructor_id) REFERENCES professors(instructor_id),
  UNIQUE (student_id, subject_id, term, academic_year, semester)
);

-- Quizzes Table
CREATE TABLE quizzes (
  quiz_id SERIAL PRIMARY KEY,
  quiz_number INT NOT NULL,
  score NUMERIC(5,2) NOT NULL,
  total_items INT NOT NULL CHECK (total_items > 0),
  remarks quiz_remarks_enum DEFAULT 'Passed',
  term term_enum NOT NULL,
  student_id VARCHAR(20) NOT NULL,
  subject_id VARCHAR(20) NOT NULL,
  instructor_id VARCHAR(20) NOT NULL,
  date_taken DATE NOT NULL,
  date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES courses(subject_id) ON DELETE CASCADE,
  FOREIGN KEY (instructor_id) REFERENCES professors(instructor_id)
);

-- Assignments Table
CREATE TABLE assignments (
  assignment_id SERIAL PRIMARY KEY,
  assignment_number INT NOT NULL,
  score NUMERIC(5,2) NOT NULL,
  total_items INT NOT NULL CHECK (total_items > 0),
  remarks assignment_remarks_enum DEFAULT 'Passed',
  term term_enum NOT NULL,
  student_id VARCHAR(20) NOT NULL,
  subject_id VARCHAR(20) NOT NULL,
  instructor_id VARCHAR(20) NOT NULL,
  date_submitted DATE NOT NULL,
  date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES courses(subject_id) ON DELETE CASCADE,
  FOREIGN KEY (instructor_id) REFERENCES professors(instructor_id)
);

-- Exams Table
CREATE TABLE exams (
  exam_id SERIAL PRIMARY KEY,
  score NUMERIC(5,2) NOT NULL,
  total_items INT NOT NULL CHECK (total_items > 0),
  remarks exam_remarks_enum DEFAULT 'Passed',
  term term_enum NOT NULL,
  student_id VARCHAR(20) NOT NULL,
  subject_id VARCHAR(20) NOT NULL,
  instructor_id VARCHAR(20) NOT NULL,
  date_taken DATE NOT NULL,
  date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES courses(subject_id) ON DELETE CASCADE,
  FOREIGN KEY (instructor_id) REFERENCES professors(instructor_id),
  UNIQUE (student_id, subject_id, term)
);

-- Scholars Table
CREATE TABLE scholars (
  scholar_id SERIAL PRIMARY KEY,
  student_id VARCHAR(20) NOT NULL UNIQUE,
  student_rank INT,
  scholarship_type VARCHAR(100),
  academic_year VARCHAR(20) NOT NULL,
  semester VARCHAR(20) NOT NULL,
  date_awarded DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- Insert Sample Data
INSERT INTO programs (program_name, department) VALUES
('BS Computer Science', 'CCS'),
('BS Information Technology', 'CCS');

INSERT INTO admins (admin_name, email, admin_role, department, username, password) VALUES
('Admin User', 'admin@university.edu', 'System Administrator', 'CCS', 'admin', 'admin123');

INSERT INTO professors (instructor_id, instructor_name, email, department, username, password) VALUES
('CCS001', 'Dr. Maria Santos', 'maria.santos@university.edu', 'CCS', 'maria_santos', 'prof123'),
('CCS002', 'Prof. Juan Dela Cruz', 'juan.dela.cruz@university.edu', 'CCS', 'juan_dela_cruz', 'prof456');

INSERT INTO courses (subject_id, section, subject_name, units, schedule) VALUES
('CS101', '9411-AY225', 'Introduction to Programming', 3, 'MWF 10:00-11:00'),
('CS102', '9412-AY225', 'Data Structures', 3, 'TTH 13:00-14:30');

-- Create indexes for better performance
CREATE INDEX idx_students_program ON students(program_id);
CREATE INDEX idx_students_username ON students(username);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_subject ON enrollments(subject_id);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_subject ON grades(subject_id);
CREATE INDEX idx_quizzes_student ON quizzes(student_id);
CREATE INDEX idx_assignments_student ON assignments(student_id);
CREATE INDEX idx_exams_student ON exams(student_id);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE professors ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE scholars ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (adjust based on your security needs)
-- For development purposes, allowing all operations
-- IMPORTANT: Modify these policies for production use!

CREATE POLICY "Enable all access for programs" ON programs FOR ALL USING (true);
CREATE POLICY "Enable all access for admins" ON admins FOR ALL USING (true);
CREATE POLICY "Enable all access for professors" ON professors FOR ALL USING (true);
CREATE POLICY "Enable all access for courses" ON courses FOR ALL USING (true);
CREATE POLICY "Enable all access for students" ON students FOR ALL USING (true);
CREATE POLICY "Enable all access for enrollments" ON enrollments FOR ALL USING (true);
CREATE POLICY "Enable all access for grades" ON grades FOR ALL USING (true);
CREATE POLICY "Enable all access for quizzes" ON quizzes FOR ALL USING (true);
CREATE POLICY "Enable all access for assignments" ON assignments FOR ALL USING (true);
CREATE POLICY "Enable all access for exams" ON exams FOR ALL USING (true);
CREATE POLICY "Enable all access for scholars" ON scholars FOR ALL USING (true);