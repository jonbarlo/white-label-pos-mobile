# Development Guidelines

## Code Style and Standards

### 1. Dart/Flutter Conventions
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter_lints` for consistent code style
- Run `flutter analyze` before committing
- Use `dart format` to format code

### 2. Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private members**: `_camelCase`

### 3. File Organization
- One class per file (except for small related classes)
- Group related functionality in the same file
- Keep files under 300 lines when possible
- Use meaningful file names

## Architecture Guidelines

### 1. Feature-Based Organization
```
features/
├── auth/
│   ├── data/
│   ├── domain/
│   └── presentation/
└── pos/
    ├── data/
    ├── domain/
    └── presentation/
```

### 2. Layer Responsibilities
- **Data Layer**: API calls, local storage, data models
- **Domain Layer**: Business logic, entities, use cases
- **Presentation Layer**: UI, state management, user interaction

### 3. Dependency Injection
- Use Riverpod for dependency injection
- Keep providers close to where they're used
- Use meaningful provider names
- Avoid circular dependencies

## State Management

### 1. Riverpod Best Practices
- Use `@riverpod` annotation for providers
- Keep state immutable
- Use `copyWith` for state updates
- Handle loading and error states

### 2. Provider Organization
```dart
// Good
@riverpod
class AuthNotifier extends _$AuthNotifier {
  // Implementation
}

// Avoid
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

### 3. State Design
- Keep state simple and focused
- Use sealed classes for complex state
- Avoid storing derived data in state

## Testing Guidelines

### 1. Test Structure
- **Unit Tests**: Test business logic in isolation
- **Widget Tests**: Test UI components
- **Integration Tests**: Test feature workflows

### 2. Test Naming
```dart
// Good
test('should return user when login is successful', () async {
  // Test implementation
});

// Avoid
test('test1', () {
  // Test implementation
});
```

### 3. Test Organization
- Use `group()` to organize related tests
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Test edge cases and error scenarios

### 4. Mocking Guidelines
- Mock external dependencies (API, storage)
- Don't mock business logic
- Use meaningful mock data
- Verify mock interactions

## Error Handling

### 1. Exception Types
- Use custom exception classes
- Handle errors at appropriate layers
- Provide meaningful error messages
- Log errors for debugging

### 2. Error Handling Pattern
```dart
try {
  final result = await repository.getData();
  return result;
} on NetworkException catch (e) {
  // Handle network errors
  throw UserFriendlyException('Please check your connection');
} on ValidationException catch (e) {
  // Handle validation errors
  throw UserFriendlyException('Please check your input');
} catch (e) {
  // Handle unexpected errors
  throw UserFriendlyException('Something went wrong');
}
```

## Performance Guidelines

### 1. Widget Optimization
- Use `const` constructors
- Implement `==` operator and `hashCode`
- Use `ListView.builder` for large lists
- Avoid unnecessary rebuilds

### 2. State Management Optimization
- Use `select` for fine-grained updates
- Minimize state updates
- Use `ref.listen` sparingly
- Avoid storing computed values in state

### 3. Network Optimization
- Implement caching
- Use pagination for large datasets
- Cancel unnecessary requests
- Handle offline scenarios

## Security Guidelines

### 1. Data Protection
- Never store sensitive data in plain text
- Use secure storage for tokens
- Validate all user inputs
- Sanitize data before display

### 2. Network Security
- Use HTTPS for all API calls
- Validate API responses
- Handle authentication errors
- Implement certificate pinning if needed

## Documentation

### 1. Code Documentation
- Document public APIs
- Use meaningful comments for complex logic
- Keep documentation up to date
- Use `///` for documentation comments

### 2. Architecture Documentation
- Document design decisions
- Maintain architecture diagrams
- Keep guidelines updated
- Document breaking changes

## Git Workflow

### 1. Branch Naming
- `feature/feature-name`
- `bugfix/bug-description`
- `hotfix/urgent-fix`
- `refactor/refactor-description`

### 2. Commit Messages
- Use conventional commit format
- Write clear, descriptive messages
- Reference issues when applicable
- Keep commits focused and atomic

### 3. Pull Request Guidelines
- Write clear descriptions
- Include screenshots for UI changes
- Add tests for new features
- Request reviews from team members

## Code Review Checklist

### 1. Functionality
- [ ] Does the code work as expected?
- [ ] Are edge cases handled?
- [ ] Are error scenarios covered?
- [ ] Is the code efficient?

### 2. Code Quality
- [ ] Is the code readable and maintainable?
- [ ] Are naming conventions followed?
- [ ] Is the code properly documented?
- [ ] Are there any code smells?

### 3. Testing
- [ ] Are there adequate tests?
- [ ] Do tests cover edge cases?
- [ ] Are tests meaningful and focused?
- [ ] Do tests follow best practices?

### 4. Security
- [ ] Are inputs validated?
- [ ] Is sensitive data handled properly?
- [ ] Are there any security vulnerabilities?
- [ ] Is authentication/authorization correct?

### 5. Performance
- [ ] Is the code performant?
- [ ] Are there any memory leaks?
- [ ] Is the UI responsive?
- [ ] Are network calls optimized?

## Common Anti-Patterns to Avoid

### 1. State Management
- Don't store derived data in state
- Don't use global variables
- Don't mutate state directly
- Don't create unnecessary providers

### 2. Widget Design
- Don't create overly complex widgets
- Don't use `setState` with Riverpod
- Don't ignore widget lifecycle
- Don't create widgets with too many parameters

### 3. Error Handling
- Don't ignore errors
- Don't show technical errors to users
- Don't catch and rethrow without context
- Don't use generic error messages

### 4. Performance
- Don't rebuild widgets unnecessarily
- Don't make expensive operations in build methods
- Don't ignore memory leaks
- Don't make unnecessary API calls

## Tools and Setup

### 1. Required Tools
- Flutter SDK (latest stable)
- Dart SDK
- VS Code with Flutter extension
- Git

### 2. VS Code Extensions
- Flutter
- Dart
- Flutter Widget Snippets
- Error Lens
- GitLens

### 3. Pre-commit Hooks
- Run `flutter analyze`
- Run `flutter test`
- Run `dart format`
- Check for TODO comments

## Getting Started

### 1. Project Setup
```bash
# Clone the repository
git clone <repository-url>
cd white-label-pos-mobile

# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Run tests
flutter test

# Start development
flutter run
```

### 2. Development Workflow
1. Create a feature branch
2. Implement the feature
3. Write tests
4. Run tests and analysis
5. Create a pull request
6. Get code review
7. Merge to main branch

### 3. Troubleshooting
- Check the [Flutter documentation](https://flutter.dev/docs)
- Review the architecture guide
- Ask for help in team channels
- Document solutions for future reference 