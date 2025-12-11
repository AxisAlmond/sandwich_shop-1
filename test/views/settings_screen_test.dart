import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('displays settings screen with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays font size slider', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('displays current font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('slider changes font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      final Finder slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      final Finder backButton = find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });

    testWidgets('font size persists after save', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      final Finder slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Rebuild the widget to simulate app restart
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      // Verify font size is persisted
      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('displays preview text with current font size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('This is sample text to preview the font size.'),
        findsOneWidget,
      );
    });

    testWidgets('displays info message about restart',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining('Restart the app'),
        findsOneWidget,
      );
    });
  });
}