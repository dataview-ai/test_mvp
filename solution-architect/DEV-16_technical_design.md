
# Technical Design Document: DEV-16 - Core Data Model & Schema

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect

## 1. Overview

This document outlines the technical architecture, data models, and API specifications for the Knowlance AI website (V1.0). The goal is to create a robust, scalable, and performant platform that meets the requirements outlined in the PRD (DEV-16), including lead generation, community building, and brand establishment.

## 2. High-Level Architecture

We will adopt a decoupled architecture using a modern frontend framework, a backend API service, and a relational database.

*   **Frontend:** **Next.js (React)**. This choice provides excellent performance through Server-Side Rendering (SSR) and Static Site Generation (SSG), which is crucial for SEO and a fast user experience. It allows for the creation of a dynamic, single-page application feel while maintaining performance.
*   **Backend:** **Node.js with Express.js**. A lightweight and efficient choice for building the RESTful API. It will handle business logic for form submissions, user authentication, and community forum interactions.
*   **Database:** **PostgreSQL**. A powerful, open-source, and reliable relational database that can effectively model the relationships between users, forum topics, and posts, while also storing lead and waitlist data.

![Architecture Diagram](https://i.imgur.com/3yQYm2C.png)

## 3. Data Models

The database will be structured around the following core entities. The detailed schema is provided in `DEV-16_db_schema.sql`.

### 3.1. `users`
Stores information for registered community members.
- `id`: UUID (Primary Key)
- `email`: VARCHAR(255) (Unique, for login)
- `username`: VARCHAR(50) (Unique, for display)
- `password_hash`: VARCHAR(255) (Hashed and salted password)
- `is_staff`: BOOLEAN (To identify Knowlance AI team members)
- `created_at`: TIMESTAMPTZ

### 3.2. `demo_requests`
Captures leads from the "Apply for a Demo" client console.
- `id`: UUID (Primary Key)
- `full_name`: VARCHAR(255)
- `work_email`: VARCHAR(255)
- `company_name`: VARCHAR(255)
- `role`: VARCHAR(100)
- `project_description`: TEXT
- `goal`: TEXT
- `technical_requirements`: TEXT (Optional)
- `submitted_at`: TIMESTAMPTZ

### 3.3. `mvp_waitlist`
Stores email sign-ups for the "AI Data Analyst" MVP.
- `id`: UUID (Primary Key)
- `email`: VARCHAR(255) (Unique)
- `created_at`: TIMESTAMPTZ

### 3.4. `forum_topics`
Represents a single discussion topic in the community forum.
- `id`: UUID (Primary Key)
- `title`: VARCHAR(255)
- `created_by`: UUID (Foreign Key to `users.id`)
- `created_at`: TIMESTAMPTZ

### 3.5. `forum_posts`
Represents a single post (reply) within a forum topic.
- `id`: UUID (Primary Key)
- `content`: TEXT
- `topic_id`: UUID (Foreign Key to `forum_topics.id`)
- `created_by`: UUID (Foreign Key to `users.id`)
- `created_at`: TIMESTAMPTZ

## 4. API Specification

The backend will expose a RESTful API. The full contract is defined in `DEV-16_api_spec.yaml`.

### Key Endpoints:

*   **Lead Generation:**
    *   `POST /api/demo-requests`: Submits the client console form.
*   **MVP Waitlist:**
    *   `POST /api/mvp-waitlist`: Adds an email to the waitlist.
*   **Authentication:**
    *   `POST /api/auth/register`: Creates a new user account for the community.
    *   `POST /api/auth/login`: Authenticates a user and returns a JSON Web Token (JWT).
*   **Forum:**
    *   `GET /api/forum/topics`: Retrieves a list of all forum topics.
    *   `POST /api/forum/topics`: Creates a new topic (Authentication required).
    *   `GET /api/forum/topics/:topicId`: Retrieves a single topic and all its posts.
    *   `POST /api/forum/topics/:topicId/posts`: Adds a new post to a topic (Authentication required).

### Authentication Mechanism

- The community forum will use **JSON Web Tokens (JWT)** for authentication.
- Upon successful login, the `/api/auth/login` endpoint will return a JWT to the client.
- The client will then include this token in the `Authorization` header (`Bearer <token>`) for all subsequent requests to protected endpoints (e.g., creating topics/posts).
- The backend API will have middleware to validate the JWT on protected routes.

## 5. Frontend Components

The Next.js frontend will be built with the following key components, corresponding to the sections in the PRD:

- **`HeroSection`**: Contains the UVP, sub-headline, and primary CTA.
- **`ServicesSection`**: Highlights the core service offerings.
- **`MvpShowcaseSection`**: "Coming Soon" section with the email capture form.
- **`TeamSection`**: Displays profiles of the core engineering team.
- **`CommunityTeaser`**: Links to the community page.
- **`ClientConsoleForm`**: The "Apply for a Demo" form.
- **`CommunityPage`**: The main view for the forum, listing topics.
- **`TopicView`**: A view to display a single topic and its posts.
- **`Layout`**: A global component including the `Header` and `Footer`.

## 6. Deployment & Infrastructure

- **Frontend (Next.js):** Vercel is the recommended hosting platform, as it's built by the creators of Next.js and offers seamless deployment, automatic scaling, and a global CDN.
- **Backend (Node.js API):** A containerized Docker image deployed on a cloud service like AWS Fargate, Google Cloud Run, or Heroku for scalability and ease of management.
- **Database (PostgreSQL):** A managed database service like Amazon RDS or Google Cloud SQL is recommended to handle backups, scaling, and maintenance.
