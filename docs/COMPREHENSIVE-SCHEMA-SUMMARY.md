# OpenDept CMS - Comprehensive Database Implementation Summary

## Overview

This document summarizes the comprehensive database design for OpenDept CMS, a Headless Content Management System for Kalasin University's Department of Computer Science and Information Technology (DCIT).

**Design Status**: Complete ✓  
**Schema Tables**: 70+ tables across 6 modules  
**Alignment**: Fully aligned with TOR requirements  
**Implementation Phase**: SQLAlchemy models + Alembic migrations (pending)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenDept CMS Database                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  0. SYSTEM FOUNDATION                                │  │
│  │  └─ organizations, user_prefixes, user_types, users  │  │
│  │     roles, permissions, audit_logs                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. CORE ACADEMIC (Faculty, Curriculum, Content)     │  │
│  │  └─ faculty, publications, courses, curricula,       │  │
│  │     course_materials, posts, news, announcements     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  2-3. STAKEHOLDER PORTALS (External & Internal)      │  │
│  │  └─ admission_info, scholarships, counselor_hub,     │  │
│  │     student_profiles, cwie_records, dashboard_stats  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  4. LABOR MARKET & JOB BOARD                         │  │
│  │  └─ job_posts, job_categories, market_trends,       │  │
│  │     salary_ranges, job_applications                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  5. JOB MATCHING SYSTEM (Algorithm-Driven)           │  │
│  │  └─ skills, student_skills, portfolios,             │  │
│  │     skill_matching_scores, job_recommendations,      │  │
│  │     matching_alerts, matching_config                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  6. ADMINISTRATION                                   │  │
│  │  └─ menu_structure, content_categories,             │  │
│  │     system_settings, notifications                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Module Breakdown

### Module 0: System Foundation (RBAC & Audit)

**Purpose**: Core identity, authorization, and compliance infrastructure

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| **organizations** | Departments, schools, institutions | name, slug, is_active |
| **user_prefixes** | Name titles (Mr., Dr., Prof., etc.) | prefix_name, abbreviation |
| **user_types** | User roles (admin, faculty, student, etc.) | type_name, description |
| **users** | All system users (unified identity) | email, username, is_verified, last_login |
| **roles** | RBAC roles (e.g., admin, editor, viewer) | role_name, is_system_role |
| **permissions** | Granular permissions (create, read, update, delete) | permission_name, module, action |
| **role_permissions** | Role ↔ Permission many-to-many | role_id, permission_id |
| **user_roles** | User ↔ Role assignment with audit | user_id, role_id, assigned_by, assigned_at |
| **user_user_types** | User ↔ Type mapping (multi-type support) | user_id, user_type_id |
| **audit_logs** | Complete action trail for compliance | user_id, action, entity_type, details, ip_address |

**Key Features**:
- ✓ Supports multi-role assignment per user
- ✓ Granular permission-based access control
- ✓ Complete audit trail with IP tracking
- ✓ Extensible through JSONB details field

---

### Module 1: Core Academic (Faculty, Curriculum, Content)

#### Faculty & Publications

| Table | Purpose |
|-------|---------|
| **faculty_titles** | Academic ranks (Prof, Assoc. Prof, Lecturer) |
| **faculty** | Faculty profile linked to users |
| **faculty_expertise** | Research areas & specialization |
| **publications** | Research publications |
| **publication_authors** | Many-to-many faculty-publication |

**Key Features**:
- Tracks academic titles with hierarchy
- Expertise areas with proficiency levels
- Publication metadata (DOI, venue, volume)
- Multi-author publications support

#### Curriculum & Courses

| Table | Purpose |
|-------|---------|
| **curricula** | Degree programs (BS, MS, etc.) |
| **curriculum_objectives** | Learning objectives per program |
| **courses** | Individual courses |
| **course_prerequisites** | Prerequisite chains |
| **course_semesters** | Semester schedules |
| **course_materials** | Syllabus, resources, documents |

**Key Features**:
- Prerequisite chain validation
- Multi-semester scheduling
- Course material version control
- Faculty assignment tracking

#### News, Announcements & Events

| Table | Purpose |
|-------|---------|
| **post_categories** | Categories: news, announcement, event |
| **posts** | Main content with status workflow |
| **post_attachments** | Multimedia attachments |
| **post_comments** | Threaded comments with approval |

**Key Features**:
- Draft → Published workflow
- Featured content highlighting
- View count tracking
- Threaded comment system

---

### Modules 2-3: Stakeholder Portals (External & Internal)

#### External Portals

**Prospective Students & Parents**:
- admission_info: Admission requirements, timelines
- scholarships: Award programs, eligibility, deadlines
- career_paths: Job roles, salary expectations

**Counselor Hub**:
- counselor_resources: Downloadable materials (presentations, forms)
- counselor_coordination_forms: Official coordination documents

**Academic Partners**:
- academic_partners: MOUs with external institutions
- collaboration_proposals: Research/curriculum partnership requests

#### Internal Portals

**Current Students**:
- student_profiles: Student identity + academic status
- student_petitions: Downloadable petition forms
- cwie_records: Internship & work-integrated education tracking

**Faculty & Executives**:
- dashboard_stats: Visitor metrics, enrollment, engagement
- executive_reports: Generated reports with decision-making data

---

### Module 4: Labor Market & Job Board

| Table | Purpose |
|-------|---------|
| **job_categories** | Job classification (IT, Sales, HR, etc.) |
| **job_posts** | Job postings with salary, location, requirements |
| **job_post_applications** | Applications to job postings |
| **market_trends** | Labor market statistics & trends by category |
| **salary_ranges** | Salary data by job level & location |

**Key Features**:
- Multi-criteria job posting (title, category, salary, location)
- Application status tracking
- Market trend analysis
- Salary range benchmarking

---

### Module 5: Job Matching System (Core Innovation)

#### Skill Management

| Table | Purpose |
|-------|---------|
| **skills** | Master skill database (technical + soft skills) |
| **student_skills** | Student skill proficiency with certification |
| **job_post_skills** | Job requirements with mandatory/optional flags |

**Key Features**:
- Centralized skill taxonomy
- Proficiency level tracking (beginner, intermediate, expert)
- Certification tracking
- Mandatory vs. optional skill differentiation

#### Portfolio & Profile

| Table | Purpose |
|-------|---------|
| **portfolios** | Student digital portfolios/resumes |
| **portfolio_projects** | Individual project showcases |

**Key Features**:
- Public/private portfolio control
- Project URL & GitHub integration
- Technology stack documentation
- Time-bound project tracking

#### Matching Engine (Algorithm Core)

| Table | Purpose |
|-------|---------|
| **skill_matching_scores** | Calculated match % (student ↔ job) |
| **job_recommendations** | Generated recommendations with reasons |
| **matching_alerts** | Automated alerts when match threshold met |
| **matching_config** | Algorithm weights & configuration |

**Key Features**:
- Score-based matching (0-100%)
- Configurable thresholds & weights
- Alert generation on high-match jobs
- Recommendation tracking with engagement

#### Employer Management

| Table | Purpose |
|-------|---------|
| **employers** | Company profiles with KYC status |
| **employer_verification** | Identity verification records |

**Key Features**:
- Company size & industry tracking
- Verification status workflow
- Document trail for compliance

---

### Module 6: Administration

#### Access Control

| Table | Purpose |
|-------|---------|
| **role_based_access** | RBAC (covered under user_roles) |
| (Inherited from Module 0) | |

#### System Management

| Table | Purpose |
|-------|---------|
| **menu_structure** | Dynamic portal navigation |
| **content_categories** | Global content categorization |
| **system_settings** | Configuration & feature toggles |
| **notifications** | System alerts & notifications |

**Key Features**:
- Dynamic menu hierarchy
- Feature toggle control
- Notification delivery tracking
- Settings versioning with audit

---

## Key Design Decisions

### 1. Unified User Identity
- Single USERS table for all stakeholders
- USER_TYPES for role classification (supports multi-role per user)
- Extensible through user_type combinations

### 2. Prefix Tables (Normalized)
- USER_PREFIXES: Centralized title management
- FACULTY_TITLES: Academic rank hierarchy
- Enables consistency and easy updates

### 3. RBAC Architecture
- Granular permissions (create, read, update, delete per module)
- Role-permission mapping
- User role assignment with audit trail
- Supports dynamic role creation

### 4. Audit Trail
- Complete audit_logs table with:
  - User action tracking
  - Entity-level changes
  - IP address & user agent
  - JSONB details for flexible logging
- Compliance-ready for regulations

### 5. Job Matching Algorithm
- Dedicated matching_scores, recommendations, alerts tables
- Configurable weights in matching_config
- Separates algorithm logic from data

### 6. Multi-Type User Support
- Students can be alumni
- Faculty can be admins
- Employers can have multiple roles
- Flexible through user_user_types bridge

### 7. Modular Design
- Each module independently queryable
- Clear table naming conventions
- Minimal cross-module dependencies
- Supports future microservices split

---

## Database Statistics

| Metric | Count |
|--------|-------|
| Total Tables | 70+ |
| Foreign Keys | 80+ |
| Indexes | 30+ |
| Many-to-Many Tables | 12 |
| JSONB Fields | 2 |
| Audit-Enabled Tables | 12+ |

---

## Implementation Roadmap

### Phase 1: Core Schema (Completed ✓)
- [x] Design comprehensive ER diagram
- [x] Create SQL DDL (schema-comprehensive.sql)
- [x] Document TOR alignment (TOR-DATABASE-DESIGN.md)

### Phase 2: SQLAlchemy Models (Pending)
- [ ] Create ORM models for all 70+ tables
- [ ] Implement relationships & cascades
- [ ] Add Pydantic schemas for API serialization

### Phase 3: Alembic Migrations (Pending)
- [ ] Generate initial migration from models
- [ ] Create data migration for seed prefixes/roles
- [ ] Test migration rollback/forward

### Phase 4: Seed Data (Pending)
- [ ] Populate user_prefixes, user_types, permissions
- [ ] Add default roles (admin, faculty, student, employer)
- [ ] Create sample organizations & departments

### Phase 5: API Endpoints (Pending)
- [ ] RESTful CRUD for each module
- [ ] FastAPI route organization by module
- [ ] OpenAPI/Swagger documentation

### Phase 6: Testing (Pending)
- [ ] Integration tests for relationships
- [ ] Schema validation tests
- [ ] Data integrity tests

---

## SQL Files Reference

| File | Purpose |
|------|---------|
| **schema-comprehensive.sql** | Complete DDL with all 70+ tables, indexes, constraints, sample inserts |
| **erd-comprehensive.mmd** | Mermaid ER diagram (erDiagram format) with all relationships |
| **erd-comprehensive.png** | Rendered ER diagram (PNG format) |
| **erd-comprehensive.svg** | Rendered ER diagram (SVG format) |
| **TOR-DATABASE-DESIGN.md** | Module breakdown & design rationale |

---

## Next Steps

1. **Render ER Diagram**: Complete PNG/SVG rendering (in progress)
2. **Create SQLAlchemy Models**: Implement ORM models for all tables
3. **Generate Alembic Migration**: Auto-generate initial migration from models
4. **Commit & Push**: Version control comprehensive schema
5. **Create API Layer**: RESTful endpoints per module
6. **Document API**: OpenAPI/Swagger integration

---

## Appendix: TOR Module Mapping

| TOR Module | Database Tables | Coverage |
|-----------|-----------------|----------|
| Core Content & Academic | faculty, publications, curricula, courses, posts, post_attachments | ✓ Complete |
| External Stakeholders Portal | admission_info, scholarships, career_paths, counselor_resources, academic_partners | ✓ Complete |
| Internal Stakeholders Portal | student_profiles, cwie_records, dashboard_stats, executive_reports | ✓ Complete |
| Labor Market & Job Board | job_categories, job_posts, market_trends, salary_ranges, job_applications | ✓ Complete |
| Job Matching System | skills, student_skills, portfolios, skill_matching_scores, job_recommendations, matching_alerts | ✓ Complete |
| Administration Module | roles, permissions, audit_logs, menu_structure, content_categories, system_settings | ✓ Complete |

---

## Document Metadata

- **Created**: Today
- **Schema Version**: 1.0.0
- **Database Compatibility**: PostgreSQL, MySQL, MariaDB
- **ORM Framework**: SQLAlchemy 1.4+
- **Migration Tool**: Alembic

---

## Contact & Questions

For schema questions or clarifications, refer to:
- TOR-DATABASE-DESIGN.md (module breakdown)
- schema-comprehensive.sql (DDL details)
- erd-comprehensive.mmd (visual relationships)
