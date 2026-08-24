class LookalikeDetector {
  static final Map<String, String> _commonLookalikes = {
    'jamb': 'jamb.gov.ng',
    'mtn': 'mtn.ng',
    'airtel': 'airtel.com.ng',
    'opay': 'opayweb.com',
    'palmpay': 'palmpay.com',
    'waec': 'waecdirect.org',
  };

  /// Simple lookalike detection (future: add Levenshtein distance)
  static String? detectLookalike(String host) {
    final clean = host.toLowerCase().replaceAll('www.', '');
    for (final entry in _commonLookalikes.entries) {
      if (clean.contains(entry.key) && !clean.contains(entry.value)) {
        return entry.value;
      }
    }
    return null;
  }
}