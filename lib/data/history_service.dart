import 'package:trueurl/models/verdict.dart';
import 'dart:convert';

class HistoryService {
  // Simple in-memory history for now (will be replaced with Hive later)
  static final List<CheckResult> _history = [];

  static List<CheckResult> getHistory() => List.unmodifiable(_history);

  static void addToHistory(CheckResult result) {
    _history.insert(0, result);
    if (_history.length > 50) {
      _history.removeLast();
    }
  }

  static void clearHistory() {
    _history.clear();
  }

  // Future: persist with shared_preferences or Hive
  static String exportAsJson() {
    return jsonEncode(_history.map((r) => r.toJson()).toList());
  }
}