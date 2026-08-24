import 'package:trueurl/models/brand.dart';
import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/advanced_url_analyzer.dart';

class UrlInspector {
  static final RegExp _urlRegex = RegExp(
    r'https?://[^\s]+',
    caseSensitive: false,
  );

  static final RegExp _shortenerRegex = RegExp(
    r'(bit\.ly|tinyurl\.com|t\.co|goo\.gl|ow\.ly|is\.gd|buff\.ly|short\.link)',
    caseSensitive: false,
  );

  static final RegExp _suspiciousTld = RegExp(
    r'\.(xyz|top|online|site|club|icu|fun|pw|cc|tk|ml|ga|cf|ng|com\.ng|net)$',
    caseSensitive: false,
  );

  static final RegExp _ipHostRegex = RegExp(
    r'https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',
  );

  static final RegExp _atSignPhishing = RegExp(r'https?://[^/]+@');

  static final RegExp _punycodeRegex = RegExp(r'xn--', caseSensitive: false);

  /// Extracts the first URL from text. Returns null if none found.
  static String? extractUrl(String text) {
    final match = _urlRegex.firstMatch(text);
    return match?.group(0);
  }

  /// Main inspection logic
  static CheckResult inspectUrl(String input) {
    final url = extractUrl(input) ?? input.trim();
    if (url.isEmpty) {
      return CheckResult(
        verdict: VerdictType.unknown,
        title: 'No URL detected',
        reasons: ['Please paste a valid link.'],
        checkedAt: DateTime.now(),
      );
    }

    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    if (uri == null) {
      return CheckResult(
        verdict: VerdictType.beCareful,
        title: 'Invalid URL format',
        reasons: ['The link could not be parsed correctly.'],
        checkedAt: DateTime.now(),
      );
    }

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();
    final fullUrl = uri.toString();

    // Check for known brand (OFFICIAL)
    final brand = BrandBook.findByDomain(host);
    if (brand != null) {
      return CheckResult(
        verdict: VerdictType.official,
        title: '${brand.name} Official Site',
        reasons: [
          'This domain belongs to ${brand.name}.',
          if (brand.warning != null) brand.warning!,
        ],
        officialLinks: brand.domains.map((d) => 'https://$d').toList(),
        checkedAt: DateTime.now(),
      );
    }

    // === Advanced Brand Impersonation Check ===
    final matchedBrand = BrandBook.findByDomain(host);

    if (matchedBrand == null) {
      // Use the advanced analyzer
      if (AdvancedUrlAnalyzer.hasBrandImpersonation(host, path)) {
        return CheckResult(
          verdict: VerdictType.fake,
          title: 'Likely Scam Link',
          reasons: [
            'A popular brand name appears in the link, but this is not an official website for that brand.',
            'This is a very common impersonation technique used by scammers.',
          ],
          checkedAt: DateTime.now(),
        );
      }

      // Additional structural risk scoring
      final riskScore = AdvancedUrlAnalyzer.calculateUrlRiskScore(host, path);
      if (riskScore >= 6) {
        return CheckResult(
          verdict: VerdictType.fake,
          title: 'Likely Scam Link',
          reasons: [
            'This link has multiple high-risk characteristics (suspicious structure, brand impersonation, or risky domain).',
          ],
          checkedAt: DateTime.now(),
        );
      }
    }

    final reasons = <String>[];
    VerdictType verdict = VerdictType.unknown;

    // === FAKE signals ===
    bool isFake = false;

    // Known scam patterns in path (stronger detection)
    if (path.contains('gift') ||
        path.contains('free') ||
        path.contains('claim') ||
        path.contains('verify') ||
        path.contains('login') ||
        path.contains('update') ||
        path.contains('selected') ||
        path.contains('winner') ||
        path.contains('reward') ||
        path.contains('bonus')) {
      isFake = true;
      reasons.add('This looks like a classic "free gift / claim now" scam path.');
    }

    // Celebrity + data giveaway pattern (stronger)
    if (fullUrl.contains('davido') ||
        fullUrl.contains('wizkid') ||
        fullUrl.contains('burna') ||
        fullUrl.contains('data') && fullUrl.contains('gb') ||
        fullUrl.contains('loyalty') ||
        fullUrl.contains('rewards')) {
      isFake = true;
      reasons.add('Celebrity name + free data / rewards is a very common WhatsApp scam template.');
    }

    // Brand name in path but not in domain (very strong fake signal)
    final knownBrandsInPath = ['mtn', 'airtel', 'jamb', 'opay', 'palmpay'];
    for (final brand in knownBrandsInPath) {
      if (path.contains(brand) && !host.contains(brand)) {
        isFake = true;
        reasons.add('Brand name "$brand" appears in the link path but the domain is not official.');
        break;
      }
    }

    if (isFake) {
      verdict = VerdictType.fake;
    }

    // === BE CAREFUL signals ===
    if (verdict != VerdictType.fake) {
      if (_shortenerRegex.hasMatch(host)) {
        verdict = VerdictType.beCareful;
        reasons.add('This is a URL shortener. The real destination is hidden.');
      }

      if (_suspiciousTld.hasMatch(host)) {
        verdict = VerdictType.beCareful;
        reasons.add('Unusual top-level domain (.xyz, .top, etc.) often used by scammers.');
      }

      if (_ipHostRegex.hasMatch(fullUrl)) {
        verdict = VerdictType.beCareful;
        reasons.add('The link uses a raw IP address instead of a normal domain name.');
      }

      if (_atSignPhishing.hasMatch(fullUrl)) {
        verdict = VerdictType.fake;
        reasons.add('This URL contains an @ symbol — a classic phishing trick.');
      }

      if (_punycodeRegex.hasMatch(host)) {
        verdict = VerdictType.beCareful;
        reasons.add('Punycode domain detected (possible lookalike).');
      }

      if (!fullUrl.startsWith('https://')) {
        verdict = VerdictType.beCareful;
        reasons.add('The link is not using secure HTTPS.');
      }

      if (host.split('.').length > 4) {
        verdict = VerdictType.beCareful;
        reasons.add('Unusually long or nested subdomain structure.');
      }
    }

    // Final verdict decision
    if (verdict == VerdictType.unknown && reasons.isEmpty) {
      verdict = VerdictType.unknown;
      reasons.add('No obvious scam signals detected in the URL structure.');
    }

    return CheckResult(
      verdict: verdict,
      title: verdict == VerdictType.fake ? 'Likely Scam Link' : 'Link Analysis',
      reasons: reasons,
      checkedAt: DateTime.now(),
    );
  }
}