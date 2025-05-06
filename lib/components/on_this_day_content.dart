import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/today_controller.dart';
import '../components/on_this_day_cards.dart';
import '../utils/app_theme.dart';

class OnThisDayContent extends StatelessWidget {
  final bool isIOS;
  final TodayController controller;

  const OnThisDayContent({
    Key? key,
    required this.isIOS,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child:
              isIOS
                  ? const CupertinoActivityIndicator()
                  : CircularProgressIndicator(color: AppTheme.primaryColor),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.errorMessage.value}',
                style: TextStyle(color: AppTheme.errorColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              isIOS
                  ? CupertinoButton(
                    child: const Text('Retry'),
                    onPressed: controller.refreshEvents,
                    color: AppTheme.iosPrimaryColor,
                  )
                  : ElevatedButton(
                    onPressed: controller.refreshEvents,
                    child: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
            ],
          ),
        );
      }

      if (controller.historicalEvents.isEmpty) {
        return Center(
          child: Text(
            'No historical events found for today',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor),
          ),
        );
      }

      final currentDate =
          controller.timestamp.value > 0
              ? DateTime.fromMillisecondsSinceEpoch(
                controller.timestamp.value * 1000,
              )
              : DateTime.now();
      final dateFormatter = DateFormat('MMMM d');
      final formattedDate = dateFormatter.format(currentDate);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Historical Events on $formattedDate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isIOS ? AppTheme.iosPrimaryColor : AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: OnThisDayCards(
              events: controller.historicalEvents,
              onRefresh: controller.refreshEvents,
            ),
          ),
        ],
      );
    });
  }
}
