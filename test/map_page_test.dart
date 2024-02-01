import 'package:bladenight_app_flutter/pages/map/map_page.dart';
import 'package:flutter_test/flutter_test.dart';

class MessageTest {
  void main() {
    testWidgets('MapPage ', (WidgetTester tester) async {
      await tester.pumpWidget(const MapPage());

      final titleFinder = find.text('km');
      assert(titleFinder.hasFound == true);
    });
  }
}
