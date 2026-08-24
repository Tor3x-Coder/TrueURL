import 'package:trueurl/models/brand.dart';

class AdvancedUrlAnalyzer {
  /// Extracts the **registered domain** (e.g. from mtn-gift.com → com)
  static String getRegisteredDomain(String host) {
    final parts = host.toLowerCase().split('.');
    if (parts.length <= 2) return host;

    // Handle common second-level domains
    final tld = parts.last;
    if (['ng', 'com', 'net', 'org'].contains(tld) && parts.length > 2) {
      return '${parts[parts.length - 2]}.$tld';
    }
    return host;
  }

  /// Detects if a brand name appears in subdomain or path but not in the real domain
  static bool hasBrandImpersonation(String host, String path) {
    final registeredDomain = getRegisteredDomain(host);
    final knownBrands = [
      'mtn', 'airtel', 'glo', 'jamb', 'waec', 'opay', 'palmpay',
      'kuda', 'firstbank', 'gtbank', 'access', 'zenith', 'uba'
    ];

    for (final brand in knownBrands) {
      if ((host.contains(brand) || path.contains(brand)) &&
          !registeredDomain.contains(brand)) {
        return true;
      }
    }
    return false;
  }

  /// Checks for high-risk patterns in the URL path
  static List<String> analyzePath(String path) {
    final signals = <String>[];
    final lower = path.toLowerCase();

    if (lower.contains('claim') || lower.contains('reward')) {
      signals.add('claim_reward');
    }
    if (lower.contains('login') || lower.contains('verify')) {
      signals.add('login_verify');
    }
    if (lower.contains('gift') || lower.contains('bonus')) {
      signals.add('gift_bonus');
    }
    if (lower.contains('free') || lower.contains('data')) {
      signals.add('free_data');
    }
    if (lower.contains('payment') || lower.contains('fee')) {
      signals.add('payment_fee');
    }

    return signals;
  }

  /// Scores the URL based on structure
  static int calculateUrlRiskScore(String host, String path) {
    int score = 0;
    final lowerHost = host.toLowerCase();

    // Suspicious TLDs
    if (lowerHost.endsWith('.xyz') ||
        lowerHost.endsWith('.top') ||
        lowerHost.endsWith('.site') ||
        lowerHost.endsWith('.online') ||
        lowerHost.endsWith('.icu')) {
      score += 3;
    }

    // Brand impersonation in subdomain
    if (hasBrandImpersonation(host, path)) {
      score += 5;
    }

    // Very long subdomain
    if (host.split('.').length > 4) {
      score += 2;
    }

    // Numbers in domain (often used in lookalikes)
    if (RegExp(r'\d').hasMatch(host)) {
      score += 1;
    }

    // Hyphens in domain
    if (host.contains('-')) {
      score += 2;
    }

    return score;
  }
}