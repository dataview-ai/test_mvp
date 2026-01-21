
# Technical Design Document: DEV-17 - Website V1.0

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect

## 1. Overview

This document outlines the technical architecture for the Knowlance AI public website and client console (V1.0). The goal is to create a performant, scalable, and maintainable platform that meets the requirements outlined in the PRD (DEV-17), including lead generation, brand building, and community engagement.

The architecture prioritizes speed of development and deployment to align with the company's UVP: "Custom AI, Built Fast."

## 2. System Architecture

We will adopt a decoupled frontend/backend architecture. This provides flexibility for future development, allows for independent scaling, and enables a modern developer experience.

*   **Frontend (Web Application):** A server-rendered single-page application (SPA).
*   **Backend (API):** A RESTful API service to handle data persistence, user authentication, and business logic.
*   **Database:** A relational database to store all application data.

### Technology Stack

| Component | Technology | Rationale |
| :--- | :--- | :--- |
| **Frontend Framework** | **Next.js (React)** | Excellent for SEO and performance due to Server-Side Rendering (SSR) and Static Site Generation (SSG). Great developer experience and a large ecosystem. |
| **UI/Styling** | **Tailwind CSS** | A utility-first CSS framework that allows for rapid and consistent UI development directly in the markup. |
| **Backend Framework** | **Node.js w/ Express.js** | Lightweight, fast, and uses JavaScript, allowing for code consistency across the stack. Well-suited for I/O-bound operations like a REST API. |
| **Database** | **PostgreSQL** | A powerful, open-source, and reliable relational database that can handle the required data structures and scale effectively. |
| **Deployment** | - **Frontend:** Vercel <br> - **Backend:** AWS Elastic Beanstalk <br> - **Database:** AWS RDS | - Vercel offers seamless, zero-config deployment for Next.js. <br> - Elastic Beanstalk simplifies deployment and scaling of the Node.js application. <br> - RDS provides a managed, scalable, and secure PostgreSQL database. |
| **Authentication** | **JWT (JSON Web Tokens)** | Standard for securing APIs. Tokens will be issued upon login and used to authenticate requests for protected community endpoints. |

## 3. Frontend Design

The frontend will be built as a single Next.js project.

*   **Pages & Routing:**
    *   `/` (Homepage): Statically generated (SSG) for maximum performance. Will use client-side fetching for dynamic content like community posts.
    *   `/community`: Server-side rendered (SSR) to display the latest topics.
    *   `/community/topics/[id]`: SSR page to display a specific topic and its posts.
    *   `/about`: Statically generated page for founder/team info.
    *   `/console`: A dedicated page for the "Apply for a Demo" form. Can be statically generated.
    *   `/privacy-policy`: Statically generated.

*   **Key Components:**
    *   **Hero Section:** Standard React component.
    *   **MVP Showcase:** A simple form component that calls the `/api/mvp-signups` endpoint.
    *   **Client Console Form:** A multi-field form component using a state management library (like React Hook Form) for validation. It will post data to the `/api/demo-requests` endpoint.
    *   **Community Components:**
        *   `TopicList`: Fetches and displays topics.
        *   `PostList`: Fetches and displays posts within a topic.
        *   `PostForm`: A protected component for creating new topics or replies, visible only to authenticated users.
    *   **Authentication:** A login/registration modal or page that interacts with the `/api/auth/` endpoints. JWTs will be stored securely in `httpOnly` cookies.

## 4. Backend (API) Design

The backend will be a Node.js/Express.js application responsible for all data interactions.

*   **API Endpoints:** See `DEV-17_api_spec.yaml` for the detailed OpenAPI specification.
*   **Authentication:**
    *   The `/auth/register` endpoint will hash passwords using `bcrypt` before storing them in the `users` table.
    *   The `/auth/login` endpoint will verify credentials and, if successful, generate a JWT containing the `user_id` and `role`.
    *   A middleware will protect specific routes (e.g., POSTing to the community) by verifying the JWT from the request's cookie.
*   **Business Logic:**
    *   **Demo Request:** The `/demo-requests` endpoint will perform validation and insert the sanitized data into the `demo_requests` table. It may also trigger an internal email notification to the sales team.
    *   **Community Logic:** Standard CRUD operations for topics and posts, ensuring that users can only edit/delete their own content.

## 5. Database Schema

The database schema is designed to support the core features of the application.

*   **Tables:**
    *   `users`: Stores community member data and handles authentication.
    *   `demo_requests`: Captures all lead generation data from the client console.
    *   `mvp_signups`: A simple table to collect emails for the MVP waitlist.
    *   `community_topics` & `community_posts`: Structured to create a simple forum.
*   **Relationships:**
    *   `users` to `community_topics` (one-to-many)
    *   `users` to `community_posts` (one-to-many)
    *   `community_topics` to `community_posts` (one-to-many)

See `DEV-17_db_schema.sql` for the complete SQL definitions.

## 6. Deployment & Infrastructure

1.  **Vercel:** The Next.js project will be linked to a GitHub repository. Pushes to the `main` branch will trigger automatic builds and deployments on Vercel. Environment variables for the API URL will be configured in the Vercel project settings.
2.  **AWS Elastic Beanstalk:** The Node.js application will be deployed here. It will handle environment configuration, load balancing, and auto-scaling.
3.  **AWS RDS:** A PostgreSQL instance will be provisioned via RDS. The database credentials will be securely passed to the Elastic Beanstalk environment as environment variables. The RDS instance will be placed in a private subnet for security, accessible only by the backend application.

## 7. Out of Scope for V1.0

As per the PRD, the following are not included in this initial technical design:
*   Full client login portal with project tracking.
*   Payment processing.
*   The "AI Data Analyst" product itself.
*   Advanced community features (DMs, gamification, etc.).
