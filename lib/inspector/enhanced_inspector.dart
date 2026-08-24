import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';
import 'package:trueurl/inspector/message_inspector.dart';
import 'package:trueurl/inspector/homograph_detector.dart';
import 'package:trueurl/claim/online_checker.dart';
import 'package:trueurl/services/connectivity_service.dart';

class EnhancedInspector {
  /// Main check method with optional online enhancement
  static Future<CheckResult> check(
    String input, {
    bool forceMessageMode = false,
    bool allowOnline = true,
  }) async {
    // First do the fast offline check
    final offlineResult = TrueURLInspector.check(
      input,
      forceMessageMode: forceMessageMode,
    );

    // If offline or user doesn't want online, return the offline result
    if (!allowOnline) {
      return offlineResult;
    }

    final isOnline = await ConnectivityService.isOnline();
    if (!isOnline) {
      // Return offline result but we can add a note later in UI
      return offlineResult;
    }

    // === ONLINE ENHANCEMENTS ===
    String? url = UrlInspector.extractUrl(input);
    if (url == null && !forceMessageMode) {
      url = input.trim();
    }

    if (url != null && url.startsWith('http')) {
      // 1. Follow redirects (especially for shorteners)
      final redirectResult = await OnlineChecker.followRedirects(url);

      if (redirectResult.success && redirectResult.redirectHops > 0) {
        // Re-check the final destination
        final finalResult = UrlInspector.inspectUrl(redirectResult.finalUrl);
        
        if (finalResult.verdict == VerdictType.fake) {
          return CheckResult(
            verdict: VerdictType.fake,
            title: 'Likely Scam Link (Redirected)',
            reasons: [
              ...finalResult.reasons,
              'This link redirects through ${redirectResult.redirectHops} hop(s).',
              'Final destination: ${redirectResult.finalHost}',
            ],
            checkedAt: DateTime.now(),
            originalInput: input,
          );
        }
      }

      // 2. Check for homograph attacks on final host
      final finalHost = redirectResult.success 
          ? redirectResult.finalHost 
          : Uri.tryParse(url)?.host.toLowerCase() ?? '';

      if (HomographDetector.isSuspiciousHomograph(finalHost)) {
        return CheckResult(
          verdict: VerdictType.fake,
          title: 'Likely Scam Link (Homograph)',
          reasons: [
            ...offlineResult.reasons,
            HomographDetector.getWarning(finalHost),
          ],
          checkedAt: DateTime.now(),
          originalInput: input,
        );
      }
    }

    // 3. High-risk intent check on the full message
    if (OnlineChecker.isHighRiskIntent(input)) {
      if (offlineResult.verdict == VerdictType.unknown ||
          offlineResult.verdict == VerdictType.beCareful) {
        return CheckResult(
          verdict: VerdictType.beCareful,
          title: 'High Risk Message',
          reasons: [
            ...offlineResult.reasons,
            'This message contains urgent + financial/credential language — a common phishing pattern.',
          ],
          checkedAt: DateTime.now(),
          originalInput: input,
          isMessageMode: forceMessageMode,
        );
      }
    }

    return offlineResult;
  }
}