import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anewsment/models/category_model.dart';
import 'package:anewsment/models/category_news_model.dart';

class NewsService {
  static const String baseUrl = 'https://kite.kagi.com';
  final http.Client client;

  NewsService({http.Client? client}) : this.client = client ?? http.Client();

  String _getErrorMessageForStatusCode(int statusCode) {
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

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/kite.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (!data.containsKey('categories') || data['categories'] == null) {
          throw Exception('Invalid data format: categories field is missing');
        }

        final List<dynamic> categoriesJson =
            data['categories'] as List<dynamic>;

        return categoriesJson
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        final errorMessage = _getErrorMessageForStatusCode(response.statusCode);
        throw Exception('Failed to load categories: $errorMessage');
      }
    } on FormatException catch (_) {
      throw Exception('Invalid response format');
    } catch (e) {
      if (e is Exception &&
          e.toString().contains('Failed to load categories')) {
        rethrow;
      }
      throw Exception(
        'Error occurred when fetching categories: ${e.toString().split('\n')[0]}',
      );
    }
  }

  Future<CategoryNewsModel> getCategoryNews(String file) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$file'));

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          return CategoryNewsModel.fromJson(data);
        } on FormatException catch (_) {
          throw Exception(
            'Invalid response format. Cannot parse category news data.',
          );
        }
      } else {
        final errorMessage = _getErrorMessageForStatusCode(response.statusCode);
        throw Exception('Failed to load news: $errorMessage');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to load news')) {
        rethrow;
      }
      throw Exception('Error fetching news: ${e.toString().split('\n')[0]}');
    }
  }
}
