import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';
import '../helpers/url_launch_helper.dart';
import 'widgets/about_page/privacy.dart';
import 'widgets/version_widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();

  static Future<void> show(BuildContext context) async {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => const AboutPage()));
  }
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(Localize.of(context).about_bnapp),
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(1),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VersionWidget(),
                _sizedWidget(context),
                _aboutAppWidget(context),
                _sizedWidget(context),
                const PrivacyContent(),
                _sizedWidget(context),
                _feedBackWidget(context),
                _sizedWidget(context),
                _homePageWidget(context),
                _sizedWidget(context),
                _impressumWidget(context),
                _sizedWidget(context),
                _flutterAppWidget2023(context),
                _flutterAppWidget2022(context),
                _androidApp2014to2022Widget(context),
                _androidApp2013Widget(context),
                _sizedWidget(context),
                _serverAppWidget(context),
                _sizedWidget(context),
                _licenceWidget(context),
                _sizedWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _sizedWidget(BuildContext context) {
  return const SizedBox(
    height: 20,
  );
}

Widget _aboutAppWidget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_bnapp,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Text(
        Localize.of(context).about_appinfo,
        overflow: TextOverflow.visible,
      ),
    ],
  );
}

Widget _impressumWidget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_impressum,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_impressum,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}

Widget _homePageWidget(BuildContext context) {
  var url = 'http://skatemunich.de';
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(Localize.of(context).about_h_homepage,
            style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
        Column(children: [
          GestureDetector(
            onTap: () {
              Launch.launchUrlFromString(url);
            },
            child: (Text(url,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle)),
          ),
        ]),
      ]);
}

Widget _feedBackWidget(BuildContext context) {
  Uri serviceurl = Uri(
    scheme: 'mailto',
    path: 'service@skatemunich.de',
  );
  Uri supporturl = Uri(
    scheme: 'mailto',
    path: 'it@huth.app',
  );

  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(Localize.of(context).about_h_feedback,
            style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(Localize.of(context).about_feedback,
                  style:
                      CupertinoTheme.of(context).textTheme.navTitleTextStyle),
              GestureDetector(
                onTap: () async {
                  Launch.launchUrlFromUri(
                    serviceurl,
                  );
                },
                child: (Text(serviceurl.path,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle)),
              ),
            ]),
        const SizedBox(
          height: 5,
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(Localize.of(context).appsupport,
                  style:
                      CupertinoTheme.of(context).textTheme.navActionTextStyle),
              GestureDetector(
                onTap: () async {
                  Launch.launchUrlFromUri(supporturl);
                },
                child: (Text(supporturl.path,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle)),
              ),
            ]),
      ]);
}

Widget _flutterAppWidget2023(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_androidapplicationflutter_23,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_lars,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}

Widget _flutterAppWidget2022(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_androidapplicationflutter,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_kilianlars,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}

Widget _androidApp2014to2022Widget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_androidapplicationv2,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_olivier,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}

Widget _androidApp2013Widget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_androidapplicationv1,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_olivierandbenjamin,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}

Widget _serverAppWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(Localize.of(context).about_h_serverapp,
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
      Row(
        children: [
          Expanded(
            child: Text(Localize.of(context).about_olivier,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
        ],
      ),
    ],
  );
}



Widget _licenceWidget(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(Localize.of(context).about_h_licences,
        style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
    Row(
      children: <Widget>[
        Expanded(
          child: Text(Localize.of(context).about_licences,
              overflow: TextOverflow.clip,
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        // more widgets
      ],
    )
  ]);
}
