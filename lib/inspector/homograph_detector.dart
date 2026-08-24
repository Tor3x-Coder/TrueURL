class HomographDetector {
  // Common Cyrillic characters that look like Latin ones
  static final Map<String, String> _cyrillicLookalikes = {
    'а': 'a', 'е': 'e', 'о': 'o', 'р': 'p', 'с': 'c', 'х': 'x',
    'у': 'y', 'к': 'k', 'м': 'm', 'н': 'h', 'т': 't', 'в': 'b',
    'і': 'i', 'ѕ': 's', 'ј': 'j', 'ґ': 'g',
  };

  /// Detects potential homograph attacks (mixed scripts)
  static bool isSuspiciousHomograph(String host) {
    final hasCyrillic = RegExp(r'[а-яА-Я]').hasMatch(host);
    final hasLatin = RegExp(r'[a-zA-Z]').hasMatch(host);

    if (hasCyrillic && hasLatin) {
      return true; // Mixed script = very suspicious
    }

    // Check for Cyrillic characters that look like Latin
    for (final cyrillic in _cyrillicLookalikes.keys) {
      if (host.contains(cyrillic)) {
        return true;
      }
    }

    return false;
  }

  /// Converts suspicious characters to punycode-style warning
  static String getWarning(String host) {
    if (isSuspiciousHomograph(host)) {
      return 'This domain uses characters that look like normal letters but may be from another alphabet (homograph attack).';
    }
    return '';
  }
}