
# Technical Design: DEV-26 - API Contract for Frontend-Backend Communication

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Solution Architect Agent

## 1. Introduction

This document outlines the technical design for the API that will serve the Knowlance AI website. The API will handle interactions for the Client Console, MVP subscription, community forum, and dynamic content delivery for team members. This contract ensures a clear separation of concerns between the frontend and backend development teams.

## 2. System Architecture Overview

We will implement a RESTful API using a monolithic backend architecture for V1.0. The backend will be responsible for business logic, data storage, and authentication. The frontend will be a single-page application (SPA) that consumes this API.

- **Authentication:** API endpoints related to the community (creating posts/topics) will be protected and require token-based authentication (JWT).
- **Data Persistence:** A PostgreSQL database will be used to store all data.
- **API Versioning:** The API will be versioned under the `/api/v1/` path to allow for future iterations.

## 3. API Endpoints

The following endpoints will be created to support the features outlined in the PRD.

### 3.1. Lead Generation & Static Content

These endpoints are public and do not require authentication.

#### 3.1.1. Submit Demo Request

- **Endpoint:** `POST /api/v1/demo-requests`
- **Description:** Submits the client's project details from the "Client Console" form.
- **Request Body:** See `DEV-26_api_spec.yaml` for the detailed schema. Contains fields for name, email, company, role, project description, etc.
- **Response:**
    - `201 Created`: On successful submission. Returns the created object.
    - `400 Bad Request`: If the request body is invalid.

#### 3.1.2. Subscribe to MVP Launch

- **Endpoint:** `POST /api/v1/mvp-subscriptions`
- **Description:** Captures an email address for the "AI Data Analyst" MVP waitlist.
- **Request Body:** `{ "email": "user@example.com" }`
- **Response:**
    - `201 Created`: On successful subscription.
    - `400 Bad Request`: If the email is invalid or already subscribed.

#### 3.1.3. Get Team Members

- **Endpoint:** `GET /api/v1/team-members`
- **Description:** Retrieves a list of all core team members to be displayed on the homepage.
- **Response:**
    - `200 OK`: Returns an array of team member objects.

### 3.2. Community Forum

#### 3.2.1. User Authentication

- **Endpoint:** `POST /api/v1/auth/register`
- **Description:** Registers a new user for the community forum.
- **Request Body:** `{ "username": "string", "email": "string", "password": "string" }`
- **Response:**
    - `201 Created`: Returns the new user object (without password).

- **Endpoint:** `POST /api/v1/auth/login`
- **Description:** Authenticates a user and returns a JWT.
- **Request Body:** `{ "email": "string", "password": "string" }`
- **Response:**
    - `200 OK`: Returns an access token: `{ "accessToken": "jwt_token_string" }`.

#### 3.2.2. Topics

- **Endpoint:** `GET /api/v1/community/topics`
- **Description:** Retrieves a paginated list of all discussion topics.
- **Response:** `200 OK`: Returns an array of topic objects, each including author details.

- **Endpoint:** `POST /api/v1/community/topics`
- **Description:** Creates a new discussion topic. **(Authentication Required)**
- **Request Body:** `{ "title": "string", "content": "string" }`
- **Response:** `201 Created`: Returns the newly created topic object.

- **Endpoint:** `GET /api/v1/community/topics/{topicId}`
- **Description:** Retrieves a single topic and all its posts/replies.
- **Response:** `200 OK`: Returns a single topic object with an array of `posts`.

#### 3.2.3. Posts (Replies)

- **Endpoint:** `POST /api/v1/community/topics/{topicId}/posts`
- **Description:** Adds a new post (reply) to a specific topic. **(Authentication Required)**
- **Request Body:** `{ "content": "string" }`
- **Response:** `201 Created`: Returns the newly created post object.

## 4. Data Models

The API will use the following data models, which correspond to the database schema. See `DEV-26_db_schema.sql` for table definitions.

- **User:** Represents a registered member of the community.
- **DemoRequest:** Represents a submission from the client console.
- **MvpSubscription:** Represents an email signup for the MVP.
- **TeamMember:** Represents a core Knowlance AI team member.
- **CommunityTopic:** Represents a main thread in the forum.
- **CommunityPost:** Represents a reply within a topic.

## 5. Error Handling

The API will use standard HTTP status codes to indicate the success or failure of a request. Error responses will be in a consistent JSON format:

```json
{
  "error": {
    "status": 400,
    "message": "A descriptive error message."
  }
}
```
