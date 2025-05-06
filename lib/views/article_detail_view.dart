import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anewsment/controllers/article_detail_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:anewsment/widgets/video_player_widget.dart';
import 'package:anewsment/utils/app_theme.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({Key? key}) : super(key: key);

  IconData get _shareIcon {
    return Platform.isIOS ? CupertinoIcons.share : Icons.share_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Article Details'),
          actions: [
            IconButton(
              icon: Icon(_shareIcon),
              tooltip: 'Share Article',
              onPressed: controller.shareArticle,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.article.value == null) {
            return Center(
              child: Text(
                'Article not found',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            );
          }

          final article = controller.article.value!;
          DateTime? publishDate;
          try {
            publishDate = DateTime.parse(article.date);
          } catch (_) {}

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.hasVideo() && !controller.hasImage())
                  VideoPlayerWidget(
                    videoUrl: controller.getVideoUrl(),
                    onPlayPressed: controller.launchVideoUrl,
                  )
                else if (controller.hasImage())
                  Container(
                    width: double.infinity,
                    height: deviceSize.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(article.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.imageCaption.isNotEmpty &&
                          controller.hasImage())
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundDarkColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            article.imageCaption,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.public,
                                size: 14,
                                color: AppTheme.textLightColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  article.domain,
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (publishDate != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: AppTheme.textLightColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'MMMM d, yyyy',
                                  ).format(publishDate),
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      if (controller.hasVideo() && controller.hasImage()) ...[
                        SizedBox(height: Platform.isIOS ? 16 : 12),
                        VideoPlayerWidget(
                          videoUrl: controller.getVideoUrl(),
                          onPlayPressed: controller.launchVideoUrl,
                        ),
                      ],

                      SizedBox(height: Platform.isIOS ? 20 : 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.launchArticleUrl,
                          icon: const Icon(Icons.article, size: 16),
                          label: const Text(
                            'Read Full Article',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
