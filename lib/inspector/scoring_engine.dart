import 'package:trueurl/inspector/scam_patterns.dart';
import 'package:trueurl/inspector/advanced_url_analyzer.dart';
import 'package:trueurl/models/verdict.dart';

class ScoringEngine {
  /// Calculates final verdict + confidence based on all signals
  static Map<String, dynamic> calculate({
    required String input,
    required bool isMessage,
    String? url,
    String? path,
    List<String> detectedSignals = const [],
  }) {
    int totalScore = 0;
    final allSignals = <String>[...detectedSignals];

    // 1. Scam Pattern Scores
    final matchedPatterns = ScamPatternLibrary.matchPatterns(input);
    for (final pattern in matchedPatterns) {
      totalScore += pattern.score;
      allSignals.add(pattern.id);
    }

    // 2. URL Risk Score (if URL exists)
    if (url != null) {
      final host = Uri.tryParse(url)?.host ?? '';
      final urlRisk = AdvancedUrlAnalyzer.calculateUrlRiskScore(host, path ?? '');
      totalScore += urlRisk;
    }

    // 3. Brand Mismatch Bonus
    if (allSignals.contains('brand_mismatch')) {
      totalScore += 6;
    }

    // 4. Normalize score to 0-100
    int confidence = (totalScore * 4).clamp(0, 100);

    // 5. Determine Verdict
    VerdictType verdict;

    if (totalScore >= 10) {
      verdict = VerdictType.fake;
    } else if (totalScore >= 6) {
      verdict = VerdictType.beCareful;
    } else if (totalScore >= 3) {
      verdict = VerdictType.beCareful;
    } else {
      verdict = VerdictType.unknown;
    }

    // Special case: Very clean link
    if (verdict == VerdictType.unknown && url != null) {
      final host = Uri.tryParse(url)?.host ?? '';
      if (!host.contains('-') && !host.contains(RegExp(r'\d'))) {
        confidence = 65; // Slightly more confident it's clean
      }
    }

    return {
      'verdict': verdict,
      'confidence': confidence,
      'signals': allSignals,
      'score': totalScore,
    };
  }
}