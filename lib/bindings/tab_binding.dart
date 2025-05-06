import 'package:get/get.dart';
import 'package:anewsment/controllers/tab_controller.dart';

class TabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabViewController>(() => TabViewController());
  }
}
