
-- Database Schema for Knowlance AI Website
-- Version: 1.0
-- Author: Solution Architect

-- This schema defines the tables for managing users, community discussions, and leads generated from the website.

-- Table for storing user accounts.
-- Users can be community members or staff.
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_staff BOOLEAN DEFAULT FALSE,
    linkedin_profile VARCHAR(255),
    github_profile VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing community discussion topics.
CREATE TABLE community_topics (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing individual posts/replies within a community topic.
CREATE TABLE community_posts (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES community_topics(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing leads from the "Apply for a Demo" form.
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    work_email VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    role VARCHAR(255),
    challenge_description TEXT NOT NULL,
    goal TEXT,
    technical_requirements TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing email sign-ups for the MVP waitlist.
CREATE TABLE mvp_waitlist (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    signed_up_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_community_topics_user_id ON community_topics(user_id);
CREATE INDEX idx_community_posts_topic_id ON community_posts(topic_id);
CREATE INDEX idx_community_posts_user_id ON community_posts(user_id);
CREATE INDEX idx_leads_work_email ON leads(work_email);
