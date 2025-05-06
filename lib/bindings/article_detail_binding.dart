import 'package:get/get.dart';
import 'package:anewsment/controllers/article_detail_controller.dart';

class ArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleDetailController>(() => ArticleDetailController());
  }
}
