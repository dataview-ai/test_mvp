# Developer Handoff Guide: Genesis Project

This document provides the necessary guidance for the development and QA teams to implement and test the "Genesis" Digital Twin project.

## 1. Tech Stack

- **Backend:** Node.js (Express.js)
- **Database:** PostgreSQL (SQL)

## 2. Setup Instructions

1.  **Database First:** Before running the application, initialize the database schema by executing the `04_Database_Schema.sql` script. This will create all necessary tables and relationships.
2.  **API Scaffolding:** Use the `05_API_Specification.yaml` with an OpenAPI generator to scaffold the initial backend server, routes, and models.
3.  **Dependencies:** Install project dependencies using `npm install`.

## 3. Implementation Map: PM Tickets to API Endpoints

This section maps the business requirements from the PM's tickets to the specific technical implementation in the API.

| PM Ticket                                       | Workstream     | API Endpoint(s) Implementation                               |
| ----------------------------------------------- | -------------- | ------------------------------------------------------------ |
| **ID: 4** - Product Discovery Page              | `pre_purchase` | `GET /products/{id}`: Fetches all public-facing product data, including images, videos, and description. |
| **Workstream** - Virtual Queue                  | `pre_purchase` | `POST /queue/join`: Allows a user to enter the waiting list for the drop.<br>`GET /queue/status`: Lets the user check their position in the queue. |
| **Workstream** - Secure Checkout                | `pre_purchase` | `POST /checkout`: Handles payment processing, order creation, and inventory reduction. Requires authentication. |
| **Workstream** - Post-Purchase & NFT Fulfillment | `post_purchase`| `GET /orders/{orderId}`: Retrieves order status and delivery tracking information.<br>`POST /users/wallet`: Allows the owner to link their crypto wallet address for NFT delivery.<br>`GET /nfts/{watchId}`: Displays the status and details of the digital twin NFT. |

## 4. Testing Requirements (QA Agent)

The QA Agent must verify the following critical paths and functionalities:

- **API Endpoint Integrity:**
  - All endpoints defined in `05_API_Specification.yaml` must be tested for correct responses (2xx), error handling (4xx for client errors, 5xx for server errors), and data validation.
  - Authenticated endpoints must reject requests without a valid JWT.

- **End-to-End User Journey:**
  - **Successful Purchase:** Verify the complete flow: View Product -> Join Queue -> Reach Checkout -> Submit Payment -> Receive Order Confirmation.
  - **Queue Logic:** Confirm that the queue is fair (FIFO) and correctly manages user sessions.
  - **Sold Out Scenario:** Ensure that once all 50 units are sold, the system prevents further purchases.

- **NFT Fulfillment:**
  - Confirm that a successful and verified order automatically triggers the NFT minting and transfer process to the owner's registered wallet address.

- **Security:**
  - All data in transit must be over TLS 1.2+.
  - Run basic security scans to check for common vulnerabilities (e.g., SQL Injection, XSS) on all input fields and API parameters.
