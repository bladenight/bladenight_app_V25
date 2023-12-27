import 'package:flutter/cupertino.dart';

class DataWidgetLeftRightSmallTextContent extends StatelessWidget {
  const DataWidgetLeftRightSmallTextContent(
      {Key? key,
      required this.descriptionLeft,
      required this.descriptionRight,
      required this.rightWidget})
      : super(key: key);
  final String descriptionLeft;
  final String descriptionRight;
  final Widget rightWidget;
  final double _textSize = 14;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Text(
          descriptionLeft,
          overflow: TextOverflow.fade,
          style: TextStyle(
              fontSize: MediaQuery.textScalerOf(context).scale(_textSize),
              color: CupertinoTheme.of(context).primaryColor),
          maxLines: 1,
        ),
      ),
      Row(
        children: [
          Text(
            descriptionRight,
            style: TextStyle(
                fontSize: MediaQuery.textScalerOf(context).scale(_textSize),
                color: CupertinoTheme.of(context).primaryColor),
          ),
          const SizedBox(
            width: 2,
          ),
          SizedBox(
            width: 20,
            child: Builder(builder: (context) => rightWidget),
          ),
        ],
      )
    ]);
  }
}
