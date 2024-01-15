import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapPinWidget extends StatefulWidget {
  final Color color;
  final String row1Text;
  final String row2Text;
  final String row3Text;
  final String row4Text;
  final Icon? leftIcon;

  const MapPinWidget(
      {super.key,
      required this.color,
      required this.row1Text,
      required this.row2Text,
      required this.row3Text,
      required this.row4Text,
      this.leftIcon});

  @override
  State<StatefulWidget> createState() => _MapPinWidgetState();
}

class _MapPinWidgetState extends State<MapPinWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 10),
                width: 50,
                height: 50,
                child: const ClipOval(
                    child: Icon(
                  CupertinoIcons.person,
                ))),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.row1Text,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          color: widget.color,
                          shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(0.1, 0.1),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            Shadow(
                              offset: Offset(0.3, 0.3),
                              blurRadius: 2.0,
                              color: Color.fromARGB(125, 0, 0, 255),
                            ),
                          ]),
                    ),
                    Text(widget.row2Text,
                        overflow: TextOverflow.visible,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(widget.row3Text,
                        overflow: TextOverflow.visible,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(widget.row4Text,
                        overflow: TextOverflow.visible,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey))
                  ], // end of Column Widgets
                ), // end of Column
              ), // end of Container
            ), // end of Expanded  // second widget
          ],
        ),
      ),
    );
  }
}
