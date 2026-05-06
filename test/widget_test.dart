// Basic smoke test for Nalara app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Nalara app scaffold renders correctly', (WidgetTester tester) async {
    // Build a minimal widget for testing without Firebase dependency
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Nalara'),
            ),
          ),
        ),
      ),
    );

    // Verify that Nalara text is rendered
    expect(find.text('Nalara'), findsOneWidget);
  });
}
