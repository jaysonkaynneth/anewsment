import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anewsment/routes/app_pages.dart';
import 'package:anewsment/routes/app_routes.dart';
import 'package:anewsment/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'aNewsment',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.TABS,
      getPages: AppPages.routes,
    );
  }
}
