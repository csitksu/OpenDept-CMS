# 🎓 OpenDept CMS

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688.svg?logo=fastapi)
![Next.js](https://img.shields.io/badge/Frontend-Next.js-000000.svg?logo=next.js)
![Docker](https://img.shields.io/badge/Docker-Supported-2496ED.svg?logo=docker)
![Contributions welcome](https://img.shields.io/badge/Contributions-welcome-orange.svg)

> An API-first, Open-Source Headless CMS featuring an intelligent Job Matching engine, meticulously designed for academic departments and higher education institutions.

Originally initiated by the **Department of Computer Science and Information Technology, Kalasin University**, OpenDept CMS aims to provide a scalable, secure, and modern platform to bridge the communication gap between educational institutions and their stakeholders.

## ✨ Key Features

- **API-First Architecture:** Complete separation of backend API and frontend presentation, ready for seamless mobile application (iOS/Android) integration in the future.
- **Academic Core Module:** Manage curriculums, courses, faculty directories, and departmental news.
- **Stakeholder Portals:** Dedicated dashboards and resource hubs tailored for:
  - Prospective Students & Parents
  - Current Students
  - Guidance Counselors
  - Academic Networks & Industry Partners
- **Intelligent Job Matching & Labor Market:** A built-in job board equipped with a matching algorithm that connects student/alumni skills with employer requirements.
- **Role-Based Access Control (RBAC):** Secure administration module with comprehensive audit logs.

## 🏗️ Architecture & Tech Stack

This project is built for high performance and scalability:

- **Backend (API):** [FastAPI (Python)](https://fastapi.tiangolo.com/) - Lightning fast, asynchronous, and AI-ready for future matching algorithms.
- **Frontend (Web):** [Next.js (React)](https://nextjs.org/) - Utilizing Server-Side Rendering (SSR) for optimal speed and SEO.
- **Database:** [MySQL](https://www.mysql.com/) / MariaDB or PostgreSQL via SQLAlchemy.
- **Infrastructure:** [Docker](https://www.docker.com/) & Docker Compose for seamless containerized deployment and CI/CD pipelines.

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

Ensure you have the following installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Git

### Installation via Docker (Recommended)

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YourOrganization/opendept-cms.git](https://github.com/YourOrganization/opendept-cms.git)
   cd opendept-cms
