from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL, Enum, Date, TIMESTAMP, CheckConstraint, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import enum

# Enum definitions
class TermEnum(str, enum.Enum):
    PRELIM = "Prelim"
    MIDTERM = "Midterm"
    FINALS = "Finals"

class GradeRemarksEnum(str, enum.Enum):
    PASSED = "Passed"
    FAILED = "Failed"
    INCOMPLETE = "Incomplete"

class AssignmentRemarksEnum(str, enum.Enum):
    PASSED = "Passed"
    FAILED = "Failed"
    LATE = "Late"

class QuizRemarksEnum(str, enum.Enum):
    PASSED = "Passed"
    FAILED = "Failed"

class ExamRemarksEnum(str, enum.Enum):
    PASSED = "Passed"
    FAILED = "Failed"


class Program(Base):
    __tablename__ = "Programs"
    
    Program_ID = Column(Integer, primary_key=True, autoincrement=True)
    Program_Name = Column(String(50), nullable=False, unique=True)
    Department = Column(String(100), default='CCS')
    
    # Relationships
    students = relationship("Student", back_populates="program")
    scholars = relationship("Scholar", back_populates="program", foreign_keys="[Scholar.Program_ID]")


class Student(Base):
    __tablename__ = "Students"
    
    Student_ID = Column(String(20), primary_key=True)
    Name = Column(String(100), nullable=False)
    Email = Column(String(100), unique=True, nullable=False)
    Year = Column(Integer, nullable=False)
    Username = Column(String(50), unique=True, nullable=False)
    Password = Column(String(255), nullable=False)
    GWA = Column(DECIMAL(3, 2), default=None)
    Program_ID = Column(Integer, ForeignKey('Programs.Program_ID'), nullable=False)
    
    __table_args__ = (
        CheckConstraint('"Year" BETWEEN 1 AND 5', name='check_year'),
        CheckConstraint('"GWA" >= 1.00 AND "GWA" <= 5.00', name='check_gwa'),
    )
    
    # Relationships
    program = relationship("Program", back_populates="students")
    enrollments = relationship("Enrollment", back_populates="student", cascade="all, delete-orphan")
    grades = relationship("Grade", back_populates="student", cascade="all, delete-orphan")
    quizzes = relationship("Quiz", back_populates="student", cascade="all, delete-orphan")
    assignments = relationship("Assignment", back_populates="student", cascade="all, delete-orphan")
    exams = relationship("Exam", back_populates="student", cascade="all, delete-orphan")
    scholar = relationship("Scholar", back_populates="student", uselist=False, cascade="all, delete-orphan")


class Professor(Base):
    __tablename__ = "Professors"
    
    Instructor_ID = Column(String(20), primary_key=True)
    Instructor_Name = Column(String(100), nullable=False)
    Department = Column(String(100), default='CCS')
    Email = Column(String(100), unique=True, nullable=False)
    Username = Column(String(50), unique=True, nullable=False)
    Password = Column(String(255), nullable=False)
    
    # Relationships
    enrollments = relationship("Enrollment", back_populates="instructor")
    grades = relationship("Grade", back_populates="instructor")
    quizzes = relationship("Quiz", back_populates="instructor")
    assignments = relationship("Assignment", back_populates="instructor")
    exams = relationship("Exam", back_populates="instructor")


class Admin(Base):
    __tablename__ = "Admins"
    
    Admin_ID = Column(Integer, primary_key=True, autoincrement=True)
    Admin_Name = Column(String(100), nullable=False)
    Admin_Role = Column(String(50), nullable=False)
    Department = Column(String(100))
    Email = Column(String(100), unique=True, nullable=False)
    Username = Column(String(50), unique=True, nullable=False)
    Password = Column(String(255), nullable=False)


class Course(Base):
    __tablename__ = "Courses"
    
    Subject_ID = Column(String(20), primary_key=True)
    Section = Column(String(20), nullable=False)
    Subject_Name = Column(String(150), nullable=False)
    Units = Column(Integer, nullable=False)
    Schedule = Column(String(100))
    
    __table_args__ = (
        CheckConstraint('"Units" > 0', name='check_units'),
    )
    
    # Relationships
    enrollments = relationship("Enrollment", back_populates="course", cascade="all, delete-orphan")
    grades = relationship("Grade", back_populates="course", cascade="all, delete-orphan")
    quizzes = relationship("Quiz", back_populates="course", cascade="all, delete-orphan")
    assignments = relationship("Assignment", back_populates="course", cascade="all, delete-orphan")
    exams = relationship("Exam", back_populates="course", cascade="all, delete-orphan")


class Enrollment(Base):
    __tablename__ = "Enrollments"
    
    Enrollment_ID = Column(Integer, primary_key=True, autoincrement=True)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False)
    Subject_ID = Column(String(20), ForeignKey('Courses.Subject_ID', ondelete='CASCADE'), nullable=False)
    Instructor_ID = Column(String(20), ForeignKey('Professors.Instructor_ID'), nullable=False)
    Academic_Year = Column(String(20), nullable=False)
    Semester = Column(String(20), nullable=False)
    
    __table_args__ = (
        UniqueConstraint('Student_ID', 'Subject_ID', 'Academic_Year', 'Semester', name='unique_enrollment'),
    )
    
    # Relationships
    student = relationship("Student", back_populates="enrollments")
    course = relationship("Course", back_populates="enrollments")
    instructor = relationship("Professor", back_populates="enrollments")


class Grade(Base):
    __tablename__ = "Grades"
    
    Grade_ID = Column(Integer, primary_key=True, autoincrement=True)
    Grade = Column(DECIMAL(3, 2))
    Term = Column(Enum(TermEnum), nullable=False)
    Remarks = Column(Enum(GradeRemarksEnum), default=GradeRemarksEnum.INCOMPLETE)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False)
    Subject_ID = Column(String(20), ForeignKey('Courses.Subject_ID', ondelete='CASCADE'), nullable=False)
    Instructor_ID = Column(String(20), ForeignKey('Professors.Instructor_ID'), nullable=False)
    Academic_Year = Column(String(20), nullable=False)
    Semester = Column(String(20), nullable=False)
    Date_Recorded = Column(TIMESTAMP, server_default=func.current_timestamp())
    
    __table_args__ = (
        CheckConstraint('"Grade" >= 1.00 AND "Grade" <= 5.00', name='check_grade_range'),
        UniqueConstraint('Student_ID', 'Subject_ID', 'Term', 'Academic_Year', 'Semester', name='unique_grade'),
    )
    
    # Relationships
    student = relationship("Student", back_populates="grades")
    course = relationship("Course", back_populates="grades")
    instructor = relationship("Professor", back_populates="grades")


class Quiz(Base):
    __tablename__ = "Quizzes"
    
    Quiz_ID = Column(Integer, primary_key=True, autoincrement=True)
    Quiz_Number = Column(Integer, nullable=False)
    Score = Column(DECIMAL(5, 2), nullable=False)
    Total_Items = Column(Integer, nullable=False)
    Remarks = Column(Enum(QuizRemarksEnum), default=QuizRemarksEnum.PASSED)
    Term = Column(Enum(TermEnum), nullable=False)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False)
    Subject_ID = Column(String(20), ForeignKey('Courses.Subject_ID', ondelete='CASCADE'), nullable=False)
    Instructor_ID = Column(String(20), ForeignKey('Professors.Instructor_ID'), nullable=False)
    Date_Taken = Column(Date, nullable=False)
    Date_Recorded = Column(TIMESTAMP, server_default=func.current_timestamp())
    
    __table_args__ = (
        CheckConstraint('"Total_Items" > 0', name='check_quiz_total_items'),
    )
    
    # Relationships
    student = relationship("Student", back_populates="quizzes")
    course = relationship("Course", back_populates="quizzes")
    instructor = relationship("Professor", back_populates="quizzes")


class Assignment(Base):
    __tablename__ = "Assignments"
    
    Assignment_ID = Column(Integer, primary_key=True, autoincrement=True)
    Assignment_Number = Column(Integer, nullable=False)
    Score = Column(DECIMAL(5, 2), nullable=False)
    Total_Items = Column(Integer, nullable=False)
    Remarks = Column(Enum(AssignmentRemarksEnum), default=AssignmentRemarksEnum.PASSED)
    Term = Column(Enum(TermEnum), nullable=False)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False)
    Subject_ID = Column(String(20), ForeignKey('Courses.Subject_ID', ondelete='CASCADE'), nullable=False)
    Instructor_ID = Column(String(20), ForeignKey('Professors.Instructor_ID'), nullable=False)
    Date_Submitted = Column(Date, nullable=False)
    Date_Recorded = Column(TIMESTAMP, server_default=func.current_timestamp())
    
    __table_args__ = (
        CheckConstraint('"Total_Items" > 0', name='check_assignment_total_items'),
    )
    
    # Relationships
    student = relationship("Student", back_populates="assignments")
    course = relationship("Course", back_populates="assignments")
    instructor = relationship("Professor", back_populates="assignments")


class Exam(Base):
    __tablename__ = "Exams"
    
    Exam_ID = Column(Integer, primary_key=True, autoincrement=True)
    Score = Column(DECIMAL(5, 2), nullable=False)
    Total_Items = Column(Integer, nullable=False)
    Remarks = Column(Enum(ExamRemarksEnum), default=ExamRemarksEnum.PASSED)
    Term = Column(Enum(TermEnum), nullable=False)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False)
    Subject_ID = Column(String(20), ForeignKey('Courses.Subject_ID', ondelete='CASCADE'), nullable=False)
    Instructor_ID = Column(String(20), ForeignKey('Professors.Instructor_ID'), nullable=False)
    Date_Taken = Column(Date, nullable=False)
    Date_Recorded = Column(TIMESTAMP, server_default=func.current_timestamp())
    
    __table_args__ = (
        CheckConstraint('"Total_Items" > 0', name='check_exam_total_items'),
        UniqueConstraint('Student_ID', 'Subject_ID', 'Term', name='unique_exam'),
    )
    
    # Relationships
    student = relationship("Student", back_populates="exams")
    course = relationship("Course", back_populates="exams")
    instructor = relationship("Professor", back_populates="exams")


class Scholar(Base):
    __tablename__ = "Scholars"
    Scholar_ID = Column(Integer, primary_key=True, autoincrement=True)
    Student_ID = Column(String(20), ForeignKey('Students.Student_ID', ondelete='CASCADE'), nullable=False, unique=True)
    Rank = Column(Integer)
    Scholarship_Type = Column(String(100))
    Academic_Year = Column(String(20), nullable=False)
    Semester = Column(String(20), nullable=False)
    Date_Awarded = Column(Date, server_default=func.current_date())
    Program_ID = Column(Integer, ForeignKey('Programs.Program_ID'))
    
    # Relationships
    student = relationship("Student", back_populates="scholar")
    program = relationship("Program", back_populates="scholars", foreign_keys=[Program_ID])