import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/todays_news_controller.dart';
import '../components/feature_article_item.dart';
import '../utils/app_theme.dart';

class TodayNewsContent extends StatelessWidget {
  final bool isIOS;
  final TodaysNewsController controller;

  const TodayNewsContent({
    Key? key,
    required this.isIOS,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child:
              isIOS
                  ? const CupertinoActivityIndicator()
                  : CircularProgressIndicator(color: AppTheme.primaryColor),
        );
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.error.value}',
                style: TextStyle(color: AppTheme.errorColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              isIOS
                  ? CupertinoButton(
                    child: const Text('Retry'),
                    onPressed: controller.refreshTodaysNews,
                    color: AppTheme.iosPrimaryColor,
                  )
                  : ElevatedButton(
                    onPressed: controller.refreshTodaysNews,
                    child: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
            ],
          ),
        );
      }

      if (controller.featuredArticles.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No featured articles available',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              isIOS
                  ? CupertinoButton(
                    child: const Text('Refresh'),
                    onPressed: controller.refreshTodaysNews,
                    color: AppTheme.iosPrimaryColor,
                  )
                  : ElevatedButton(
                    onPressed: controller.refreshTodaysNews,
                    child: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
            ],
          ),
        );
      }

      final now = DateTime.now().subtract(const Duration(days: 1));
      final dateFormatter = DateFormat('EEEE, MMMM d');
      final formattedDate = dateFormatter.format(now);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isIOS ? AppTheme.iosPrimaryColor : AppTheme.primaryColor,
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchTodaysNews(),
              color: AppTheme.primaryColor,
              child: ListView.builder(
                itemCount: controller.featuredArticles.length,
                itemBuilder: (context, index) {
                  final featuredItem = controller.featuredArticles[index];
                  return FeaturedArticleItem(
                    article: featuredItem['article'],
                    category: featuredItem['category'],
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
