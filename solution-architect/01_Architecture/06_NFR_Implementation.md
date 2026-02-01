
# Non-Functional Requirements (NFRs) - Technical Implementation

This document outlines the technical implementation details for the key non-functional requirements of the sr watch store project.

## 1. Authentication

Our authentication strategy will be based on JSON Web Tokens (JWT) to ensure a stateless and scalable architecture.

- **Method:** JWTs will be issued to users upon successful login (either via email/password or OAuth2).
- **Token Storage:** The JWT will be stored in a secure, HttpOnly cookie to prevent XSS attacks.
- **Token Structure:**
  - **Header:** Standard JWT header (`alg`: "HS256", `typ`: "JWT").
  - **Payload:**
    - `sub` (Subject): User ID.
    - `role`: User role (e.g., `customer`, `admin`).
    - `iat` (Issued At): Timestamp of token issuance.
    - `exp` (Expiration): Timestamp for token expiry (e.g., 15 minutes for an access token).
  - **Signature:** The signature will be generated using a strong, secret key stored securely on the server.
- **Refresh Tokens:** A long-lived refresh token (e.g., 7 days) will be stored in the database and used to issue new access tokens without requiring the user to log in again.
- **OAuth2 Providers:** For social login, we will integrate with **Google** and **Apple** using the OAuth2 protocol. This will be handled by a dedicated library like Passport.js (for Node.js environments) to manage the OAuth2 flow.

## 2. Rate Limiting

To protect the "Drop" API endpoint from bots and ensure fair access to limited-edition products, a multi-layered rate-limiting strategy will be implemented.

- **Primary Strategy (User-based):**
  - **Algorithm:** Token Bucket.
  - **Implementation:** We will use a middleware library like `express-rate-limit` with a Redis store to share state across multiple server instances.
  - **Limit:** A strict limit of **1 request per user every 10 seconds** will be enforced on the `/api/drops/claim` endpoint. This prevents a single user from spamming the claim button.

- **Secondary Strategy (IP-based):**
  - **Purpose:** To block malicious actors who are not logged in or are attempting to circumvent user-based limits from multiple accounts from the same IP.
  - **Limit:** A more general limit of **100 requests per IP per minute** will be applied to all sensitive endpoints, including login, registration, and the drop listing page.

## 3. Caching Strategy

We will use Redis as our in-memory data store for caching frequently accessed data, primarily product information, to reduce database load and improve response times.

- **Redis Key Naming Convention:**
  - **Single Product:** `product:<product_id>` (e.g., `product:12345`)
  - **List of All Products:** `products:all`
  - **Paginated Product Lists:** `products:all:page:<page_number>`
  - **Products by Category:** `products:category:<category_name>:page:<page_number>`

- **Time-to-Live (TTL) Policies:**
  - **General Product Data (`product:<product_id>`, `products:*`):**
    - **TTL:** **24 hours (86400 seconds)**. This data does not change frequently.
  - **Inventory/Stock Data:**
    - **Strategy:** We will not cache inventory counts directly for long periods. Instead, we will use a **cache-aside with write-through/write-invalidate** strategy.
    - When a product's stock level is updated (e.g., after a purchase), the application will:
      1. Update the stock count in the primary database.
      2. Immediately invalidate the corresponding product cache key in Redis (e.g., `DEL product:<product_id>`).
    - The next request for that product will result in a cache miss, fetching the fresh data from the database and repopulating the cache.

## 4. Blockchain Security

Securing the hot wallet private key is critical for the integrity of our blockchain operations. The private key will **never** be stored in plaintext in environment variables, configuration files, or source code.

- **Recommended Solution: AWS Key Management Service (KMS)**
  - **Storage:** The hot wallet private key will be encrypted using a Customer Master Key (CMK) in AWS KMS. The encrypted key (ciphertext) can be safely stored in our application's secret management system (e.g., AWS Secrets Manager or as an environment variable).
  - **Runtime Decryption:** The application will be assigned an IAM Role with a specific policy granting it `kms:Decrypt` permissions for the designated CMK.
  - **Process:**
    1. At runtime, when a transaction needs to be signed, the application will fetch the encrypted private key.
    2. It will then make an API call to AWS KMS, passing the encrypted key.
    3. KMS will decrypt the key in memory and return the plaintext private key to the application over a secure channel.
    4. The application will use the plaintext key to sign the transaction and then immediately discard it from memory. The plaintext key is never logged or stored.

- **Alternative Solution: HashiCorp Vault**
  - If a cloud-agnostic solution is preferred, HashiCorp Vault provides a similar level of security. The application would authenticate with Vault using a method like AppRole to retrieve the private key dynamically when needed.
