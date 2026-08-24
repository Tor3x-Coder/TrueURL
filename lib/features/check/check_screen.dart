import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trueurl/models/verdict.dart';
import 'package:trueurl/inspector/inspector.dart';
import 'package:trueurl/widgets/verdict_card.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final TextEditingController _controller = TextEditingController();
  CheckResult? _result;
  bool _isChecking = false;
  bool _isMessageMode = false;

  void _performCheck() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isChecking = true;
      _result = null;
    });

    // Simulate slight delay for "inspecting" feel (0.4s)
    await Future.delayed(const Duration(milliseconds: 400));

    final result = TrueURLInspector.check(
      text,
      forceMessageMode: _isMessageMode,
    );

    setState(() {
      _result = result;
      _isChecking = false;
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = null;
      _isMessageMode = false;
    });
  }

  void _copyVerdict() {
    if (_result == null) return;

    final text = '''
TrueURL Verdict: ${_result!.verdict.displayName}

${_result!.title}

${_result!.reasons.join('\n• ')}

${_result!.officialLinks.isNotEmpty ? 'Official links:\n${_result!.officialLinks.join('\n')}' : ''}

Checked with TrueURL — Know before you tap.
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verdict copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrueURL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to history
            },
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // TODO: Navigate to brand book
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isMessageMode = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isMessageMode ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: !_isMessageMode
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                              : null,
                        ),
                        child: const Center(
                          child: Text('Link', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isMessageMode = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isMessageMode ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isMessageMode
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                              : null,
                        ),
                        child: const Center(
                          child: Text('Message', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input area
            TextField(
              controller: _controller,
              maxLines: 6,
              minLines: 3,
              decoration: InputDecoration(
                hintText: _isMessageMode
                    ? 'Paste the full WhatsApp message here...'
                    : 'Paste the link here...',
                prefixIcon: const Icon(Icons.paste),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Check button
            ElevatedButton.icon(
              onPressed: _controller.text.trim().isNotEmpty && !_isChecking
                  ? _performCheck
                  : null,
              icon: _isChecking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.search),
              label: Text(_isChecking ? 'Inspecting...' : 'Check Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
            const SizedBox(height: 32),

            // Result
            if (_result != null) ...[
              VerdictCard(result: _result!),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyVerdict,
                      icon: const Icon(Icons.copy),
                      label: const Text('Share to WhatsApp'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Check Another'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}