import 'package:trueurl/models/verdict.dart';

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
    final lowerInput = input.toLowerCase();

    if (verdict == VerdictType.fake) {
      // Brand impersonation
      if (detectedSignals.contains('brand_mismatch')) {
        reasons.add(
          'A brand name (like MTN, JAMB, or Davido) is mentioned in the message, but the link domain is not an official website for that brand. This is a very common impersonation technique used by scammers.'
        );
      }

      // Celebrity + Money
      if (detectedSignals.contains('celebrity_cash')) {
        reasons.add(
          'This message uses a celebrity name (Davido, Wizkid, etc.) combined with a large cash gift. Real celebrities and their teams do not randomly give away money through WhatsApp links. These are almost always scams designed to steal your details.'
        );
      }

      // Government + Money
      if (detectedSignals.contains('government_money')) {
        reasons.add(
          'Messages claiming the Federal Government is giving out money (palliative, grants, etc.) through random links are extremely common right now. The real government never asks citizens to click links sent via WhatsApp to receive money.'
        );
      }

      // Lottery / Win
      if (detectedSignals.contains('lottery_win')) {
        reasons.add(
          'Lottery or betting win messages that ask you to claim money are almost always fake. Real lotteries and betting companies do not randomly contact winners through WhatsApp with links.'
        );
      }

      // Free data / GB
      if (detectedSignals.contains('free_data')) {
        reasons.add(
          'This is the classic "free data giveaway" scam. MTN, Airtel, Glo, and 9mobile do not announce data gifts through random WhatsApp forwards. They only run official promos through their apps and verified websites.'
        );
      }

      // Urgency + Fear
      if (detectedSignals.contains('urgency_fear')) {
        reasons.add(
          'The message uses fear and urgency ("account blocked", "fraud detected", "claim immediately") to make you act without thinking. Real banks and government agencies never send panic-inducing messages with links.'
        );
      }

      // Multiple networks
      if (detectedSignals.contains('multiple_networks')) {
        reasons.add(
          'Asking you to "choose your network" (MTN, Airtel, Glo) is a very common scam template. Legitimate companies already know which network you\'re on.'
        );
      }

      // Generic fallback for fake
      if (reasons.isEmpty) {
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

    return reasons;
  }
}