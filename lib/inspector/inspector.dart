import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';
import 'package:trueurl/inspector/message_inspector.dart';
import 'package:trueurl/inspector/enhanced_inspector.dart';

class TrueURLInspector {
  /// Main entry point for checking any input (offline first)
  static CheckResult check(String input, {bool forceMessageMode = false}) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return CheckResult(
        verdict: VerdictType.unknown,
        title: 'Empty input',
        reasons: ['Please paste a link or message.'],
        checkedAt: DateTime.now(),
      );
    }

    // Auto-detect mode
    final hasUrl = UrlInspector.extractUrl(trimmed) != null;
    final isLongMessage = trimmed.split(' ').length > 8;

    if (forceMessageMode || (!hasUrl && isLongMessage)) {
      return MessageInspector.inspectMessage(trimmed);
    } else {
      return UrlInspector.inspectUrl(trimmed);
    }
  }

  /// Enhanced check with optional online features
  static Future<CheckResult> checkWithOnline(
    String input, {
    bool forceMessageMode = false,
    bool allowOnline = true,
  }) async {
    return EnhancedInspector.check(
      input,
      forceMessageMode: forceMessageMode,
      allowOnline: allowOnline,
    );
  }
}