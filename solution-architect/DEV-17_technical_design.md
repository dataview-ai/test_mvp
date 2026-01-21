
# Technical Design Document: Knowlance AI Website V1.0

**Version:** 1.0
**Date:** October 26, 2023
**Author:** Senior Solution Architect Agent
**Ticket:** DEV-17

---

## 1. Overview

This document provides the technical architecture and design for the Knowlance AI public website and client console (V1.0), based on the requirements outlined in the Product Requirements Document (PRD).

The primary goal is to build a modern, performant, and scalable platform that serves as a lead generation engine, a community hub, and a showcase for the company's expertise.

## 2. Technology Stack

To meet the requirements for a modern, aesthetic, and responsive design with good performance and SEO, the following technology stack is recommended:

*   **Frontend:** **Next.js (React)**
    *   **Reasoning:** Next.js provides an excellent developer experience, server-side rendering (SSR) and static site generation (SSG) for optimal performance and SEO, a strong component-based architecture, and a rich ecosystem. It is ideal for building the single-page-like landing experience and separate pages like the community and blog.
    *   **Styling:** **Tailwind CSS** for rapid, utility-first styling to maintain a consistent and clean design system.

*   **Backend:** **Node.js with Express.js** or **FastAPI (Python)**
    *   **Reasoning:** A lightweight backend is sufficient for the V1.0 scope.
        *   **Express.js (Node.js):** A mature and widely-used framework with a large community. It integrates well with a JavaScript-based frontend stack.
        *   **FastAPI (Python):** Given the AI/ML nature of the company, using Python for the backend could be a strategic choice, allowing for future integration of ML models and leveraging the team's existing Python expertise. It offers high performance and automatic API documentation.
    *   **Recommendation:** **FastAPI** due to the company's core competency in Python and AI.

*   **Database:** **PostgreSQL**
    *   **Reasoning:** A robust, open-source relational database that can handle structured data for demo requests, user accounts, and the community forum with ease. Its support for JSONB is also beneficial for storing flexible data structures if needed in the future.

*   **Deployment:**
    *   **Frontend (Next.js):** **Vercel**. It offers a seamless, Git-based workflow, automatic deployments, and a global CDN for optimal performance.
    *   **Backend (FastAPI) & Database (PostgreSQL):** **AWS (Elastic Beanstalk/ECS + RDS)** or **Google Cloud (Cloud Run + Cloud SQL)**. These platforms provide scalable, managed environments for the application and database, reducing operational overhead.

## 3. Frontend Architecture

The frontend will be structured into modular components corresponding to the sections defined in the PRD.

*   **`pages/` directory (Next.js):**
    *   `index.js`: The main landing page, composed of the components below.
    *   `community/index.js`: The main view for the community forum, listing topics.
    *   `community/[topicId].js`: The detailed view for a single community topic and its replies.
    *   `about.js`: The "About Us / Founder Info" page.
    *   `demo.js`: The "Client Console" page for submitting a demo request.
    *   `privacy.js`: The Privacy Policy page.

*   **`components/` directory:**
    *   **`layout/`**:
        *   `Header.js`: Global header with navigation and CTA.
        *   `Footer.js`: Global footer with links and copyright.
    *   **`home/`**:
        *   `HeroSection.js`: Contains the UVP, sub-headline, and primary CTA.
        *   `ServicesSection.js`: Feature blocks for company services.
        *   `MvpShowcaseSection.js`: "Coming Soon" section with email capture form.
        *   `TeamSection.js`: Displays profiles of the core team members.
        *   `CommunityTeaser.js`: A small section to link to the community page.
    *   **`community/`**:
        *   `TopicList.js`: Renders a list of community topics.
        *   `TopicDetail.js`: Renders a single topic and its replies.
        *   `NewTopicForm.js`: A form for creating a new topic.
        *   `ReplyForm.js`: A form for replying to a topic.
    *   **`forms/`**:
        *   `DemoRequestForm.js`: The form for the client console.
        *   `MvpWaitlistForm.js`: The simple email capture form.

## 4. Backend API Design

The backend will expose a RESTful API to handle data persistence and user authentication.

*   **Authentication:** For the community forum, we will implement token-based authentication (JWT). When a user registers or logs in, the API will issue a short-lived JWT. This token must be sent in the `Authorization` header for protected actions (e.g., creating posts/replies).
*   **API Endpoints:** See the `DEV-17_api_spec.yaml` file for a detailed OpenAPI specification.

## 5. Database Schema

The database will store information for users, demo requests, the MVP waitlist, and the community forum.

*   **Tables:**
    *   `users`: Stores user profile information for the community. Passwords must be hashed.
    *   `demo_requests`: Captures all submissions from the client console form.
    *   `mvp_waitlist`: Stores email addresses of users interested in the AI Data Analyst MVP.
    *   `community_categories`: To organize forum topics.
    *   `community_posts`: Stores the main content for each forum topic, linked to a user and a category.
    *   `community_replies`: Stores replies to posts, linked to a post and a user.
*   **Schema:** See the `DEV-17_db_schema.sql` file for the detailed SQL schema.

## 6. Non-Functional Requirements

*   **Performance:**
    *   Next.js SSG/SSR will be used to ensure fast initial page loads.
    *   All images will be optimized using `next/image`.
    *   API endpoints will be benchmarked for response times under 200ms.
    *   Database queries will be optimized with appropriate indexing.
*   **Security:**
    *   All user input will be validated and sanitized on both the client and server to prevent XSS and other injection attacks.
    *   Passwords will be securely hashed using a strong algorithm like Argon2 or bcrypt.
    *   API endpoints will be protected with appropriate authentication and authorization checks.
    *   Use HTTPS for all communication.
*   **Responsiveness:** A mobile-first approach will be taken using Tailwind CSS's responsive design features to ensure the site works flawlessly on all screen sizes.
