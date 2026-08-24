class ScamPattern {
  final String id;
  final List<String> keywords;
  final int score;
  final String reason;
  final List<String> categories;

  const ScamPattern({
    required this.id,
    required this.keywords,
    required this.score,
    required this.reason,
    required this.categories,
  });
}

class ScamPatternLibrary {
  static final List<ScamPattern> patterns = [
    // === High Impact Patterns ===
    ScamPattern(
      id: 'celebrity_cash_gift',
      keywords: ['davido', 'wizkid', 'burna', 'cash gift', 'n100,000', 'n50,000'],
      score: 8,
      reason: 'Celebrity name combined with large cash giveaway is a very common WhatsApp scam pattern.',
      categories: ['celebrity', 'money'],
    ),
    ScamPattern(
      id: 'government_palliative',
      keywords: ['federal government', 'palliative', 'n50,000', 'grant', 'disbursement'],
      score: 8,
      reason: 'Government money distribution messages sent via WhatsApp links are almost always fraudulent.',
      categories: ['government', 'money'],
    ),
    ScamPattern(
      id: 'lottery_win',
      keywords: ['won', 'winner', 'congratulations', 'million', 'bet9ja', 'n2,500,000'],
      score: 7,
      reason: 'Lottery or betting win messages asking you to claim money through a link are classic scams.',
      categories: ['gambling', 'money'],
    ),
    ScamPattern(
      id: 'free_data_giveaway',
      keywords: ['free data', '50gb', '100gb', 'airtime', 'choose your network'],
      score: 7,
      reason: 'Telecom companies never give away large amounts of data through random WhatsApp messages.',
      categories: ['telco', 'freebie'],
    ),
    ScamPattern(
      id: 'account_blocked_fear',
      keywords: ['account blocked', 'bvn', 'fraudulent', 'unauthorized', 'suspended'],
      score: 8,
      reason: 'Banks never send messages with links asking you to "unblock" your account or verify your BVN.',
      categories: ['bank', 'fear'],
    ),
    ScamPattern(
      id: 'package_held',
      keywords: ['package', 'delivery', 'held', 'post office', 'pay fee'],
      score: 6,
      reason: 'Fake delivery fee scams are very common, especially with popular e-commerce brands.',
      categories: ['delivery', 'payment'],
    ),

    // === Medium Impact Patterns ===
    ScamPattern(
      id: 'urgent_action',
      keywords: ['immediately', 'urgent', 'closes today', 'before it closes', 'act now'],
      score: 4,
      reason: 'Strong urgency language is designed to stop you from thinking carefully.',
      categories: ['urgency'],
    ),
    ScamPattern(
      id: 'multiple_networks',
      keywords: ['mtn', 'airtel', 'glo', 'choose network'],
      score: 5,
      reason: 'Asking you to choose your network is a very common scam template.',
      categories: ['telco'],
    ),
    ScamPattern(
      id: 'verify_login',
      keywords: ['verify', 'login', 'update details', 'confirm identity'],
      score: 5,
      reason: 'Requests to verify or login through a link are frequently used in phishing attacks.',
      categories: ['phishing'],
    ),
  ];

  static List<ScamPattern> matchPatterns(String text) {
    final lower = text.toLowerCase();
    final matches = <ScamPattern>[];

    for (final pattern in patterns) {
      int matchCount = 0;
      for (final keyword in pattern.keywords) {
        if (lower.contains(keyword)) matchCount++;
      }
      if (matchCount >= 2 || (pattern.keywords.length == 1 && matchCount == 1)) {
        matches.add(pattern);
      }
    }
    return matches;
  }
}