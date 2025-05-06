import 'package:get/get.dart';
import 'package:anewsment/bindings/tab_binding.dart';
import 'package:anewsment/bindings/news_binding.dart';
import 'package:anewsment/bindings/articles_binding.dart';
import 'package:anewsment/bindings/article_detail_binding.dart';
import 'package:anewsment/views/tab_view.dart';
import 'package:anewsment/views/articles_view.dart';
import 'package:anewsment/views/article_detail_view.dart';
import 'package:anewsment/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.TABS,
      page: () => const TabView(),
      binding: TabBinding(),
      bindings: [NewsBinding()],
    ),
    GetPage(
      name: Routes.ARTICLES,
      page: () => const ArticlesView(),
      binding: ArticlesBinding(),
    ),
    GetPage(
      name: Routes.ARTICLE_DETAIL,
      page: () => const ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
  ];
}
