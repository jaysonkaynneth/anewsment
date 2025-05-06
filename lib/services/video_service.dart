import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class VideoService {
  final http.Client client;

  VideoService({http.Client? client}) : this.client = client ?? http.Client();

  static String _getErrorMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'You are not authorized to access this.';
      case 403:
        return 'You do not have permission to access this.';
      case 404:
        return 'Page not found.';
      case 429:
        return 'Too many requests, please try again later.';
      case 500:
        return 'Internal server error, try again later.';
      case 502:
        return 'Bad gateway, The server is down.';
      case 503:
        return 'Service is not available. ';
      case 504:
        return 'The server timed out.';
      default:
        return 'Error with status code $statusCode';
    }
  }

  Future<String?> getVideoUrl(String articleUrl) async {
    try {
      final response = await client
          .get(Uri.parse(articleUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final htmlContent = response.body;

        if (htmlContent.isEmpty) {
          return articleUrl;
        }

        final youtubeEmbedRegex = RegExp(
          r'youtube.com\/embed\/([a-zA-Z0-9_-]+)',
        );
        final youtubeEmbedMatch = youtubeEmbedRegex.firstMatch(htmlContent);

        if (youtubeEmbedMatch != null && youtubeEmbedMatch.groupCount >= 1) {
          final videoId = youtubeEmbedMatch.group(1);
          return 'https://www.youtube.com/watch?v=$videoId';
        }

        final youtubeWatchRegex = RegExp(
          r'youtube.com\/watch\?v=([a-zA-Z0-9_-]+)',
        );
        final youtubeWatchMatch = youtubeWatchRegex.firstMatch(htmlContent);

        if (youtubeWatchMatch != null && youtubeWatchMatch.groupCount >= 1) {
          final videoId = youtubeWatchMatch.group(1);
          return 'https://www.youtube.com/watch?v=$videoId';
        }

        final vimeoRegex = RegExp(r'vimeo.com\/(\d+)');
        final vimeoMatch = vimeoRegex.firstMatch(htmlContent);

        if (vimeoMatch != null && vimeoMatch.groupCount >= 1) {
          final videoId = vimeoMatch.group(1);
          return 'https://vimeo.com/$videoId';
        }

        final dailymotionRegex = RegExp(
          r'dailymotion.com\/video\/([a-zA-Z0-9]+)',
        );
        final dailymotionMatch = dailymotionRegex.firstMatch(htmlContent);

        if (dailymotionMatch != null && dailymotionMatch.groupCount >= 1) {
          final videoId = dailymotionMatch.group(1);
          return 'https://www.dailymotion.com/video/$videoId';
        }

        return articleUrl;
      } else {
        print(
          'Error extracting video URL: ${_getErrorMessageForStatusCode(response.statusCode)}',
        );
        return articleUrl;
      }
    } on SocketException catch (e) {
      print('Network error extracting video URL: ${e.message}');
      return articleUrl;
    } on TimeoutException catch (e) {
      print('Timeout error extracting video URL: ${e.message}');
      return articleUrl;
    } catch (e) {
      print('Error extracting video URL: $e');
      return articleUrl;
    }
  }

  static bool isVideoUrl(String url) {
    return url.contains('youtube.com/watch') ||
        url.contains('youtube.com/embed') ||
        url.contains('vimeo.com') ||
        url.contains('dailymotion.com/video');
  }

  static String? getThumbnailUrl(String videoUrl) {
    try {
      if (videoUrl.contains('youtube.com')) {
        final videoId = RegExp(
          r'(?:v=|embed\/)([a-zA-Z0-9_-]+)',
        ).firstMatch(videoUrl)?.group(1);
        if (videoId != null) {
          return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
        }
      } else if (videoUrl.contains('vimeo.com')) {
        return null;
      } else if (videoUrl.contains('dailymotion.com')) {
        final videoId = RegExp(
          r'video\/([a-zA-Z0-9]+)',
        ).firstMatch(videoUrl)?.group(1);
        if (videoId != null) {
          return 'https://www.dailymotion.com/thumbnail/video/$videoId';
        }
      }
      return null;
    } catch (e) {
      print('Error getting thumbnail URL: $e');
      return null;
    }
  }
}
