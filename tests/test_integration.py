import pytest
from sqlalchemy import inspect
from app.db import SessionLocal, engine, Base
from app.models.core import Department, User


def test_migration_creates_all_tables():
    """Test that migrations create all required tables."""
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    
    expected_tables = {
        'users', 'roles', 'departments', 'courses', 
        'curriculums', 'job_posts', 'applications',
        'role_users', 'curriculum_courses'
    }
    
    for table in expected_tables:
        assert table in tables, f"Table {table} not found in database"


def test_can_insert_and_query_data():
    """Test basic CRUD operations through the schema."""
    Base.metadata.create_all(engine)
    db = SessionLocal()
    
    try:
        # Insert
        dept = Department(name="Test Department")
        db.add(dept)
        db.commit()
        
        # Query
        result = db.query(Department).filter_by(name="Test Department").first()
        assert result is not None
        assert result.name == "Test Department"
        
        # Update
        result.name = "Updated Department"
        db.commit()
        
        updated = db.query(Department).filter_by(name="Updated Department").first()
        assert updated is not None
        
        # Delete
        db.delete(updated)
        db.commit()
        
        deleted = db.query(Department).filter_by(name="Updated Department").first()
        assert deleted is None
    finally:
        db.close()
