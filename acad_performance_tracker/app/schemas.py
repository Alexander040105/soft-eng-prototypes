from pydantic import BaseModel, EmailStr, Field, ConfigDict
from typing import Optional
from datetime import date, datetime
from decimal import Decimal
from enum import Enum

# Enum schemas
class TermEnum(str, Enum):
    PRELIM = "Prelim"
    MIDTERM = "Midterm"
    FINALS = "Finals"

class GradeRemarksEnum(str, Enum):
    PASSED = "Passed"
    FAILED = "Failed"
    INCOMPLETE = "Incomplete"

class AssignmentRemarksEnum(str, Enum):
    PASSED = "Passed"
    FAILED = "Failed"
    LATE = "Late"

class QuizRemarksEnum(str, Enum):
    PASSED = "Passed"
    FAILED = "Failed"

class ExamRemarksEnum(str, Enum):
    PASSED = "Passed"
    FAILED = "Failed"


# ========== PROGRAM SCHEMAS ==========
class ProgramBase(BaseModel):
    Program_Name: str = Field(..., max_length=50)
    Department: str = Field(default='CCS', max_length=100)

class ProgramCreate(ProgramBase):
    pass

class ProgramUpdate(BaseModel):
    Program_Name: Optional[str] = Field(None, max_length=50)
    Department: Optional[str] = Field(None, max_length=100)

class ProgramResponse(ProgramBase):
    Program_ID: int
    
    model_config = ConfigDict(from_attributes=True)


# ========== STUDENT SCHEMAS ==========
class StudentBase(BaseModel):
    Name: str = Field(..., max_length=100)
    Email: EmailStr
    Year: int = Field(..., ge=1, le=5)
    Username: str = Field(..., max_length=50)
    GWA: Optional[Decimal] = Field(None, ge=1.00, le=5.00, decimal_places=2)
    Program_ID: int

class StudentCreate(StudentBase):
    Student_ID: str = Field(..., max_length=20)
    Password: str = Field(..., max_length=255)

class StudentUpdate(BaseModel):
    Name: Optional[str] = Field(None, max_length=100)
    Email: Optional[EmailStr] = None
    Year: Optional[int] = Field(None, ge=1, le=5)
    Username: Optional[str] = Field(None, max_length=50)
    Password: Optional[str] = Field(None, max_length=255)
    GWA: Optional[Decimal] = Field(None, ge=1.00, le=5.00, decimal_places=2)
    Program_ID: Optional[int] = None

class StudentResponse(StudentBase):
    Student_ID: str
    
    model_config = ConfigDict(from_attributes=True)


# ========== PROFESSOR SCHEMAS ==========
class ProfessorBase(BaseModel):
    Instructor_Name: str = Field(..., max_length=100)
    Department: str = Field(default='CCS', max_length=100)
    Username: str = Field(..., max_length=50)
    Email: EmailStr
class ProfessorCreate(ProfessorBase):
    Instructor_ID: str = Field(..., max_length=20)
    Password: str = Field(..., max_length=255)

class ProfessorUpdate(BaseModel):
    Instructor_Name: Optional[str] = Field(None, max_length=100)
    Department: Optional[str] = Field(None, max_length=100)
    Username: Optional[str] = Field(None, max_length=50)
    Password: Optional[str] = Field(None, max_length=255)
    Email: Optional[EmailStr] = None
class ProfessorResponse(ProfessorBase):
    Instructor_ID: str
    
    model_config = ConfigDict(from_attributes=True)


# ========== ADMIN SCHEMAS ==========
class AdminBase(BaseModel):
    Admin_Name: str = Field(..., max_length=100)
    Admin_Role: str = Field(..., max_length=50)
    Department: Optional[str] = Field(None, max_length=100)
    Email: EmailStr
    Username: str = Field(..., max_length=50)

class AdminCreate(AdminBase):
    Password: str = Field(..., max_length=255)

class AdminUpdate(BaseModel):
    Admin_Name: Optional[str] = Field(None, max_length=100)
    Admin_Role: Optional[str] = Field(None, max_length=50)
    Department: Optional[str] = Field(None, max_length=100)
    Username: Optional[str] = Field(None, max_length=50)
    Password: Optional[str] = Field(None, max_length=255)
    Email: Optional[EmailStr] = None
class AdminResponse(AdminBase):
    Admin_ID: int
    
    model_config = ConfigDict(from_attributes=True)


# ========== COURSE SCHEMAS ==========
class CourseBase(BaseModel):
    Subject_Name: str = Field(..., max_length=150)
    Section: str = Field(..., max_length=20)
    Units: int = Field(..., gt=0)
    Schedule: Optional[str] = Field(None, max_length=100)

class CourseCreate(CourseBase):
    Subject_ID: str = Field(..., max_length=20)

class CourseUpdate(BaseModel):
    Subject_Name: Optional[str] = Field(None, max_length=150)
    Section: Optional[str] = Field(None, max_length=20)
    Units: Optional[int] = Field(None, gt=0)
    Schedule: Optional[str] = Field(None, max_length=100)

class CourseResponse(CourseBase):
    Subject_ID: str
    
    model_config = ConfigDict(from_attributes=True)


# ========== ENROLLMENT SCHEMAS ==========
class EnrollmentBase(BaseModel):
    Student_ID: str = Field(..., max_length=20)
    Subject_ID: str = Field(..., max_length=20)
    Instructor_ID: str = Field(..., max_length=20)
    Academic_Year: str = Field(..., max_length=20)
    Semester: str = Field(..., max_length=20)

class EnrollmentCreate(EnrollmentBase):
    pass

class EnrollmentUpdate(BaseModel):
    Instructor_ID: Optional[str] = Field(None, max_length=20)
    Academic_Year: Optional[str] = Field(None, max_length=20)
    Semester: Optional[str] = Field(None, max_length=20)

class EnrollmentResponse(EnrollmentBase):
    Enrollment_ID: int
    
    model_config = ConfigDict(from_attributes=True)


# ========== GRADE SCHEMAS ==========
class GradeBase(BaseModel):
    Grade: Optional[Decimal] = Field(None, ge=1.00, le=5.00, decimal_places=2)
    Term: TermEnum
    Remarks: GradeRemarksEnum = GradeRemarksEnum.INCOMPLETE
    Student_ID: str = Field(..., max_length=20)
    Subject_ID: str = Field(..., max_length=20)
    Instructor_ID: str = Field(..., max_length=20)
    Academic_Year: str = Field(..., max_length=20)
    Semester: str = Field(..., max_length=20)

class GradeCreate(GradeBase):
    pass

class GradeUpdate(BaseModel):
    Grade: Optional[Decimal] = Field(None, ge=1.00, le=5.00, decimal_places=2)
    Term: Optional[TermEnum] = None
    Remarks: Optional[GradeRemarksEnum] = None

class GradeResponse(GradeBase):
    Grade_ID: int
    Date_Recorded: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ========== QUIZ SCHEMAS ==========
class QuizBase(BaseModel):
    Quiz_Number: int
    Score: Decimal = Field(..., decimal_places=2)
    Total_Items: int = Field(..., gt=0)
    Remarks: QuizRemarksEnum = QuizRemarksEnum.PASSED
    Term: TermEnum
    Student_ID: str = Field(..., max_length=20)
    Subject_ID: str = Field(..., max_length=20)
    Instructor_ID: str = Field(..., max_length=20)
    Date_Taken: date

class QuizCreate(QuizBase):
    pass

class QuizUpdate(BaseModel):
    Quiz_Number: Optional[int] = None
    Score: Optional[Decimal] = Field(None, decimal_places=2)
    Total_Items: Optional[int] = Field(None, gt=0)
    Remarks: Optional[QuizRemarksEnum] = None
    Term: Optional[TermEnum] = None
    Date_Taken: Optional[date] = None

class QuizResponse(QuizBase):
    Quiz_ID: int
    Date_Recorded: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ========== ASSIGNMENT SCHEMAS ==========
class AssignmentBase(BaseModel):
    Assignment_Number: int
    Score: Decimal = Field(..., decimal_places=2)
    Total_Items: int = Field(..., gt=0)
    Remarks: AssignmentRemarksEnum = AssignmentRemarksEnum.PASSED
    Term: TermEnum
    Student_ID: str = Field(..., max_length=20)
    Subject_ID: str = Field(..., max_length=20)
    Instructor_ID: str = Field(..., max_length=20)
    Date_Submitted: date

class AssignmentCreate(AssignmentBase):
    pass

class AssignmentUpdate(BaseModel):
    Assignment_Number: Optional[int] = None
    Score: Optional[Decimal] = Field(None, decimal_places=2)
    Total_Items: Optional[int] = Field(None, gt=0)
    Remarks: Optional[AssignmentRemarksEnum] = None
    Term: Optional[TermEnum] = None
    Date_Submitted: Optional[date] = None

class AssignmentResponse(AssignmentBase):
    Assignment_ID: int
    Date_Recorded: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ========== EXAM SCHEMAS ==========
class ExamBase(BaseModel):
    Score: Decimal = Field(..., decimal_places=2)
    Total_Items: int = Field(..., gt=0)
    Remarks: ExamRemarksEnum = ExamRemarksEnum.PASSED
    Term: TermEnum
    Student_ID: str = Field(..., max_length=20)
    Subject_ID: str = Field(..., max_length=20)
    Instructor_ID: str = Field(..., max_length=20)
    Date_Taken: date

class ExamCreate(ExamBase):
    pass

class ExamUpdate(BaseModel):
    Score: Optional[Decimal] = Field(None, decimal_places=2)
    Total_Items: Optional[int] = Field(None, gt=0)
    Remarks: Optional[ExamRemarksEnum] = None
    Term: Optional[TermEnum] = None
    Date_Taken: Optional[date] = None

class ExamResponse(ExamBase):
    Exam_ID: int
    Date_Recorded: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ========== SCHOLAR SCHEMAS ==========
class ScholarBase(BaseModel):
    Student_ID: str = Field(..., max_length=20)
    Rank: Optional[int] = None
    Scholarship_Type: Optional[str] = Field(None, max_length=100)
    Academic_Year: str = Field(..., max_length=20)
    Semester: str = Field(..., max_length=20)
    Program_ID: Optional[int] = None

class ScholarCreate(ScholarBase):
    pass

class ScholarUpdate(BaseModel):
    Rank: Optional[int] = None
    Scholarship_Type: Optional[str] = Field(None, max_length=100)
    Academic_Year: Optional[str] = Field(None, max_length=20)
    Semester: Optional[str] = Field(None, max_length=20)
    Program_ID: Optional[int] = None

class ScholarResponse(ScholarBase):
    Scholar_ID: int
    Date_Awarded: date
    
    model_config = ConfigDict(from_attributes=True)


# ========== LOGIN SCHEMAS ==========
class LoginRequest(BaseModel):
    username: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_type: str  # "student", "professor", or "admin"
    user_id: str | int  # Student_ID/Instructor_ID or Admin_ID
    name: str