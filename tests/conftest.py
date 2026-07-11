import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.db import Base
from app.models.core import (
    Department,
    Course,
    User,
    Role,
    Curriculum,
    JobPost,
    Application,
)


@pytest.fixture
def db_session():
    """Create a test database session."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()


def test_create_department(db_session):
    """Test creating a department."""
    dept = Department(name="Computer Science")
    db_session.add(dept)
    db_session.commit()

    assert db_session.query(Department).count() == 1
    assert db_session.query(Department).first().name == "Computer Science"


def test_create_course_with_department(db_session):
    """Test creating a course linked to a department."""
    dept = Department(name="CS")
    db_session.add(dept)
    db_session.flush()

    course = Course(code="CS101", title="Intro to CS", department_id=dept.id)
    db_session.add(course)
    db_session.commit()

    fetched_course = db_session.query(Course).first()
    assert fetched_course.code == "CS101"
    assert fetched_course.department.name == "CS"


def test_create_user_with_roles(db_session):
    """Test creating a user and assigning roles."""
    user = User(full_name="John Doe", email="john@example.com")
    role = Role(name="student")
    db_session.add(user)
    db_session.add(role)
    db_session.flush()

    user.roles.append(role)
    db_session.commit()

    fetched_user = db_session.query(User).first()
    assert fetched_user.full_name == "John Doe"
    assert len(fetched_user.roles) == 1
    assert fetched_user.roles[0].name == "student"


def test_create_curriculum_with_courses(db_session):
    """Test creating a curriculum and associating courses."""
    curriculum = Curriculum(name="BS Computer Science")
    course1 = Course(code="CS101", title="Intro to CS")
    course2 = Course(code="CS201", title="Data Structures")
    
    db_session.add(curriculum)
    db_session.add(course1)
    db_session.add(course2)
    db_session.flush()

    curriculum.courses.append(course1)
    curriculum.courses.append(course2)
    db_session.commit()

    fetched_curriculum = db_session.query(Curriculum).first()
    assert fetched_curriculum.name == "BS Computer Science"
    assert len(fetched_curriculum.courses) == 2


def test_create_job_application(db_session):
    """Test creating a job posting and application."""
    user = User(full_name="Jane Doe", email="jane@example.com")
    job = JobPost(title="Software Engineer Intern", description="Summer internship")
    
    db_session.add(user)
    db_session.add(job)
    db_session.flush()

    app = Application(user_id=user.id, job_post_id=job.id, status="pending")
    db_session.add(app)
    db_session.commit()

    fetched_app = db_session.query(Application).first()
    assert fetched_app.status == "pending"
    assert fetched_app.user.full_name == "Jane Doe"
    assert fetched_app.job_post.title == "Software Engineer Intern"


def test_all_tables_exist(db_session):
    """Test that all required tables are created."""
    metadata = Base.metadata
    table_names = {table.name for table in metadata.tables.values()}
    
    required_tables = {
        "users",
        "roles",
        "role_users",
        "departments",
        "courses",
        "curriculums",
        "curriculum_courses",
        "job_posts",
        "applications",
    }
    
    assert required_tables.issubset(table_names), f"Missing tables: {required_tables - table_names}"
