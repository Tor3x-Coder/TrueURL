import 'package:http/http.dart' as http;
import 'dart:async';

class OnlineChecker {
  /// Safely follows redirects (max 5 hops) and returns the final URL + status
  static Future<RedirectResult> followRedirects(String url) async {
    try {
      final client = http.Client();
      var currentUrl = url;
      int hops = 0;
      const maxHops = 5;

      while (hops < maxHops) {
        final response = await client
            .head(Uri.parse(currentUrl))
            .timeout(const Duration(seconds: 8));

        if (response.isRedirect && response.headers['location'] != null) {
          currentUrl = response.headers['location']!;
          hops++;
        } else {
          break;
        }
      }

      client.close();

      final finalUri = Uri.parse(currentUrl);
      return RedirectResult(
        finalUrl: currentUrl,
        finalHost: finalUri.host.toLowerCase(),
        redirectHops: hops,
        success: true,
      );
    } catch (e) {
      return RedirectResult(
        finalUrl: url,
        finalHost: Uri.tryParse(url)?.host.toLowerCase() ?? '',
        redirectHops: 0,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Simple high-risk intent detection (can be expanded later)
  static bool isHighRiskIntent(String text) {
    final lower = text.toLowerCase();

    final urgencyWords = [
      'immediately', 'urgent', 'account suspended', 'verify now',
      'expires', 'limited time', 'act now', 'hurry', 'midnight'
    ];

    final financialWords = [
      'refund', 'payment', 'bank', 'transfer', 'otp', 'token',
      'login', 'password', 'verify identity', 'unauthorized'
    ];

    final credentialWords = [
      'reset password', 'login to claim', 'enter otp', 'verify account'
    ];

    bool hasUrgency = urgencyWords.any((w) => lower.contains(w));
    bool hasFinancial = financialWords.any((w) => lower.contains(w));
    bool hasCredential = credentialWords.any((w) => lower.contains(w));

    // High risk if it has urgency + (financial or credential)
    return (hasUrgency && (hasFinancial || hasCredential)) ||
           hasCredential;
  }
}

class RedirectResult {
  final String finalUrl;
  final String finalHost;
  final int redirectHops;
  final bool success;
  final String? error;

  RedirectResult({
    required this.finalUrl,
    required this.finalHost,
    required this.redirectHops,
    required this.success,
    this.error,
  });
}