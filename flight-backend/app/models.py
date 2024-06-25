from datetime import datetime
from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    ForeignKey,
    Text,
    ForeignKey,
    DECIMAL,
    Table,
    Boolean,
)
from sqlalchemy.orm import relationship
from app.db import Base

# Asociación de usuarios y perfiles
user_profiles = Table(
    "user_profiles",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("users.user_id"), primary_key=True),
    Column("profile_id", Integer, ForeignKey("profiles.profile_id"), primary_key=True),
    Column("assigned_at", DateTime, default=datetime.utcnow),
)

# Asociación de usuarios y módulos
user_modules = Table(
    "user_modules",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("users.user_id"), primary_key=True),
    Column("module_id", Integer, ForeignKey("modules.module_id"), primary_key=True),
    Column("access_level", String(20), default="read"),
    Column("created_at", DateTime, default=datetime.utcnow),
    Column("updated_at", DateTime, default=datetime.utcnow, onupdate=datetime.utcnow),
)


class User(Base):
    __tablename__ = "users"
    user_id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    first_name = Column(String(50))
    last_name = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    profiles = relationship("Profile", secondary=user_profiles, back_populates="users")
    modules = relationship("Module", secondary=user_modules, back_populates="users")


class Profile(Base):
    __tablename__ = "profiles"
    profile_id = Column(Integer, primary_key=True, autoincrement=True)
    profile_name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    users = relationship("User", secondary=user_profiles, back_populates="profiles")


class Module(Base):
    __tablename__ = "modules"
    module_id = Column(Integer, primary_key=True, autoincrement=True)
    module_name = Column(String(50), unique=True, nullable=False)
    icon = Column(String(50), unique=True, nullable=False)
    path = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    users = relationship("User", secondary=user_modules, back_populates="modules")


class Flight(Base):
    __tablename__ = "flights"
    flight_id = Column(Integer, primary_key=True, autoincrement=True)
    airline = Column(String(50), nullable=False)
    flight_number = Column(String(20), nullable=False)
    departure_airport = Column(String(3), nullable=False)
    arrival_airport = Column(String(3), nullable=False)
    departure_city = Column(String(50), nullable=False)
    arrival_city = Column(String(50), nullable=False)
    departure_time = Column(DateTime, nullable=False)
    arrival_time = Column(DateTime, nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Reservation(Base):
    __tablename__ = "reservations"
    reservation_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(50), nullable=False)
    flight_id = Column(Integer, ForeignKey("flights.flight_id"), nullable=False)
    seat_id = Column(Integer, ForeignKey("seats.seat_id"), nullable=False)
    reservation_status = Column(String(20), default="booked")
    seat_number = Column(String(10))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    flight = relationship("Flight")
    seat = relationship("Seat")


class Payment(Base):
    __tablename__ = "payments"
    payment_id = Column(Integer, primary_key=True, autoincrement=True)
    reservation_id = Column(
        Integer, ForeignKey("reservations.reservation_id"), nullable=False
    )
    payment_status = Column(String(20), default="pending")
    amount = Column(DECIMAL(10, 2), nullable=False)
    payment_method = Column(String(50), nullable=False)
    transaction_id = Column(String(100))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    reservation = relationship("Reservation")


class Notification(Base):
    __tablename__ = "notifications"
    notification_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    message = Column(Text, nullable=False)
    is_sent = Column(Boolean, default=False)
    send_at = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User")


class Catalog(Base):
    __tablename__ = "catalogs"
    catalog_id = Column(Integer, primary_key=True, autoincrement=True)
    catalog_name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class CatalogItem(Base):
    __tablename__ = "catalog_items"
    item_id = Column(Integer, primary_key=True, autoincrement=True)
    catalog_id = Column(Integer, ForeignKey("catalogs.catalog_id"), nullable=False)
    item_name = Column(String(50), nullable=False)
    item_description = Column(Text)
    item_price = Column(DECIMAL(10, 2))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    catalog = relationship("Catalog")


class Seat(Base):
    __tablename__ = "seats"
    seat_id = Column(Integer, primary_key=True)
    flight_id = Column(Integer, ForeignKey("flights.flight_id"), nullable=False)
    user_id = Column(String(50))
    seat_number = Column(String(5), nullable=False)
    is_occupied = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    flight = relationship("Flight", back_populates="seats")


Flight.seats = relationship("Seat", order_by=Seat.seat_id, back_populates="flight")
