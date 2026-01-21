
# Technical Design: DEV-25 - Database and API Schema

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect

## 1. Introduction

This document outlines the technical design for the database schema and corresponding API endpoints required for the Knowlance AI website (V1.0). It addresses the requirements detailed in ticket DEV-25, covering data models for users, leads (demo requests), and the community forum.

The primary goal is to create a scalable and normalized data structure that supports the user stories and feature requirements outlined in the PRD.

## 2. Database Schema Design

A PostgreSQL relational database is selected for this project due to its robustness, scalability, and strong support for data integrity.

The schema is designed to handle three core entities:
1.  **Users:** A central table to manage all individuals interacting with the site, whether they are community members or clients submitting a lead.
2.  **Leads:** Captures all information from the "Apply for a Demo" form.
3.  **Community:** A set of tables to power the discussion forum.
4.  **MVP Waitlist:** A simple table to capture interest in the upcoming "AI Data Analyst" tool.

### SQL Schema (`db_schema.sql`)

The complete SQL for creating these tables is provided in `DEV-25_db_schema.sql`.

### Table Definitions

#### `users`
Stores information for any individual who signs up for the community or submits a lead.

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY` | Unique identifier for the user. |
| `full_name` | `VARCHAR(255)` | `NOT NULL` | User's full name. |
| `email` | `VARCHAR(255)` | `NOT NULL, UNIQUE` | User's email address. Used for login and contact. |
| `password_hash` | `VARCHAR(255)` | `NULL` | Hashed password for community members. NULL for users who only submitted a lead without creating an account. |
| `user_role` | `user_role_enum` | `NOT NULL` | Enum ('staff', 'community_member'). Helps distinguish team members. |
| `linkedin_profile` | `VARCHAR(255)` | `NULL` | URL to the user's LinkedIn profile. |
| `github_profile` | `VARCHAR(255)` | `NULL` | URL to the user's GitHub profile. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of user creation. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of last update. |

#### `leads`
Captures submissions from the client console/demo request form.

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY` | Unique identifier for the lead. |
| `user_id` | `UUID` | `FK to users(id)` | Links the lead to a user record. |
| `company_name` | `VARCHAR(255)` | `NULL` | Name of the potential client's company. |
| `role_title` | `VARCHAR(255)` | `NULL` | The user's role at their company. |
| `challenge_description` | `TEXT` | `NOT NULL` | The core business problem described by the user. |
| `desired_outcome` | `TEXT` | `NULL` | What the user hopes to achieve. |
| `technical_requirements` | `TEXT` | `NULL` | Optional technical details provided by the user. |
| `status` | `lead_status_enum` | `DEFAULT 'new'` | Enum ('new', 'contacted', 'in_progress', 'converted', 'closed'). For internal tracking. |
| `submitted_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of form submission. |

#### `community_topics`
Stores the main threads or topics in the community forum.

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY` | Unique identifier for the topic. |
| `author_id` | `UUID` | `FK to users(id)` | The user who created the topic. |
| `title` | `VARCHAR(255)` | `NOT NULL` | The title of the discussion topic. |
| `category` | `VARCHAR(100)` | `NULL` | Category of the topic (e.g., "Use Cases", "AI Trends"). |
| `content` | `TEXT` | `NOT NULL` | The main body content of the topic post. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of topic creation. |

#### `community_posts`
Stores replies to community topics.

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY` | Unique identifier for the post/reply. |
| `topic_id` | `UUID` | `FK to community_topics(id)` | The topic this post is a reply to. |
| `author_id` | `UUID` | `FK to users(id)` | The user who wrote the reply. |
| `content` | `TEXT` | `NOT NULL` | The body content of the reply. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of post creation. |

#### `mvp_waitlist`
A simple collection of emails for the MVP launch notification.

| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `SERIAL` | `PRIMARY KEY` | Unique identifier. |
| `email` | `VARCHAR(255)` | `NOT NULL, UNIQUE` | Email address of the interested person. |
| `signed_up_at` | `TIMESTAMPTZ` | `DEFAULT now()` | Timestamp of when they signed up. |

## 3. API Specification

The API will be a RESTful service. The full specification is in `DEV-25_api_spec.yaml`.

### Key Endpoints

- **`POST /leads`**
  - **Action:** Submits the "Apply for a Demo" form.
  - **Logic:**
    1.  Accepts user and company details.
    2.  Internally, it will perform an "upsert" on the `users` table based on the email.
    3.  Creates a new record in the `leads` table linked to the user.
  - **Authentication:** None required.

- **`POST /users/register`**
  - **Action:** Creates a new user account for the community.
  - **Logic:**
    1.  Accepts `full_name`, `email`, and `password`.
    2.  Hashes the password.
    3.  Creates a new record in the `users` table with the `community_member` role.
  - **Authentication:** None required.

- **`POST /mvp-waitlist`**
  - **Action:** Adds a user's email to the MVP waitlist.
  - **Authentication:** None required.

- **`GET /community/topics`**
  - **Action:** Retrieves a list of all community topics. Can be paginated.
  - **Authentication:** None required.

- **`POST /community/topics`**
  - **Action:** Creates a new community topic.
  - **Authentication:** Required (e.g., JWT Bearer Token). The user must have a registered account.

- **`GET /community/topics/{topicId}`**
  - **Action:** Retrieves a single topic and all its associated posts (`community_posts`).
  - **Authentication:** None required.

- **`POST /community/topics/{topicId}/posts`**
  - **Action:** Adds a new reply/post to an existing topic.
  - **Authentication:** Required.

## 4. Security Considerations

- **Password Hashing:** All user passwords stored in the `users` table will be hashed using a strong, modern algorithm like **bcrypt**.
- **Authentication:** API endpoints that require a logged-in user (e.g., posting to the community) will be protected and require a JWT (JSON Web Token) to be passed in the `Authorization` header.
- **Data Validation:** All incoming data from API requests will be strictly validated to prevent injection attacks (SQLi, XSS).
- **Permissions:** API logic will enforce role-based access. For example, only users with the 'staff' role might be able to pin or lock community topics in a future version.
