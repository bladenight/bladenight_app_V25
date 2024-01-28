import 'package:bladenight_app_flutter/pages/widgets/formated_text.dart';
import 'package:flutter_test/flutter_test.dart';

class MessageTest {
  void main() {
    testWidgets('formatting text ', (WidgetTester tester) async {
      var text = 'await <b>MessagesDb</b>.messagesList';
      await tester.pumpWidget(FormatedText(text));

      final titleFinder = find.text('T');
      assert(titleFinder.hasFound == true);
    });
  }
}
