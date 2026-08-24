enum VerdictType {
  official,
  unknown,
  beCareful,
  fake,
}

extension VerdictTypeExtension on VerdictType {
  String get displayName {
    switch (this) {
      case VerdictType.official:
        return 'OFFICIAL';
      case VerdictType.unknown:
        return 'UNKNOWN';
      case VerdictType.beCareful:
        return 'BE CAREFUL';
      case VerdictType.fake:
        return 'FAKE';
    }
  }

  String get description {
    switch (this) {
      case VerdictType.official:
        return 'This is a known real brand domain.';
      case VerdictType.unknown:
        return 'No trap signals detected, but we do not vouch for it.';
      case VerdictType.beCareful:
        return 'Shortener, odd structure, or other caution signals.';
      case VerdictType.fake:
        return 'Clear impersonation or known scam pattern.';
    }
  }
}

class CheckResult {
  final VerdictType verdict;
  final String title;
  final List<String> reasons;
  final List<String> officialLinks;
  final String? noOfficialMessage;
  final String? originalInput;
  final DateTime checkedAt;
  final bool isMessageMode;
  final int confidenceScore; // 0-100

  const CheckResult({
    required this.verdict,
    required this.title,
    required this.reasons,
    this.officialLinks = const [],
    this.noOfficialMessage,
    this.originalInput,
    required this.checkedAt,
    this.isMessageMode = false,
    this.confidenceScore = 70,
  });

  Map<String, dynamic> toJson() => {
        'verdict': verdict.name,
        'title': title,
        'reasons': reasons,
        'officialLinks': officialLinks,
        'noOfficialMessage': noOfficialMessage,
        'originalInput': originalInput,
        'checkedAt': checkedAt.toIso8601String(),
        'isMessageMode': isMessageMode,
        'confidenceScore': confidenceScore,
      };

  factory CheckResult.fromJson(Map<String, dynamic> json) => CheckResult(
        verdict: VerdictType.values.firstWhere(
          (e) => e.name == json['verdict'],
          orElse: () => VerdictType.unknown,
        ),
        title: json['title'] ?? '',
        reasons: List<String>.from(json['reasons'] ?? []),
        officialLinks: List<String>.from(json['officialLinks'] ?? []),
        noOfficialMessage: json['noOfficialMessage'],
        originalInput: json['originalInput'],
        checkedAt: DateTime.parse(json['checkedAt']),
        isMessageMode: json['isMessageMode'] ?? false,
        confidenceScore: json['confidenceScore'] ?? 70,
      );
}