# Testing Conventions

## Unit, Widget, and Provider Testing

### 1. Mocking with `mocktail`
- Use `mocktail` for creating test doubles.
- Inherit mocks using empty class declarations:
  ```dart
  import 'package:mocktail/mocktail.dart';

  class MockAuthRepository extends Mock implements AuthRepository;
  ```

### 2. Riverpod Container Testing
- When testing providers or services, isolate them using `ProviderContainer`:
  ```dart
  late MockAuthRepository mockAuthRepo;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });
  ```

### 3. Widget Testing
- Wrap widgets under test in `ProviderScope` and `MaterialApp`:
  ```dart
  testWidgets('renders login button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    expect(find.byType(LoginPage), findsOneWidget);
  });
  ```

### 4. Running Tests
- Run all tests: `flutter test`
- Run with coverage: `flutter test --coverage`
