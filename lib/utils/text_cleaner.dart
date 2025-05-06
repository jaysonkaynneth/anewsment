class TextCleaner {
  static String clean(String? text) {
    if (text == null || text.isEmpty) return '';

    var cleanedText = text.trim();

    cleanedText = cleanedText
        .replaceAll('â€™', "'")
        .replaceAll("â€˜", "'")
        .replaceAll('â€œ', '"')
        .replaceAll('â€', '"')
        .replaceAll('â', "'")
        .replaceAll('´', "'");

    cleanedText = cleanedText
        .replaceAll('â€"', "–")
        .replaceAll('â€"', "—")
        .replaceAll('â€¦', "...");

    cleanedText = cleanedText
        .replaceAll('ã', "a")
        .replaceAll('å', "a")
        .replaceAll('ä', "a")
        .replaceAll('à', "a")
        .replaceAll('ö', "o")
        .replaceAll('ø', "o")
        .replaceAll('ò', "o")
        .replaceAll('ñ', "n")
        .replaceAll('é', "e")
        .replaceAll('è', "e")
        .replaceAll('ê', "e")
        .replaceAll('ë', "e")
        .replaceAll('ü', "u")
        .replaceAll('ù', "u")
        .replaceAll('í', "i")
        .replaceAll('ì', "i")
        .replaceAll('ï', "i");

    cleanedText = cleanedText
        .replaceAll('∂', "")
        .replaceAll('Â', "")
        .replaceAll('·', "");

    cleanedText = cleanedText
        .replaceAll(RegExp(r'Australia(â|å|\u00e2|Â)s'), "Australia's")
        .replaceAll(
          RegExp(r'Australia(â|å|\u00e2|Â)(\u20ac|\u2122)s'),
          "Australia's",
        )
        .replaceAll('Australiaâs', "Australia's")
        .replaceAll('Australiaâ€™s', "Australia's")
        .replaceAll('AustraliaÂs', "Australia's")
        .replaceAll('Australiaås', "Australia's");

    cleanedText = cleanedText
        .replaceAll(RegExp(r'[\u0000-\u001F]'), '')
        .replaceAll(RegExp(r'[\u0080-\u009F]'), '')
        .replaceAll(RegExp(r'[\u0091-\u0096]'), "'")
        .replaceAll(RegExp(r'[\u0082-\u008C]'), "")
        .replaceAll(RegExp(r'[\u008D-\u009F]'), "");

    if (RegExp(r'[^\x00-\x7F]+').hasMatch(cleanedText)) {
      cleanedText = cleanedText.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    }

    return cleanedText;
  }
}
