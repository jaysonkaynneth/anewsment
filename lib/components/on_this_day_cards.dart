import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:anewsment/models/historical_event_model.dart';
import 'package:anewsment/controllers/today_controller.dart';
import 'package:anewsment/utils/ui_helpers.dart';

class OnThisDayCards extends StatefulWidget {
  final List<HistoricalEvent> events;
  final Function onRefresh;

  const OnThisDayCards({
    Key? key,
    required this.events,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<OnThisDayCards> createState() => _OnThisDayCardsState();
}

class _OnThisDayCardsState extends State<OnThisDayCards> {
  late PageController _pageController;
  int _currentPage = 0;
  late TodayController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _controller = Get.find<TodayController>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    final deviceSize = MediaQuery.of(context).size;
    final cardHeight = deviceSize.height * (isIOS ? 0.55 : 0.60);

    if (widget.events.isEmpty) {
      return const Center(child: Text('No historical events found for today'));
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      edgeOffset: 80,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Event ${_currentPage + 1} of ${widget.events.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        isIOS ? CupertinoColors.systemGrey : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: cardHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.events.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return _buildEventCard(event, cardHeight, isIOS);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.events.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? (isIOS ? CupertinoColors.activeBlue : Colors.blue)
                            : (isIOS
                                ? CupertinoColors.systemGrey4
                                : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildEventCard(HistoricalEvent event, double cardHeight, bool isIOS) {
    final displayTitle = event.title
        .replaceAll('Â', '')
        .replaceAll(' mph; ', ' mph; ')
        .replaceAll(' km/h) ', ' km/h) ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isIOS ? CupertinoColors.systemBlue : Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.year,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  UIHelpers.getEventCategoryIcon(event.type, isIOS),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color:
                                isIOS ? CupertinoColors.label : Colors.black87,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                        ),
                        const SizedBox(height: 24),

                        if (event.linkUrl != null)
                          isIOS
                              ? CupertinoButton(
                                onPressed:
                                    () => _controller.launchEventUrl(
                                      event.linkUrl,
                                    ),
                                color: CupertinoColors.systemBlue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: const Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : ElevatedButton.icon(
                                onPressed:
                                    () => _controller.launchEventUrl(
                                      event.linkUrl,
                                    ),
                                icon: const Icon(Icons.launch, size: 18),
                                label: const Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isIOS ? CupertinoColors.systemGrey6 : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                UIHelpers.getEventTypeLabel(event.type),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isIOS ? CupertinoColors.systemGrey : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
