import 'package:flutter_test/flutter_test.dart';
import 'package:trueurl/inspector/inspector.dart';
import 'package:trueurl/models/verdict.dart';

void main() {
  group('TrueURLInspector Tests', () {
    test('Detects official MTN domain', () {
      final result = TrueURLInspector.check('https://mtn.ng');
      expect(result.verdict, VerdictType.official);
      expect(result.title, contains('MTN'));
    });

    test('Detects fake scam pattern in message', () {
      const scamMessage = '''
Davido is gifting 20GB to everyone! 
Click here to claim: https://mtn-data-gift.xyz/claim
Choose your network (MTN, Airtel, Glo)
''';
      final result = TrueURLInspector.check(scamMessage);
      expect(result.verdict, VerdictType.fake);
      expect(result.reasons.any((r) => r.contains('Celebrity')), true);
    });

    test('Detects suspicious TLD', () {
      final result = TrueURLInspector.check('https://jamb-login.xyz/verify');
      expect(result.verdict, VerdictType.beCareful);
    });

    test('Detects official JAMB', () {
      final result = TrueURLInspector.check('https://jamb.gov.ng');
      expect(result.verdict, VerdictType.official);
    });

    test('Handles empty input', () {
      final result = TrueURLInspector.check('');
      expect(result.verdict, VerdictType.unknown);
    });
  });
}