import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';
import 'package:trueurl/inspector/reasons_engine.dart';
import 'package:trueurl/inspector/scam_patterns.dart';
import 'package:trueurl/inspector/scoring_engine.dart';

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
    final url = UrlInspector.extractUrl(message);

    // Use the new Scoring Engine
    final scoringResult = ScoringEngine.calculate(
      input: message,
      isMessage: true,
      url: url,
      detectedSignals: [],
    );

    final verdict = scoringResult['verdict'] as VerdictType;
    final confidence = scoringResult['confidence'] as int;
    final signals = List<String>.from(scoringResult['signals']);

    // === Generate rich, detailed reasons ===
    final reasons = ReasonsEngine.generateReasons(
      verdict: verdict,
      input: message,
      isMessage: true,
      detectedSignals: signals,
      url: url,
    );

    return CheckResult(
      verdict: verdict,
      title: verdict == VerdictType.fake
          ? 'This message looks like a scam'
          : verdict == VerdictType.beCareful
              ? 'Be careful with this message'
              : 'Message analyzed',
      reasons: reasons,
      checkedAt: DateTime.now(),
      isMessageMode: true,
      originalInput: message,
      confidenceScore: confidence,
    );
  }
}