from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class User(BaseModel):
    username: str
    role: str
    avatar: str

users_db = [
    {"username": "admin", "role": "manager", "avatar": "🧑‍💼"},
    {"username": "staff1", "role": "staff", "avatar": "👨‍🔧"},
]

@router.post('/login')
def login(user: User):
    for u in users_db:
        if u['username'] == user.username:
            return {"success": True, "user": u}
    return {"success": True, "user": {"username": user.username, "role": user.role, "avatar": user.avatar}}

@router.get('/users')
def get_users():
    return {"users": users_db}
