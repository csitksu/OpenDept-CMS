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

### 2. Build and spin up the containers
Once your .env file is ready, you can build and start the entire application stack using Docker Compose. Run this command in the root directory:

docker-compose up -d --build

Note: The -d flag runs containers in the background, and --build ensures images are built with your latest code changes.

### 3. Access the Application
After the containers are successfully running, you can access the system via your web browser:

- Frontend Portal (Next.js): http://localhost:3000
- Backend API Docs (Swagger UI): http://localhost:8000/docs
- Database Admin Panel: http://localhost:8080

To stop the application, run:
docker-compose down

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
