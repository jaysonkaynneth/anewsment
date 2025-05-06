// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:anewsment/main.dart';
import 'package:anewsment/controllers/tab_controller.dart';

void main() {
  testWidgets('App should render correctly and show tab navigation', (
    WidgetTester tester,
  ) async {
    // Build app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that we start on the Today tab
    expect(find.text('Today'), findsWidgets);

    // Check that the bottom navigation has both required tabs
    expect(find.byIcon(Icons.newspaper), findsOneWidget);
  });

  testWidgets('Navigation between tabs should work', (
    WidgetTester tester,
  ) async {
    // Mock initial bindings
    Get.testMode = true;
    Get.put(TabViewController());

    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap on the News tab
    await tester.tap(find.byIcon(Icons.newspaper));
    await tester.pumpAndSettle();

    // Verify that we navigated to the News tab
    expect(find.text('News Categories'), findsOneWidget);

    // Tap on the Today tab
    await tester.tap(find.byIcon(Icons.today));
    await tester.pumpAndSettle();

    // Verify that we navigated back to the Today tab
    expect(find.text('Today'), findsWidgets);
  });

  // For testing actual navigation logic with mocked controllers
  testWidgets('TabViewController should change tabs properly', (
    WidgetTester tester,
  ) async {
    // Create a test controller
    final controller = TabViewController();

    // Create a simpler test app with just the controller functionality
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Obx(
            () => Text('Current tab: ${controller.selectedIndex.value}'),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTabIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'News',
              ),
            ],
          ),
        ),
      ),
    );

    // check initial state
    expect(find.text('Current tab: 0'), findsOneWidget);

    // Tap the News tab (index 1)
    await tester.tap(find.byIcon(Icons.newspaper));
    await tester.pump();

    // Check that the controller updated the index
    expect(find.text('Current tab: 1'), findsOneWidget);

    // Tap the Today tab (index 0)
    await tester.tap(find.byIcon(Icons.today));
    await tester.pump();

    // Check that the controller updated the index back
    expect(find.text('Current tab: 0'), findsOneWidget);
  });
}
