# backend/crud.py

from sqlalchemy.orm import Session
import models, schemas, security
from typing import Union

def create_user(db: Session, user: schemas.UserCreate):
    # Hash the password before storing it
    hashed_password = security.get_password_hash(user.password)

    # create the user model instance, excluding the plain password
    db_user = models.User(
        email=user.email,
        name=user.name,
        phone=user.phone,
        hashed_password=hashed_password,
        interests=user.interests,
        meetup_style=user.meetup_style,
        purpose=user.purpose,
        availability=user.availability,
        preferred_locations=user.preferred_locations,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_users(db: Session, skip: int=0, limit: int=100):
    return db.query(models.User).offset(skip).limit(limit).all()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_event(db: Session, event: schemas.EventCreate, user_id:int):
    # Create a new event model linking it to the user id
    db_event = models.Event(**event.dict(), host_id=user_id)
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event


def get_events(db: Session, skip: int=0, limit: int=100, interest: Union[str, None]=None):
    """
    Retrieve a list of all events from the database.
    """
    query = db.query(models.Event)
    # If an interest is provided
    if interest:
        query = query.filter(models.Event.interest_tags.ilike(f"%{interest}%"))
    return query.offset(skip).limit(limit).all()

def get_event_by_id(db: Session, event_id: int):
    return db.query(models.Event).filter(models.Event.id == event_id).first()

def join_event(db: Session, event_id: int, user_id: int):
    db_event = db.query(models.Event).filter(models.Event.id == event_id).first()
    db_user = db.query(models.User).filter(models.User.id == user_id).first()

    if not db_event or not db_user:
        return None
    
    if db_user in db_event.attendees:
        return "Already Joined"
    
    if len(db_event.attendees) >= db_event.group_size:
        return "Full"
    
    db_event.attendees.append(db_user)
    db.commit()
    db.refresh(db_event)
    
    return db_event

def complete_event(db: Session, event_id: int, user_id: int):
    db_event = db.query(models.Event).filter(models.Event.id == event_id).first()

    # check if the event exists and if the user is the host
    if db_event and db_event.host_id == user_id:
        db_event.status = 'completed'
        db.commit()
        db.refresh(db_event)
        return db_event
    
    return None

def leave_event(db: Session, event_id: int, user_id: int):
    db_event = db.query(models.Event).filter(models.Event.id == event_id).first()
    db_user = db.query(models.User).filter(models.User.id == user_id).first()

    # ensure both the user and event exist
    if not db_user or not db_event:
        return None
    
    if db_event.status != 'Upcoming':
        return "completed"
    
    if db_user not in db_event.attendees:
        return "not joined"
    
    db_event.attendees.remove(db_user)
    db.commit()
    db.refresh(db_event)

    return db_event