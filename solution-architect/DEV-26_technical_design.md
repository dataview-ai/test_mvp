
# Technical Design: DEV-26 - API Contract and System Architecture

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Gemini, Solution Architect

## 1. Overview

This document outlines the technical architecture for the Knowlance AI website (V1.0), as specified in the Product Requirements Document (PRD) for ticket DEV-26. It covers the frontend, backend, database, and API specifications required to deliver the project goals of lead generation, brand credibility, and community building.

## 2. System Architecture

We will adopt a decoupled architecture, with a modern Jamstack frontend communicating with a lightweight backend via a RESTful API. This approach ensures scalability, performance, and maintainability.

### 2.1. Frontend Architecture

*   **Framework:** **Next.js (v13+)**
    *   **Reasoning:** Chosen for its hybrid static & server rendering capabilities, which are excellent for SEO and performance. The file-based routing (App Router) simplifies development.
*   **Language:** **TypeScript**
    *   **Reasoning:** For type safety, which will reduce bugs and improve developer experience when interacting with the API.
*   **Styling:** **Tailwind CSS**
    *   **Reasoning:** A utility-first CSS framework that allows for rapid and consistent UI development directly within the markup.
*   **State Management:** **React Context API / Zustand**
    *   **Reasoning:** For managing global state like user authentication status. We will start with the built-in Context API and adopt Zustand if complexity increases.
*   **Key Libraries:**
    *   `axios` or `fetch` for API calls.
    *   `react-hook-form` for managing the Client Console form state and validation.
    *   `SWR` or `React Query` for data fetching and caching, especially for community data.

### 2.2. Backend Architecture

*   **Framework:** **Node.js with Express.js**
    *   **Reasoning:** A lightweight, fast, and widely-supported framework perfect for building the required RESTful API. Its non-blocking I/O is well-suited for handling concurrent requests.
*   **Language:** **TypeScript**
    *   **Reasoning:** To maintain consistency with the frontend and ensure type-safe operations, especially with the database.
*   **Database ORM:** **Prisma**
    *   **Reasoning:** Provides a type-safe database client and simplifies migrations. Its schema-first approach is a single source of truth for database models.
*   **Authentication:** **JSON Web Tokens (JWT)**
    *   **Reasoning:** A stateless and standard way to secure the community-related endpoints. A token will be issued upon login/registration and sent in the `Authorization` header for protected requests.

### 2.3. Database Architecture

*   **Database System:** **PostgreSQL**
    *   **Reasoning:** A robust, reliable, and feature-rich open-source relational database that can handle the required data structures and relationships.
*   **Schema:** The detailed schema is defined in `DEV-26_db_schema.sql`. It includes tables for:
    *   `users`: Stores community user data, including authentication details and roles.
    *   `demo_requests`: Captures all submissions from the client console form.
    *   `mvp_waitlist`: A simple table to store emails for the MVP launch notification.
    *   `community_categories`: To categorize forum topics.
    *   `community_topics`: Stores the main discussion threads.
    *   `community_posts`: Stores replies within a topic.

## 3. API Specification

The API contract is formally defined in `DEV-26_api_spec.yaml` using the OpenAPI 3.0 standard. This file will be the single source of truth for all frontend-backend communication.

**Key Endpoint Summary:**

*   **Public Endpoints:**
    *   `POST /api/demo-requests`: Submits the client console form.
    *   `POST /api/mvp-waitlist`: Registers an email for the MVP waitlist.
    *   `GET /api/community/topics`: Fetches a list of all community topics.
    *   `GET /api/community/topics/{topicId}`: Fetches a single topic and its posts.
    *   `GET /api/team`: Fetches profiles of the core team members.
*   **Authentication Endpoints:**
    *   `POST /api/auth/register`: Creates a new community user.
    *   `POST /api/auth/login`: Authenticates a user and returns a JWT.
*   **Protected (Community) Endpoints (Requires JWT):**
    *   `POST /api/community/topics`: Creates a new discussion topic.
    *   `POST /api/community/topics/{topicId}/posts`: Adds a new post (reply) to a topic.

## 4. Deployment and Infrastructure

*   **Frontend (Next.js):** **Vercel**
    *   **Reasoning:** Provides a seamless, zero-configuration deployment experience for Next.js applications with automatic CI/CD, SSL, and global CDN.
*   **Backend (Node.js API):** **Heroku or AWS Elastic Beanstalk**
    *   **Reasoning:** Both are Platform-as-a-Service (PaaS) solutions that simplify the deployment and scaling of the backend application.
*   **Database (PostgreSQL):** **Heroku Postgres or Amazon RDS**
    *   **Reasoning:** Managed database services that handle backups, scaling, and maintenance, allowing the team to focus on development.

## 5. Development Workflow

1.  **API First:** The backend team will implement the API endpoints as defined in `DEV-26_api_spec.yaml`.
2.  **Database Setup:** The SQL schema from `DEV-26_db_schema.sql` will be used to initialize the database. Prisma Migrate will be used for subsequent changes.
3.  **Frontend Development:** The frontend team will build the UI components and connect them to the API endpoints. The OpenAPI spec can be used to generate typed API clients.
4.  **Integration & Testing:** Continuous integration will be used to test the frontend and backend interaction.
