import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import '../controllers/today_controller.dart';
import '../controllers/todays_news_controller.dart';
import '../components/today_news_content.dart';
import '../components/on_this_day_content.dart';

class TodayView extends StatefulWidget {
  const TodayView({Key? key}) : super(key: key);

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  Set<String> _selectedSegment = {'today'};
  late TodayController _onThisDayController;
  late TodaysNewsController _todaysNewsController;

  @override
  void initState() {
    super.initState();
    _onThisDayController = Get.put(TodayController());
    _todaysNewsController = Get.put(TodaysNewsController());
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoTodayView(context)
        : _buildMaterialTodayView(context);
  }

  Widget _buildCupertinoTodayView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Today')),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoSegmentedControl<String>(
                    children: {
                      'today': Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.news, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "Today's News",
                              style: TextStyle(fontSize: 13),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      'onthisday': Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.calendar, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "On This Day",
                              style: TextStyle(fontSize: 13),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    },
                    groupValue: _selectedSegment.first,
                    onValueChanged: (String value) {
                      setState(() {
                        _selectedSegment = {value};
                      });
                    },
                  ),
                ),
              ),

              Expanded(
                child:
                    _selectedSegment.first == 'today'
                        ? TodayNewsContent(
                          isIOS: true,
                          controller: _todaysNewsController,
                        )
                        : OnThisDayContent(
                          isIOS: true,
                          controller: _onThisDayController,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialTodayView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Material(
      child: Scaffold(
        appBar: AppBar(title: const Text('Today')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment<String>(
                    value: 'today',
                    label: Text(
                      "Today's News",
                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: Icon(Icons.newspaper, size: isSmallScreen ? 16 : 18),
                  ),
                  ButtonSegment<String>(
                    value: 'onthisday',
                    label: Text(
                      "On This Day",
                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: Icon(Icons.history, size: isSmallScreen ? 16 : 18),
                  ),
                ],
                selected: _selectedSegment,
                onSelectionChanged: (Set<String> selection) {
                  setState(() {
                    _selectedSegment = selection;
                  });
                },
              ),
            ),

            Expanded(
              child:
                  _selectedSegment.first == 'today'
                      ? TodayNewsContent(
                        isIOS: false,
                        controller: _todaysNewsController,
                      )
                      : OnThisDayContent(
                        isIOS: false,
                        controller: _onThisDayController,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
