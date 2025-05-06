import 'package:get/get.dart';
import 'package:anewsment/services/news_service.dart';

class TodaysNewsController extends GetxController {
  static TodaysNewsController get to => Get.find();

  final NewsService _newsService = NewsService();
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> featuredArticles =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaysNews();
  }

  Future<void> fetchTodaysNews() async {
    try {
      isLoading.value = true;
      error.value = '';
      featuredArticles.clear();

      final categories = await _newsService.getCategories();

      final selectedCategories =
          categories
              .where((category) => category.name.toLowerCase() != 'onthisday')
              .take(10)
              .toList();

      for (final category in selectedCategories) {
        try {
          final categoryNews = await _newsService.getCategoryNews(
            category.file,
          );

          if (categoryNews.clusters.isNotEmpty &&
              categoryNews.clusters.first.articles.isNotEmpty) {
            featuredArticles.add({
              'category': category,
              'article': categoryNews.clusters.first.articles.first,
            });
          }
        } catch (e) {
          print('Error fetching articles for ${category.name}: $e');
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshTodaysNews() {
    fetchTodaysNews();
  }
}
