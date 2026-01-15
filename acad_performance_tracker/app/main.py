from fastapi import FastAPI, status
import app.routers.register_student as register_student
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello FastAPI"}

app.include_router(register_student, prefix="", tags=["Register Student"])
