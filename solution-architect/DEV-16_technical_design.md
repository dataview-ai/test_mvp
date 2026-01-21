
# Technical Design Document: Website V1.0 Core Data Model

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect
**Status:** In Review
**Ticket:** [DEV-16](https://jira.example.com/browse/DEV-16)

## 1. Overview

This document outlines the technical architecture, database schema, and API specification for the Knowlance AI website (V1.0). The primary goal is to establish the foundational backend services required to support the features defined in the Product Requirements Document (PRD), including the Client Console (demo requests), the Community Forum, and the MVP waitlist.

## 2. System Architecture

We will adopt a decoupled frontend/backend architecture. This provides flexibility for development, deployment, and scaling of each component independently.

*   **Frontend (Client):** A modern, server-rendered JavaScript application.
    *   **Framework:** Next.js (React)
    *   **Reasoning:** Next.js is chosen for its excellent performance (Server-Side Rendering and Static Site Generation), built-in routing, and strong SEO capabilities, which are critical for the landing page.
    *   **Styling:** Tailwind CSS will be used for rapid, utility-first UI development, ensuring a consistent and professional aesthetic.

*   **Backend (Server):** A RESTful API server to handle business logic and data persistence.
    *   **Framework:** Node.js with Express.js
    *   **Reasoning:** A lightweight and widely-used framework that is well-suited for building REST APIs. The choice of JavaScript on the backend maintains language consistency across the stack.
    *   **Database:** PostgreSQL
    *   **Reasoning:** A powerful, open-source, and reliable relational database that can handle the structured data for users, posts, and demo requests effectively.

*   **Deployment:**
    *   **Frontend:** Vercel is the recommended platform, as it is optimized for Next.js applications and offers a seamless deployment experience.
    *   **Backend:** Heroku or AWS Elastic Beanstalk for straightforward deployment and scaling of the Node.js application.
    *   **Database:** Amazon RDS for PostgreSQL or Heroku Postgres, providing managed, scalable, and secure database hosting.

## 3. Database Schema

The database will be structured to support the core entities of the application. All timestamps will be stored as `TIMESTAMPTZ` for timezone consistency.

*   **`users`**: Stores registered members for the community forum.
*   **`demo_requests`**: Captures lead information from the "Apply for a Demo" form.
*   **`mvp_waitlist`**: A simple table to store emails of users interested in the "AI Data Analyst" MVP.
*   **`community_categories`**: Stores the different categories for forum discussions (e.g., "Latest Trends," "Use Cases").
*   **`community_posts`**: Stores the main topics/threads initiated by users in the community forum.
*   **`community_replies`**: Stores replies to specific posts within the community forum.

The detailed SQL schema is provided in `DEV-16_db_schema.sql`.

## 4. API Specification

The API will expose several endpoints to enable the functionality described in the PRD. Authentication for protected routes (e.g., creating posts) will be handled using JSON Web Tokens (JWT).

**Key Endpoints:**

*   **Authentication:**
    *   `POST /api/auth/register`: Create a new community user account.
    *   `POST /api/auth/login`: Authenticate a user and receive a JWT.
*   **Demo Requests:**
    *   `POST /api/demo-requests`: Submit a new demo/project request.
*   **MVP Waitlist:**
    *   `POST /api/mvp-waitlist`: Add an email to the waitlist.
*   **Community Forum:**
    *   `GET /api/community/posts`: Fetch a list of all discussion posts.
    *   `POST /api/community/posts`: Create a new discussion post (Authenticated).
    *   `GET /api/community/posts/{postId}`: Fetch a single post and its replies.
    *   `POST /api/community/posts/{postId}/replies`: Add a reply to a post (Authenticated).
*   **Static Content (Example):**
    *   `GET /api/team`: An endpoint to fetch team member data, allowing for dynamic updates without redeploying the frontend.

The detailed API contract is defined in `DEV-16_api_spec.yaml`.

## 5. Non-Functional Requirements

*   **Security:**
    *   Passwords will be hashed using a strong algorithm (e.g., bcrypt).
    *   JWTs will be used to secure authenticated endpoints.
    *   Input validation will be implemented on the backend to prevent SQL injection and other attacks.
    *   CORS will be configured to only allow requests from the frontend domain.
*   **Performance:**
    *   Database queries will be optimized with appropriate indexing.
    *   API response payloads will be kept concise.
    *   The Next.js frontend will leverage SSG for static pages (like About Us) and SSR for dynamic pages (like the Community Forum) to ensure fast load times.
