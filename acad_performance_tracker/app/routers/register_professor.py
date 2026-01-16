from fastapi import APIRouter, HTTPException, Depends, status
from sqlalchemy.orm import Session
from werkzeug.security import generate_password_hash, check_password_hash
from app import schemas, models  # Relative import - remove acad_performance_tracker
from app.database import get_db  # Relative import

# Create router instance
router = APIRouter(prefix="/auth")

def hashing_password(password: str) -> str:
    return generate_password_hash(password, method='pbkdf2:sha256', salt_length=8)

@router.post("/register_professor", response_model=schemas.ProfessorResponse, status_code=status.HTTP_201_CREATED)
def register_professor(professor: schemas.ProfessorCreate, db: Session = Depends(get_db)):
    # Check if professor ID already exists
    existing_professor = db.query(models.Professor).filter(
        models.Professor.Instructor_ID == professor.Instructor_ID
    ).first()
    
    if existing_professor:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Professor ID already exists"
        )
    
    existing_username = db.query(models.Professor).filter(
        models.Professor.Username == professor.Username
    ).first()
    
    if existing_username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already exists"
        )
    
    existing_email = db.query(models.professor).filter(
        models.professor.Email == professor.Email
    ).first()
    
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already exists"
        )
    
    new_professor = models.professor(
        professor_ID=professor.instructor_ID,
        Name=professor.Instructor_Name,  # Don't forget Name field!
        Email=professor.Email,
        Username=professor.Username,
        Password=hashing_password(professor.Password),
        Department=professor.Department
    )

    db.add(new_professor)
    db.commit()
    db.refresh(new_professor)
    
    return new_professor