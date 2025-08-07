import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DataLeftWidgetRightTextContent extends StatelessWidget {
  const DataLeftWidgetRightTextContent(
      {super.key, required this.descriptionRight, required this.leftWidget});

  final String descriptionRight;
  final Widget leftWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          children: [
            Builder(builder: (context) => leftWidget),
            const SizedBox(
              width: 2,
            ),
          ],
        ),
        Expanded(
          child: Text(descriptionRight),
        )
      ]),
    );
  }
}
