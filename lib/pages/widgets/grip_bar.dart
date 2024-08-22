import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class GripBar extends StatelessWidget {
  const GripBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.33 / 2,
          height: 20,
        ),
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: CupertinoTheme.of(context).primaryColor,
                height: 7,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.33 / 2,
          height: 20,
          child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  child: const Icon(material.Icons.close),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  })),
        )
      ],
    );
  }
}
