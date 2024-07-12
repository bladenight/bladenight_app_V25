import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../helpers/url_launch_helper.dart';

class OpenStreetMapCopyright extends StatelessWidget {
  const OpenStreetMapCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb
        ? Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.openstreetmap.org/copyright');
              },
              child: const FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 10),
                  child: Text(
                    '© OpenStreetMap',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.openstreetmap.org/copyright');
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  '© OpenStreetMap',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
