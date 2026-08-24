import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';

class MessageInspector {
  static final List<String> _scamKeywords = [
    'free data', '20gb', '50gb', '100gb', 'gift', 'claim now',
    'you have been selected', 'congratulations', 'winner',
    'school fees', 'admission', 'jamb', 'waec', 'results are out',
    'verify your account', 'otp', 'login to claim', 'double your money',
    'investment', 'pay to claim', 'limited time', 'expires at midnight',
    'everyone is claiming', 'davido', 'wizkid', 'burna boy',
    'mtn', 'airtel', 'glo', '9mobile', 'opay', 'palmpay',
    'account suspended', 'unauthorized login', 'tax refund',
    'verify identity', 'reset password', 'claim your reward',
  ];

  static final RegExp _phoneNumberRegex = RegExp(r'(\+?234|0)[789]\d{9}');

  /// Checks if a brand name appears in the message but NOT in the actual domain
  static bool _hasBrandMismatch(String message, String? url) {
    if (url == null) return false;

    final lowerMsg = message.toLowerCase();
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';

    final knownBrands = ['mtn', 'airtel', 'glo', 'jamb', 'waec', 'opay', 'palmpay', 'kuda'];

    for (final brand in knownBrands) {
      if (lowerMsg.contains(brand) && !host.contains(brand)) {
        return true;
      }
    }
    return false;
  }

  /// Inspects the full message text for scam patterns + runs URL inspector
  static CheckResult inspectMessage(String message) {
    final lowerMessage = message.toLowerCase();
    final reasons = <String>[];
    VerdictType verdict = VerdictType.unknown;
    int scamScore = 0;

    // Extract any URL first
    final url = UrlInspector.extractUrl(message);
    CheckResult? urlResult;
    if (url != null) {
      urlResult = UrlInspector.inspectUrl(url);
    }

    // === Brand name mismatch (very strong signal) ===
    if (_hasBrandMismatch(message, url)) {
      scamScore += 5;
      reasons.add('Brand name mentioned in message (e.g. MTN) but the link domain is NOT official.');
    }

    // Strong scam signals
    for (final keyword in _scamKeywords) {
      if (lowerMessage.contains(keyword)) {
        scamScore++;
        if (keyword.contains('free data') || keyword.contains('gb')) {
          reasons.add('Mentions "free data" or large GB amounts — a very common scam hook.');
        } else if (keyword.contains('davido') || keyword.contains('wizkid')) {
          reasons.add('Celebrity name used to create urgency and trust.');
        } else if (keyword.contains('claim') || keyword.contains('winner')) {
          reasons.add('Classic "you have been selected / claim your reward" language.');
        } else if (keyword.contains('school fees') || keyword.contains('admission')) {
          reasons.add('Targets students and parents with education-related panic.');
        } else if (keyword.contains('verify') || keyword.contains('login')) {
          reasons.add('Urgent verification/login language commonly used in phishing.');
        }
      }
    }

    // Multiple networks mentioned
    if ((lowerMessage.contains('mtn') && lowerMessage.contains('airtel')) ||
        (lowerMessage.contains('mtn') && lowerMessage.contains('glo'))) {
      scamScore += 3;
      reasons.add('Asking you to "choose your network" is a classic scam template.');
    }

    // Urgency / FOMO language
    if (lowerMessage.contains('midnight') ||
        lowerMessage.contains('limited') ||
        lowerMessage.contains('expires') ||
        lowerMessage.contains('hurry') ||
        lowerMessage.contains('everyone')) {
      scamScore += 2;
      reasons.add('Written to create panic and FOMO ("expires at midnight", "everyone is claiming").');
    }

    // Phone number in message
    if (_phoneNumberRegex.hasMatch(message)) {
      scamScore += 2;
      reasons.add('Contains a phone number — scammers often ask you to contact them directly.');
    }

    // Combine with URL result
    if (urlResult != null) {
      if (urlResult.verdict == VerdictType.fake) {
        verdict = VerdictType.fake;
        reasons.addAll(urlResult.reasons);
      } else if (urlResult.verdict == VerdictType.beCareful && scamScore > 2) {
        verdict = VerdictType.fake;
      } else if (urlResult.verdict == VerdictType.beCareful) {
        verdict = VerdictType.beCareful;
        reasons.addAll(urlResult.reasons);
      }
    }

    // Final decision based on score
    if (verdict == VerdictType.unknown) {
      if (scamScore >= 4) {
        verdict = VerdictType.fake;
      } else if (scamScore >= 2) {
        verdict = VerdictType.beCareful;
      } else {
        verdict = VerdictType.unknown;
      }
    }

    if (reasons.isEmpty) {
      reasons.add('No strong scam patterns detected in the message text.');
    }

    return CheckResult(
      verdict: verdict,
      title: verdict == VerdictType.fake
          ? 'This message looks like a scam'
          : verdict == VerdictType.beCareful
              ? 'Be careful with this message'
              : 'Message analyzed',
      reasons: reasons.toSet().toList(),
      checkedAt: DateTime.now(),
      isMessageMode: true,
      originalInput: message,
    );
  }
}