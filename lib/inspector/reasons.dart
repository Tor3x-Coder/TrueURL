import 'package:trueurl/models/verdict.dart';

class ReasonTemplates {
  static List<String> getDetailedReasons({
    required VerdictType verdict,
    required String input,
    required bool isMessage,
  }) {
    final reasons = <String>[];

    switch (verdict) {
      case VerdictType.fake:
        reasons.addAll([
          'This is written to make you tap before you think.',
          'The host or message uses classic scam patterns (celebrity + free data, "claim now", school fees, etc.).',
          'Real brands do not send these kinds of links or messages via WhatsApp forwards.',
        ]);
        break;
      case VerdictType.beCareful:
        reasons.addAll([
          'The link or message has caution signals (shortener, unusual domain, urgency language).',
          'Not enough evidence to call it fake, but you should be careful.',
        ]);
        break;
      case VerdictType.official:
        reasons.add('This domain is in our trusted brand book.');
        break;
      case VerdictType.unknown:
        reasons.add('No obvious scam signals were found.');
        break;
    }

    return reasons;
  }
}