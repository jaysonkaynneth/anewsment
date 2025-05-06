import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import '../models/historical_event_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TodayController extends GetxController {
  static TodayController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxList<HistoricalEvent> historicalEvents = <HistoricalEvent>[].obs;
  final RxString errorMessage = ''.obs;
  final RxInt timestamp = 0.obs;
  final Rx<DateTime> displayDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnThisDayEvents();
  }

  Future<void> fetchOnThisDayEvents() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse('https://kite.kagi.com/onthisday.json'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('timestamp')) {
          timestamp.value = data['timestamp'] as int;

          // Convert API timestamp to DateTime
          final apiDate = DateTime.fromMillisecondsSinceEpoch(
            timestamp.value * 1000,
          );
          final now = DateTime.now();

          // Only use API date if it's the same day or newer than today
          // Otherwise use current device date
          if (apiDate.day == now.day &&
              apiDate.month == now.month &&
              apiDate.year == now.year) {
            displayDate.value = apiDate;
          } else {
            displayDate.value = now;
          }
        } else {
          displayDate.value = DateTime.now();
        }

        if (data.containsKey('events') && data['events'] is List) {
          final List<dynamic> eventsList = data['events'];
          final List<HistoricalEvent> processedEvents = [];

          for (final event in eventsList) {
            final String content = event['content'] ?? '';

            final document = html_parser.parse(content);
            String processedContent = content;
            String? linkUrl;
            String personName = '';
            String description = '';
            String fullTitle = '';

            processedContent = _cleanHtmlContent(content);

            final aElements = document.getElementsByTagName('a');
            if (aElements.isNotEmpty) {
              final aElement = aElements.first;
              linkUrl = aElement.attributes['href'];
              personName = _cleanHtmlContent(aElement.text);
            }

            final parenthesesMatch = RegExp(
              r'\((.*?)\)',
            ).firstMatch(processedContent);
            if (parenthesesMatch != null && parenthesesMatch.group(1) != null) {
              description = parenthesesMatch.group(1)!;
            }

            if (personName.isNotEmpty) {
              if (description.isNotEmpty) {
                fullTitle = '$personName ($description)';
              } else {
                fullTitle = personName;
              }

              if (processedContent.contains(')')) {
                final afterParentheses =
                    processedContent.split(')').last.trim();
                if (afterParentheses.isNotEmpty) {
                  fullTitle += ' $afterParentheses';
                }
              }
            } else {
              fullTitle = processedContent;
            }

            processedEvents.add(
              HistoricalEvent(
                year: event['year'] ?? '',
                content: processedContent,
                type: event['type'] ?? '',
                sortYear:
                    event['sort_year'] is num
                        ? (event['sort_year'] as num).toDouble()
                        : null,
                linkUrl: linkUrl,
                title: fullTitle,
              ),
            );
          }

          historicalEvents.value = processedEvents;
        } else {
          errorMessage.value = 'Invalid data format from API';
        }
      } else {
        errorMessage.value = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String _cleanHtmlContent(String content) {
    String cleaned = content.replaceAll(RegExp(r'<[^>]*>'), '');

    cleaned = cleaned
        .replaceAll('Â', '')
        .replaceAll('â€™', "'")
        .replaceAll('â€œ', '"')
        .replaceAll('â€', '"')
        .replaceAll('â€"', '—')
        .replaceAll('â€"', '–')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }

  Future<void> launchEventUrl(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open $url',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void refreshEvents() {
    fetchOnThisDayEvents();
  }
}
