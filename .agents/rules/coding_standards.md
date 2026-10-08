# Coding Standards & Best Practices

## Modern Dart (3.13+) Standards

### 1. Parameter Conventions
- The project enforces `avoid_final_parameters: true` in `analysis_options.yaml`.
- **Do not** write `final` before formal function/method parameters.
  - Good: `Widget build(BuildContext context, WidgetRef ref)`
  - Bad: `Widget build(final BuildContext context, final WidgetRef ref)`

### 2. Pattern Matching & Switch Expressions
- Use Dart pattern matching and switch expressions for sealed classes and enums:
  ```dart
  final description = switch (sessionState) {
    SessionActive(:final user) => 'Active: ${user.email}',
    SessionLoading() => 'Loading session...',
    SessionInactive() => 'Logged out',
    SessionExpired() => 'Session timed out',
  };
  ```

### 3. Error Handling with `Result<T>`
- Repositories return `Future<Result<T>>` containing either `Success(data)` or `Failure(exception)`.
- Never throw exceptions from repositories to UI layers.
- Custom exceptions should inherit from `AppException`.
- Always use typed catch clauses:
  ```dart
  try {
    final response = await dio.get('/endpoint');
    return Success(response.data);
  } on DioException catch (e) {
    return Failure(NetworkException.fromDio(e));
  } on Exception catch (e) {
    return Failure(UnexpectedException(e.toString()));
  }
  ```

### 4. Logging Standards
- Never use `print()` or `debugPrint()`.
- Use the centralized `AppLogger.instance`:
  - `AppLogger.instance.d('Debug message')`
  - `AppLogger.instance.i('Info message')`
  - `AppLogger.instance.w('Warning message')`
  - `AppLogger.instance.e('Error message', error: e, stackTrace: stack)`

### 5. Code Formatting & Linting
- Line length: 100 characters.
- Format before submitting: `dart format lib test`.
- Linter checks: `flutter analyze --no-fatal-infos`.
