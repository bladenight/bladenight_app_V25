import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/url_launch_helper.dart';

class BayernAtlasCopyright extends StatelessWidget {
  const BayernAtlasCopyright({super.key});

  final link = 'https://www.ldbv.bayern.de';
  final copyright =
      '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert - Bayernatlas Landesamt für Digitalisierung, Breitband und Vermessung';

  @override
  Widget build(BuildContext context) {
    var fontSize = CupertinoTheme.of(context).textTheme.textStyle.fontSize;
    return kIsWeb
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(link, copyright);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert',
                    style: TextStyle(
                        fontSize: fontSize == null ? 10 : fontSize * 0.8,
                        color: CupertinoTheme.brightnessOf(context) ==
                                Brightness.dark
                            ? Colors.black
                            : Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 0, right: 5),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(link, copyright);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: const Text(
                  '© Datenquellen: Bayerische Vermessungsverwaltung, '
                  'GeoBasis-DE / BKG 2023 – Daten verändert',
                  style: TextStyle(fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
