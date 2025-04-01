import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../helpers/url_launch_helper.dart';

class BayernAtlasCopyright extends StatelessWidget {
  const BayernAtlasCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    var fontSize = CupertinoTheme.of(context).textTheme.textStyle.fontSize;
    return kIsWeb
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.bkg.bund.de/DE/Home/home.html',
                    'Bundesamt für Kartographie und Geodäsie');
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert',
                  style: TextStyle(
                      fontSize: fontSize == null ? 12 : fontSize * 0.8),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 0, right: 5),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.bkg.bund.de/DE/Home/home.html',
                    'Bundesamt für Kartographie und Geodäsie ');
              },
              child: const Text(
                '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
