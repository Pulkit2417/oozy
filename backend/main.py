# main.py

from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Union
import crud, models, schemas, security
from database import SessionLocal, engine
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from jose import JWTError, jwt


models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# this tells fastAPI where to look for the token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Dependency to get a db session for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(token: str=Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticated": "Bearer"},
    )
    try:
        payload = jwt.decode(token, security.SECRET_KEY, algorithms=[security.ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = schemas.TokenData(email=email)
    except JWTError:
        raise credentials_exception
    user = crud.get_user_by_email(db, email=token_data.email)
    if user is None:
        raise credentials_exception
    return user


# ========================
# User endpoints
# ========================

@app.post("/users/register", response_model=schemas.User, status_code=status.HTTP_201_CREATED)
def register_user(user: schemas.UserCreate, db: Session=Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)

@app.post("/token")
def login_for_access_token(form_data: OAuth2PasswordRequestForm=Depends(), db: Session=Depends(get_db)):
    user = crud.get_user_by_email(db, email=form_data.username)
    if not user or not security.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token=security.create_access_token(
        data={"sub": user.email}
    )
    return {"access_token":access_token, "token_type": "bearer"}

# ====== NEEW PROTECTED ENDPOINT ======
@app.get("/users/me", response_model=schemas.User)
def read_users_me(current_user: schemas.User=Depends(get_current_user)):
    return current_user

# endpoint to get the list of all users
@app.get("/users/", response_model=List[schemas.User])
def read_users(skip: int=0, limit: int=100, db: Session=Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


# ========================
# Event endpoints
# ========================

@app.post("/events", response_model=schemas.Event, status_code=status.HTTP_201_CREATED)
def create_events(
    event: schemas.EventCreate,
    db: Session=Depends(get_db),
    current_user: schemas.User=Depends(get_current_user)
    ):
    return crud.create_event(db=db, event=event, user_id=current_user.id)

@app.get("/events/", response_model=List[schemas.Event])
def read_events(
    skip: int=0,
    limit: int=100,
    interest: Union[str, None]=None,
    db: Session=Depends(get_db)):
    events = crud.get_events(db, skip=skip, limit=limit, interest=interest)
    # Iterate through events and hide the attendees if status is 'upcoming'
    for event in events:
        if event.status =="Upcoming":
            event.attendees = []
    return events

@app.post("/events/{event_id}/join", response_model=schemas.Event)
def join_event(
    event_id: int,
    db: Session=Depends(get_db),
    current_user: schemas.User=Depends(get_current_user)):

    event = crud.get_event_by_id(db, event_id=event_id)
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    result=crud.join_event(db=db, event_id=event_id, user_id=current_user.id)
    if result=="None":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")
    if result=="Full":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Event is already full")
    if result=="Already Joined":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You have already joined the Event.")
    if result=="completed":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Event is already completed")
    
    if result and result.status=="Upcoming":
        result.attendees = []
    return result


@app.post("/events/{event_id}/complete", response_model=schemas.Event)
def complete_event(
    event_id: int,
    db: Session=Depends(get_db),
    current_user: schemas.User = Depends(get_current_user)):

    updated_event = crud.complete_event(db=db, event_id=event_id, user_id=current_user.id)
    if not updated_event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found or you are not the host",
        )
    return updated_event

@app.post("/events/{event_id}/leave", response_model=schemas.Event)
def leave_event(
    event_id: int,
    db: Session=Depends(get_db),
    current_user: schemas.User=Depends(get_current_user)
    ):
    result = crud.leave_event(db=db, event_id=event_id, user_id=current_user.id)
    if result is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event or user not found")
    if result=="completed":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot leave an event that has already been completed")
    if result=="not_joined":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not an attendee of this event")
    # Hide attendees if the event is still upcoming
    if result.status=="Upcoming":
        result.attendees = []
    
    return result

@app.get("/")
def read_root():
    """
    This is the root endpoint of our application.
    It returns a simple welcome message.
    """
    return {"message": "Hello, welcome to the OOZY app backend"}
