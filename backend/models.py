from sqlalchemy import Column, Integer, String, Text, ForeignKey, Table
from database import Base
from sqlalchemy.orm import relationship


# this table links user to the events they are attending
event_attendees = Table(
    'event_attendees',
    Base.metadata,
    Column('user_id', ForeignKey('users.id'), primary_key=True),
    Column('event_id', ForeignKey('events.id'), primary_key=True)
)

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    # ======= New Authentication fields =======
    name = Column(String)
    email = Column(String, unique=True, index=True)
    phone = Column(String, unique=True, index=True, nullable=True) # Optional field
    hashed_password = Column(String)
    
    #profile setup information based on PRD
    interests = Column(String)
    meetup_style = Column(String)
    purpose = Column(String)
    availability = Column(String)
    preferred_locations = Column(String)

    # Relationship to the events CREATED by the user
    events = relationship("Event", back_populates="host")

    # Relationship to the events the user is ATTENDING
    attended_events = relationship("Event", secondary=event_attendees, back_populates="attendees")


class Event(Base):
    __tablename__ = "events"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    date = Column(String)
    location = Column(String)
    interest_tags = Column(String)
    group_size = Column(Integer)
    duration = Column(String) # "short-term" or "long-term"
    status = Column(String, default="Upcoming")

    # This establishes the link to the users table
    host_id = Column(Integer, ForeignKey("users.id"))

    # This creates a link back to the User model
    host = relationship("User", back_populates="events")

    # Relationship to the users who are ATTENDING the event
    attendees = relationship("User", secondary=event_attendees, back_populates="attended_events")
