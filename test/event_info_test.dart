import 'package:bladenight_app_flutter/generated/l10n.dart';
import 'package:bladenight_app_flutter/models/event.dart';
import 'package:bladenight_app_flutter/pages/home_info/event_data_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Event Info', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpMyView();

    // Verify that our counter starts at 0.
    expect(find.text('Ost-nn'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

/// Adds the view under test to [WidgetTester]
extension on WidgetTester {
  Future<void> pumpMyView() async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          Localize.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: Localize.delegate.supportedLocales,
        locale: const Locale('de'), // Fixed to ENGLISH
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return EventDataOverview(
                showMap: false,
                nextEvent: Event(
                  startDate: DateTime.now(),
                  routeName: 'Ost-nn',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
