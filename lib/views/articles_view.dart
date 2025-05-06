import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anewsment/controllers/articles_controller.dart';
import 'package:anewsment/widgets/cluster_card.dart';
import 'package:anewsment/utils/app_theme.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.categoryName.value)),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.fetchCategoryNews,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (controller.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading news',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      controller.error.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchCategoryNews,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.clusters.isEmpty) {
            return Center(
              child: Text(
                'No news available',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.clusters.length,
            itemBuilder: (context, index) {
              final cluster = controller.clusters[index];
              return ClusterCard(cluster: cluster);
            },
          );
        }),
      ),
    );
  }
}
