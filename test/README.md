# aNewsment Tests

This directory contains tests for the aNewsment app. The tests are written to ensure the reliability and functionality of the app's core features.

## Test Structure

- **Unit Tests**: Tests for individual units (classes, methods) in isolation
  - `services/`: Tests for services that handle data fetching and business logic
    - `news_service_test.dart`: Tests for category and news fetching
    - `video_service_test.dart`: Tests for video URL extraction and processing
  - `utils/`: Tests for utility functions and helpers
    - `ui_helpers_test.dart`: Tests for UI helper functions like emoji mapping

- **Widget Tests**: Tests for UI components and their behavior
  - `widget_test.dart`: Main app navigation and tab controller tests

## Setting Up the Test Environment

### Dependencies

The app uses the following packages for testing:
- `flutter_test`: Flutter's built-in testing framework
- `mockito`: For mocking dependencies
- `http_mock_adapter`: For mocking HTTP requests

These dependencies are in the `pubspec.yaml` file in the dev_dependencies section.

### Generating Mock Classes

For services that use HTTP requests, we use mockito to generate mock clients:

```bash
# Generate mock files
flutter pub run build_runner build
```

This will create the necessary `.mocks.dart` files used in the tests.

## Running Tests

You can run the tests using the provided `test.sh` script from the project root:

```bash
# Run all tests
./test.sh

# Run only service tests
./test.sh services

# Run only utility tests
./test.sh utils

# Run only widget tests
./test.sh widgets
```

Alternatively, you can run tests directly using Flutter's test command:

```bash
flutter test
```

## Test Coverage

The tests cover:

1. **Error Handling**: 
   - HTTP status codes (200, 400, 401, 403, 404, 429, 500, etc.)
   - Network connectivity issues
   - API response parsing errors
   - Timeouts

2. **Service Logic**: 
   - Fetching categories from the API
   - Fetching news articles by category
   - Extracting video URLs from article content
   - Generating video thumbnails

3. **UI Functionality**: 
   - Navigation between tabs
   - Tab controller state management
   - Category display

4. **Utility Functions**: 
   - Category emoji mapping
   - Event icon generation
   - Event type labeling

## Testing Approach

### Unit Testing Services

Our services are designed to be testable through dependency injection:

```dart
class NewsService {
  final http.Client client;
  
  NewsService({http.Client? client}) : this.client = client ?? http.Client();
  
  // Methods that can now be tested with a mock client
}
```

This allows us to inject a mock HTTP client during tests to simulate various scenarios without making actual network requests.

### Widget Testing

For widgets, we isolate components and test them in a minimal environment:

```dart
testWidgets('Widget behavior test', (WidgetTester tester) async {
  // Build a minimal app with just the widget under test
  await tester.pumpWidget(MaterialApp(home: WidgetUnderTest()));
  
  // Perform interactions and verify behavior
  await tester.tap(find.byType(Button));
  await tester.pump();
  expect(find.text('Expected Result'), findsOneWidget);
});
```

## Adding New Tests

When adding new tests:

1. Follow the existing pattern of using the AAA pattern (Arrange, Act, Assert)
2. Use descriptive test names that explain what is being tested
3. Mock external dependencies using the Mockito package
4. Focus on testing one specific behavior per test
5. Group related tests together
6. For services that make HTTP requests:
   - Test successful responses
   - Test error responses
   - Test parsing edge cases

## Common Testing Patterns

### Testing HTTP Services

```dart
test('returns data when HTTP call completes successfully', () async {
  // Arrange
  when(mockClient.get(any))
    .thenAnswer((_) async => http.Response('{"data": "success"}', 200));
    
  // Act
  final result = await service.fetchData();
  
  // Assert
  expect(result, isA<ExpectedType>());
  expect(result.property, 'expected value');
});
```

### Testing Error Handling

```dart
test('throws an exception when HTTP call fails', () async {
  // Arrange
  when(mockClient.get(any))
    .thenAnswer((_) async => http.Response('Not Found', 404));
    
  // Act & Assert
  expect(() => service.fetchData(), throwsException);
}); 