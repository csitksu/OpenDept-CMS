from app.db import SessionLocal
from app.models.core import Department, Role, Course, User
from sqlalchemy import create_engine


def seed_database():
    """Seed database with initial data for development."""
    # Create tables if they don't exist
    from app.db import engine, Base
    Base.metadata.create_all(engine)

    db = SessionLocal()

    # Check if already seeded
    if db.query(Department).count() > 0:
        print("Database already seeded, skipping...")
        db.close()
        return

    # Create roles
    roles_data = [
        {"name": "student"},
        {"name": "faculty"},
        {"name": "admin"},
        {"name": "industry_partner"},
    ]
    roles = [Role(**role) for role in roles_data]
    db.add_all(roles)
    db.flush()

    # Create departments
    departments_data = [
        {"name": "Computer Science"},
        {"name": "Information Technology"},
        {"name": "Engineering"},
    ]
    departments = [Department(**dept) for dept in departments_data]
    db.add_all(departments)
    db.flush()

    # Create courses
    courses_data = [
        {"code": "CS101", "title": "Introduction to Programming", "department_id": departments[0].id},
        {"code": "CS201", "title": "Data Structures", "department_id": departments[0].id},
        {"code": "IT101", "title": "Database Fundamentals", "department_id": departments[1].id},
    ]
    courses = [Course(**course) for course in courses_data]
    db.add_all(courses)
    db.flush()

    # Create users
    users_data = [
        {"full_name": "Alice Student", "email": "alice@university.edu"},
        {"full_name": "Bob Faculty", "email": "bob@university.edu"},
        {"full_name": "Admin User", "email": "admin@university.edu"},
    ]
    users = [User(**user) for user in users_data]
    db.add_all(users)
    db.flush()

    # Assign roles
    users[0].roles.append(roles[0])  # Alice is a student
    users[1].roles.append(roles[1])  # Bob is faculty
    users[2].roles.append(roles[2])  # Admin is admin

    db.commit()
    db.close()
    print("Database seeded successfully!")


if __name__ == "__main__":
    seed_database()
