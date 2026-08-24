import 'package:flutter/material.dart';
import 'package:trueurl/models/verdict.dart';

class VerdictCard extends StatelessWidget {
  final CheckResult result;

  const VerdictCard({super.key, required this.result});

  Color _getVerdictColor(VerdictType verdict) {
    switch (verdict) {
      case VerdictType.official:
        return const Color(0xFF388E3C);
      case VerdictType.unknown:
        return Colors.grey.shade700;
      case VerdictType.beCareful:
        return const Color(0xFFFFA000);
      case VerdictType.fake:
        return const Color(0xFFD32F2F);
    }
  }

  IconData _getVerdictIcon(VerdictType verdict) {
    switch (verdict) {
      case VerdictType.official:
        return Icons.verified;
      case VerdictType.unknown:
        return Icons.help_outline;
      case VerdictType.beCareful:
        return Icons.warning_amber;
      case VerdictType.fake:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getVerdictColor(result.verdict);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getVerdictIcon(result.verdict),
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.verdict.displayName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          result.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reasons
              const Text(
                'Why this verdict?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              ...result.reasons.map(
                (reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          reason,
                          style: const TextStyle(fontSize: 15, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Official links
              if (result.officialLinks.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Official sites:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.officialLinks.map((link) {
                    return Chip(
                      label: Text(
                        link.replaceAll('https://', ''),
                        style: const TextStyle(fontSize: 13),
                      ),
                      backgroundColor: Colors.green.shade50,
                      labelStyle: const TextStyle(color: Colors.green),
                    );
                  }).toList(),
                ),
              ],

              // No official message
              if (result.noOfficialMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.noOfficialMessage!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              Text(
                'Checked ${_formatTime(result.checkedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}