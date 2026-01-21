
# Technical Design Document: DEV-26 - API Contract

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Solution Architect Agent

## 1. Overview

This document outlines the technical design for the API that will support the Knowlance AI website (V1.0). The API will facilitate communication between the frontend single-page application (SPA) and the backend server. It will handle lead generation, community features, and content delivery.

The architecture will be a standard RESTful API served over HTTPS. The backend will be responsible for business logic, data storage, and authentication.

## 2. Data Models

The following data models are the core components of the system. They will be represented as tables in the database and as JSON objects in API requests and responses.

### 2.1. DemoRequest
Stores submissions from the "Apply for a Demo" form.

- `id`: UUID (Primary Key)
- `full_name`: String
- `work_email`: String
- `company_name`: String
- `role`: String
- `project_description`: Text
- `goal`: Text
- `technical_requirements`: Text (Optional)
- `created_at`: Timestamp

### 2.2. MvpWaitlist
Stores email sign-ups for the "AI Data Analyst" MVP.

- `id`: UUID (Primary Key)
- `email`: String (Unique)
- `created_at`: Timestamp

### 2.3. User
Represents a registered member of the community.

- `id`: UUID (Primary Key)
- `username`: String (Unique)
- `email`: String (Unique)
- `password_hash`: String
- `role`: Enum (`MEMBER`, `STAFF`) - `STAFF` role will have a special badge.
- `created_at`: Timestamp

### 2.4. CommunityTopic
Represents a main topic or thread in the community forum.

- `id`: UUID (Primary Key)
- `title`: String
- `content`: Text
- `author_id`: UUID (Foreign Key to `User.id`)
- `category`: String (e.g., "Latest Trends", "Use Cases")
- `created_at`: Timestamp

### 2.5. CommunityPost
Represents a reply to a `CommunityTopic`.

- `id`: UUID (Primary Key)
- `content`: Text
- `author_id`: UUID (Foreign Key to `User.id`)
- `topic_id`: UUID (Foreign Key to `CommunityTopic.id`)
- `created_at`: Timestamp

### 2.6. TeamMember
Stores profile information for the core team.

- `id`: UUID (Primary Key)
- `name`: String
- `title`: String
- `bio`: Text
- `headshot_url`: String
- `linkedin_url`: String (Optional)
- `github_url`: String (Optional)

## 3. Authentication & Authorization

- **Community Features:** Endpoints for creating topics (`POST /community/topics`) and posts (`POST /community/topics/{topicId}/posts`) will be protected.
- **Authentication Method:** We will use JSON Web Tokens (JWT).
    1. A user will `POST /auth/login` with their credentials.
    2. The server will validate the credentials and return a short-lived JWT.
    3. The frontend will store this JWT and include it in the `Authorization` header for all subsequent protected requests (e.g., `Authorization: Bearer <token>`).
- **Roles:** The `User.role` field will be used to grant special privileges or display badges on the frontend. For V1, this will just be for display purposes (the "Staff" badge).

## 4. API Endpoints

The API will be versioned under `/api/v1`.

### 4.1. Public Endpoints (No Auth Required)

- `POST /demo-requests`: Submits the client console form.
- `POST /mvp-waitlist`: Adds an email to the MVP waitlist.
- `GET /team-members`: Retrieves a list of all team member profiles.
- `GET /community/topics`: Retrieves a paginated list of all community topics. Can also be used for the "Community Teaser" section on the homepage by fetching the 3 most recent.
- `GET /community/topics/{topicId}`: Retrieves a single topic and all its associated posts.
- `POST /auth/register`: Registers a new user for the community.
- `POST /auth/login`: Authenticates a user and returns a JWT.

### 4.2. Protected Endpoints (JWT Auth Required)

- `POST /community/topics`: Creates a new discussion topic. The `author_id` will be extracted from the JWT payload.
- `POST /community/topics/{topicId}/posts`: Creates a new reply (post) within a topic. The `author_id` will be extracted from the JWT payload.

## 5. Error Handling

The API will use standard HTTP status codes to indicate the success or failure of a request.
- `200 OK`: Request succeeded.
- `201 Created`: Resource was successfully created.
- `400 Bad Request`: The request was malformed (e.g., missing fields, invalid data).
- `401 Unauthorized`: The request requires authentication, but the token is missing or invalid.
- `403 Forbidden`: The authenticated user does not have permission to perform the action.
- `404 Not Found`: The requested resource does not exist.
- `500 Internal Server Error`: An unexpected server-side error occurred.

Response bodies for errors will contain a machine-readable error code and a human-readable message.
```json
{
  "error": "INVALID_INPUT",
  "message": "Email address is already registered."
}
```
