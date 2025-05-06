import 'package:get/get.dart';
import 'package:anewsment/models/category_news_model.dart';
import 'package:anewsment/models/cluster_model.dart';
import 'package:anewsment/services/news_service.dart';

class ArticlesController extends GetxController {
  final NewsService _newsService = NewsService();
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  final Rx<CategoryNewsModel?> categoryNews = Rx<CategoryNewsModel?>(null);
  final RxString categoryName = ''.obs;
  final RxString fileName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryName.value = Get.arguments['categoryName'] ?? '';
      fileName.value = Get.arguments['fileName'] ?? '';
      fetchCategoryNews();
    }
  }

  Future<void> fetchCategoryNews() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (fileName.value.isNotEmpty) {
        final result = await _newsService.getCategoryNews(fileName.value);
        categoryNews.value = result;
      } else {
        throw Exception('No file name provided');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<ClusterModel> get clusters => categoryNews.value?.clusters ?? [];
}
