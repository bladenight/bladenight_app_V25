import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:universal_io/io.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../providers/app_start_and_router/go_router.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> slides = <ContentConfig>[];
  Function? goToTab;

  @override
  void didChangeDependencies() {
    TextStyle titleStyle = TextStyle(
        color: CupertinoTheme.of(context).primaryColor,
        fontSize: 30.0,
        fontWeight: FontWeight.bold);
    TextStyle descriptionStyle = TextStyle(
        color: CupertinoTheme.of(context).primaryColor,
        fontSize: 20.0,
        fontStyle: FontStyle.normal);
    slides.add(
      ContentConfig(
          title: 'Kurzanleitung\nBladenight App',
          styleTitle: titleStyle,
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          description:
              'Auf den nachfolgenden Seiten gibt es eine kleine Kurzanleitung zur App.\nDiese kann auf dem Infobildschirm jederzeit wieder aufgerufen werden.\nNach links wischen startet Anleitung. Mit ⏩ gehts zur App.',
          styleDescription: descriptionStyle,
          pathImage: 'assets/images/instruction/openinstruction.png',
          foregroundImageFit: BoxFit.scaleDown,
          marginDescription: const EdgeInsets.all(20)),
    );
    slides.add(
      ContentConfig(
          title: 'Infoseite',
          styleTitle: titleStyle,
          widthImage: MediaQuery.of(context).size.width * 0.8,
          heightImage: MediaQuery.of(context).size.height * 0.7,
          styleDescription: descriptionStyle,
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          pathImage: 'assets/images/instruction/infohome.png',
          foregroundImageFit: BoxFit.contain,
          backgroundImageFit: BoxFit.scaleDown,
          marginDescription: const EdgeInsets.only(top: 20)),
    );
    slides.add(
      ContentConfig(
          title: Localize.of(context).settings,
          styleTitle: titleStyle,
          styleDescription: descriptionStyle,
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          pathImage: 'assets/images/instruction/settings.png',
          foregroundImageFit: BoxFit.scaleDown,
          widthImage: MediaQuery.of(context).size.width * 0.8,
          heightImage: MediaQuery.of(context).size.height * 0.7,
          backgroundImageFit: BoxFit.scaleDown,
          marginDescription: const EdgeInsets.only(top: 20)),
    );
    slides.add(
      ContentConfig(
          title: 'Kartenübersicht',
          styleTitle: titleStyle,
          styleDescription: descriptionStyle,
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          pathImage: 'assets/images/instruction/map1.png',
          foregroundImageFit: BoxFit.contain,
          widthImage: MediaQuery.of(context).size.width * 0.8,
          heightImage: MediaQuery.of(context).size.height * 0.7,
          marginDescription: const EdgeInsets.only(top: 20)),
    );
    slides.add(
      ContentConfig(
        title: 'Karte Detail 1',
        styleTitle: titleStyle,
        description:
            'Im oberen Teil der Karte kann man sehen welche Strecke auf der Route man gefahren ist (↦7.6km).\n'
            'Wieviel Prozent der Gesamtstrecke (48.3%).\n'
            'Wie weit es bis zum Ziel ist ⇥8.2km\n'
            'Auf dem Balken wird der Fortschritt und Position der Freunde und des Zuges angezeigt\n'
            '⏱ Σ Welche Durchfahrtzeit hat der Zug (1s)\n'
            '⇥ Wie lange dauert es bis zum Zugende (0s)\n'
            '📏 Wie lang ist der Zug von Anfang bis Ende (0.0km)\n'
            'Route: Name der aktuellen Route\n'
            'Length: Länge der Strecke\n'
            'Tracker - Anzahl der unterstüzenden Teilnehmer (2 Tracker)\n',
        styleDescription: descriptionStyle,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        pathImage: 'assets/images/instruction/map2.png',
        foregroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: 'Karte Detail 2',
        styleTitle: titleStyle,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        pathImage: 'assets/images/instruction/map3.png',
        foregroundImageFit: BoxFit.scaleDown,
        widthImage: MediaQuery.of(context).size.width * 0.8,
        heightImage: MediaQuery.of(context).size.height * 0.7,
        backgroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: 'Karte Detail 3',
        styleTitle: titleStyle,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        pathImage: 'assets/images/instruction/map4.png',
        foregroundImageFit: BoxFit.scaleDown,
        widthImage: MediaQuery.of(context).size.width * 0.8,
        heightImage: MediaQuery.of(context).size.height * 0.7,
        backgroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: 'Events',
        styleTitle: titleStyle,
        pathImage: 'assets/images/instruction/eventsinfo.png',
        foregroundImageFit: BoxFit.scaleDown,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        widthImage: MediaQuery.of(context).size.width * 0.8,
        heightImage: MediaQuery.of(context).size.height * 0.7,
        backgroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: 'Freunde',
        styleTitle: titleStyle,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        description:
            'Du kannst mit der App deine Position mit deinen Freunden austauschen.\nDies funktioniert allerdings nur, solange du selbst und der Freund sein Tracking aktiviert hat.\nFreunde werden über einen Codeaustausch zusammengeführt.\nDer Freund hat 60 Minuten Zeit den übermittelten Code in seiner App online einzugeben.\nDanach verfällt der Code.\nSolange der Code aktiv ist, steht dieser auch in der Freundeliste unter Status.\nWenn du den Standort mit dem Freund nicht mehr teilen möchtest, kannst du den Freund in der Liste löschen.\nEs werden keinerlei persönliche Daten übermittelt, ausser der Nachricht mit dem Dienst deiner Wahl, die du selbst mit dem Code an den Freund schickst',
        styleDescription: descriptionStyle,
        pathImage: 'assets/images/instruction/friends1.png',
        foregroundImageFit: BoxFit.contain,
        backgroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: 'Freunde Detail',
        styleTitle: titleStyle,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        pathImage: 'assets/images/instruction/friends2.png',
        foregroundImageFit: BoxFit.scaleDown,
        widthImage: MediaQuery.of(context).size.width * 0.8,
        heightImage: MediaQuery.of(context).size.height * 0.6,
        backgroundImageFit: BoxFit.scaleDown,
      ),
    );
    slides.add(
      ContentConfig(
        title: "Los geht's",
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        styleTitle: titleStyle,
      ),
    );
    super.didChangeDependencies();
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void _onDonePress() {
    HiveSettingsDB.setHasShownIntro(true);
    if (context.canPop()) {
      context.pop();
    }

    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    //context.goNamed(AppRoute.home.name);
  }

  void _onTabChangeCompleted(index) {
    //will called when next tab changed
    if (slides.length == index + 1) {
      _onDonePress();
    }
  }

  Widget _renderNextBtn() {
    return Icon(Icons.navigate_next,
        color: CupertinoTheme.of(context).primaryColor, size: 35.0);
  }

  Widget _renderDoneBtn() {
    return Text(Localize.current.ok);
  }

  Widget _renderSkipBtn() {
    return Icon(
      Icons.fast_forward,
      size: 35.0,
      color: CupertinoTheme.of(context).primaryColor,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: IntroSlider(
        listContentConfig: slides,
        indicatorConfig: const IndicatorConfig(isShowIndicator: false),
        renderSkipBtn: _renderSkipBtn(),
        renderNextBtn: _renderNextBtn(),
        renderDoneBtn: _renderDoneBtn(),
        isPauseAutoPlayOnTouch: true,
        navigationBarConfig: NavigationBarConfig(
            padding: const EdgeInsets.all(30),
            navPosition:
                Platform.isAndroid ? NavPosition.bottom : NavPosition.bottom,
            backgroundColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withAlpha(20)),
        autoScrollInterval: const Duration(seconds: 8),
        onDonePress: _onDonePress,
        backgroundColorAllTabs:
            CupertinoTheme.of(context).scaffoldBackgroundColor,
        refFuncGoToTab: (refFunc) {
          goToTab = refFunc;
        },
        onTabChangeCompleted: _onTabChangeCompleted,
        onSkipPress: _onDonePress,
      ),
    );
  }
}
