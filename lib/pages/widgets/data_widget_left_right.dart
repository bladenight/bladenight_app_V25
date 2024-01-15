import 'package:flutter/cupertino.dart';

class DataLeftRightContent extends StatelessWidget {
  const DataLeftRightContent(
      {super.key,
      required this.descriptionLeft,
      required this.descriptionRight,
      required this.rightWidget});
  final String descriptionLeft;
  final String descriptionRight;
  final Widget rightWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(
            descriptionLeft,
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
        ),
        Row(
          children: [
            Text(descriptionRight),
            const SizedBox(
              width: 2,
            ),
            Builder(builder: (context) => rightWidget),
          ],
        )
      ]),
    );
  }
}
