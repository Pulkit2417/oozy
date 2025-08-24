# backend/schemas.py

from pydantic import BaseModel, EmailStr
from typing import List, Optional, Union


class TokenData(BaseModel):
    email: Union[str, None] = None

# We need a minimal User Schema to avoid circular dependencies
class UserInEvent(BaseModel):
    id: int
    name: str
    class Config:
        orm_mode = True

# Add a minimal event Schema
class EventInUser(BaseModel):
    id: int
    title: str
    class Config:
        orm_mode = True

# =============================
# Event schemas
# =============================
class EventBase(BaseModel):
    title: str
    date: str
    location: str
    interest_tags: str
    group_size: int
    duration: str

class EventCreate(EventBase):
    pass

# This schema will be used for reading/returning event data
class Event(EventBase):
    id: int
    host_id: int
    status: str
    attendees: List[UserInEvent] = []

    class Config:
        orm_mode = True

# =============================
# User schemas
# =============================
class UserBase(BaseModel):
    name: str
    email: EmailStr # Pydantic will validate this is a valid email
    phone: Union[str, None] = None

    interests: str
    meetup_style: str
    purpose: str
    availability: str
    preferred_locations: str

class UserCreate(UserBase):
    password: str # Passsword is required only for creation

# this schema will be used for reading/returning user data
class User(UserBase):
    id: int
    events: List[EventInUser] = []
    attended_events: List[EventInUser] = []

    class Config:
        orm_mode = True
