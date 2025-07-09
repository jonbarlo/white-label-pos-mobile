# Architecture Guide

## Project Structure

```
lib/
├── src/
│   ├── core/                    # Core functionality, shared across features
│   │   ├── config/             # App configuration, environment
│   │   ├── constants/          # App-wide constants
│   │   ├── errors/             # Error handling and custom exceptions
│   │   ├── extensions/         # Dart extensions
│   │   ├── network/            # Network layer (Dio setup, interceptors)
│   │   ├── storage/            # Local storage abstractions
│   │   ├── utils/              # Utility functions and helpers
│   │   └── widgets/            # Shared/reusable widgets
│   │
│   ├── features/               # Feature-based modules
│   │   ├── auth/               # Authentication feature
│   │   │   ├── data/           # Data layer
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── remote/
│   │   │   │   │   └── local/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/         # Business logic layer
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/   # UI layer
│   │   │       ├── pages/
│   │   │       ├── widgets/
│   │   │       └── providers/
│   │   │
│   │   ├── pos/                # POS feature
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   └── [other_features]/
│   │
│   ├── shared/                 # Shared components across features
│   │   ├── models/             # Shared data models
│   │   ├── widgets/            # Shared UI components
│   │   └── services/           # Shared services
│   │
│   └── app/                    # App-level configuration
│       ├── router/             # Navigation and routing
│       ├── theme/              # App theming
│       └── providers/          # App-level providers
│
├── main.dart                   # App entry point
└── app.dart                    # App widget
```

## Architecture Principles

### 1. Clean Architecture
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: Dependencies point inward toward the domain layer
- **Testability**: Each layer can be tested independently

### 2. Feature-First Organization
- Each feature is self-contained with its own data, domain, and presentation layers
- Features can be developed and tested independently
- Clear boundaries between features

### 3. Dependency Injection
- Use Riverpod for dependency injection
- Providers are organized by feature
- Clear provider naming conventions

## Naming Conventions

### Files and Folders
- Use `snake_case` for file and folder names
- Use `PascalCase` for class names
- Use `camelCase` for variables and methods

### Providers
- `[Feature]RepositoryProvider` - Repository providers
- `[Feature]NotifierProvider` - State notifiers
- `[Feature]Provider` - Simple providers

### Models
- `[Entity]` - Domain entities
- `[Entity]Model` - Data models
- `[Entity]Dto` - API DTOs

## Code Organization Guidelines

### 1. Single Responsibility Principle
- Each class should have one reason to change
- Keep methods focused and concise

### 2. DRY (Don't Repeat Yourself)
- Extract common functionality into shared utilities
- Use mixins for shared behavior
- Create base classes for common patterns

### 3. SOLID Principles
- **S**ingle Responsibility
- **O**pen/Closed Principle
- **L**iskov Substitution
- **I**nterface Segregation
- **D**ependency Inversion

## Testing Strategy

### Test Structure
```
test/
├── unit/                       # Unit tests
│   ├── core/
│   ├── features/
│   └── shared/
├── widget/                     # Widget tests
├── integration/                # Integration tests
└── helpers/                    # Test utilities
```

### Testing Guidelines
- Test business logic in isolation
- Mock external dependencies
- Use meaningful test names
- Follow AAA pattern (Arrange, Act, Assert)

## Error Handling

### Error Types
- `AppException` - Base exception class
- `NetworkException` - Network-related errors
- `ValidationException` - Input validation errors
- `BusinessException` - Business logic errors

### Error Handling Strategy
- Handle errors at the appropriate layer
- Provide meaningful error messages
- Log errors for debugging
- Show user-friendly error messages

## Performance Guidelines

### 1. Widget Optimization
- Use `const` constructors where possible
- Implement `==` operator and `hashCode` for custom widgets
- Use `ListView.builder` for large lists

### 2. State Management
- Minimize widget rebuilds
- Use `select` for fine-grained updates
- Avoid unnecessary state updates

### 3. Network Optimization
- Implement caching strategies
- Use pagination for large datasets
- Optimize API calls

## Security Guidelines

### 1. Data Protection
- Never store sensitive data in plain text
- Use secure storage for tokens
- Validate all user inputs

### 2. Network Security
- Use HTTPS for all API calls
- Implement certificate pinning if needed
- Validate API responses

## Documentation

### Code Documentation
- Document public APIs
- Use meaningful comments for complex logic
- Keep documentation up to date

### Architecture Documentation
- Document design decisions
- Maintain architecture diagrams
- Keep this guide updated 