# My Social - Backend

NestJS backend API server for the My Social application.

## 🚀 Getting Started

### Prerequisites

- Node.js (v18+)
- Yarn or npm
- PostgreSQL database

### Installation

1. Install dependencies:
```bash
yarn install
```

2. Set up environment variables:
Create a `.env` file in the `backend` directory:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/my_social"
JWT_SECRET="your-secret-key"
PORT=3000
```

3. Run database migrations:
```bash
yarn migrate:postgres
```

4. Start the development server:
```bash
yarn start:dev
```

The API will be available at `http://localhost:3000`
Swagger documentation: `http://localhost:3000/api`

## 📚 API Documentation

### Base URL
```
/api/v1
```

### Authentication
All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <access_token>
```

### Main Endpoints

- **Authentication**
  - `POST /api/v1/auth/register` - Register a new user
  - `POST /api/v1/auth/login` - Login user

- **Users**
  - `GET /api/v1/users/me` - Get current user

- **Profiles**
  - `GET /api/v1/profiles/me` - Get current user's profile
  - `PATCH /api/v1/profiles/me` - Update profile
  - `POST /api/v1/profiles/me/avatar` - Upload avatar

- **Posts**
  - `GET /api/v1/posts` - Get paginated feed
  - `GET /api/v1/posts/:id` - Get post details
  - `POST /api/v1/posts` - Create a new post
  - `DELETE /api/v1/posts/:id` - Delete a post

For detailed API documentation:
- Swagger UI: `http://localhost:3000/api` (when server is running)
- API Specification: `../documentation/api_spesification.md`

## 🛠️ Development

### Available Scripts

```bash
# Development
yarn start:dev          # Start in watch mode
yarn start:debug        # Start in debug mode
yarn start              # Start in production mode

# Production
yarn build              # Build the project
yarn start:prod         # Start production server

# Code Quality
yarn lint               # Run ESLint
yarn format             # Format code with Prettier

# Database
yarn migrate:postgres   # Run migrations
yarn migrate:postgres-test  # Run test migrations
```

## 🧪 Testing

### Unit Tests
```bash
yarn test
```

### E2E Tests
```bash
yarn test:e2e
```

### Test Coverage
```bash
yarn test:cov
```

## 🗄️ Database

The application uses PostgreSQL with Prisma ORM. The database schema includes:

- **User**: User accounts with email, username, and role
- **Profile**: User profiles with bio, avatar, and thumbnail
- **Post**: Posts with rich text content and optional images
- **File**: File metadata and storage information

See `prisma/schema.prisma` for the complete schema.

### Migrations

Run migrations:
```bash
yarn migrate:postgres
```

For test environment:
```bash
yarn migrate:postgres-test
```

## 🔒 Security Features

- JWT token authentication
- Password hashing with bcrypt
- Rate limiting on authentication endpoints
- File upload validation
- Ownership-based authorization
- Input validation with Zod
- CORS configuration

## 📦 Tech Stack

- **Framework**: NestJS
- **Language**: TypeScript
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Validation**: Zod
- **Authentication**: JWT
- **Documentation**: Swagger/OpenAPI

## 📝 Key Backend Rules

1. **Authentication**: All requests (except login/register) require a valid JWT token
2. **Ownership**: Users can only modify their own resources (enforced on backend)
3. **Soft Delete**: Posts are soft-deleted, not permanently removed
4. **File Lifecycle**: Files are automatically cleaned up when associated resources are deleted
5. **Pagination**: Feed uses cursor-based pagination, not offset-based
6. **Rich Text**: Post content is stored as Quill JSON, not plain text

See `../documentation/product_rule.md` for complete rules and constraints.
