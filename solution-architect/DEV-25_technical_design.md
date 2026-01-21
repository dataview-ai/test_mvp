# Technical Design: DEV-25 - Database and API Schema

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect

## 1. Overview

This document provides the technical specifications for the database schema and API endpoints required to support the Knowlance AI website (V1.0). The design is based on the requirements outlined in the PRD (DEV-25), focusing on three core areas:
1.  **Lead Generation:** Capturing demo requests from potential clients.
2.  **Community Forum:** Enabling user registration and discussions.
3.  **User Management:** Storing user data for community engagement.

## 2. Database Schema

The database will be relational (e.g., PostgreSQL) and will consist of the following tables to store user, community, and lead data.

### 2.1. `users`

Stores information about registered community members.

-   `id` (UUID, Primary Key): Unique identifier for the user.
-   `full_name` (VARCHAR): User's full name.
-   `email` (VARCHAR, Unique): User's email address, used for login.
-   `password_hash` (VARCHAR): Hashed password for authentication.
-   `is_staff` (BOOLEAN, default: false): Flag to identify Knowlance AI team members.
-   `github_profile` (VARCHAR, nullable): Link to the user's GitHub profile.
-   `linkedin_profile` (VARCHAR, nullable): Link to the user's LinkedIn profile.
-   `created_at` (TIMESTAMP WITH TIME ZONE): Timestamp of user registration.

### 2.2. `leads`

Stores submissions from the "Apply for a Demo" form.

-   `id` (UUID, Primary Key): Unique identifier for the lead.
-   `full_name` (VARCHAR): Lead's full name.
-   `work_email` (VARCHAR): Lead's work email.
-   `company_name` (VARCHAR): Lead's company.
-   `role` (VARCHAR): Lead's role or title.
-   `challenge_description` (TEXT): Description of the business challenge.
-   `goal` (TEXT): What the lead hopes to achieve.
-   `technical_requirements` (TEXT, nullable): Any specific technical needs.
-   `submitted_at` (TIMESTAMP WITH TIME ZONE): Timestamp of form submission.

### 2.3. `community_categories`

Stores the different categories for forum discussions.

-   `id` (SERIAL, Primary Key): Unique identifier for the category.
-   `name` (VARCHAR, Unique): The name of the category (e.g., "Use Cases").
-   `slug` (VARCHAR, Unique): A URL-friendly version of the name.

### 2.4. `community_topics`

Represents a single discussion thread/topic in the community forum.

-   `id` (SERIAL, Primary Key): Unique identifier for the topic.
-   `title` (VARCHAR): The title of the topic.
-   `user_id` (UUID, Foreign Key -> `users.id`): The user who created the topic.
-   `category_id` (INTEGER, Foreign Key -> `community_categories.id`): The category this topic belongs to.
-   `created_at` (TIMESTAMP WITH TIME ZONE): Timestamp of topic creation.

### 2.5. `community_posts`

Represents a single post or reply within a community topic.

-   `id` (SERIAL, Primary Key): Unique identifier for the post.
-   `content` (TEXT): The body of the post.
-   `user_id` (UUID, Foreign Key -> `users.id`): The user who created the post.
-   `topic_id` (INTEGER, Foreign Key -> `community_topics.id`): The topic this post belongs to.
-   `created_at` (TIMESTAMP WITH TIME ZONE): Timestamp of post creation.

### 2.6. `mvp_waitlist`

Stores email addresses of users interested in the "AI Data Analyst" MVP.

-   `id` (SERIAL, Primary Key): Unique identifier.
-   `email` (VARCHAR, Unique): The email address submitted.
-   `signed_up_at` (TIMESTAMP WITH TIME ZONE): Timestamp of sign-up.

## 3. API Specification

The API will be RESTful and use JSON for requests and responses. All timestamps are in ISO 8601 format.

### 3.1. Authentication

-   **`POST /api/auth/register`**: Creates a new user.
    -   Request Body: `{ "full_name", "email", "password" }`
    -   Response: `{ "user_id", "full_name", "email" }`
-   **`POST /api/auth/login`**: Authenticates a user and returns a JWT.
    -   Request Body: `{ "email", "password" }`
    -   Response: `{ "token" }`

### 3.2. Leads API

-   **`POST /api/leads`**: Submits the "Apply for a Demo" form.
    -   Authentication: None.
    -   Request Body: `{ "full_name", "work_email", "company_name", "role", "challenge_description", "goal", "technical_requirements" }`
    -   Response: `201 Created` with `{ "message": "Submission successful." }`

### 3.3. MVP Waitlist API

-   **`POST /api/mvp-waitlist`**: Adds an email to the MVP waitlist.
    -   Authentication: None.
    -   Request Body: `{ "email" }`
    -   Response: `201 Created` with `{ "message": "You have been added to the waitlist." }`

### 3.4. Community API

-   **`GET /api/community/categories`**: Retrieves all discussion categories.
    -   Authentication: None.
-   **`GET /api/community/topics`**: Retrieves a paginated list of all topics.
    -   Authentication: None.
    -   Query Params: `?page=1&limit=20&category_slug=use-cases`
-   **`POST /api/community/topics`**: Creates a new topic.
    -   Authentication: Required (JWT Bearer Token).
    -   Request Body: `{ "title", "content", "category_id" }` (Content is for the first post).
-   **`GET /api/community/topics/{topic_id}`**: Retrieves a single topic and its posts.
    -   Authentication: None.
-   **`POST /api/community/topics/{topic_id}/posts`**: Adds a reply to a topic.
    -   Authentication: Required (JWT Bearer Token).
    -   Request Body: `{ "content" }`

## 4. Security Considerations

-   **Password Hashing:** All user passwords MUST be hashed using a strong, modern algorithm like Argon2 or bcrypt.
-   **Input Validation:** All incoming API requests must be validated to prevent injection attacks (SQLi, XSS).
-   **CORS:** Configure Cross-Origin Resource Sharing (CORS) to only allow requests from the website's domain.
-   **Authentication:** Use JWTs for securing community-related endpoints that require a logged-in user.
