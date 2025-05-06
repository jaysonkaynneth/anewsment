import 'package:get/get.dart';
import 'package:anewsment/models/category_model.dart';
import 'package:anewsment/services/news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _newsService.getCategories();

      final filteredCategories =
          result
              .where((category) => category.name.toLowerCase() != 'onthisday')
              .toList();

      categories.assignAll(filteredCategories);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
