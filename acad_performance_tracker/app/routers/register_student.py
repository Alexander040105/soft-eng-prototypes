from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from acad_performance_tracker.app import schemas, models, database, app  # Relative imports
from acad_performance_tracker.app.database import get_db
from fastapi import APIRouter
from werkzeug.security import generate_password_hash, check_password_hash
from acad_performance_tracker.app import models

def hashing_password(password: str) -> str:
        return generate_password_hash(password, method='pbkdf2:sha256', salt_length=8)

@app.post("/auth/register_student", response_model=schemas.StudentCreate, status_code=201)
def register_student(student: schemas.StudentCreate, db: Session = Depends(get_db)):
    new_student = models.Student(
        Student_ID=student.Student_ID,
        Email=student.Email,                  
        Year=student.Year,                    
        Username=student.Username,            
        Password=hashing_password(student.Password),  
        Program_ID=student.Program_ID        
    )

    db.add(new_student)
    db.commit()
    db.refresh(new_student)
    return new_student