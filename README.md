# Novatech Chat

A modern real-time chat application built with Flutter and Firebase, featuring a clean architecture, robust authentication, and real-time messaging capabilities.

## Overview

Novatech Chat is a full-featured chat application that demonstrates modern Flutter development practices and architectural patterns. The app includes:

- Real-time messaging with Firebase Firestore
- Authentication with both Google Sign-in and Email/Password
- User presence system (online/offline status)
- Clean and modern UI using shadcn_ui
- Form validation using Formz
- Comprehensive test coverage

## Architecture 🏗️

The project follows Clean Architecture principles, separated into distinct layers:

```text
lib/
├── app/                  # App initialization and configuration
├── authentication/       # Authentication feature
│   ├── bloc/            # Authentication business logic
│   ├── view/            # Authentication UI components
│   └── models/          # Authentication-related models
├── core/                # Core functionality and shared code
│   ├── data/           
│   │   ├── datasource/  # Remote data sources
│   │   └── repository/  # Repository implementations
│   └── domain/
│       ├── models/      # Domain entities
│       └── usecase/     # Business logic use cases
├── chats/               # Chat feature
│   ├── bloc/           
│   ├── view/           
│   └── models/         
└── register/            # User registration feature
    ├── bloc/           
    ├── view/           
    └── models/         
```

### Architecture Diagram

```text
┌─────────────────┐     ┌──────────────┐     ┌────────────────┐
│     UI Layer    │     │  BLoC Layer  │     │ Repository     │
│  (Flutter Views)│────▶│(Business     │────▶│   Layer        │
│                 │     │   Logic)     │     │                │
└─────────────────┘     └──────────────┘     └────────────────┘
                                                     │
                                                     ▼
                                            ┌────────────────┐
                                            │  Data Sources  │
                                            │   (Firebase)   │
                                            └────────────────┘
```

## Technical Decisions and Trade-offs 🤔

### State Management

- **BLoC Pattern**: Chosen for its clear separation of concerns and excellent testability
- **Formz**: Used for form validation to maintain consistent validation logic across the app

### Authentication

- Dual authentication methods (Google & Email/Password) for flexibility
- Firebase Auth for secure user management
- User profiles stored in Firestore to maintain additional user data

### Real-time Features

- Firebase Firestore for real-time messages and user presence
- Optimistic UI updates for better user experience
- Batch operations for efficient database access

### Testing Strategy

- Comprehensive unit tests for business logic
- Integration tests for critical user flows
- Mock repositories for isolated testing

## Firebase Emulator Setup 🔥

To run the app with Firebase Emulator Suite:

1. Install Firebase CLI:

   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:

   ```bash
   firebase login
   ```

3. Initialize Firebase project:

   ```bash
   firebase init emulators
   ```

4. Start the emulators with data persistence:

   ```bash
   firebase emulators:start --import=./firebase-data --export-on-exit=./firebase-data
   ```

This will:

- Start Authentication and Firestore emulators
- Import existing data from ./firebase-data (if it exists)
- Export data to ./firebase-data when stopping

### Emulator Configuration

The emulators will run on these default ports:

- Authentication: 9099
- Firestore: 8080
- UI: 4000

You can configure these in `firebase.json`:

```json
{
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "ui": {
      "port": 4000
    }
  }
}
```

## Getting Started 🚀

This project contains 3 flavors:

- development (uses emulators)
- staging
- production

To run the desired flavor:

```bash
# Development (with emulators)
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

## Running Tests 🧪

Run all tests with coverage:

```bash
flutter test --coverage --test-randomize-ordering-seed random
```

View coverage report:

```bash
genhtml coverage/lcov.info -o coverage/
```

## License 📝

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
