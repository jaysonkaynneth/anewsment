class HistoricalEvent {
  final String year;
  final String content;
  final String type;
  final double? sortYear;
  final String? linkUrl;
  final String title;

  HistoricalEvent({
    required this.year,
    required this.content,
    required this.type,
    this.sortYear,
    this.linkUrl,
    required this.title,
  });

  factory HistoricalEvent.fromJson(Map<String, dynamic> json) {
    final String content = json['content'] ?? '';

    String extractedTitle = '';
    String? extractedLink;

    final linkRegex = RegExp(r'<a href="([^"]+)"[^>]*>([^<]+)</a>');
    final Match? match = linkRegex.firstMatch(content);

    if (match != null && match.groupCount >= 2) {
      extractedLink = match.group(1);
      extractedTitle = match.group(2) ?? '';
    }

    if (extractedTitle.isEmpty) {
      final parenthesesRegex = RegExp(r'\((.*?)\)');
      final Match? parenthesesMatch = parenthesesRegex.firstMatch(content);
      if (parenthesesMatch != null) {
        extractedTitle = parenthesesMatch.group(1) ?? '';
      } else {
        extractedTitle = content.split(' ').take(3).join(' ');
      }
    }

    return HistoricalEvent(
      year: json['year'] ?? '',
      content: content,
      type: json['type'] ?? '',
      sortYear:
          json['sort_year'] is num
              ? (json['sort_year'] as num).toDouble()
              : null,
      linkUrl: extractedLink,
      title: extractedTitle,
    );
  }
}
