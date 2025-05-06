import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anewsment/utils/ui_helpers.dart';

void main() {
  group('UIHelpers - getCategoryEmoji', () {
    test('returns correct emoji for countries', () {
      expect(UIHelpers.getCategoryEmoji('USA'), '🇺🇸');
      expect(UIHelpers.getCategoryEmoji('UK'), '🇬🇧');
      expect(UIHelpers.getCategoryEmoji('Japan'), '🇯🇵');
      expect(UIHelpers.getCategoryEmoji('France'), '🇫🇷');
    });

    test('returns correct emoji for categories', () {
      expect(UIHelpers.getCategoryEmoji('Business'), '💼');
      expect(UIHelpers.getCategoryEmoji('Technology'), '💻');
      expect(UIHelpers.getCategoryEmoji('Science'), '🔬');
      expect(UIHelpers.getCategoryEmoji('Sports'), '⚽');
    });

    test('is case insensitive', () {
      expect(UIHelpers.getCategoryEmoji('usa'), '🇺🇸');
      expect(UIHelpers.getCategoryEmoji('BUSINESS'), '💼');
      expect(UIHelpers.getCategoryEmoji('Technology'), '💻');
      expect(UIHelpers.getCategoryEmoji('SPORTS'), '⚽');
    });

    test('returns default emoji for unknown categories', () {
      expect(UIHelpers.getCategoryEmoji('Unknown'), '📰');
      expect(UIHelpers.getCategoryEmoji('Random'), '📰');
    });
  });

  testWidgets(
    'UIHelpers - getEventCategoryIcon returns correct icon for people',
    (WidgetTester tester) async {
      // Build our widget with the icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return UIHelpers.getEventCategoryIcon('people', false);
              },
            ),
          ),
        ),
      );

      // Verify that the correct icon is displayed for Material
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Now test Cupertino icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return UIHelpers.getEventCategoryIcon('people', true);
              },
            ),
          ),
        ),
      );

      // Verify that the correct icon is displayed for Cupertino
      expect(find.byIcon(CupertinoIcons.person_fill), findsOneWidget);
    },
  );

  testWidgets(
    'UIHelpers - getEventCategoryIcon returns correct icon for event',
    (WidgetTester tester) async {
      // Build our widget with the icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return UIHelpers.getEventCategoryIcon('event', false);
              },
            ),
          ),
        ),
      );

      // Verify that the correct icon is displayed for Material
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Now test Cupertino icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return UIHelpers.getEventCategoryIcon('event', true);
              },
            ),
          ),
        ),
      );

      // Verify that the correct icon is displayed for Cupertino
      expect(find.byIcon(CupertinoIcons.star_fill), findsOneWidget);
    },
  );

  group('UIHelpers - getEventTypeLabel', () {
    test('returns correct label for each type', () {
      expect(UIHelpers.getEventTypeLabel('people'), 'Historical Figure');
      expect(UIHelpers.getEventTypeLabel('event'), 'Historical Event');
      expect(UIHelpers.getEventTypeLabel('other'), 'On This Day in History');
    });
  });
}
