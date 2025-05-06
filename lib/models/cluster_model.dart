import 'package:anewsment/models/article_model.dart';
import 'package:anewsment/utils/text_cleaner.dart';

class ClusterModel {
  final int clusterNumber;
  final int uniqueDomains;
  final int numberOfTitles;
  final String category;
  final String title;
  final String shortSummary;
  final String didYouKnow;
  final List<String> talkingPoints;
  final String quote;
  final String quoteAuthor;
  final String quoteSourceUrl;
  final String emoji;
  final List<ArticleModel> articles;

  ClusterModel({
    required this.clusterNumber,
    required this.uniqueDomains,
    required this.numberOfTitles,
    required this.category,
    required this.title,
    required this.shortSummary,
    required this.didYouKnow,
    required this.talkingPoints,
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSourceUrl,
    required this.emoji,
    required this.articles,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> articlesJson = json['articles'] as List<dynamic>? ?? [];
    List<ArticleModel> articlesList =
        articlesJson
            .map((articleJson) => ArticleModel.fromJson(articleJson))
            .toList();

    List<dynamic> talkingPointsJson =
        json['talking_points'] as List<dynamic>? ?? [];
    List<String> talkingPointsList =
        talkingPointsJson
            .map((point) => TextCleaner.clean(point as String?))
            .toList();

    return ClusterModel(
      clusterNumber: json['cluster_number'] as int? ?? 0,
      uniqueDomains: json['unique_domains'] as int? ?? 0,
      numberOfTitles: json['number_of_titles'] as int? ?? 0,
      category: TextCleaner.clean(json['category'] as String?),
      title: TextCleaner.clean(json['title'] as String?),
      shortSummary: TextCleaner.clean(json['short_summary'] as String?),
      didYouKnow: TextCleaner.clean(json['did_you_know'] as String?),
      talkingPoints: talkingPointsList,
      quote: TextCleaner.clean(json['quote'] as String?),
      quoteAuthor: TextCleaner.clean(json['quote_author'] as String?),
      quoteSourceUrl: TextCleaner.clean(json['quote_source_url'] as String?),
      emoji: TextCleaner.clean(json['emoji'] as String?),
      articles: articlesList,
    );
  }
}
