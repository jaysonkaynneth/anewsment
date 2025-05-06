import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UIHelpers {
  static Widget getEventCategoryIcon(String type, bool isIOS) {
    IconData iconData;
    Color iconColor = Colors.white;

    switch (type) {
      case 'people':
        iconData = isIOS ? CupertinoIcons.person_fill : Icons.person;
        break;
      case 'event':
        iconData = isIOS ? CupertinoIcons.star_fill : Icons.star;
        break;
      default:
        iconData = isIOS ? CupertinoIcons.calendar : Icons.event;
    }

    return Icon(iconData, color: iconColor, size: 28);
  }

  static String getEventTypeLabel(String type) {
    switch (type) {
      case 'people':
        return 'Historical Figure';
      case 'event':
        return 'Historical Event';
      default:
        return 'On This Day in History';
    }
  }

  static String getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'usa':
        return '🇺🇸';
      case 'uk':
        return '🇬🇧';
      case 'canada':
        return '🇨🇦';
      case 'australia':
        return '🇦🇺';
      case 'japan':
        return '🇯🇵';
      case 'china':
        return '🇨🇳';
      case 'india':
        return '🇮🇳';
      case 'france':
        return '🇫🇷';
      case 'germany':
        return '🇩🇪';
      case 'brazil':
        return '🇧🇷';
      case 'russia':
        return '🇷🇺';
      case 'mexico':
        return '🇲🇽';
      case 'spain':
        return '🇪🇸';
      case 'italy':
        return '🇮🇹';
      case 'thailand':
        return '🇹🇭';
      case 'israel':
        return '🇮🇱';
      case 'poland':
        return '🇵🇱';
      case 'ireland':
        return '🇮🇪';
      case 'belgium':
        return '🇧🇪';
      case 'the netherlands':
        return '🇳🇱';
      case 'romania':
        return '🇷🇴';
      case 'south korea':
        return '🇰🇷';
      case 'slovenia':
        return '🇸🇮';
      case 'portugal':
        return '🇵🇹';
      case 'new zealand':
        return '🇳🇿';
      case 'serbia':
        return '🇷🇸';
      case 'europe':
        return '🇪🇺';
      case 'ukraine':
        return '🇺🇦';
      case 'estonia':
        return '🇪🇪';
      case 'world':
        return '🌎';
      case 'business':
        return '💼';
      case 'technology':
        return '💻';
      case 'science':
        return '🔬';
      case 'sports':
        return '⚽';
      case 'gaming':
        return '🎮';
      case 'entertainment':
        return '🎬';
      case 'health':
        return '🏥';
      case 'politics':
        return '🏛️';
      case 'environment':
        return '🌳';
      case 'education':
        return '🎓';
      case 'travel':
        return '✈️';
      case 'food':
        return '🍽️';
      case 'linux & oss':
        return '🐧';
      case 'cryptocurrency':
        return '💰';

      default:
        return '📰';
    }
  }
}
