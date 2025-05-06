import 'package:flutter/material.dart';
import 'package:anewsment/utils/app_theme.dart';
import 'dart:io' show Platform;

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;
  final Function onPlayPressed;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.onPlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final containerHeight =
        Platform.isIOS ? deviceSize.height * 0.22 : deviceSize.height * 0.205;

    return Container(
      width: double.infinity,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: containerHeight),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics:
                    Platform.isAndroid
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Platform.isAndroid ? 4.0 : 8.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size:
                            deviceSize.width * (Platform.isIOS ? 0.12 : 0.105),
                      ),
                      SizedBox(height: Platform.isIOS ? 6 : 3),
                      const Text(
                        'Video Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Platform.isIOS ? 4 : 1),
                      ElevatedButton(
                        onPressed: () => onPlayPressed(),
                        child: Text(
                          'Watch Video',
                          style: TextStyle(fontSize: Platform.isIOS ? 13 : 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: Platform.isIOS ? 16 : 12,
                            vertical: Platform.isIOS ? 8 : 5,
                          ),
                          minimumSize:
                              Platform.isIOS ? null : const Size(10, 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
