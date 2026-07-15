# OpenDept CMS - Comprehensive Database Design

Based on TOR: Development of an Open-Source Headless CMS Platform for DCIT, Kalasin University

## Overview

This document details the complete database schema covering all 6 modules:
1. Core Content & Academic Module
2. External Stakeholders Portal
3. Internal Stakeholders Portal
4. Labor Market & Job Board Module
5. Job Matching System
6. Administration Module

---

## Module 1: Core Content & Academic Module

### 1.1 News, Announcements & Events

| Table | Purpose |
|-------|---------|
| **posts** | News, announcements, events with categories and status |
| **post_categories** | Categories: news, announcement, event |
| **post_attachments** | Files attached to posts |
| **post_comments** | User comments on posts |

### 1.2 Curriculum & Course Management

| Table | Purpose |
|-------|---------|
| **curricula** | Degree programs (e.g., "BS Computer Science") |
| **curriculum_objectives** | Learning objectives for each curriculum |
| **courses** | Individual courses with credits, prerequisites |
| **course_semesters** | Course schedule (Sem 1-8, offered years) |
| **course_materials** | Syllabi, course descriptions, resources |
| **course_prerequisites** | Prerequisite relationships |

### 1.3 Faculty & Staff Directory

| Table | Purpose |
|-------|---------|
| **faculty** | Faculty profile (user + additional fields) |
| **faculty_titles** | Academic titles (Prof, Assoc. Prof, etc.) |
| **faculty_departments** | Department assignments |
| **faculty_expertise** | Research areas & specialization |
| **publications** | Research publications (author, date, venue) |
| **publication_authors** | Many-to-many faculty-publication |

---

## Module 2 & 3: Stakeholder Portals

### 2.1 External Portal: Prospective Students & Parents

| Table | Purpose |
|-------|---------|
| **admission_info** | Admission requirements, timeline, procedures |
| **scholarships** | Scholarship programs, eligibility, application deadlines |
| **career_paths** | Career pathways (job roles, salary expectations) |

### 2.2 External Portal: Counselor Hub

| Table | Purpose |
|-------|---------|
| **counselor_resources** | Downloadable materials (presentations, forms) |
| **counselor_coordination_forms** | Coordination documents for counselors |

### 2.3 External Portal: Academic Partners

| Table | Purpose |
|-------|---------|
| **academic_partners** | Partner institutions, MOUs |
| **collaboration_proposals** | Research/curriculum collaboration requests |

### 3.1 Internal Portal: Current Students

| Table | Purpose |
|-------|---------|
| **student_petitions** | Downloadable petition forms |
| **cwie_records** | Cooperative Education & Work Integrated Education data |

### 3.2 Internal Portal: Faculty & Executives

| Table | Purpose |
|-------|---------|
| **dashboard_stats** | Visitor statistics, enrollment, engagement metrics |
| **executive_reports** | Generated reports for decision-making |

---

## Module 4: Labor Market & Job Board

| Table | Purpose |
|-------|---------|
| **job_categories** | Job classification (IT, Sales, etc.) |
| **job_posts** | Job postings with category, salary, skills required |
| **job_post_skills** | Many-to-many job_posts-skills |
| **job_post_applications** | Applications to job postings |
| **market_trends** | Labor market statistics & trends |
| **salary_ranges** | Salary data by job category & location |

---

## Module 5: Job Matching System

### 5.1 Employer Management

| Table | Purpose |
|-------|---------|
| **employers** | Company profile with verification status |
| **employer_verification** | KYC/identity verification records |

### 5.2 Student/Alumni Portfolio

| Table | Purpose |
|-------|---------|
| **student_profiles** | Student/Alumni profile with status |
| **skills** | All available skills (database) |
| **student_skills** | Student expertise & proficiency levels |
| **portfolios** | Digital portfolio/resume with projects |
| **portfolio_projects** | Individual portfolio projects |

### 5.3 Job Matching Engine

| Table | Purpose |
|-------|---------|
| **skill_matching_scores** | Matching scores between student & job (algorithmic) |
| **job_recommendations** | Generated recommendations for students |
| **matching_alerts** | Automated alerts when match > threshold |
| **matching_config** | Configuration & weights for matching algorithm |

---

## Module 6: Administration

| Table | Purpose |
|-------|---------|
| **audit_logs** | Complete audit trail (user, action, timestamp, IP) |
| **role_based_access** | RBAC permissions & role hierarchy |
| **menu_structure** | Dynamic menu structure for portal |
| **content_categories** | Content categorization system |
| **system_settings** | Configuration & feature toggles |

---

## Cross-Module Tables

| Table | Purpose |
|-------|---------|
| **users** | All system users (students, faculty, admins, employers) |
| **user_types** | User role: student, faculty, admin, employer, prospective |
| **user_prefixes** | Name prefixes (Mr., Dr., Prof., etc.) |
| **organizations** | Department, university, companies |
| **notifications** | System notifications & alerts |

---

## ER Diagram Structure

```
USERS (core identity)
├── USER_TYPES
├── USER_PREFIXES
├── ORGANIZATIONS
│
├── ACADEMIC BRANCH (faculty, students, courses)
│   ├── FACULTY
│   │   ├── FACULTY_TITLES
│   │   ├── FACULTY_EXPERTISE
│   │   └── PUBLICATIONS
│   ├── CURRICULA
│   │   ├── COURSES
│   │   ├── COURSE_MATERIALS
│   │   └── COURSE_PREREQUISITES
│   ├── STUDENT_PROFILES
│   │   └── CWIE_RECORDS
│   └── POSTS (news, events)
│       ├── POST_CATEGORIES
│       ├── POST_ATTACHMENTS
│       └── POST_COMMENTS
│
├── EXTERNAL PORTAL BRANCH
│   ├── ADMISSION_INFO
│   ├── SCHOLARSHIPS
│   ├── CAREER_PATHS
│   ├── COUNSELOR_RESOURCES
│   └── ACADEMIC_PARTNERS
│
├── INTERNAL PORTAL BRANCH
│   ├── STUDENT_PETITIONS
│   └── DASHBOARD_STATS
│
├── LABOR MARKET BRANCH
│   ├── JOB_CATEGORIES
│   ├── JOB_POSTS
│   │   ├── JOB_POST_SKILLS
│   │   ├── JOB_POST_APPLICATIONS
│   │   └── MARKET_TRENDS
│   └── SALARY_RANGES
│
├── JOB MATCHING BRANCH
│   ├── EMPLOYERS
│   │   └── EMPLOYER_VERIFICATION
│   ├── SKILLS
│   ├── STUDENT_SKILLS
│   ├── PORTFOLIOS
│   │   └── PORTFOLIO_PROJECTS
│   ├── SKILL_MATCHING_SCORES
│   ├── JOB_RECOMMENDATIONS
│   ├── MATCHING_ALERTS
│   └── MATCHING_CONFIG
│
└── ADMINISTRATION BRANCH
    ├── AUDIT_LOGS
    ├── ROLE_BASED_ACCESS
    ├── MENU_STRUCTURE
    ├── CONTENT_CATEGORIES
    └── SYSTEM_SETTINGS
```

---

## Key Design Decisions

1. **User-Centric**: All stakeholders (students, faculty, admins, employers) share a common USERS table with USER_TYPES for role distinction
2. **Name Management**: Separate USER_PREFIXES table for titles (Mr., Dr., Prof., A.P., etc.)
3. **Skill Taxonomy**: Centralized SKILLS table with student/job proficiency mapping
4. **Audit Trail**: Complete AUDIT_LOGS for compliance and security monitoring
5. **Matching Algorithm**: Dedicated tables for matching scores, recommendations, and configuration
6. **Modular Design**: Each module is independently queryable but interconnected for reports

---

## Next Steps

1. Generate comprehensive SQL DDL from this design
2. Create SQLAlchemy ORM models for all tables
3. Implement Alembic migration scripts
4. Build API endpoints for each module
5. Create frontend integration points
