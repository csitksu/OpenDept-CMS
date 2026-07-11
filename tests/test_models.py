from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.db import Base
from app.models.core import Department, User


def test_create_tables_and_basic_insert():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    s = Session()

    dept = Department(name="Computer Science")
    s.add(dept)
    user = User(full_name="Test User", email="test@example.com")
    s.add(user)
    s.commit()

    assert s.query(Department).count() == 1
    assert s.query(User).count() == 1
