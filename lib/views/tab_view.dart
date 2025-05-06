import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:anewsment/controllers/tab_controller.dart';
import 'package:anewsment/views/today_view.dart';
import 'package:anewsment/views/news_view.dart';
import 'package:anewsment/utils/app_theme.dart';

class TabView extends GetView<TabViewController> {
  const TabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoTabView()
        : _buildMaterialTabView(context);
  }

  Widget _buildCupertinoTabView() {
    return Obx(
      () => CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          activeColor: AppTheme.iosPrimaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.today),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news),
              label: 'News',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) => const TodayView());
            case 1:
              return CupertinoTabView(builder: (context) => const NewsView());
            default:
              return CupertinoTabView(builder: (context) => const TodayView());
          }
        },
      ),
    );
  }

  Widget _buildMaterialTabView(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [const TodayView(), const NewsView()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textLightColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          ],
        ),
      ),
    );
  }
}
