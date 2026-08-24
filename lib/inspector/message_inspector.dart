import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';

class MessageInspector {
  static final List<String> _scamKeywords = [
    'free data',
    '20gb',
    '50gb',
    '100gb',
    'gift',
    'claim now',
    'you have been selected',
    'congratulations',
    'winner',
    'school fees',
    'admission',
    'jamb',
    'waec',
    'results are out',
    'verify your account',
    'otp',
    'login to claim',
    'double your money',
    'investment',
    'pay to claim',
    'limited time',
    'expires at midnight',
    'everyone is claiming',
    'davido',
    'wizkid',
    'burna boy',
    'mtn',
    'airtel',
    'glo',
    '9mobile',
    'opay',
    'palmpay',
  ];

  static final RegExp _phoneNumberRegex = RegExp(r'(\+?234|0)[789]\d{9}');

  /// Inspects the full message text for scam patterns + runs URL inspector
  static CheckResult inspectMessage(String message) {
    final lowerMessage = message.toLowerCase();
    final reasons = <String>[];
    VerdictType verdict = VerdictType.unknown;

    // Extract any URL first
    final url = UrlInspector.extractUrl(message);
    CheckResult? urlResult;
    if (url != null) {
      urlResult = UrlInspector.inspectUrl(url);
    }

    // Strong scam signals
    int scamScore = 0;

    for (final keyword in _scamKeywords) {
      if (lowerMessage.contains(keyword)) {
        scamScore++;
        if (keyword == 'free data' || keyword.contains('gb')) {
          reasons.add('Mentions "free data" or large GB amounts — a very common scam hook.');
        } else if (keyword.contains('davido') || keyword.contains('wizkid')) {
          reasons.add('Celebrity name used to create urgency and trust.');
        } else if (keyword.contains('claim') || keyword.contains('winner')) {
          reasons.add('Classic "you have been selected / claim your reward" language.');
        } else if (keyword.contains('school fees') || keyword.contains('admission')) {
          reasons.add('Targets students and parents with education-related panic.');
        }
      }
    }

    // Multiple networks mentioned
    if ((lowerMessage.contains('mtn') && lowerMessage.contains('airtel')) ||
        (lowerMessage.contains('mtn') && lowerMessage.contains('glo'))) {
      scamScore += 2;
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

    // Phone number in message (often used for scam contact)
    if (_phoneNumberRegex.hasMatch(message)) {
      scamScore += 1;
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

    // Final decision
    if (verdict == VerdictType.unknown) {
      if (scamScore >= 3) {
        verdict = VerdictType.fake;
      } else if (scamScore >= 1) {
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
      reasons: reasons.toSet().toList(), // remove duplicates
      checkedAt: DateTime.now(),
      isMessageMode: true,
      originalInput: message,
    );
  }
}