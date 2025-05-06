import 'package:get/get.dart';
import 'package:anewsment/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:anewsment/services/video_service.dart';

class ArticleDetailController extends GetxController {
  final Rx<ArticleModel?> article = Rx<ArticleModel?>(null);
  final RxString processedVideoUrl = ''.obs;
  final VideoService videoService = VideoService();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['article'] != null) {
      article.value = Get.arguments['article'] as ArticleModel;
      _processVideoUrl();
    }
  }

  Future<void> _processVideoUrl() async {
    if (article.value != null) {
      if (article.value!.videoUrl.isNotEmpty) {
        processedVideoUrl.value = article.value!.videoUrl;
      } else if (article.value!.link.isNotEmpty) {
        final extractedUrl = await videoService.getVideoUrl(
          article.value!.link,
        );
        if (extractedUrl != null) {
          processedVideoUrl.value = extractedUrl;
        }
      }
    }
  }

  Future<void> launchArticleUrl() async {
    if (article.value != null && article.value!.link.isNotEmpty) {
      final Uri url = Uri.parse(article.value!.link);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future<void> shareArticle() async {
    if (article.value != null) {
      final articleToShare = article.value!;
      final String title = articleToShare.title;
      final String url = articleToShare.link;

      await Share.share('$title\n\n$url', subject: title);
    }
  }

  bool hasVideo() {
    return article.value != null &&
        (article.value!.videoUrl.isNotEmpty ||
            processedVideoUrl.value.isNotEmpty);
  }

  String getVideoUrl() {
    if (processedVideoUrl.value.isNotEmpty) {
      return processedVideoUrl.value;
    }
    return article.value?.videoUrl ?? '';
  }

  bool hasImage() {
    return article.value != null && article.value!.image.isNotEmpty;
  }

  Future<void> launchVideoUrl() async {
    if (hasVideo()) {
      final Uri url = Uri.parse(getVideoUrl());
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch video: $url');
      }
    }
  }

  bool hasDomain() {
    return article.value != null && article.value!.domain.isNotEmpty;
  }
}
