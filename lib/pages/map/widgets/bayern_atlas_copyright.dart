import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../helpers/url_launch_helper.dart';

class BayernAtlasCopyright extends StatelessWidget {
  const BayernAtlasCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb
        ? Padding(
            padding: const EdgeInsets.only(left: 0, right: 5),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.bkg.bund.de/DE/Home/home.html');
              },
              child: const Text(
                '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Launch.launchUrlFromString(
                    'https://www.bkg.bund.de/DE/Home/home.html');
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  '© Datenquellen: Bayerische Vermessungsverwaltung, GeoBasis-DE / BKG 2023 – Daten verändert',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
