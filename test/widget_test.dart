// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_analyzer/app.dart';
import 'package:health_analyzer/providers/health_provider.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingCompletedProvider.overrideWith((ref) async => false),
        ],
        child: const HealthAnalyzerApp(),
      ),
    );
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 120));
      if (find
          .text('Your fitness data, finally useful.')
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }

    expect(find.text('Health Analyzer'), findsWidgets);
    expect(find.text('Your fitness data, finally useful.'), findsOneWidget);
  });
}
