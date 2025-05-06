import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:anewsment/services/news_service.dart';
import 'package:anewsment/models/category_model.dart';
import 'package:anewsment/models/category_news_model.dart';

// Generate a MockClient using the Mockito package
@GenerateMocks([http.Client])
import 'news_service_test.mocks.dart';

void main() {
  late NewsService newsService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    // Inject the mock client
    newsService = NewsService(client: mockClient);
  });

  group('NewsService - getCategories', () {
    test(
      'returns a list of categories when HTTP call completes successfully',
      () async {
        // Arrange
        final responseData = '''
      {
        "categories": [
          {"name": "World", "file": "world.json"},
          {"name": "Technology", "file": "tech.json"}
        ]
      }
      ''';

        when(
          mockClient.get(Uri.parse('https://kite.kagi.com/kite.json')),
        ).thenAnswer((_) async => http.Response(responseData, 200));

        // Act
        final categories = await newsService.getCategories();

        // Assert
        expect(categories, isA<List<CategoryModel>>());
        expect(categories.length, 2);
        expect(categories[0].name, 'World');
        expect(categories[0].file, 'world.json');
      },
    );

    test('throws an exception when HTTP call fails', () async {
      // Arrange
      when(
        mockClient.get(Uri.parse('https://kite.kagi.com/kite.json')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() => newsService.getCategories(), throwsException);
    });

    test('throws an exception when response has invalid format', () async {
      // Arrange
      when(
        mockClient.get(Uri.parse('https://kite.kagi.com/kite.json')),
      ).thenAnswer((_) async => http.Response('{"invalid": "response"}', 200));

      // Act & Assert
      expect(() => newsService.getCategories(), throwsException);
    });
  });

  group('NewsService - getCategoryNews', () {
    test(
      'returns category news when HTTP call completes successfully',
      () async {
        // Arrange
        final responseData = '''
      {
        "clusters": [
          {
            "cluster_number": 1,
            "title": "Test Cluster",
            "articles": [
              {
                "title": "Test Article",
                "description": "Description",
                "image_url": "http://example.com/image.jpg",
                "link_url": "http://example.com/article"
              }
            ]
          }
        ]
      }
      ''';

        when(
          mockClient.get(Uri.parse('https://kite.kagi.com/test.json')),
        ).thenAnswer((_) async => http.Response(responseData, 200));

        // Act
        final categoryNews = await newsService.getCategoryNews('test.json');

        // Assert
        expect(categoryNews, isA<CategoryNewsModel>());
        expect(categoryNews.clusters.length, 1);
        expect(categoryNews.clusters[0].title, 'Test Cluster');
        expect(categoryNews.clusters[0].articles.length, 1);
      },
    );

    test('throws an exception when HTTP call fails', () async {
      // Arrange
      when(
        mockClient.get(Uri.parse('https://kite.kagi.com/test.json')),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      // Act & Assert
      expect(() => newsService.getCategoryNews('test.json'), throwsException);
    });

    test('handles various HTTP error codes correctly', () async {
      // Arrange
      when(
        mockClient.get(Uri.parse('https://kite.kagi.com/test.json')),
      ).thenAnswer((_) async => http.Response('Not authorized', 401));

      // Act & Assert
      expect(() => newsService.getCategoryNews('test.json'), throwsException);
    });
  });
}
