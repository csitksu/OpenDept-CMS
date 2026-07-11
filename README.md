# 🎓 OpenDept CMS

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688.svg?logo=fastapi)
![Next.js](https://img.shields.io/badge/Frontend-Next.js-000000.svg?logo=next.js)
![Docker](https://img.shields.io/badge/Docker-Supported-2496ED.svg?logo=docker)

> OpenDept CMS is an open-source Headless CMS (FastAPI + Next.js) designed for academia. It connects students, faculty, and industry partners, featuring a smart Job Matching engine to enhance career prospects. The platform is fully scalable and ready for mobile app integration.

## ✨ Key Features
- API-First Architecture: Complete separation of backend API and frontend presentation.
- Academic Core Module: Manage curriculums, courses, and faculty directories.
- Stakeholder Portals: Dedicated dashboards for students, counselors, and industry partners.
- Intelligent Job Matching: A built-in job board with an automated matching engine.

## 🏗️ Tech Stack
- Backend: Python (FastAPI)
- Frontend: Next.js (React), TailwindCSS
- Database: MySQL / PostgreSQL
- Deployment: Docker & Docker Compose

---

## 🚀 Getting Started

### Prerequisites
Ensure you have the following installed on your system:
- Docker
- Docker Compose
- Git

### 1. Set up Environment Variables
The project uses environment variables for configuration. You need to create a .env file before running the containers.

1. Clone the repository:
   git clone https://github.com/YourOrganization/opendept-cms.git
   cd opendept-cms

2. Copy the template environment file:
   cp .env.example .env

3. Open the .env file in your text editor and update the variables (e.g., Database credentials, JWT Secret Keys) to match your local setup.

### 2. Database Migrations

This project uses **Alembic** for database schema migrations. Migrations are automatically applied when containers start, but you can also run them manually:

```bash
# Apply all pending migrations
alembic upgrade head

# Create a new migration (after modifying models)
alembic revision --autogenerate -m "Description of changes"

# View migration history
alembic history

# Downgrade to a specific revision
alembic downgrade -1
```

For more details, see the [Alembic documentation](https://alembic.sqlalchemy.org/).

### 3. Build and spin up the containers
Once your .env file is ready, you can build and start the entire application stack using Docker Compose. Run this command in the root directory:

docker-compose up -d --build

Note: The -d flag runs containers in the background, and --build ensures images are built with your latest code changes.

The docker-compose service automatically:
- Creates the database schema using Alembic migrations
- Seeds the database with initial development data
- Starts the FastAPI backend and Next.js frontend

### 4. Access the Application
After the containers are successfully running, you can access the system via your web browser:

- Frontend Portal (Next.js): http://localhost:3000
- Backend API Docs (Swagger UI): http://localhost:8000/docs
- Database (MySQL): localhost:3306

To stop the application, run:
docker-compose down

### 5. Local Development (Without Docker)

To run the backend locally without Docker:

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env

# Apply migrations
alembic upgrade head

# (Optional) Seed the database
python seed.py

# Run the server
uvicorn main:app --reload
```

Backend API will be available at http://localhost:8000

## 🗄️ Database Schema

The database schema includes the following core entities:

- **Users**: Students and faculty members
- **Roles**: Role-based access control (student, faculty, admin, industry_partner)
- **Departments**: Academic departments
- **Courses**: Individual courses within departments
- **Curricula**: Degree programs that group courses
- **JobPosts**: Job opportunities from industry partners
- **Applications**: Student applications to job postings

For the complete schema diagram, refer to the migration files in `alembic/versions/`

---

## 🤝 Contributing
We welcome contributions from developers, students, and open-source enthusiasts! 

1. Fork the repository and Clone your fork.
2. Create a new branch (git checkout -b feature/your-feature-name).
3. Commit your changes following Conventional Commits.
4. Push to your branch and Open a Pull Request.

Please read our CONTRIBUTING.md for detailed guidelines.

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for more details.

## 📞 Contact & Support
- **Project Lead:** Department of Computer Science and Information Technology, Faculty of Science and Health Technology, Kalasin University, Thailand.
- **Issue Tracker:** Please use the GitHub Issues page for bugs or feature requests.
- **Email Support:** paitoon.th@ksu.ac.th
