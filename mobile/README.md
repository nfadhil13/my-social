# My Social - Mobile

Flutter mobile application for the My Social platform.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.10.1+)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (for dependency injection and localization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the application:
```bash
flutter run
```

## 📦 Package Structure

The mobile app uses a modular architecture with custom packages:

- **my_social_sdk**: Generated SDK for API communication
- **fdl_core**: Core utilities and base classes
- **fdl_types**: Shared type definitions
- **fdl_ui**: Reusable UI components
- **fdl_bloc**: BLoC pattern implementations

## 🛠️ Development

### Available Commands

```bash
# Development
flutter run              # Run the app
flutter pub get          # Install dependencies

# Code Generation
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch  # Watch mode for code generation

# Analysis
flutter analyze         # Run static analysis
flutter format          # Format code

# Build
flutter build apk       # Build Android APK
flutter build ios       # Build iOS app
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📱 App Screens

The application includes 4 main screens:

- **Login**: User authentication
- **Register**: New user registration
- **Feed**: Paginated posts feed
- **Profile**: User profile management

## 🔧 SDK Generation

The SDK is automatically generated from the OpenAPI specification. To regenerate:

1. Navigate to the scripts directory:
```bash
cd ../scripts
```

2. Install dependencies:
```bash
bun install
```

3. Generate the SDK:
```bash
bun run generate-dart-sdk
```

## 📦 Dependencies

### Main Dependencies

- **go_router**: Navigation and routing
- **get_it**: Dependency injection
- **injectable**: Code generation for dependency injection
- **bloc**: State management
- **flutter_bloc**: BLoC integration for Flutter
- **flutter_secure_storage**: Secure token storage
- **slang**: Internationalization
- **dio**: HTTP client
- **equatable**: Value equality

### Dev Dependencies

- **injectable_generator**: Code generation for injectable
- **build_runner**: Code generation runner
- **slang_build_runner**: Code generation for slang
- **flutter_lints**: Linting rules

## 🎨 Architecture

The app follows a clean architecture pattern with:

- **BLoC Pattern**: State management using BLoC
- **Dependency Injection**: Using get_it and injectable
- **Modular Packages**: Separation of concerns with custom packages
- **Generated SDK**: Type-safe API client generated from OpenAPI spec

## 📝 Localization

The app uses `slang` for internationalization. Translation files are located in:
```
lib/core/localization/i18n
```

Generated files are in:
```
lib/core/localization/generated
```

## 🔐 Security

- Secure token storage using `flutter_secure_storage`
- JWT token management
- Secure API communication

## 📄 License

This project is private and unlicensed.
