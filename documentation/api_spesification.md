# API Specification

**Mini Social App – v1**

## Base URL

```
/api/v1
```

## Authentication

**Type:** JWT Bearer Token

**Header:**

```
Authorization: Bearer <access_token>
```

---

## 1️⃣ Authentication

### Register

**POST** `/auth/register`

**Request:**

```json
{
  "email": "user@mail.com",
  "password": "strongpassword"
}
```

**Rules:**

- Email must be unique
- Password is hashed
- Profile is auto-created

**Response Success** – `201 Created`

```json
{
  "message": "User registered successfully",
  "data": {
    "accessToken": "jwt_token"
  }
}
```

**Errors:**

**409**

```json
{
  "message": "Email already exists",
  "error": {
    "code": "EMAIL_ALREADY_EXISTS",
    "details": {}
  }
}
```

**422**

```json
{
  "message": "Invalid input",
  "error": {
    "code": "INVALID_INPUT",
    "details": {}
  }
}
```

### Login

**POST** `/auth/login`

**Request:**

```json
{
  "email": "user@mail.com",
  "password": "strongpassword"
}
```

**Response Success** – `200 OK`

```json
{
  "message": "Login successful",
  "data": {
    "accessToken": "jwt_token"
  }
}
```

**Errors:**

**401**

```json
{
  "message": "Invalid credentials",
  "error": {
    "code": "INVALID_CREDENTIALS",
    "details": {}
  }
}
```

**429**

```json
{
  "message": "Too many login attempts",
  "error": {
    "code": "TOO_MANY_ATTEMPTS",
    "details": {}
  }
}
```

---

## 2️⃣ Current User

### Get Current User

**GET** `/users/me`

**Auth:** required

**Response Success** – `200 OK`

```json
{
  "message": "User retrieved successfully",
  "data": {
    "id": "uuid",
    "email": "user@mail.com",
    "role": "USER"
  }
}
```

---

## 3️⃣ Profile

### Get My Profile

**GET** `/profiles/me`

**Auth:** required

**Response Success** – `200 OK`

```json
{
  "message": "Profile retrieved successfully",
  "data": {
    "id": "uuid",
    "bio": "Hello world",
    "avatarUrl": "https://...",
    "thumbnailUrl": "https://..."
  }
}
```

### Update My Profile

**PATCH** `/profiles/me`

**Auth:** required

**Request:**

```json
{
  "bio": "Updated bio"
}
```

**Rules:**

- User can update only own profile

**Response Success** – `200 OK`

```json
{
  "message": "Profile updated successfully",
  "data": {
    "id": "uuid",
    "bio": "Updated bio",
    "avatarUrl": "https://...",
    "thumbnailUrl": "https://..."
  }
}
```

### Update Avatar

**POST** `/profiles/me/avatar`

**Auth:** required  
**Content-Type:** `multipart/form-data`

**Form Data:**

- `avatar`: `<image file>`

**Rules:**

- Image only
- Max file size enforced
- Old avatar is deleted
- Thumbnail is auto-generated

**Response Success** – `200 OK`

```json
{
  "message": "Avatar updated successfully",
  "data": {
    "avatarUrl": "https://...",
    "thumbnailUrl": "https://..."
  }
}
```

---

## 4️⃣ Posts

### Create Post

**POST** `/posts`

**Auth:** required  
**Content-Type:** `multipart/form-data`

**Form Data:**

- `content`: `<quill JSON string>`
- `image`: `<optional image file>`

**Rules:**

- Author derived from token
- Image optional
- Content must be valid Quill JSON

**Response Success** – `201 Created`

```json
{
  "message": "Post created successfully",
  "data": {
    "id": "uuid",
    "author": {
      "id": "uuid",
      "bio": "Hello",
      "avatarUrl": "https://...",
      "thumbnailUrl": "https://..."
    },
    "content": { "ops": [] },
    "imageUrl": "https://...",
    "createdAt": "2025-01-01T10:00:00Z"
  }
}
```

### Get Feed

**GET** `/posts`

**Auth:** required

**Query Params:**

- `limit=10`
- `cursor=2025-01-01T10:00:00Z`

**Rules:**

- Ordered by newest first
- Soft-deleted posts excluded

**Response Success** – `200 OK`

```json
{
  "message": "Feed retrieved successfully",
  "data": {
    "items": [
      {
        "id": "uuid",
        "author": {
          "id": "uuid",
          "bio": "Hello",
          "avatarUrl": "https://..."
        },
        "content": { "ops": [] },
        "imageUrl": "https://...",
        "createdAt": "2025-01-01T10:00:00Z"
      }
    ],
    "nextCursor": "2025-01-01T09:55:00Z"
  }
}
```

### Get Post Detail

**GET** `/posts/:id`

**Auth:** required

**Response Success** – `200 OK`

```json
{
  "message": "Post retrieved successfully",
  "data": {
    "id": "uuid",
    "author": {
      "id": "uuid",
      "bio": "Hello",
      "avatarUrl": "https://...",
      "thumbnailUrl": "https://..."
    },
    "content": { "ops": [] },
    "imageUrl": "https://...",
    "createdAt": "2025-01-01T10:00:00Z"
  }
}
```

**Errors:**

**404**

```json
{
  "message": "Post not found or deleted",
  "error": {
    "code": "POST_NOT_FOUND",
    "details": {}
  }
}
```

### Delete Post

**DELETE** `/posts/:id`

**Auth:** required

**Rules:**

- Only post owner or admin
- Soft delete only

**Response Success** – `204 No Content`

(no content)

**Errors:**

**403**

```json
{
  "message": "You do not own this post",
  "error": {
    "code": "FORBIDDEN",
    "details": {}
  }
}
```

**404**

```json
{
  "message": "Post not found",
  "error": {
    "code": "POST_NOT_FOUND",
    "details": {}
  }
}
```

---

## 6 Cars

## Get Car By Id

**Get** `/car/:id`

**Request**

---

## 5️⃣ Files (Optional Public Access)

### Get File

**GET** `/files/:id`

**Rules:**

- Files served read-only
- Authorization optional (depends on setup)

---

## 6️⃣ Error Response Format (Global)

All errors follow this format:

```json
{
  "message": "Error message here",
  "error": {
    "code": "ERROR_CODE",
    "details": {}
  }
}
```

---

## 7️⃣ HTTP Status Code Rules

| Case                    | Code  |
| ----------------------- | ----- |
| Not logged in           | `401` |
| Logged in but forbidden | `403` |
| Invalid input           | `422` |
| Duplicate data          | `409` |
| Too many requests       | `429` |
| Not found               | `404` |
