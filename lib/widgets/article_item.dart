import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anewsment/models/article_model.dart';
import 'package:anewsment/routes/app_routes.dart';
import 'package:anewsment/utils/app_theme.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel article;

  const ArticleItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1.0,
      shadowColor: AppTheme.primaryLightColor,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.ARTICLE_DETAIL, arguments: {'article': article});
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    article.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (ctx, err, _) => Container(
                          width: 60,
                          height: 60,
                          color: AppTheme.backgroundDarkColor,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 24,
                            color: AppTheme.textLightColor,
                          ),
                        ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 12,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            article.domain,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
