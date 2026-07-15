-- OpenDept CMS - Comprehensive SQL Schema
-- Supports all TOR modules: Core Academic, Stakeholder Portals, Labor Market, Job Matching, Admin
-- Database: PostgreSQL/MySQL compatible

-- ============================================================================
-- 0. BASE / SYSTEM TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_prefixes (
    id SERIAL PRIMARY KEY,
    prefix_name VARCHAR(50) UNIQUE NOT NULL,
    prefix_abbreviation VARCHAR(10),
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user_prefixes (prefix_name, prefix_abbreviation, display_order) VALUES
    ('Mister', 'Mr.', 1),
    ('Miss', 'Miss', 2),
    ('Missis', 'Mrs.', 3),
    ('Doctor', 'Dr.', 4),
    ('Professor', 'Prof.', 5),
    ('Associate Professor', 'Assoc. Prof.', 6),
    ('Assistant Professor', 'Asst. Prof.', 7),
    ('Lecturer', 'Lect.', 8)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS user_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user_types (type_name, description) VALUES
    ('admin', 'System administrator'),
    ('faculty', 'Faculty member'),
    ('student', 'Current student'),
    ('alumnus', 'Alumni'),
    ('prospective_student', 'Prospective student'),
    ('parent', 'Parent/Guardian'),
    ('counselor', 'Academic counselor'),
    ('employer', 'Employer/Industry partner')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 1. CORE USERS & ROLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    prefix_id INT REFERENCES user_prefixes(id),
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    username VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    organization_id INT REFERENCES organizations(id),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

CREATE TABLE IF NOT EXISTS user_user_types (
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_type_id INT NOT NULL REFERENCES user_types(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, user_type_id)
);

-- ============================================================================
-- 2. RBAC & PERMISSIONS (Admin Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    module VARCHAR(50),
    action VARCHAR(50),
    description TEXT
);

CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_system_role BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT REFERENCES users(id),
    PRIMARY KEY (user_id, role_id)
);

-- ============================================================================
-- 3. AUDIT LOGS (Admin Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    module VARCHAR(50),
    entity_type VARCHAR(100),
    entity_id INT,
    details JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    STATUS VARCHAR(20) DEFAULT 'success'
);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(created_at);

-- ============================================================================
-- 4. FACULTY & STAFF (Core Academic Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS faculty_titles (
    id SERIAL PRIMARY KEY,
    title_name VARCHAR(100) UNIQUE NOT NULL,
    title_level INT DEFAULT 0,
    description TEXT
);

INSERT INTO faculty_titles (title_name, title_level) VALUES
    ('Professor', 5),
    ('Associate Professor', 4),
    ('Assistant Professor', 3),
    ('Lecturer', 2),
    ('Instructor', 1)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS faculty (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title_id INT REFERENCES faculty_titles(id),
    office_location VARCHAR(255),
    office_phone VARCHAR(20),
    bio TEXT,
    qualification TEXT,
    hire_date DATE,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS faculty_expertise (
    id SERIAL PRIMARY KEY,
    faculty_id INT NOT NULL REFERENCES faculty(id) ON DELETE CASCADE,
    expertise_area VARCHAR(255) NOT NULL,
    proficiency_level VARCHAR(20),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS publications (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    publication_year INT,
    publication_venue VARCHAR(255),
    volume_issue VARCHAR(50),
    pages VARCHAR(50),
    url TEXT,
    doi VARCHAR(100),
    publication_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS publication_authors (
    publication_id INT NOT NULL REFERENCES publications(id) ON DELETE CASCADE,
    faculty_id INT NOT NULL REFERENCES faculty(id) ON DELETE CASCADE,
    author_order INT,
    is_corresponding BOOLEAN DEFAULT false,
    PRIMARY KEY (publication_id, faculty_id)
);

-- ============================================================================
-- 5. CURRICULUM & COURSES (Core Academic Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS curricula (
    id SERIAL PRIMARY KEY,
    curriculum_name VARCHAR(255) NOT NULL,
    curriculum_code VARCHAR(50) UNIQUE,
    organization_id INT REFERENCES organizations(id),
    description TEXT,
    total_credits INT,
    duration_years INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS curriculum_objectives (
    id SERIAL PRIMARY KEY,
    curriculum_id INT NOT NULL REFERENCES curricula(id) ON DELETE CASCADE,
    objective_text TEXT NOT NULL,
    objective_order INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(50) UNIQUE NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    curriculum_id INT REFERENCES curricula(id),
    description TEXT,
    credits INT,
    lecture_hours INT,
    lab_hours INT,
    faculty_id INT REFERENCES faculty(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS course_prerequisites (
    course_id INT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    prerequisite_course_id INT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    is_corequisite BOOLEAN DEFAULT false,
    PRIMARY KEY (course_id, prerequisite_course_id)
);

CREATE TABLE IF NOT EXISTS course_semesters (
    id SERIAL PRIMARY KEY,
    course_id INT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester_number INT NOT NULL,
    academic_year VARCHAR(10),
    is_offered BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS course_materials (
    id SERIAL PRIMARY KEY,
    course_id INT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    material_type VARCHAR(50),
    material_name VARCHAR(255),
    file_url TEXT,
    file_path VARCHAR(500),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by INT REFERENCES users(id)
);

-- ============================================================================
-- 6. NEWS, ANNOUNCEMENTS & EVENTS (Core Academic Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS post_categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    category_slug VARCHAR(100),
    description TEXT
);

INSERT INTO post_categories (category_name, category_slug) VALUES
    ('News', 'news'),
    ('Announcement', 'announcement'),
    ('Event', 'event')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE,
    category_id INT REFERENCES post_categories(id),
    author_id INT REFERENCES users(id),
    content TEXT NOT NULL,
    featured_image_url TEXT,
    excerpt VARCHAR(500),
    status VARCHAR(20) DEFAULT 'draft',
    published_at TIMESTAMP,
    is_featured BOOLEAN DEFAULT false,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_posts_status ON posts(STATUS);
CREATE INDEX idx_posts_published ON posts(published_at);

CREATE TABLE IF NOT EXISTS post_attachments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    attachment_name VARCHAR(255),
    file_url TEXT,
    file_path VARCHAR(500),
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS post_comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    author_id INT REFERENCES users(id),
    comment_text TEXT NOT NULL,
    parent_comment_id INT REFERENCES post_comments(id),
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 7. EXTERNAL PORTAL: PROSPECTIVE STUDENTS (External Stakeholder Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS admission_info (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    info_type VARCHAR(50),
    effective_date DATE,
    expiration_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INT REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS scholarships (
    id SERIAL PRIMARY KEY,
    scholarship_name VARCHAR(255) NOT NULL,
    description TEXT,
    amount DECIMAL(12, 2),
    eligibility_criteria TEXT,
    application_deadline DATE,
    award_count INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS career_paths (
    id SERIAL PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT,
    required_skills TEXT,
    salary_range_min DECIMAL(12, 2),
    salary_range_max DECIMAL(12, 2),
    career_growth_opportunities TEXT,
    industries VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 8. EXTERNAL PORTAL: COUNSELOR HUB (External Stakeholder Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS counselor_resources (
    id SERIAL PRIMARY KEY,
    resource_name VARCHAR(255) NOT NULL,
    resource_type VARCHAR(50),
    description TEXT,
    file_url TEXT,
    file_path VARCHAR(500),
    file_size BIGINT,
    downloads_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS counselor_coordination_forms (
    id SERIAL PRIMARY KEY,
    form_name VARCHAR(255) NOT NULL,
    form_description TEXT,
    file_url TEXT,
    file_path VARCHAR(500),
    version VARCHAR(20),
    effective_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 9. EXTERNAL PORTAL: ACADEMIC PARTNERS (External Stakeholder Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS academic_partners (
    id SERIAL PRIMARY KEY,
    institution_name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    contact_person VARCHAR(255),
    contact_email VARCHAR(255),
    collaboration_type VARCHAR(100),
    mou_date DATE,
    mou_expiration_date DATE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS collaboration_proposals (
    id SERIAL PRIMARY KEY,
    proposing_partner_id INT REFERENCES academic_partners(id),
    proposal_type VARCHAR(50),
    proposal_title VARCHAR(255),
    proposal_description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    submitted_by INT REFERENCES users(id),
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INT REFERENCES users(id),
    reviewed_date TIMESTAMP
);

-- ============================================================================
-- 10. INTERNAL PORTAL: STUDENTS (Internal Stakeholder Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS student_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    student_id VARCHAR(50) UNIQUE,
    curriculum_id INT REFERENCES curricula(id),
    enrollment_date DATE,
    graduation_date DATE,
    academic_status VARCHAR(50),
    gpa DECIMAL(3, 2),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS student_petitions (
    id SERIAL PRIMARY KEY,
    petition_name VARCHAR(255) NOT NULL,
    petition_description TEXT,
    file_url TEXT,
    file_path VARCHAR(500),
    version VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cwie_records (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    employer_name VARCHAR(255),
    internship_start_date DATE,
    internship_end_date DATE,
    position_title VARCHAR(255),
    supervisor_name VARCHAR(255),
    supervisor_email VARCHAR(255),
    hours_completed INT,
    credits_earned INT,
    status VARCHAR(50) DEFAULT 'ongoing',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 11. INTERNAL PORTAL: DASHBOARDS & STATS (Internal Stakeholder Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS dashboard_stats (
    id SERIAL PRIMARY KEY,
    stat_date DATE,
    stat_type VARCHAR(50),
    metric_name VARCHAR(100),
    metric_value INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS executive_reports (
    id SERIAL PRIMARY KEY,
    report_title VARCHAR(255) NOT NULL,
    report_description TEXT,
    generated_by INT REFERENCES users(id),
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 12. LABOR MARKET & JOB BOARD (Labor Market Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS job_categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    category_description TEXT,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS job_posts (
    id SERIAL PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT NOT NULL,
    category_id INT REFERENCES job_categories(id),
    employer_id INT REFERENCES users(id),
    position_type VARCHAR(50),
    location VARCHAR(255),
    salary_min DECIMAL(12, 2),
    salary_max DECIMAL(12, 2),
    currency VARCHAR(10) DEFAULT 'THB',
    num_positions INT DEFAULT 1,
    experience_required INT,
    education_required VARCHAR(100),
    status VARCHAR(50) DEFAULT 'open',
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_job_posts_status ON job_posts(STATUS);
CREATE INDEX idx_job_posts_category ON job_posts(category_id);

CREATE TABLE IF NOT EXISTS job_post_applications (
    id SERIAL PRIMARY KEY,
    job_post_id INT NOT NULL REFERENCES job_posts(id) ON DELETE CASCADE,
    applicant_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'submitted',
    cover_letter TEXT,
    reviewed_date TIMESTAMP,
    reviewed_by INT REFERENCES users(id)
);
CREATE INDEX idx_applications_status ON job_post_applications(STATUS);

CREATE TABLE IF NOT EXISTS market_trends (
    id SERIAL PRIMARY KEY,
    trend_date DATE,
    job_category_id INT REFERENCES job_categories(id),
    avg_salary DECIMAL(12, 2),
    opening_count INT,
    popular_skills TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS salary_ranges (
    id SERIAL PRIMARY KEY,
    job_category_id INT REFERENCES job_categories(id),
    job_level VARCHAR(50),
    experience_years INT,
    salary_min DECIMAL(12, 2),
    salary_max DECIMAL(12, 2),
    location VARCHAR(100),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 13. JOB MATCHING SYSTEM (Job Matching Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS skills (
    id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    skill_category VARCHAR(50),
    description TEXT,
    is_technical BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS student_skills (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    skill_id INT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20),
    years_of_experience INT,
    certified BOOLEAN DEFAULT false,
    certification_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, skill_id)
);

CREATE TABLE IF NOT EXISTS job_post_skills (
    id SERIAL PRIMARY KEY,
    job_post_id INT NOT NULL REFERENCES job_posts(id) ON DELETE CASCADE,
    skill_id INT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    required_proficiency VARCHAR(20),
    is_mandatory BOOLEAN DEFAULT true,
    weight_score INT DEFAULT 1,
    UNIQUE (job_post_id, skill_id)
);

CREATE TABLE IF NOT EXISTS portfolios (
    id SERIAL PRIMARY KEY,
    student_id INT UNIQUE NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    portfolio_title VARCHAR(255),
    portfolio_summary TEXT,
    portfolio_url TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS portfolio_projects (
    id SERIAL PRIMARY KEY,
    portfolio_id INT NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
    project_title VARCHAR(255) NOT NULL,
    project_description TEXT,
    project_url TEXT,
    github_url TEXT,
    technologies_used TEXT,
    project_image_url TEXT,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS skill_matching_scores (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    job_post_id INT NOT NULL REFERENCES job_posts(id) ON DELETE CASCADE,
    match_score DECIMAL(5, 2),
    match_percentage INT,
    skills_matched INT,
    skills_missing INT,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, job_post_id)
);

CREATE TABLE IF NOT EXISTS job_recommendations (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    job_post_id INT NOT NULL REFERENCES job_posts(id) ON DELETE CASCADE,
    recommendation_score DECIMAL(5, 2),
    reason TEXT,
    recommended_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    viewed_at TIMESTAMP,
    applied_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS matching_alerts (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    alert_type VARCHAR(50),
    alert_message TEXT,
    job_post_id INT REFERENCES job_posts(id),
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS matching_config (
    id SERIAL PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value VARCHAR(255),
    config_type VARCHAR(50),
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INT REFERENCES users(id)
);

INSERT INTO matching_config (config_key, config_value, config_type, description) VALUES
    ('min_match_threshold', '60', 'INT', 'Minimum match percentage to recommend'),
    ('mandatory_skill_weight', '1.5', 'FLOAT', 'Weight multiplier for mandatory skills'),
    ('optional_skill_weight', '1.0', 'FLOAT', 'Weight multiplier for optional skills'),
    ('gpa_weight', '0.1', 'FLOAT', 'GPA contribution to match score'),
    ('experience_weight', '0.2', 'FLOAT', 'Experience contribution to match score')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS employers (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    company_registration_number VARCHAR(50),
    company_website VARCHAR(255),
    company_size VARCHAR(50),
    industry VARCHAR(100),
    verification_status VARCHAR(50) DEFAULT 'pending',
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employer_verification (
    id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL REFERENCES employers(id) ON DELETE CASCADE,
    verification_type VARCHAR(50),
    verification_document_url TEXT,
    verification_date TIMESTAMP,
    verified_by INT REFERENCES users(id),
    verification_status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 14. ADMIN: MENU & SETTINGS (Admin Module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS menu_structure (
    id SERIAL PRIMARY KEY,
    menu_name VARCHAR(100) NOT NULL,
    menu_slug VARCHAR(100),
    parent_menu_id INT REFERENCES menu_structure(id),
    menu_order INT DEFAULT 0,
    menu_icon VARCHAR(50),
    menu_url VARCHAR(255),
    is_visible BOOLEAN DEFAULT true,
    requires_permission VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS content_categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    category_slug VARCHAR(100),
    category_description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS system_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(50),
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INT REFERENCES users(id)
);

-- ============================================================================
-- 15. NOTIFICATIONS
-- ============================================================================

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    recipient_user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(50),
    notification_title VARCHAR(255),
    notification_message TEXT,
    related_entity_type VARCHAR(100),
    related_entity_id INT,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_notifications_user ON notifications(recipient_user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_faculty_org ON faculty(user_id);
CREATE INDEX IF NOT EXISTS idx_courses_curriculum ON courses(curriculum_id);
CREATE INDEX IF NOT EXISTS idx_posts_category ON posts(category_id);
CREATE INDEX IF NOT EXISTS idx_applications_student ON job_post_applications(applicant_id);
CREATE INDEX IF NOT EXISTS idx_student_skills_student ON student_skills(student_id);
CREATE INDEX IF NOT EXISTS idx_job_recommendations_student ON job_recommendations(student_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_module ON audit_logs(module);
CREATE INDEX IF NOT EXISTS idx_cwie_student ON cwie_records(student_id);

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
