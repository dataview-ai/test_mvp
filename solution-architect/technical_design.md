# Spike: Git-for-CAD Technical Feasibility Study

**Task:** DEV-17 - Architect: Spike - Investigate 'Git-for-CAD' Technical Feasibility

## 1. Introduction

This document investigates the feasibility of implementing a "Git-for-CAD" solution. The goal is to understand the challenges of using traditional Git for Computer-Aided Design (CAD) files and to explore potential solutions that offer better version control for large binary assets.

While the current project "website" is software-focused, this investigation is a forward-looking spike to assess technologies that may be relevant for future projects or clients, particularly if "knowlance ai" expands its services to include AI for industrial design, manufacturing, or robotics, where CAD files are prevalent.

## 2. The Challenge: Why Standard Git is Not Ideal for CAD

Git was designed for source code, which consists of plain text files. Its core mechanisms, like diffing and merging, are optimized for line-based changes in text. CAD files, however, are typically large, complex, and binary. This leads to several problems:

*   **Repository Bloat:** Storing multiple versions of large binary files directly in Git causes the repository size to grow uncontrollably. Every small change results in a full copy of the file being stored.
*   **Inefficient Diffing:** `git diff` is meaningless for binary files. It can only tell you *that* a file has changed, not *what* has changed within the design.
*   **No Merging:** It is impossible to automatically merge concurrent changes from two different users on the same binary file. This breaks a core collaborative workflow of Git.
*   **Performance Issues:** Cloning, pulling, and pushing large binary files can be extremely slow and consume significant bandwidth.

## 3. Potential Solutions

Several approaches can address the shortcomings of Git for CAD files.

### 3.1. Git LFS (Large File Storage)

Git LFS is an open-source extension for Git that replaces large files with text pointers inside Git, while storing the file contents on a remote server.

*   **How it Works:** When you add a large file, Git LFS stores a small pointer file in the Git repository and uploads the actual binary file to a separate LFS store. When you checkout a commit, the LFS client downloads the required files from the LFS store.
*   **Pros:**
    *   Keeps the Git repository small and fast.
    *   Integrates seamlessly with the standard Git workflow. Developers can use the same commands.
    *   Supported by major Git hosting platforms like GitHub, GitLab, and Bitbucket.
*   **Cons:**
    *   Does not solve the diffing and merging problem. It's still impossible to see visual diffs or merge complex CAD designs.
    *   Requires a separate LFS server, which can have storage and bandwidth costs.

### 3.2. Centralized Version Control Systems (CVCS)

Systems like **Apache Subversion (SVN)** or **Perforce Helix Core** are often used in industries with large binary assets (like game development and hardware engineering).

*   **How it Works:** Unlike Git's distributed model, these systems use a central server. Users check out files, work on them, and then check them back in. They often support file locking to prevent conflicting changes.
*   **Pros:**
    *   **File Locking:** Prevents merge conflicts on binary files by allowing a user to "lock" a file while they are editing it. This is a robust way to handle un-mergeable files.
    *   Mature handling of large binary files.
*   **Cons:**
    *   Requires a different workflow and command set than Git, which can be a hurdle for teams accustomed to Git.
    *   Centralized model means a single point of failure.
    *   Less flexible for branching and offline work compared to Git.

### 3.3. Specialized "Git-for-CAD" Platforms

Several commercial platforms are built specifically for hardware and CAD version control. Examples include **GrabCAD Workbench** and **Kenesto**.

*   **How it Works:** These are often cloud-based solutions that provide a full suite of tools for CAD collaboration, including version control, visual diffing, and project management.
*   **Pros:**
    *   **Visual Diffing:** The most significant advantage. They can often render two versions of a CAD model and highlight the geometric changes.
    *   **Deep CAD Integration:** Often include plugins for popular CAD software (like SolidWorks, AutoCAD).
    *   Designed for non-technical users with intuitive user interfaces.
*   **Cons:**
    *   Proprietary, vendor lock-in.
    *   Costly, usually licensed per user.
    *   Separates the hardware and software version control systems, which can be problematic for complex mechatronic or IoT projects.

## 4. Recommendation

For a company like "knowlance ai" whose core competency is software and AI, adopting a completely new and separate version control system for a potential future use case is a significant overhead.

The most pragmatic and scalable approach is to **use Git LFS**.

**Reasoning:**

1.  **Unified Workflow:** It allows the team to continue using the familiar Git workflow for all projects. Software engineers and potential future mechanical/hardware engineers can collaborate within the same ecosystem.
2.  **Low Barrier to Entry:** Git LFS is an extension, not a replacement. It is easy to set up and start using for specific file types (`*.cad`, `*.step`, etc.).
3.  **Cost-Effective:** While there are storage costs, they are generally manageable and scale with usage. It avoids the high per-user licensing fees of specialized platforms.
4.  **Sufficient for Near-Term Needs:** While Git LFS does not provide visual diffing, it solves the most critical problem: repository bloat and performance. The lack of merging can be managed with a strong process, such as a file-locking-like protocol managed by the team (e.g., communicating via chat "I'm working on `robot_arm.sldprt` now").

**Implementation Path:**

1.  **Identify File Types:** Determine which file extensions should be tracked by Git LFS.
2.  **Install Git LFS:** Ensure all developers have the Git LFS client installed.
3.  **Configure Tracking:** Use `git lfs track "*.step"` to tell LFS which files to manage.
4.  **Educate Team:** Document the process and ensure the team understands how to work with large files.

This approach provides a solid foundation for handling large binary files without disrupting the existing development process. If the company's involvement in CAD-heavy projects grows significantly in the future, a migration to a specialized platform can be re-evaluated at that time.
