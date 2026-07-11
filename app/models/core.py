from datetime import datetime
from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    ForeignKey,
    Table,
    DateTime,
)
from sqlalchemy.orm import relationship
from app.db import Base

# Association tables
role_users = Table(
    "role_users",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("users.id"), primary_key=True),
    Column("role_id", Integer, ForeignKey("roles.id"), primary_key=True),
)

curriculum_courses = Table(
    "curriculum_courses",
    Base.metadata,
    Column("curriculum_id", Integer, ForeignKey("curriculums.id"), primary_key=True),
    Column("course_id", Integer, ForeignKey("courses.id"), primary_key=True),
)


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(200), nullable=False)
    email = Column(String(200), unique=True, index=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    roles = relationship("Role", secondary=role_users, back_populates="users")
    applications = relationship("Application", back_populates="user")


class Role(Base):
    __tablename__ = "roles"
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)

    users = relationship("User", secondary=role_users, back_populates="roles")


class Department(Base):
    __tablename__ = "departments"
    id = Column(Integer, primary_key=True)
    name = Column(String(200), unique=True, nullable=False)

    courses = relationship("Course", back_populates="department")


class Course(Base):
    __tablename__ = "courses"
    id = Column(Integer, primary_key=True)
    code = Column(String(50), unique=True, nullable=False)
    title = Column(String(300), nullable=False)
    description = Column(Text)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)

    department = relationship("Department", back_populates="courses")
    curriculums = relationship("Curriculum", secondary=curriculum_courses, back_populates="courses")


class Curriculum(Base):
    __tablename__ = "curriculums"
    id = Column(Integer, primary_key=True)
    name = Column(String(200), nullable=False)
    description = Column(Text)

    courses = relationship("Course", secondary=curriculum_courses, back_populates="curriculums")


class JobPost(Base):
    __tablename__ = "job_posts"
    id = Column(Integer, primary_key=True)
    title = Column(String(300), nullable=False)
    description = Column(Text)
    posted_at = Column(DateTime, default=datetime.utcnow)

    applications = relationship("Application", back_populates="job_post")


class Application(Base):
    __tablename__ = "applications"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    job_post_id = Column(Integer, ForeignKey("job_posts.id"), nullable=False)
    status = Column(String(50), default="submitted")
    applied_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="applications")
    job_post = relationship("JobPost", back_populates="applications")
