import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anewsment/models/cluster_model.dart';
import 'package:anewsment/widgets/section_title.dart';
import 'package:anewsment/widgets/article_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anewsment/utils/app_theme.dart';

class ClusterCard extends StatelessWidget {
  final ClusterModel cluster;

  const ClusterCard({Key? key, required this.cluster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpanded = false.obs;

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shadowColor: AppTheme.primaryLightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              'Cluster ${cluster.clusterNumber}: ${cluster.title}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cluster.shortSummary,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                if (cluster.didYouKnow.isNotEmpty) ...[
                  SectionTitle(title: 'Did You Know'),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      border: Border.all(
                        color: AppTheme.warningColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      cluster.didYouKnow,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (cluster.talkingPoints.isNotEmpty) ...[
                  SectionTitle(title: 'Key Points'),
                  ...cluster.talkingPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (cluster.quote.isNotEmpty) ...[
                  SectionTitle(title: 'Quote'),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${cluster.quote}"',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        if (cluster.quoteAuthor.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '- ${cluster.quoteAuthor}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                        if (cluster.quoteSourceUrl.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed:
                                  () => _launchUrl(cluster.quoteSourceUrl),
                              icon: Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: AppTheme.primaryColor,
                              ),
                              label: Text(
                                'See More',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                InkWell(
                  onTap: () => isExpanded.toggle(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDarkColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Articles (${cluster.articles.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => Icon(
                            isExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Obx(() {
                  if (!isExpanded.value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      ...cluster.articles.map(
                        (article) => ArticleItem(article: article),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
