# Ehtmam Platform — API Reference Documentation

**Base URL:** `https://final-graduation-production.up.railway.app`  
**Prepared for:** Frontend Team  
**Version:** 1.0 • June 2025

---

## Authentication

Most endpoints require a JWT Bearer Token in the `Authorization` header. After login / signup, save the returned token and include it in every protected request.

**Header format:**

```
Authorization: Bearer <your_token_here>
```

**User roles:** `client` | `caregiver` | `admin`

Endpoints marked with 🔐 require the header above. Public endpoints have no lock icon.

---

## Standard Response Shape

All responses follow this JSON envelope:

```json
{
  "status": "success" | "fail" | "error",
  "message": "Human-readable message",
  "data": { ... } | null
}
```

### HTTP Error Codes

| Code | Status | Meaning |
|------|--------|---------|
| 400 | Bad Request | Missing or invalid request body |
| 401 | Unauthorized | Missing or invalid JWT token |
| 403 | Forbidden | User does not have the required role |
| 404 | Not Found | Resource with given ID does not exist |
| 500 | Internal Error | Unexpected server-side error |

---

## User (Client) Auth — `/userlog`

Manages client registration, login, password management, and profile lookup. Clients are the main users who book caregivers.

### POST `/userlog/signup` — Register a New Client

**Public.** Accepts `multipart/form-data` to upload photos.

**Request body (`multipart/form-data`)**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `full_name` | String | Yes | Client's full name |
| `email` | String | Yes | Unique email address |
| `password` | String | Yes | Minimum 6 characters |
| `passwordConfirmation` | String | Yes | Must match password |
| `profile_picture` | File | No | Profile photo (image file) |
| `national_id` | File | No | National ID image |

**Success response (201):**

```json
{
  "status": "success",
  "data": {
    "_id": "...",
    "full_name": "Ahmed",
    "email": "a@email.com",
    "role": "client"
  }
}
```

### POST `/userlog/login` — Login

**Public.** Returns a JWT token to use in all protected requests.

**Request body (JSON)**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `email` | String | Yes | Registered email |
| `password` | String | Yes | Password |

**Success response (200):**

```json
{
  "status": "success",
  "message": "User logged in successfully",
  "data": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### POST `/userlog/logout` — Logout

**Protected (JWT).** Ends the session.

**Success response (200):**

```json
{
  "status": "success",
  "message": "Logged out successfully"
}
```

### POST `/userlog/forgotpassword` — Forgot Password

**Public.** Sends a reset link to the user's email (valid 10 min).

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `email` | String | Yes | The account email |

### PATCH `/userlog/resetpassword/:token` — Reset Password

`:token` — the token received via email link.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `password` | String | Yes | New password |
| `passwordConfirmation` | String | Yes | Must match new password |

### PATCH `/userlog/updatepassword` — Update Password

**Protected (JWT, role: client).**

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `currentPassword` | String | Yes | Current password |
| `password` | String | Yes | New password |
| `passwordConfirmation` | String | Yes | Must match new password |

### GET `/userlog/:id` — Get User Profile

**Public.** Returns user profile without the password field.

**URL param:** `:id` — MongoDB ObjectId of the user.

---

## Caregiver — `/caregiver`

Caregivers are service providers. They can register, be searched, updated, and deleted.

### POST `/caregiver/signup` — Register a Caregiver

**Public.** Accepts `multipart/form-data`.

**Request body (`multipart/form-data`)**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `full_name` | String | Yes | Full name |
| `email` | String | Yes | Unique email |
| `password` | String | Yes | Password |
| `passwordConfirmation` | String | Yes | Must match password |
| `speciality` | String | No | One of: `elderly care`, `child care`, `pet care`, `medical care` |
| `price` | Number | No | Hourly rate |
| `availability` | String | No | Free-text availability schedule |
| `experience` | String | No | Experience description |
| `profile_picture` | File | No | Profile photo (max 1) |
| `certifications` | File[] | No | Certification files (max 5) |
| `verifcation_documents` | File[] | No | Verification documents (max 5) |

### GET `/caregiver` — Get All Caregivers

**Public.** Supports query-string filtering.

**Query params:** `?speciality=elderly+care` | `?availability=weekends` etc.

### GET `/caregiver/:id` — Get Caregiver by ID

**Public.**

### PATCH `/caregiver/:id` — Update Caregiver

Send only the fields you want to update in JSON body.

### DELETE `/caregiver/:id` — Delete Caregiver

**Protected (JWT).** Role: `admin`.

---

## Services — `/services`

Services are the care types offered on the platform (e.g. elderly care, pet care). No authentication required for these endpoints.

### POST `/services` — Create Service

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `serviceID` | Number | Yes | Unique 5-digit ID |
| `serviceName` | String | Yes | 3–15 characters |
| `serviceDescription` | String | Yes | 3–255 characters |

### GET `/services` — Get All Services

Returns all services. Supports query filtering.

### GET `/services/:id` — Get Service

### PATCH `/services/:id` — Update Service

Send only fields to update.

### DELETE `/services/:id` — Delete Service

### DELETE `/services` — Delete All Services

Deletes every service in the database.

---

## Care Requests — `/request`

A Request is created by a client when they need a caregiver for a specific service. Caregivers can view available requests and submit offers.

### POST `/request` — Create a New Request

**Protected (JWT).** Role: `client`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `service` | ObjectId | Yes | ID of the requested service |
| `location` | String | Yes | Service location / address |
| `date` | Date | Yes | Requested date (ISO 8601) |
| `time` | String | Yes | Requested time (e.g. `'14:00'`) |
| `duration` | String | No | Duration (e.g. `'2 hours'`) |
| `notes` | String | No | Additional notes for the caregiver |

**Success response (201):**

```json
{
  "success": true,
  "message": "Request created successfully",
  "data": {
    "_id": "...",
    "status": "PENDING",
    "client": "..."
  }
}
```

### GET `/request` — Get My Requests

**Protected (JWT).** Role: `client`. Returns the logged-in client's requests.

### GET `/request/available` — Get Available Requests

**Protected (JWT).** Role: `caregiver`. Returns all `PENDING` requests.

### GET `/request/:id` — Get Request by ID

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

### GET `/request/:requestId/offers` — Get Offers on a Request

**Protected (JWT).** Role: `client`. Returns all caregiver offers for this request.

### POST `/request/:id/respond` — Caregiver Respond to Request

**Protected (JWT).** Role: `caregiver`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `action` | String | Yes | `ACCEPT` or `REJECT` |

### PATCH `/request/:id` — Update Request

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

### DELETE `/request/:id` — Delete Request

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

---

## Offers — `/offer`

After a client creates a request, caregivers can submit offers. The client then accepts or rejects an offer to move forward with a booking.

### POST `/offer/:requestId/offer` — Send an Offer

**Protected (JWT).** Role: `caregiver`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `price` | Number | Yes | Proposed price for the service |
| `notes` | String | No | Message or conditions for the client |

**Success response (201):**

```json
{
  "message": "Offer sent",
  "data": {
    "_id": "...",
    "status": "pending",
    "price": 200
  }
}
```

### GET `/request/:requestId/offers` — Get Offers for a Request

**Protected (JWT).** Role: `client`. (Routed through `/request`.)

### PATCH `/offer/:offerId/respond` — Accept / Reject Offer

**Protected (JWT).** Role: `client`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `status` | String | Yes | `accepted` or `rejected` |

### DELETE `/offer/:id` — Delete Offer

**Protected (JWT).** Role: `caregiver`. Only the caregiver who created it.

---

## Bookings — `/booking`

Once a client accepts an offer, a booking is created. The booking flow: `PENDING` → `CONFIRMED` (after payment) → `COMPLETED` / `CANCELLED`.

### Booking Status Lifecycle

| Status | Meaning |
|--------|---------|
| `PENDING` | Booking created, awaiting payment confirmation |
| `CONFIRMED` | Payment received, caregiver confirmed |
| `COMPLETED` | Service was delivered |
| `CANCELLED` | Booking was cancelled |

### POST `/booking/bookingfromoffer` — Create Booking from Offer

**Protected (JWT).** Role: `client`. Called automatically when the client accepts an offer.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `offerId` | ObjectId | Yes | ID of the accepted offer |

### GET `/booking` — Get All Bookings

**Protected (JWT).** Roles: `client`, `caregiver`. Returns only the user's bookings.

### GET `/booking/:id` — Get Booking by ID

**Protected (JWT).** Roles: `client`, `caregiver`.

### PATCH `/booking/confirmbookingandpay/:id` — Confirm & Pay

**Protected (JWT).** Role: `client`. Confirms the booking and deducts the price from the client's wallet.

### PATCH `/booking/:id` — Update Booking

**Protected (JWT).** Role: `client`.

### DELETE `/booking/:id` — Delete Booking

**Protected (JWT).** Role: `client`.

---

## Payments — `/payment`

Handles wallet top-up via Paymob and direct booking payment from wallet balance.

### POST `/payment/create` — Initiate Wallet Top-Up (Paymob)

**Protected (JWT).** Role: `client`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `amount` | Number | Yes | Amount in EGP to add to wallet |
| `paymentMethod` | String | Yes | `CARD` or `MOBILE_WALLET` |

**Success response (200):**

```json
{
  "success": true,
  "paymentUrl": "https://accept.paymob.com/..."
}
```

Redirect the user to `paymentUrl`. Paymob will call `/payment/callback` when complete.

### POST `/payment/callback` — Paymob Webhook (Internal)

**Public.** Called by Paymob after a transaction. **Do NOT call this from frontend.** It automatically updates the wallet balance on success.

### POST `/payment/pay-booking-wallet` — Pay Booking from Wallet

**Protected (JWT).** Role: `client`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `bookingId` | ObjectId | Yes | ID of the booking to pay for |

**Success response (200):**

```json
{
  "success": true,
  "message": "Booking paid successfully",
  "data": { }
}
```

---

## Wallet — `/wallet`

Each user has a wallet. Clients use it to pay for bookings and bundles. Caregivers receive payments into their wallets.

### POST `/wallet` — Create Wallet

**Protected (JWT).** Roles: `client`, `caregiver`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `userlog` | ObjectId | Yes | User ID (usually auto-filled from token) |

### GET `/wallet` — Get All Wallets

**Protected (JWT).** Role: `admin`.

### GET `/wallet/:id` — Get Wallet by ID

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

**Returns:** `balance`, `totalDeposited`, `totalSpent`, `transactions[]`.

### PATCH `/wallet/:id` — Update Wallet

**Protected (JWT).** Roles: `client`, `caregiver`.

### DELETE `/wallet/:id` — Delete Wallet

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

---

## Transactions — `/transaction`

Transaction records are auto-created by the system for every wallet deposit, booking payment, and refund. These endpoints are mostly for admin/reporting.

### POST `/transaction` — Create Transaction (Internal)

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `userlog` | ObjectId | Yes | Owner user ID |
| `wallet` | ObjectId | No | Wallet ID |
| `booking` | ObjectId | No | Related booking ID |
| `amount` | Number | Yes | Amount (min 1) |
| `type` | String | Yes | `DEPOSIT` \| `BOOKING_PAYMENT` \| `REFUND` |
| `paymentMethod` | String | Yes | `CARD` \| `MOBILE_WALLET` \| `INTERNAL_WALLET` |
| `status` | String | No | `PENDING` \| `COMPLETED` \| `FAILED` (default: `PENDING`) |

### GET `/transaction` — Get All Transactions

### GET `/transaction/:id` — Get Transaction by ID

### PATCH `/transaction/:id` — Update Transaction

### DELETE `/transaction/:id` — Delete Transaction

### DELETE `/transaction` — Delete All Transactions

---

## Tasks — `/tasks`

Tasks represent caregiving activities that must be done and can be tracked (e.g. giving medication, bathing). Admins create tasks; all authenticated users can view them.

### POST `/tasks` — Create Task

**Protected (JWT).** Role: `admin`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `taskID` | String | Yes | Unique task identifier |
| `taskTitle` | String | Yes | Short title |
| `taskDescription` | String | Yes | Full description |
| `taskState` | String | No | `pending` \| `in-progress` \| `completed` (default: `pending`) |
| `proofType` | String | No | `image` \| `video` (default: `image`) |
| `proofUrl` | String | Yes | URL of proof media |
| `taskType` | String | No | e.g. `daily` (default: `daily`) |

### GET `/tasks` — Get All Tasks

**Protected (JWT).** All roles.

### GET `/tasks/:id` — Get Task by ID

**Protected (JWT).**

### PATCH `/tasks/:id` — Update Task

**Protected (JWT).**

### DELETE `/tasks/:id` — Delete Task

**Protected (JWT).**

### DELETE `/tasks` — Delete All Tasks

**Protected (JWT).** Role: `admin`.

---

## Reviews — `/review`

Clients and caregivers can leave reviews after a service is completed.

### POST `/review` — Create Review

**Protected (JWT).** Roles: `client`, `caregiver`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `caregiver` | ObjectId | Yes | Caregiver being reviewed |
| `service` | ObjectId | Yes | Service that was provided |
| `request` | ObjectId | Yes | Related request ID |
| `rating` | Number | Yes | Rating (1–5) |
| `review` | String | Yes | Review text |
| `feedback` | String | No | Optional feedback |

### GET `/review` — Get All Reviews

**Protected (JWT).** Role: `admin`.

### GET `/review/:id` — Get Review by ID

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

### PATCH `/review/:id` — Update Review

**Protected (JWT).** Roles: `client`, `caregiver`.

### DELETE `/review/:id` — Delete Review

**Protected (JWT).** Roles: `client`, `caregiver`, `admin`.

---

## Bundles — `/bundle` & `/clientbundle`

Bundles are pre-packaged service deals. Admins create bundles; clients can choose and pay for them through the ClientBundle flow.

### Admin — Bundle Management (`/bundle`)

#### POST `/bundle` — Create Bundle

**Protected (JWT).** Role: `admin`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `client` | ObjectId | Yes | Target client ID |
| `caregiver` | ObjectId | Yes | Assigned caregiver ID |
| `services` | ObjectId[] | Yes | Array of service IDs |
| `price` | Number | Yes | Base price |
| `discount` | Number | No | Discount percentage |
| `totalPrice` | Number | Yes | Final price after discount |

#### GET `/bundle` — Get All Bundles

**Public.**

#### GET `/bundle/:id` — Get Bundle by ID

**Public.**

#### PATCH `/bundle/:id` — Update Bundle

**Admin.**

#### DELETE `/bundle/:id` — Delete Bundle

**Admin.**

### Client — ClientBundle (`/clientbundle`)

Represents a client subscribing to a bundle.

#### POST `/clientbundle` — Choose Bundle

**Protected (JWT).** Role: `client`.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `bundleId` | ObjectId | Yes | ID of the bundle to subscribe to |

**ClientBundle status flow:** `PENDING` → `PAID` → `ACTIVE` (or `CANCELLED`)

#### GET `/clientbundle` — Get All ClientBundles

#### GET `/clientbundle/:id` — Get ClientBundle

Roles: `client`, `admin`.

#### PATCH `/clientbundle/:id` — Pay Bundle

Role: `client`.

#### DELETE `/clientbundle/:id` — Cancel Bundle

Role: `client`.

---

## AI Chat Assistant — `/chat`

An AI-powered chat assistant that helps clients describe their care needs, recommends caregiver specialties, and answers app questions. Sessions are persisted per user.

### POST `/chat/message` — Send Message to AI

**Protected (JWT).** All authenticated users.

**Request body**

| Field | Type | Required? | Description |
|-------|------|-----------|-------------|
| `message` | String | Yes | User message (max 1000 chars) |
| `sessionId` | ObjectId | No | Existing session ID (omit to use latest session) |

**Success response (200):**

```json
{
  "success": true,
  "message": "Response received",
  "data": {
    "sessionId": "...",
    "userMessage": "I need help with elderly care",
    "assistantMessage": "I can help! Could you tell me...",
    "intent": "improve_care_request",
    "structuredResponse": {
      "botMessage": "...",
      "suggestedRequestDescription": "...",
      "recommendedSpecialty": "elderly care",
      "followUpQuestions": ["How many hours per day?"]
    }
  }
}
```

**Intent types:** `improve_care_request` | `recommend_caregiver_specialty` | `app_usage_support` | `general_question`

### GET `/chat/history` — Get Chat History

**Protected (JWT).**

**Query params:** `?sessionId=xxx` (optional — returns latest session if omitted)

Returns `messages` array with `role` (`user`/`assistant`), `content`, `intent`, timestamps.

### GET `/chat/sessions` — Get All Sessions

**Protected (JWT).** Returns list of all past chat sessions with titles and `lastMessageAt`.

### POST `/chat/sessions/new` — Start New Session

**Protected (JWT).** Creates a fresh chat session. Previous sessions are preserved.

**Success response (201):**

```json
{
  "success": true,
  "data": {
    "sessionId": "...",
    "sessionTitle": "New Chat"
  }
}
```

---

## Quick Reference — All Endpoints

Complete list of all endpoints with method, path, auth, and allowed roles.

| Group | Method | Endpoint | Auth | Roles |
|-------|--------|----------|------|-------|
| User Auth | POST | `/userlog/signup` | No | — |
| User Auth | POST | `/userlog/login` | No | — |
| User Auth | POST | `/userlog/logout` | JWT | all |
| User Auth | POST | `/userlog/forgotpassword` | No | — |
| User Auth | PATCH | `/userlog/resetpassword/:token` | No | — |
| User Auth | PATCH | `/userlog/updatepassword` | JWT | all |
| User Auth | GET | `/userlog/:id` | No | — |
| Caregiver | POST | `/caregiver/signup` | No | — |
| Caregiver | GET | `/caregiver` | No | — |
| Caregiver | GET | `/caregiver/:id` | No | — |
| Caregiver | PATCH | `/caregiver/:id` | JWT | all |
| Caregiver | DELETE | `/caregiver/:id` | JWT | admin |
| Services | POST | `/services` | No | — |
| Services | GET | `/services` | No | — |
| Services | GET | `/services/:id` | No | — |
| Services | PATCH | `/services/:id` | No | — |
| Services | DELETE | `/services/:id` | No | — |
| Services | DELETE | `/services` | No | — |
| Requests | POST | `/request` | JWT | client |
| Requests | GET | `/request` | JWT | client |
| Requests | GET | `/request/available` | JWT | caregiver |
| Requests | GET | `/request/:requestId/offers` | JWT | client |
| Requests | POST | `/request/:id/respond` | JWT | caregiver |
| Requests | GET | `/request/:id` | JWT | all |
| Requests | PATCH | `/request/:id` | JWT | all |
| Requests | DELETE | `/request/:id` | JWT | all |
| Offers | POST | `/offer/:requestId/offer` | JWT | caregiver |
| Offers | PATCH | `/offer/:offerId/respond` | JWT | client |
| Offers | DELETE | `/offer/:id` | JWT | caregiver |
| Bookings | POST | `/booking/bookingfromoffer` | JWT | client |
| Bookings | GET | `/booking` | JWT | client, caregiver |
| Bookings | GET | `/booking/:id` | JWT | client, caregiver |
| Bookings | PATCH | `/booking/confirmbookingandpay/:id` | JWT | client |
| Bookings | PATCH | `/booking/:id` | JWT | client |
| Bookings | DELETE | `/booking/:id` | JWT | client |
| Payment | POST | `/payment/create` | JWT | client |
| Payment | POST | `/payment/callback` | No | Paymob |
| Payment | GET | `/payment/callback` | No | Paymob |
| Payment | POST | `/payment/pay-booking-wallet` | JWT | client |
| Wallet | POST | `/wallet` | JWT | client, caregiver |
| Wallet | GET | `/wallet` | JWT | admin |
| Wallet | GET | `/wallet/:id` | JWT | all |
| Wallet | PATCH | `/wallet/:id` | JWT | client, caregiver |
| Wallet | DELETE | `/wallet/:id` | JWT | all |
| Transaction | POST | `/transaction` | No | — |
| Transaction | GET | `/transaction` | No | — |
| Transaction | GET | `/transaction/:id` | No | — |
| Transaction | PATCH | `/transaction/:id` | No | — |
| Transaction | DELETE | `/transaction/:id` | No | — |
| Transaction | DELETE | `/transaction` | No | — |
| Tasks | POST | `/tasks` | JWT | admin |
| Tasks | GET | `/tasks` | JWT | all |
| Tasks | GET | `/tasks/:id` | JWT | all |
| Tasks | PATCH | `/tasks/:id` | JWT | all |
| Tasks | DELETE | `/tasks/:id` | JWT | all |
| Tasks | DELETE | `/tasks` | JWT | admin |
| Reviews | POST | `/review` | JWT | client, caregiver |
| Reviews | GET | `/review` | JWT | admin |
| Reviews | GET | `/review/:id` | JWT | all |
| Reviews | PATCH | `/review/:id` | JWT | client, caregiver |
| Reviews | DELETE | `/review/:id` | JWT | all |
| Chat | POST | `/chat/message` | JWT | all |
| Chat | GET | `/chat/history` | JWT | all |
| Chat | GET | `/chat/sessions` | JWT | all |
| Chat | POST | `/chat/sessions/new` | JWT | all |
