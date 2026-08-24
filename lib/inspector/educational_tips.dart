class EducationalTip {
  final String title;
  final String message;

  const EducationalTip({required this.title, required this.message});
}

class EducationalTips {
  static EducationalTip? getTip(VerdictType verdict, List<String> detectedSignals) {
    if (verdict == VerdictType.fake) {
      if (detectedSignals.contains('brand_mismatch')) {
        return const EducationalTip(
          title: 'How to stay safe',
          message: 'Always type the official website yourself instead of clicking links sent to you.',
        );
      }
      if (detectedSignals.contains('celebrity_cash') || detectedSignals.contains('government_money')) {
        return const EducationalTip(
          title: 'Remember',
          message: 'Real celebrities and the government rarely give money through random WhatsApp messages.',
        );
      }
      if (detectedSignals.contains('account_blocked_fear')) {
        return const EducationalTip(
          title: 'Important',
          message: 'Your bank will never ask you to click a link to unblock your account or verify your BVN.',
        );
      }
      return const EducationalTip(
        title: 'General Rule',
        message: 'When in doubt, don\'t click. Verify directly on the official app or website.',
      );
    }

    if (verdict == VerdictType.beCareful) {
      return const EducationalTip(
        title: 'Tip',
        message: 'Even if it looks okay, it\'s safer to visit the official site directly.',
      );
    }

    return null;
  }
}