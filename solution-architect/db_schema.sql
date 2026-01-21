-- Users Table: Stores information about registered community members and team members.
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

-- Leads Table: Stores information from the "Apply for a Demo" form.
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    work_email VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    role VARCHAR(255),
    challenge_description TEXT NOT NULL,
    desired_outcome TEXT,
    technical_requirements TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- MVP Waitlist Table: Stores emails for the "AI Data Analyst" MVP waitlist.
CREATE TABLE mvp_waitlist (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    signed_up_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Community Topics Table: Stores discussion topics in the community forum.
CREATE TABLE community_topics (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL, -- Keep topic even if user is deleted
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Community Posts Table: Stores replies to community topics.
CREATE TABLE community_posts (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES community_topics(id) ON DELETE CASCADE, -- Delete posts if topic is deleted
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL, -- Keep post even if user is deleted
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_leads_work_email ON leads(work_email);
CREATE INDEX idx_mvp_waitlist_email ON mvp_waitlist(email);
CREATE INDEX idx_community_topics_user_id ON community_topics(user_id);
CREATE INDEX idx_community_posts_topic_id ON community_posts(topic_id);
CREATE INDEX idx_community_posts_user_id ON community_posts(user_id);
