
-- Database Schema for Knowlance AI Website V1.0

-- Users table to store information about community members and team members
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255), -- Nullable for users who sign up for waitlist but don't have an account
    role VARCHAR(50) NOT NULL DEFAULT 'community_member', -- e.g., 'community_member', 'team_member', 'admin'
    linkedin_profile VARCHAR(255),
    github_profile VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Demo requests from the client console
CREATE TABLE demo_requests (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    work_email VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    role_title VARCHAR(255),
    challenge_description TEXT NOT NULL,
    desired_outcome TEXT,
    technical_requirements TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Community forum topics
CREATE TABLE community_topics (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100), -- e.g., 'Latest Trends', 'Use Cases', 'Development & Tools'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Community forum posts/replies
CREATE TABLE community_posts (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES community_topics(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Waitlist for the "AI Data Analyst" MVP
CREATE TABLE mvp_waitlist (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    signed_up_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Pre-populate team members from the PRD
-- This is more of a data seeding step, but useful for the developer
INSERT INTO users (full_name, email, role, linkedin_profile, github_profile, bio) VALUES
('Founder Name', 'founder@knowlance.ai', 'admin', 'https://linkedin.com/in/founder', 'https://github.com/founder', 'Founder of Knowlance AI.'),
('Engineer 1', 'engineer1@knowlance.ai', 'team_member', 'https://linkedin.com/in/engineer1', 'https://github.com/engineer1', 'AI/ML Engineer with expertise in NLP.'),
('Engineer 2', 'engineer2@knowlance.ai', 'team_member', 'https://linkedin.com/in/engineer2', 'https://github.com/engineer2', 'AI/ML Engineer specializing in Computer Vision.'),
('Engineer 3', 'engineer3@knowlance.ai', 'team_member', 'https://linkedin.com/in/engineer3', 'https://github.com/engineer3', 'AI/ML Engineer focused on data pipelines and automation.'),
('Engineer 4', 'engineer4@knowlance.ai', 'team_member', 'https://linkedin.com/in/engineer4', 'https://github.com/engineer4', 'AI/ML Engineer with a background in reinforcement learning.'),
('Engineer 5', 'engineer5@knowlance.ai', 'team_member', 'https://linkedin.com/in/engineer5', 'https://github.com/engineer5', 'Full-stack AI/ML Engineer.');
