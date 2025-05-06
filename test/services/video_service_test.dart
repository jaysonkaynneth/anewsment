import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:anewsment/services/video_service.dart';

@GenerateMocks([http.Client])
import 'video_service_test.mocks.dart';

void main() {
  late VideoService videoService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    videoService = VideoService(client: mockClient);
  });

  group('VideoService - getVideoUrl', () {
    test('extracts YouTube embed URL correctly', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-with-video';
      final htmlContent = '''
      <html>
        <body>
          <iframe src="https://www.youtube.com/embed/ABC123"></iframe>
        </body>
      </html>
      ''';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenAnswer((_) async => http.Response(htmlContent, 200));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, 'https://www.youtube.com/watch?v=ABC123');
    });

    test('extracts YouTube watch URL correctly', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-with-video';
      final htmlContent = '''
      <html>
        <body>
          <a href="https://www.youtube.com/watch?v=XYZ789">Watch video</a>
        </body>
      </html>
      ''';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenAnswer((_) async => http.Response(htmlContent, 200));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, 'https://www.youtube.com/watch?v=XYZ789');
    });

    test('extracts Vimeo URL correctly', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-with-vimeo';
      final htmlContent = '''
      <html>
        <body>
          <a href="https://vimeo.com/123456">Watch on Vimeo</a>
        </body>
      </html>
      ''';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenAnswer((_) async => http.Response(htmlContent, 200));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, 'https://vimeo.com/123456');
    });

    test('returns original URL when no video is found', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-without-video';
      final htmlContent = '<html><body>No video here</body></html>';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenAnswer((_) async => http.Response(htmlContent, 200));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, articleUrl);
    });

    test('returns original URL when HTTP error occurs', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-error';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, articleUrl);
    });

    test('returns original URL when timeout occurs', () async {
      // Arrange
      final articleUrl = 'https://france24.com/article-timeout';

      when(
        mockClient.get(Uri.parse(articleUrl)),
      ).thenThrow(Exception('Connection timeout'));

      // Act
      final result = await videoService.getVideoUrl(articleUrl);

      // Assert
      expect(result, articleUrl);
    });
  });

  group('VideoService - isVideoUrl', () {
    test('identifies YouTube URLs correctly', () {
      expect(
        VideoService.isVideoUrl('https://www.youtube.com/watch?v=ABC123'),
        true,
      );
      expect(VideoService.isVideoUrl('https://youtube.com/embed/ABC123'), true);
    });

    test('identifies Vimeo URLs correctly', () {
      expect(VideoService.isVideoUrl('https://vimeo.com/123456'), true);
    });

    test('identifies Dailymotion URLs correctly', () {
      expect(
        VideoService.isVideoUrl('https://www.dailymotion.com/video/abc123'),
        true,
      );
    });

    test('identifies non-video URLs correctly', () {
      expect(VideoService.isVideoUrl('https://example.com/page'), false);
      expect(VideoService.isVideoUrl('https://youtube.com/channel/123'), false);
    });
  });

  group('VideoService - getThumbnailUrl', () {
    test('returns correct YouTube thumbnail URL', () {
      final thumbnailUrl = VideoService.getThumbnailUrl(
        'https://www.youtube.com/watch?v=ABC123',
      );
      expect(
        thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/maxresdefault.jpg',
      );
    });

    test('returns correct YouTube thumbnail URL for embed links', () {
      final thumbnailUrl = VideoService.getThumbnailUrl(
        'https://www.youtube.com/embed/ABC123',
      );
      expect(
        thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/maxresdefault.jpg',
      );
    });

    test('returns correct Dailymotion thumbnail URL', () {
      final thumbnailUrl = VideoService.getThumbnailUrl(
        'https://www.dailymotion.com/video/x7tgad2',
      );
      expect(
        thumbnailUrl,
        'https://www.dailymotion.com/thumbnail/video/x7tgad2',
      );
    });

    test('returns null for Vimeo URLs', () {
      final thumbnailUrl = VideoService.getThumbnailUrl(
        'https://vimeo.com/123456',
      );
      expect(thumbnailUrl, null);
    });

    test('returns null for non-video URLs', () {
      final thumbnailUrl = VideoService.getThumbnailUrl(
        'https://example.com/page',
      );
      expect(thumbnailUrl, null);
    });
  });
}
