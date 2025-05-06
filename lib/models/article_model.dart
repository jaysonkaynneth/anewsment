import 'package:anewsment/utils/text_cleaner.dart';

class ArticleModel {
  final String title;
  final String link;
  final String domain;
  final String date;
  final String image;
  final String imageCaption;
  final String videoUrl;

  ArticleModel({
    required this.title,
    required this.link,
    required this.domain,
    required this.date,
    required this.image,
    required this.imageCaption,
    required this.videoUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: TextCleaner.clean(json['title'] as String?),
      link: TextCleaner.clean(json['link'] as String?),
      domain: TextCleaner.clean(json['domain'] as String?),
      date: TextCleaner.clean(json['date'] as String?),
      image: TextCleaner.clean(json['image'] as String?),
      imageCaption: TextCleaner.clean(json['image_caption'] as String?),
      videoUrl: TextCleaner.clean(json['video_url'] as String?),
    );
  }
}
