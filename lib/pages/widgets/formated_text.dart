import 'package:flutter/material.dart';

class FormatedText extends StatelessWidget {
  final String text;

  const FormatedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    var widgets = _createWidgetList(text);

    return RichText(
      text: TextSpan(
        children: widgets,
      ),
    );
  }
}
//Dein Freund muss in max. 2 m Entfernung von Dir sein!\n
// <ul>Bitte bei deinem Freund in der Bladenight-App den Tab Freunde öffnen lassen.</ul>
// <ul>Dort Plus oben rechts wählen</ul>
// <ul>Freund:in neben Dir annehmen wählen</ul><ul>Nun mit diesem Gerät <b>{deviceName}</b> koppeln.</ul>
// Du kannst deinen übermittelten Namen im Textfeld oben ändern.",
//
List<InlineSpan> _createWidgetList(String text) {
  const regexBold = '<b>(.*?)</b>';
  const regexList = '<ul>(.*?)</ul>';
  const regexItalic = '<i>(.*?)</i>';
  const regexStrong = '<strong>(.*?)</strong>';
  const regexEmoji = '<emoji>(.*?)</emoji>';

  final widgets = <InlineSpan>[];
  final regexAll = RegExp('<([a-z]+)(.*?)(?![^>]*/>)[^>]*>');
  final matches = regexAll.allMatches(text);

  var currentIndex = 0;
  for (final match in matches) {
    final beforeText = text.substring(currentIndex, match.start);

    if (beforeText.isNotEmpty) {
      widgets.add(
        TextSpan(
          text: beforeText,
        ),
      );
    }

    // 1 regexBold
    // 2 regexList
    // 3 regexItalic
    // 4 strong
    if (match.group(1) != null) {
      //bold
      widgets.addAll(_createWidgetListParts('<b>${match.group(1)!}</b>'));
    } else if (match.group(2) != null) {
      //<ul> </ul>
      widgets.addAll(_createWidgetListParts('<ul>${match.group(2)!}</ul>'));
    } else if (match.group(3) != null) {
      widgets.addAll(_createWidgetListParts('<i>${match.group(3)!}</i>'));
    } else if (match.group(4) != null) {
      widgets.addAll(
          _createWidgetListParts('<strong>${match.group(4)!}</strong>'));
    }
    currentIndex = match.end;
  }
  final remainingText = text.substring(currentIndex);
  if (remainingText.isNotEmpty) {
    widgets.add(
      TextSpan(
        text: remainingText,
      ),
    );
  }
  return widgets;
}

List<InlineSpan> _createWidgetListParts(String text) {
  const regexBold = '<b>(.*?)</b>';
  const regexList = '<ul>(.*?)</ul>';
  const regexItalic = '<i>(.*?)</i>';
  const regexStrong = '<strong>(.*?)</strong>';
  const regexEmoji = '<emoji>(.*?)</emoji>';

  final widgets = <InlineSpan>[];
  final regexAll = RegExp('$regexBold|$regexList|$regexItalic|$regexStrong');
  final matches = regexAll.allMatches(text);

  var currentIndex = 0;
  for (final match in matches) {
    final beforeText = text.substring(currentIndex, match.start);

    if (beforeText.isNotEmpty) {
      widgets.add(
        TextSpan(
          text: beforeText,
        ),
      );
    }

    // 1 regexBold
    // 2 regexList
    // 3 regexItalic
    // 4 strong
    if (match.group(1) != null) {
      //bold
      widgets.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold)));
    } else if (match.group(2) != null) {
      //<ul> </ul>
      widgets.add(
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '* ',
                  style: TextStyle(),
                ),
                Text(
                  (match.group(2)!),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (match.group(3) != null) {
      widgets.add(TextSpan(
          text: match.group(3),
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          )));
    } else if (match.group(4) != null) {
      widgets.add(TextSpan(
          text: match.group(4),
          style: const TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w900)));
    }
    currentIndex = match.end;
  }
  final remainingText = text.substring(currentIndex);
  if (remainingText.isNotEmpty) {
    widgets.add(
      TextSpan(
        text: remainingText,
      ),
    );
  }
  return widgets;
}
