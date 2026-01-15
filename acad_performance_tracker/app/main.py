from fastapi import FastAPI, status
import app.routers as register_student
from app.routers import register_student
from app.database import engine, Base
from app import models  

# Create all tables
Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello FastAPI"}

app.include_router(register_student.router, prefix="", tags=["Register Student"])
