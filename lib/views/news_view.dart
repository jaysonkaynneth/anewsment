import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:anewsment/controllers/news_controller.dart';
import 'package:anewsment/routes/app_routes.dart';
import 'package:anewsment/utils/ui_helpers.dart';
import 'package:anewsment/utils/app_theme.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoNewsView(context)
        : _buildMaterialNewsView(context);
  }

  Widget _buildCupertinoNewsView(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final adjustedTextSize = deviceSize.width < 350 ? 12.0 : 14.0;
    final emojiSize = deviceSize.width < 350 ? 28.0 : 32.0;

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('News Categories'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.refresh),
            onPressed: controller.fetchCategories,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (controller.error.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Material(
                      color: Colors.transparent,
                      child: Text(
                        'Error loading categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          controller.error.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: controller.fetchCategories,
                      child: const Text('Retry'),
                      color: AppTheme.iosPrimaryColor,
                    ),
                  ],
                ),
              );
            }

            final displayCategories =
                controller.categories
                    .where(
                      (category) => category.name.toLowerCase() != 'onthisday',
                    )
                    .toList();

            if (displayCategories.isEmpty) {
              return const Center(
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'No categories available',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deviceSize.width > 600 ? 3 : 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: displayCategories.length,
                itemBuilder: (context, index) {
                  final category = displayCategories[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.ARTICLES,
                        arguments: {
                          'categoryName': category.name,
                          'fileName': category.file,
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryLightColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            UIHelpers.getCategoryEmoji(category.name),
                            style: TextStyle(fontSize: emojiSize),
                          ),
                          const SizedBox(height: 4),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: adjustedTextSize,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMaterialNewsView(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final adjustedTextSize = deviceSize.width < 350 ? 12.0 : 14.0;
    final emojiSize = deviceSize.width < 350 ? 24.0 : 28.0;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News Categories'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.fetchCategories,
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
                    'Error loading categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      controller.error.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final displayCategories =
              controller.categories
                  .where(
                    (category) => category.name.toLowerCase() != 'onthisday',
                  )
                  .toList();

          if (displayCategories.isEmpty) {
            return Center(
              child: Text(
                'No categories available',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: deviceSize.width > 600 ? 3 : 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: displayCategories.length,
              itemBuilder: (context, index) {
                final category = displayCategories[index];
                return Card(
                  elevation: 2,
                  shadowColor: AppTheme.primaryLightColor,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        Routes.ARTICLES,
                        arguments: {
                          'categoryName': category.name,
                          'fileName': category.file,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            UIHelpers.getCategoryEmoji(category.name),
                            style: TextStyle(fontSize: emojiSize),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: adjustedTextSize,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
