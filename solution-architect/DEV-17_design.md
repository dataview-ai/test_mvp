# DEV-17: Spike - Git-for-CAD Technical Feasibility

**Author:** Senior Solution Architect
**Date:** 2023-10-27

## 1. Introduction

This document outlines the findings of the technical spike to investigate the feasibility of a "Git-for-CAD" solution for version control of Computer-Aided Design (CAD) files. The goal is to determine if and how we can implement a robust versioning system for our CAD assets, similar to how we use Git for source code.

## 2. The Problem with CAD Version Control

CAD files are typically large, binary, and proprietary. This presents several challenges for traditional version control systems like Git:

*   **Binary Files:** Git is optimized for text files and cannot effectively diff or merge binary files. This means every change, no matter how small, results in a full copy of the file being stored, leading to repository bloat.
*   **Large File Sizes:** CAD assemblies can be gigabytes in size. Storing these in a standard Git repository is inefficient and can severely degrade performance.
*   **Lack of Meaningful Diffs:** When a binary file changes, Git can only tell us *that* it changed, not *what* changed. A visual diff is necessary to understand the modifications, which standard Git does not provide.
*   **Locking:** To prevent conflicting edits, a locking mechanism is often required so that only one person can edit a file at a time. Git's distributed nature makes file locking complex to implement.

## 3. Investigated Solutions

We investigated several approaches to address these challenges.

### 3.1. Git LFS (Large File Storage)

*   **Description:** An extension to Git that replaces large files with text pointers inside Git, while storing the file contents on a remote server.
*   **Pros:**
    *   Keeps the core Git repository small and fast.
    *   Integrates with existing Git workflows and hosting platforms (GitHub, GitLab, Bitbucket).
    *   Mature and well-supported.
*   **Cons:**
    *   Does not solve the diffing or merging problem for binary CAD files.
    *   Requires a separate LFS server, which can add complexity and cost.
    *   File locking is supported but can be cumbersome.

### 3.2. Specialized "Git-for-CAD" Platforms

We identified several platforms built specifically for CAD version control.

#### a) GrabCAD Workbench (No longer available for new users)

*   **Description:** Was a popular cloud-based platform for CAD collaboration. It offered version control, visual diffs, and project management tools.
*   **Status:** It has been discontinued for new users, so it's not a viable option.

#### b) Kenesto

*   **Description:** A cloud-based system that provides version control with file locking, visual diffs, and collaboration features. It's designed to work with various CAD systems.
*   **Pros:**
    *   Purpose-built for CAD.
    *   Strong file locking and permission features.
    *   Cloud-based, so no server setup.
*   **Cons:**
    *   Proprietary system, vendor lock-in.
    *   Subscription-based pricing.

#### c) Allas

*   **Description:** A newer entrant in the market, offering a Git-like command-line interface (CLI) and a desktop client for managing CAD files. It's built on top of an object-based storage system.
*   **Pros:**
    *   Familiar Git-like workflow.
    *   Promises more efficient storage and diffing of CAD data.
    *   Integrates with existing CAD tools.
*   **Cons:**
    *   A newer product, so the community and support may be less extensive.
    *   Requires adopting a new toolchain.

## 4. Recommendation

For our immediate needs, a combination of **Git + Git LFS** is the most pragmatic and recommended approach.

**Reasoning:**

1.  **Leverages Existing Infrastructure:** We already use Git for our software projects. Using Git LFS is a natural extension of our existing workflows and requires minimal new training for the team.
2.  **Cost-Effective:** Most major Git hosting providers offer a generous free tier for Git LFS, and paid plans are reasonably priced. This avoids the higher costs of specialized, proprietary platforms.
3.  **Flexibility:** This approach is not tied to a specific CAD vendor or platform. We can store any type of binary file, not just CAD.
4.  **Addresses the Core Problem:** The primary problem of repository bloat and performance degradation is solved by Git LFS.

While Git LFS does not provide visual diffing, this can be mitigated by:
*   **Good Commit Hygiene:** Writing clear, descriptive commit messages that explain the changes made.
*   **Manual Verification:** Opening the two versions of the file in a CAD application to visually compare them.
*   **Future Integration:** We can later investigate and integrate a separate visual diff tool that can be triggered as part of our workflow.

## 5. Next Steps

If this recommendation is approved, the following sub-tasks should be created:

*   **DEV-18: Setup and configure Git LFS for the 'website' project.**
*   **DEV-19: Document best practices for using Git LFS with CAD files.**
*   **DEV-20: Train the team on the new Git LFS workflow.**

This concludes the spike. The proposed solution is technically feasible and provides a solid foundation for versioning our CAD assets.
