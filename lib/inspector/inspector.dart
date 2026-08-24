import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/url_inspector.dart';
import 'package:trueurl/inspector/message_inspector.dart';

class TrueURLInspector {
  /// Main entry point for checking any input
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
}