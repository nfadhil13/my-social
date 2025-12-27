# My Social

A full-stack social media application with a NestJS backend and Flutter mobile client. This project demonstrates a complete feed-based social platform with authentication, user profiles, posts with rich text content, and file management.

## 🏗️ Architecture

- **Backend**: NestJS (Node.js/TypeScript) with PostgreSQL database
- **Mobile**: Flutter (Dart) with modular package architecture
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: JWT-based authentication
- **API Documentation**: Swagger/OpenAPI

## 📁 Project Structure

```
my-social/
├── backend/          # NestJS API server
├── mobile/           # Flutter mobile application
├── scripts/          # SDK generation scripts
└── documentation/    # API specs and product rules
```

## ✨ Features

- **Authentication**: User registration and login with JWT tokens
- **User Profiles**: Auto-created profiles with customizable bio and avatar
- **Posts**: Rich text content with optional images, paginated feed
- **File Management**: Secure file upload with automatic cleanup
- **Security**: Ownership-based authorization, rate limiting, input validation

## 🚀 Quick Start

### Prerequisites

- Node.js (v18+)
- PostgreSQL database
- Flutter SDK (v3.10.1+)
- Bun (for SDK generation scripts)

### Setup

For detailed setup instructions, see:

- **Backend**: [backend/README.md](backend/README.md)
- **Mobile**: [mobile/README.md](mobile/README.md)

## 📚 Documentation

- **API Specification**: [documentation/api_spesification.md](documentation/api_spesification.md)
- **Product Rules**: [documentation/product_rule.md](documentation/product_rule.md)
- **Database Schema**: [backend/prisma/schema.prisma](backend/prisma/schema.prisma)

## 📝 Key Rules

This application follows strict rules to ensure security and data integrity:

1. **Authentication**: All requests (except login/register) require a valid JWT token
2. **Ownership**: Users can only modify their own resources (enforced on backend)
3. **Soft Delete**: Posts are soft-deleted, not permanently removed
4. **File Lifecycle**: Files are automatically cleaned up when associated resources are deleted
5. **Pagination**: Feed uses cursor-based pagination, not offset-based
6. **Rich Text**: Post content is stored as Quill JSON, not plain text

See `documentation/product_rule.md` for complete rules and constraints.

## 📄 License

This project is private and unlicensed.
