import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/url_launch_helper.dart';

class BayernAtlasCopyright extends StatelessWidget {
  const BayernAtlasCopyright({super.key});

  final mapCopyright = '© Datenquellen: Bayerische Vermessungsverwaltung,\n'
      'GeoBasis-DE / BKG 2023 - Daten verändert';
  final link = 'https://www.ldbv.bayern.de';
  final copyright =
      '© Datenquellen: Bayerische Vermessungsverwaltung,\nGeoBasis-DE / BKG 2023 – Daten verändert - Bayernatlas Landesamt für Digitalisierung, Breitband und Vermessung';

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
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    mapCopyright,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: fontSize == null ? 10 : fontSize * 0.7,
                        color: Colors.black),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(link, copyright);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  mapCopyright,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: fontSize ?? 30,
                      fontWeight: FontWeight.bold,
                      color: CupertinoTheme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
