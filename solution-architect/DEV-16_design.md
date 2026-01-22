# DEV-16: Core Data Model and Database Schema

**Author:** Senior Solution Architect
**Date:** October 26, 2023
**Status:** Final

## 1. Overview

This document defines the core data model and database schema for the **knowlance.ai** platform. The design is based on the requirements outlined in the Lean Canvas (v1.0) and supports the primary features: the Project Scoping Portal and the AI Community Forum.

## 2. Data Model

The data model is designed to be scalable and relational, using a PostgreSQL database. It consists of five core entities:

-   **Users**: A central table to manage all individuals interacting with the platform, including clients, community members, and administrators. A `role` column will differentiate user types.
-   **Projects**: Represents the project requirements submitted by clients through the Scoping Portal. It is linked to the `users` table.
-   **Forum Categories**: A simple table to organize the community forum into different areas of discussion (e.g., "AI Trends," "Use Cases").
-   **Forum Threads**: Represents a single topic of conversation within a category. It is initiated by a user.
-   **Forum Posts**: Represents an individual message or reply within a thread.

## 3. Database Schema (PostgreSQL)

The following SQL schema will be implemented. `UUID` is used for primary keys on high-volume tables to allow for distributed generation and to avoid exposing sequential information.

### Table Definitions

-   `users`: Stores user profile information.
-   `projects`: Stores client project submissions.
-   `forum_categories`: Stores discussion categories.
-   `forum_threads`: Stores discussion threads.
-   `forum_posts`: Stores individual posts and replies.

### Relationships

-   A `user` can have many `projects`.
-   A `user` can create many `forum_threads` and `forum_posts`.
-   A `forum_category` can have many `forum_threads`.
-   A `forum_thread` can have many `forum_posts`.

## 4. API Design (High-Level)

A RESTful API will be developed to interact with this data model. The API will have endpoints for managing users, projects, and forum content. See `DEV-16_api.yaml` for the OpenAPI specification.

## 5. Rationale

-   **Relational Model:** A relational database (PostgreSQL) was chosen for its robustness, data integrity features (foreign keys), and powerful querying capabilities, which are well-suited for the structured data of users, projects, and forum content.
-   **Scalability:** The use of `UUID`s and clear separation of concerns in the table structure provides a solid foundation for future scaling.
-   **Flexibility:** The `users` table with a `role` attribute allows us to easily add new user types in the future without schema changes. Deleting users will set their forum contributions to `NULL` to preserve the conversation history.