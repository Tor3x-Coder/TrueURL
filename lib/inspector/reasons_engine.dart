import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/scam_patterns.dart';

class ReasonsEngine {
  /// Generates detailed, human-sounding reasons based on detected signals
  static List<String> generateReasons({
    required VerdictType verdict,
    required String input,
    required bool isMessage,
    required List<String> detectedSignals,
    String? url,
    String? finalHost,
  }) {
    final reasons = <String>[];

    if (verdict == VerdictType.fake) {
      // Use matched patterns for rich reasons
      final matchedPatterns = ScamPatternLibrary.matchPatterns(input);

      for (final pattern in matchedPatterns) {
        reasons.add(pattern.reason);
      }

      // Brand impersonation
      if (detectedSignals.contains('brand_mismatch')) {
        reasons.add(
          'A brand name is mentioned in the message, but the link domain is not an official website for that brand. This is one of the most common impersonation techniques used by scammers.'
        );
      }

      // Generic strong fallback
      if (reasons.isEmpty || reasons.length < 2) {
        reasons.add(
          'This message contains multiple classic scam patterns designed to create panic and urgency. Scammers use these tricks to make you click before you think.'
        );
      }

    } else if (verdict == VerdictType.beCareful) {
      if (detectedSignals.contains('shortener')) {
        reasons.add(
          'This link uses a URL shortener. The real destination is hidden, which makes it risky. You should only click short links from sources you fully trust.'
        );
      }

      if (detectedSignals.contains('punycode')) {
        reasons.add(
          'This domain uses special characters that look like normal letters but may actually be from another alphabet. This is a technique called homograph attack used in phishing.'
        );
      }

      if (detectedSignals.contains('suspicious_tld')) {
        reasons.add(
          'The link uses an unusual top-level domain (.xyz, .top, .site, etc.). These cheap domains are frequently used by scammers because they are easy and inexpensive to register.'
        );
      }

      if (detectedSignals.contains('http')) {
        reasons.add(
          'The link is not using secure HTTPS. Real websites, especially those handling any kind of personal or financial information, almost always use HTTPS.'
        );
      }

      if (reasons.isEmpty) {
        reasons.add(
          'While no obvious scam was detected, the link has some unusual characteristics that warrant caution.'
        );
      }

    } else if (verdict == VerdictType.official) {
      reasons.add(
        'This domain belongs to a verified official brand in our trusted list.'
      );
    } else {
      reasons.add(
        'No strong scam signals were detected in this message or link.'
      );
    }

    // Remove duplicates
    return reasons.toSet().toList();
  }
}