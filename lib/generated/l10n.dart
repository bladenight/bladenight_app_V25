// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Localize {
  Localize();

  static Localize? _current;

  static Localize get current {
    assert(_current != null,
        'No instance of Localize was loaded. Try to initialize the Localize delegate before accessing Localize.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Localize> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Localize();
      Localize._current = instance;

      return instance;
    });
  }

  static Localize of(BuildContext context) {
    final instance = Localize.maybeOf(context);
    assert(instance != null,
        'No instance of Localize present in the widget tree. Did you add Localize.delegate in localizationsDelegates?');
    return instance!;
  }

  static Localize? maybeOf(BuildContext context) {
    return Localizations.of<Localize>(context, Localize);
  }

  /// `am`
  String get at {
    return Intl.message(
      'am',
      name: 'at',
      desc: '',
      args: [],
    );
  }

  /// `Firebase Crashlytics`
  String get about_h_crashlytics {
    return Intl.message(
      'Firebase Crashlytics',
      name: 'about_h_crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `Um die Stabilität und Zuverlässigkeit dieser App zu verbessern, sind wir auf anonymisierte Absturzberichte angewiesen. Wir nutzen hierzu „Firebase Crashlytics“, ein Dienst der Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIm Falle eines Absturzes werden anonyme Informationen an die Server von Google in die USA übertragen (Zustand der App zum Zeitpunkt des Absturzes, Installation UUID, Crash-Trace, Hersteller und Betriebssystem des Handys, letzte Log-Meldungen). Diese Informationen enthalten keine personenbezogenen Daten.\n\nAbsturzberichte werden nur mit Ihrer ausdrücklichen Zustimmung versendet. Bei der Verwendung von iOS-Apps können Sie die Zustimmung in den Einstellungen der App oder nach einem Absturz erteilen. Bei Android-Apps besteht bei der Einrichtung des mobilen Endgeräts die Möglichkeit, generell der Übermittlung von Absturzbenachrichtigungen an Google und App-Entwickler zuzustimmen.\n\nRechtsgrundlage für die Datenübermittlung ist Art. 6 Abs. 1 lit. a DSGVO.\n\nSie können Ihre Einwilligung jederzeit widerrufen indem Sie in den Einstellungen der iOS-Apps die Funktion „Absturzberichte“ deaktivieren (in den Magazin-Apps befindet sich der Eintrag im Menüpunkt „Kommunikation“).\n\nBei den Android-Apps erfolgt die Deaktivierung grundlegend in den Android-Einstellungen. Öffnen Sie hierzu die Einstellungen App, wählen den Punkt „Google“ und dort im Dreipunkt-Menü oben rechts den Menüpunkt „Nutzung & Diagnose“. Hier können Sie das Senden der entsprechenden Daten deaktivieren. Weitere Informationen finden Sie in der Hilfe zu Ihrem Google-Konto.\n\nWeitere Informationen zum Datenschutz erhalten Sie in den Datenschutzhinweisen von Firebase Crashlytics unter https://firebase.google.com/support/privacy sowie https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies`
  String get about_crashlytics {
    return Intl.message(
      'Um die Stabilität und Zuverlässigkeit dieser App zu verbessern, sind wir auf anonymisierte Absturzberichte angewiesen. Wir nutzen hierzu „Firebase Crashlytics“, ein Dienst der Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIm Falle eines Absturzes werden anonyme Informationen an die Server von Google in die USA übertragen (Zustand der App zum Zeitpunkt des Absturzes, Installation UUID, Crash-Trace, Hersteller und Betriebssystem des Handys, letzte Log-Meldungen). Diese Informationen enthalten keine personenbezogenen Daten.\n\nAbsturzberichte werden nur mit Ihrer ausdrücklichen Zustimmung versendet. Bei der Verwendung von iOS-Apps können Sie die Zustimmung in den Einstellungen der App oder nach einem Absturz erteilen. Bei Android-Apps besteht bei der Einrichtung des mobilen Endgeräts die Möglichkeit, generell der Übermittlung von Absturzbenachrichtigungen an Google und App-Entwickler zuzustimmen.\n\nRechtsgrundlage für die Datenübermittlung ist Art. 6 Abs. 1 lit. a DSGVO.\n\nSie können Ihre Einwilligung jederzeit widerrufen indem Sie in den Einstellungen der iOS-Apps die Funktion „Absturzberichte“ deaktivieren (in den Magazin-Apps befindet sich der Eintrag im Menüpunkt „Kommunikation“).\n\nBei den Android-Apps erfolgt die Deaktivierung grundlegend in den Android-Einstellungen. Öffnen Sie hierzu die Einstellungen App, wählen den Punkt „Google“ und dort im Dreipunkt-Menü oben rechts den Menüpunkt „Nutzung & Diagnose“. Hier können Sie das Senden der entsprechenden Daten deaktivieren. Weitere Informationen finden Sie in der Hilfe zu Ihrem Google-Konto.\n\nWeitere Informationen zum Datenschutz erhalten Sie in den Datenschutzhinweisen von Firebase Crashlytics unter https://firebase.google.com/support/privacy sowie https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies',
      name: 'about_crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `OneSignal Datenschutzerklärung`
  String get about_h_oneSignalPrivacy {
    return Intl.message(
      'OneSignal Datenschutzerklärung',
      name: 'about_h_oneSignalPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Wir verwenden für unsere Website OneSignal, eine Mobile-Marketing-Plattform. Dienstanbieter ist das amerikanische Unternehmen OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal verarbeitet Daten u.a. auch in den USA. Wir weisen darauf hin, dass nach Meinung des Europäischen Gerichtshofs derzeit kein angemessenes Schutzniveau für den Datentransfer in die USA besteht. Dies kann mit verschiedenen Risiken für die Rechtmäßigkeit und Sicherheit der Datenverarbeitung einhergehen.\n\nAls Grundlage der Datenverarbeitung bei Empfängern mit Sitz in Drittstaaten (außerhalb der Europäischen Union, Island, Liechtenstein, Norwegen, also insbesondere in den USA) oder einer Datenweitergabe dorthin verwendet OneSignal von der EU-Kommission genehmigte Standardvertragsklauseln (= Art. 46. Abs. 2 und 3 DSGVO). Diese Klauseln verpflichten OneSignal, das EU-Datenschutzniveau bei der Verarbeitung relevanter Daten auch außerhalb der EU einzuhalten. Diese Klauseln basieren auf einem Durchführungsbeschluss der EU-Kommission. Sie finden den Beschluss sowie die Klauseln u.a. hier: https://germany.representation.ec.europa.eu/index_de.\n\nMehr über die Daten, die durch die Verwendung von OneSignal verarbeitet werden, erfahren Sie in der Privacy Policy auf https://onesignal.com/privacy.\n\nAlle Texte sind urheberrechtlich geschützt.\n\nQuelle: Erstellt mit dem Datenschutz Generator von AdSimple`
  String get about_oneSignalPrivacy {
    return Intl.message(
      'Wir verwenden für unsere Website OneSignal, eine Mobile-Marketing-Plattform. Dienstanbieter ist das amerikanische Unternehmen OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal verarbeitet Daten u.a. auch in den USA. Wir weisen darauf hin, dass nach Meinung des Europäischen Gerichtshofs derzeit kein angemessenes Schutzniveau für den Datentransfer in die USA besteht. Dies kann mit verschiedenen Risiken für die Rechtmäßigkeit und Sicherheit der Datenverarbeitung einhergehen.\n\nAls Grundlage der Datenverarbeitung bei Empfängern mit Sitz in Drittstaaten (außerhalb der Europäischen Union, Island, Liechtenstein, Norwegen, also insbesondere in den USA) oder einer Datenweitergabe dorthin verwendet OneSignal von der EU-Kommission genehmigte Standardvertragsklauseln (= Art. 46. Abs. 2 und 3 DSGVO). Diese Klauseln verpflichten OneSignal, das EU-Datenschutzniveau bei der Verarbeitung relevanter Daten auch außerhalb der EU einzuhalten. Diese Klauseln basieren auf einem Durchführungsbeschluss der EU-Kommission. Sie finden den Beschluss sowie die Klauseln u.a. hier: https://germany.representation.ec.europa.eu/index_de.\n\nMehr über die Daten, die durch die Verwendung von OneSignal verarbeitet werden, erfahren Sie in der Privacy Policy auf https://onesignal.com/privacy.\n\nAlle Texte sind urheberrechtlich geschützt.\n\nQuelle: Erstellt mit dem Datenschutz Generator von AdSimple',
      name: 'about_oneSignalPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Die App wird kostenfrei vom Herausgeber zur Information zur Münchener Bladnight, für Skatemunich e.V. und dessen Sponsoren bereitgestellt.\nDie App bietet allen BladeNight Teilnehmern folgende Funktionen an:\n\t-Übersicht der kommenden und vergangenen Termine\n- Anzeige der Strecken auf der Karte\n- Live Anzeige des Zuges während der BladeNight\n- Live Anzeige der eigenen Position auf der Strecke und innerhalb des Zuges\n- Freunde hinzufügen und Live verfolgen`
  String get about_appinfo {
    return Intl.message(
      'Die App wird kostenfrei vom Herausgeber zur Information zur Münchener Bladnight, für Skatemunich e.V. und dessen Sponsoren bereitgestellt.\nDie App bietet allen BladeNight Teilnehmern folgende Funktionen an:\n\t-Übersicht der kommenden und vergangenen Termine\n- Anzeige der Strecken auf der Karte\n- Live Anzeige des Zuges während der BladeNight\n- Live Anzeige der eigenen Position auf der Strecke und innerhalb des Zuges\n- Freunde hinzufügen und Live verfolgen',
      name: 'about_appinfo',
      desc: '',
      args: [],
    );
  }

  /// `Diese App benutzt eine eindeutige Id die beim ersten Start der App lokal gespeichert wird.\nDiese Id wird auf dem Server benutzt um Freunde zu verknüpfen und die Position zu teilen. Diese wird nur zwischen der eigenen App und Server übertragen.\nWeiterhin wird die App-Versionsnummer und Telefonhersteller (Apple oder Android) zur Prüfung der korrekten Kommunikation übermittelt.\nDie Id ist auf dem Server mit den verknüpften Freunden gespeichert.\nDas Löschen und Neuinstallieren der App löscht die Id und die Freunde müssen neu verknüpft werden, da die Id nicht wiederhergestellt werden kann.\nDie Daten werden nicht an Dritte weitergegeben oder anderweitig verwendet.\nDeine Standortdaten werden während der Veranstaltung benutzt um Start und Ende des Zuges auf der Strecke zu berechnen und darzustellen und die Entfernung zu Freunden und zum Ziel zu berechnen.\nEs werden keine persönlichen Daten erfasst. Die Namen der Freunde sind nur lokal in der App gespeichert.\nDas Benutzen der Emailfunktion und Webseite von Skatemunich unterliegt den Datenschutzbestimmungen von Skatemunich (https://www.skatemunich.de/datenschutzerklaerung/)\nDer Quellcode ist Opensource und kann jederzeit eingesehen werden.`
  String get about_appprivacy {
    return Intl.message(
      'Diese App benutzt eine eindeutige Id die beim ersten Start der App lokal gespeichert wird.\nDiese Id wird auf dem Server benutzt um Freunde zu verknüpfen und die Position zu teilen. Diese wird nur zwischen der eigenen App und Server übertragen.\nWeiterhin wird die App-Versionsnummer und Telefonhersteller (Apple oder Android) zur Prüfung der korrekten Kommunikation übermittelt.\nDie Id ist auf dem Server mit den verknüpften Freunden gespeichert.\nDas Löschen und Neuinstallieren der App löscht die Id und die Freunde müssen neu verknüpft werden, da die Id nicht wiederhergestellt werden kann.\nDie Daten werden nicht an Dritte weitergegeben oder anderweitig verwendet.\nDeine Standortdaten werden während der Veranstaltung benutzt um Start und Ende des Zuges auf der Strecke zu berechnen und darzustellen und die Entfernung zu Freunden und zum Ziel zu berechnen.\nEs werden keine persönlichen Daten erfasst. Die Namen der Freunde sind nur lokal in der App gespeichert.\nDas Benutzen der Emailfunktion und Webseite von Skatemunich unterliegt den Datenschutzbestimmungen von Skatemunich (https://www.skatemunich.de/datenschutzerklaerung/)\nDer Quellcode ist Opensource und kann jederzeit eingesehen werden.',
      name: 'about_appprivacy',
      desc: '',
      args: [],
    );
  }

  /// `Über die BladeNight App`
  String get about_bnapp {
    return Intl.message(
      'Über die BladeNight App',
      name: 'about_bnapp',
      desc: '',
      args: [],
    );
  }

  /// `Dein Feedback ist willkommen.\nSende uns eine E-Mail an:`
  String get about_feedback {
    return Intl.message(
      'Dein Feedback ist willkommen.\nSende uns eine E-Mail an:',
      name: 'about_feedback',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight-App iOS/Android (2023)`
  String get about_h_androidapplicationflutter_23 {
    return Intl.message(
      'BladeNight-App iOS/Android (2023)',
      name: 'about_h_androidapplicationflutter_23',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight-App iOS/Android (2022)`
  String get about_h_androidapplicationflutter {
    return Intl.message(
      'BladeNight-App iOS/Android (2022)',
      name: 'about_h_androidapplicationflutter',
      desc: '',
      args: [],
    );
  }

  /// `Android App V1 (2013)`
  String get about_h_androidapplicationv1 {
    return Intl.message(
      'Android App V1 (2013)',
      name: 'about_h_androidapplicationv1',
      desc: '',
      args: [],
    );
  }

  /// `Android App V2 (2014-2022)`
  String get about_h_androidapplicationv2 {
    return Intl.message(
      'Android App V2 (2014-2022)',
      name: 'about_h_androidapplicationv2',
      desc: '',
      args: [],
    );
  }

  /// `Android App V3 (2023)`
  String get about_h_androidapplicationv3 {
    return Intl.message(
      'Android App V3 (2023)',
      name: 'about_h_androidapplicationv3',
      desc: '',
      args: [],
    );
  }

  /// `Lars Huth`
  String get about_lars {
    return Intl.message(
      'Lars Huth',
      name: 'about_lars',
      desc: '',
      args: [],
    );
  }

  /// `Wofür ist die App`
  String get about_h_bnapp {
    return Intl.message(
      'Wofür ist die App',
      name: 'about_h_bnapp',
      desc: '',
      args: [],
    );
  }

  /// `Feedback zur BladeNight`
  String get about_h_feedback {
    return Intl.message(
      'Feedback zur BladeNight',
      name: 'about_h_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Internetseite`
  String get about_h_homepage {
    return Intl.message(
      'Internetseite',
      name: 'about_h_homepage',
      desc: '',
      args: [],
    );
  }

  /// `Impressum`
  String get about_h_impressum {
    return Intl.message(
      'Impressum',
      name: 'about_h_impressum',
      desc: '',
      args: [],
    );
  }

  /// `Lizenzen`
  String get about_h_licences {
    return Intl.message(
      'Lizenzen',
      name: 'about_h_licences',
      desc: '',
      args: [],
    );
  }

  /// `Open Street Map Datenschutzerklärung`
  String get about_h_open_street_map {
    return Intl.message(
      'Open Street Map Datenschutzerklärung',
      name: 'about_h_open_street_map',
      desc: '',
      args: [],
    );
  }

  /// `Daten, die wir automatisch erhalten\n\nDie OSMF betreibt eine Reihe von Diensten für die OpenStreetMap-Gemeinschaft, z. B. die Website openstreetmap.org, die Online-Karte im "Standard"-Stil, die OSM-API und die Nominatim-Suchfunktion.\n\nWenn Sie eine OSMF-Website besuchen, über einen Browser oder über Anwendungen, die die bereitgestellten APIs nutzen, auf einen der Dienste zugreifen, werden Aufzeichnungen über diese Nutzung erstellt, wir sammeln Informationen über Ihren Browser oder Ihre Anwendung und Ihre Interaktion mit unserer Website, einschließlich (a) IP-Adresse, (b) Browser- und Gerätetyp, (c) Betriebssystem, (d) verweisende Webseite, (e) Datum und Uhrzeit der Seitenbesuche und (f) die auf unseren Websites aufgerufenen Seiten.\n\nDarüber hinaus können wir Software zur Verfolgung der Benutzerinteraktion einsetzen, die zusätzliche Aufzeichnungen über die Benutzeraktivität erstellt, z. B. Piwik.\n\nDienste, die Geo-DNS oder ähnliche Mechanismen verwenden, um die Last auf geografisch verteilte Server zu verteilen, erzeugen möglicherweise eine Aufzeichnung Ihres Standorts in großem Umfang (z. B. ermittelt das OSMF-Kachel-Cache-Netzwerk das Land, in dem Sie sich wahrscheinlich befinden, und leitet Ihre Anfragen an einen entsprechenden Server weiter).\n\nDiese Aufzeichnungen werden auf folgende Weise verwendet oder können verwendet werden:\n\nzur Unterstützung des Betriebs der Dienste aus technischer, sicherheitstechnischer und planerischer Sicht.\nals anonymisierte, zusammengefasste Daten für Forschungs- und andere Zwecke. Solche Daten können über https://planet.openstreetmap.org oder andere Kanäle öffentlich angeboten und von Dritten genutzt werden.\num den OpenStreetMap-Datensatz zu verbessern. Zum Beispiel durch die Analyse von Nominatim-Abfragen auf fehlende Adressen und Postleitzahlen und die Bereitstellung solcher Daten für die OSM-Community.\nDie auf den Systemen gesammelten Daten sind für die Systemadministratoren und die entsprechenden OSMF-Arbeitsgruppen, z. B. die Datenarbeitsgruppe, zugänglich. Es werden keine persönlichen Informationen oder Informationen, die mit einer Person in Verbindung gebracht werden können, an Dritte weitergegeben, es sei denn, dies ist gesetzlich vorgeschrieben.\n\nDie von Piwik gespeicherten IP-Adressen werden auf zwei Bytes gekürzt und die detaillierten Nutzungsdaten werden 180 Tage lang aufbewahrt.\n\nDa diese Speicherung nur vorübergehend erfolgt, ist es uns im Allgemeinen nicht möglich, Zugang zu IP-Adressen oder den damit verbundenen Protokollen zu gewähren.\n\nDie oben genannten Daten werden auf der Grundlage eines berechtigten Interesses verarbeitet (siehe Artikel 6 Absatz 1 Buchstabe f der DSGVO).`
  String get about_open_street_map {
    return Intl.message(
      'Daten, die wir automatisch erhalten\n\nDie OSMF betreibt eine Reihe von Diensten für die OpenStreetMap-Gemeinschaft, z. B. die Website openstreetmap.org, die Online-Karte im "Standard"-Stil, die OSM-API und die Nominatim-Suchfunktion.\n\nWenn Sie eine OSMF-Website besuchen, über einen Browser oder über Anwendungen, die die bereitgestellten APIs nutzen, auf einen der Dienste zugreifen, werden Aufzeichnungen über diese Nutzung erstellt, wir sammeln Informationen über Ihren Browser oder Ihre Anwendung und Ihre Interaktion mit unserer Website, einschließlich (a) IP-Adresse, (b) Browser- und Gerätetyp, (c) Betriebssystem, (d) verweisende Webseite, (e) Datum und Uhrzeit der Seitenbesuche und (f) die auf unseren Websites aufgerufenen Seiten.\n\nDarüber hinaus können wir Software zur Verfolgung der Benutzerinteraktion einsetzen, die zusätzliche Aufzeichnungen über die Benutzeraktivität erstellt, z. B. Piwik.\n\nDienste, die Geo-DNS oder ähnliche Mechanismen verwenden, um die Last auf geografisch verteilte Server zu verteilen, erzeugen möglicherweise eine Aufzeichnung Ihres Standorts in großem Umfang (z. B. ermittelt das OSMF-Kachel-Cache-Netzwerk das Land, in dem Sie sich wahrscheinlich befinden, und leitet Ihre Anfragen an einen entsprechenden Server weiter).\n\nDiese Aufzeichnungen werden auf folgende Weise verwendet oder können verwendet werden:\n\nzur Unterstützung des Betriebs der Dienste aus technischer, sicherheitstechnischer und planerischer Sicht.\nals anonymisierte, zusammengefasste Daten für Forschungs- und andere Zwecke. Solche Daten können über https://planet.openstreetmap.org oder andere Kanäle öffentlich angeboten und von Dritten genutzt werden.\num den OpenStreetMap-Datensatz zu verbessern. Zum Beispiel durch die Analyse von Nominatim-Abfragen auf fehlende Adressen und Postleitzahlen und die Bereitstellung solcher Daten für die OSM-Community.\nDie auf den Systemen gesammelten Daten sind für die Systemadministratoren und die entsprechenden OSMF-Arbeitsgruppen, z. B. die Datenarbeitsgruppe, zugänglich. Es werden keine persönlichen Informationen oder Informationen, die mit einer Person in Verbindung gebracht werden können, an Dritte weitergegeben, es sei denn, dies ist gesetzlich vorgeschrieben.\n\nDie von Piwik gespeicherten IP-Adressen werden auf zwei Bytes gekürzt und die detaillierten Nutzungsdaten werden 180 Tage lang aufbewahrt.\n\nDa diese Speicherung nur vorübergehend erfolgt, ist es uns im Allgemeinen nicht möglich, Zugang zu IP-Adressen oder den damit verbundenen Protokollen zu gewähren.\n\nDie oben genannten Daten werden auf der Grundlage eines berechtigten Interesses verarbeitet (siehe Artikel 6 Absatz 1 Buchstabe f der DSGVO).',
      name: 'about_open_street_map',
      desc: '',
      args: [],
    );
  }

  /// `Mehr informationen`
  String get about_h_moreinfo {
    return Intl.message(
      'Mehr informationen',
      name: 'about_h_moreinfo',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get about_h_privacy {
    return Intl.message(
      'Privacy',
      name: 'about_h_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Serverprogrammierung`
  String get about_h_serverapp {
    return Intl.message(
      'Serverprogrammierung',
      name: 'about_h_serverapp',
      desc: '',
      args: [],
    );
  }

  /// `Version:`
  String get about_h_version {
    return Intl.message(
      'Version:',
      name: 'about_h_version',
      desc: '',
      args: [],
    );
  }

  /// `Betreiber und Veranstalter der Münchener BladeNight:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nVertreten durch:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de`
  String get about_impressum {
    return Intl.message(
      'Betreiber und Veranstalter der Münchener BladeNight:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nVertreten durch:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de',
      name: 'about_impressum',
      desc: '',
      args: [],
    );
  }

  /// `Kilian Schulte\nLars Huth`
  String get about_kilianlars {
    return Intl.message(
      'Kilian Schulte\nLars Huth',
      name: 'about_kilianlars',
      desc: '',
      args: [],
    );
  }

  /// `GNU General Public License v3.0`
  String get about_licences {
    return Intl.message(
      'GNU General Public License v3.0',
      name: 'about_licences',
      desc: '',
      args: [],
    );
  }

  /// `Olivier Croquette`
  String get about_olivier {
    return Intl.message(
      'Olivier Croquette',
      name: 'about_olivier',
      desc: '',
      args: [],
    );
  }

  /// `Benjamin Uekermann\nOlivier Croquette`
  String get about_olivierandbenjamin {
    return Intl.message(
      'Benjamin Uekermann\nOlivier Croquette',
      name: 'about_olivierandbenjamin',
      desc: '',
      args: [],
    );
  }

  /// `Aktuelle Informationen`
  String get actualInformations {
    return Intl.message(
      'Aktuelle Informationen',
      name: 'actualInformations',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in mit Code hinzufügen`
  String get addfriendwithcode {
    return Intl.message(
      'Freund:in mit Code hinzufügen',
      name: 'addfriendwithcode',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in neu anlegen`
  String get addnewfriend {
    return Intl.message(
      'Freund:in neu anlegen',
      name: 'addnewfriend',
      desc: '',
      args: [],
    );
  }

  /// `vor mir`
  String get aheadOfMe {
    return Intl.message(
      'vor mir',
      name: 'aheadOfMe',
      desc: '',
      args: [],
    );
  }

  /// `Standortfreigabe permanent verweigert oder im System gesperrt!`
  String get alwaysPermanentlyDenied {
    return Intl.message(
      'Standortfreigabe permanent verweigert oder im System gesperrt!',
      name: 'alwaysPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Standortfreigabe für 'Immer erlauben' scheint permanent verboten!`
  String get alwaysPermantlyDenied {
    return Intl.message(
      'Standortfreigabe für \'Immer erlauben\' scheint permanent verboten!',
      name: 'alwaysPermantlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Appversion veralted!\nBitte im Store aktualisieren.`
  String get appOutDated {
    return Intl.message(
      'Appversion veralted!\nBitte im Store aktualisieren.',
      name: 'appOutDated',
      desc: '',
      args: [],
    );
  }

  /// `App-Support/ Feedback/ Vorschläge`
  String get appsupport {
    return Intl.message(
      'App-Support/ Feedback/ Vorschläge',
      name: 'appsupport',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight`
  String get appTitle {
    return Intl.message(
      'BladeNight',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Wir schützen uns um Ihre Privatsphäre und Datensicherheit.\nUm uns dabei zu helfen, das BladeNight-Erlebnis zu verbessern, übertragen wir Ihren Standort auf unseren Server. Dies Information beinhaltet eine beim ersten Start der App erstellte eindeutige ID, um die Zuordnung der Freunde zu ermöglichen. Diese Daten werden niemals an Dritte weitergegeben oder für Werbezwecke verwendet.`
  String get apptrackingtransparancy {
    return Intl.message(
      'Wir schützen uns um Ihre Privatsphäre und Datensicherheit.\nUm uns dabei zu helfen, das BladeNight-Erlebnis zu verbessern, übertragen wir Ihren Standort auf unseren Server. Dies Information beinhaltet eine beim ersten Start der App erstellte eindeutige ID, um die Zuordnung der Freunde zu ermöglichen. Diese Daten werden niemals an Dritte weitergegeben oder für Werbezwecke verwendet.',
      name: 'apptrackingtransparancy',
      desc: '',
      args: [],
    );
  }

  /// `Durch langes drücken auf ▶️ wird der automatische Trackingstopp aktiviert. Das heißt, solange die App geöffnet ist, wird nach dem erreichen des Zieles der BladeNight das Tracking und Freundefreigabe automatisch gestoppt.\nWiederholt langes drücken auf  ▶️,⏸︎,⏹︎ stellt auf manuell Stopp oder Autostopp um.`
  String get automatedStopInfo {
    return Intl.message(
      'Durch langes drücken auf ▶️ wird der automatische Trackingstopp aktiviert. Das heißt, solange die App geöffnet ist, wird nach dem erreichen des Zieles der BladeNight das Tracking und Freundefreigabe automatisch gestoppt.\nWiederholt langes drücken auf  ▶️,⏸︎,⏹︎ stellt auf manuell Stopp oder Autostopp um.',
      name: 'automatedStopInfo',
      desc: '',
      args: [],
    );
  }

  /// `Stoppe Tracking automatisch`
  String get autoStopTracking {
    return Intl.message(
      'Stoppe Tracking automatisch',
      name: 'autoStopTracking',
      desc: '',
      args: [],
    );
  }

  /// `hinter mir`
  String get behindMe {
    return Intl.message(
      'hinter mir',
      name: 'behindMe',
      desc: '',
      args: [],
    );
  }

  /// `Das Hintergrundstandortupdate ist aktiv. Danke fürs mitmachen.`
  String get bgNotificationText {
    return Intl.message(
      'Das Hintergrundstandortupdate ist aktiv. Danke fürs mitmachen.',
      name: 'bgNotificationText',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight Hintergrundstandortupdate`
  String get bgNotificationTitle {
    return Intl.message(
      'BladeNight Hintergrundstandortupdate',
      name: 'bgNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight`
  String get bladenight {
    return Intl.message(
      'BladeNight',
      name: 'bladenight',
      desc: '',
      args: [],
    );
  }

  /// `Zuschauermodus, Teilnehmer ▶️ drücken.`
  String get bladenighttracking {
    return Intl.message(
      'Zuschauermodus, Teilnehmer ▶️ drücken.',
      name: 'bladenighttracking',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight Update`
  String get bladenightUpdate {
    return Intl.message(
      'BladeNight Update',
      name: 'bladenightUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Zuschauermodus mit GPS`
  String get bladenightViewerTracking {
    return Intl.message(
      'Zuschauermodus mit GPS',
      name: 'bladenightViewerTracking',
      desc: '',
      args: [],
    );
  }

  /// `Abbruch`
  String get cancel {
    return Intl.message(
      'Abbruch',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Abgesagt 😞`
  String get canceled {
    return Intl.message(
      'Abgesagt 😞',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Ändern`
  String get change {
    return Intl.message(
      'Ändern',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Zu 'Immer zulassen' ändern`
  String get changetoalways {
    return Intl.message(
      'Zu \'Immer zulassen\' ändern',
      name: 'changetoalways',
      desc: '',
      args: [],
    );
  }

  /// `Logdaten wirklich löschen?`
  String get clearLogsQuestion {
    return Intl.message(
      'Logdaten wirklich löschen?',
      name: 'clearLogsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Logdaten sollen gelöscht werden!`
  String get clearLogsTitle {
    return Intl.message(
      'Logdaten sollen gelöscht werden!',
      name: 'clearLogsTitle',
      desc: '',
      args: [],
    );
  }

  /// `App wirklich schließen?`
  String get closeApp {
    return Intl.message(
      'App wirklich schließen?',
      name: 'closeApp',
      desc: '',
      args: [],
    );
  }

  /// `Fehler, Code darf nur Ziffern enthalten!`
  String get codecontainsonlydigits {
    return Intl.message(
      'Fehler, Code darf nur Ziffern enthalten!',
      name: 'codecontainsonlydigits',
      desc: '',
      args: [],
    );
  }

  /// `Wir fahren 😃`
  String get confirmed {
    return Intl.message(
      'Wir fahren 😃',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Code in Zwischenablage kopiert`
  String get copiedtoclipboard {
    return Intl.message(
      'Code in Zwischenablage kopiert',
      name: 'copiedtoclipboard',
      desc: '',
      args: [],
    );
  }

  /// `Code kopieren`
  String get copy {
    return Intl.message(
      'Code kopieren',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Konnte App-Einstellung nicht öffnen!`
  String get couldNotOpenAppSettings {
    return Intl.message(
      'Konnte App-Einstellung nicht öffnen!',
      name: 'couldNotOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `{date}`
  String dateIntl(DateTime date) {
    final DateFormat dateDateFormat = DateFormat.EEEE(Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      '$dateString',
      name: 'dateIntl',
      desc: '',
      args: [dateString],
    );
  }

  /// `{date} {time}Uhr`
  String dateTimeDayIntl(DateTime date, DateTime time) {
    final DateFormat dateDateFormat =
        DateFormat('E d.MMM y', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$dateString ${timeString}Uhr',
      name: 'dateTimeDayIntl',
      desc: '',
      args: [dateString, timeString],
    );
  }

  /// `{date} {time}Uhr`
  String dateTimeIntl(DateTime date, DateTime time) {
    final DateFormat dateDateFormat =
        DateFormat('dd.MM.yyyy', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$dateString ${timeString}Uhr',
      name: 'dateTimeIntl',
      desc: '',
      args: [dateString, timeString],
    );
  }

  /// `{date} {time}Uhr`
  String dateTimeSecIntl(DateTime date, DateTime time) {
    final DateFormat dateDateFormat =
        DateFormat('dd.MM.yy', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    final DateFormat timeDateFormat = DateFormat.Hms(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$dateString ${timeString}Uhr',
      name: 'dateTimeSecIntl',
      desc: '',
      args: [dateString, timeString],
    );
  }

  /// `Freund:in löschen`
  String get deletefriend {
    return Intl.message(
      'Freund:in löschen',
      name: 'deletefriend',
      desc: '',
      args: [],
    );
  }

  /// `Löschen`
  String get delete {
    return Intl.message(
      'Löschen',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Ablehnen`
  String get deny {
    return Intl.message(
      'Ablehnen',
      name: 'deny',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung`
  String get distance {
    return Intl.message(
      'Entfernung',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Position auf Strecke`
  String get distanceDriven {
    return Intl.message(
      'Position auf Strecke',
      name: 'distanceDriven',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung zum Ziel`
  String get distanceToFinish {
    return Intl.message(
      'Entfernung zum Ziel',
      name: 'distanceToFinish',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung zum Freund`
  String get distanceToFriend {
    return Intl.message(
      'Entfernung zum Freund',
      name: 'distanceToFriend',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung zum Zugkopf`
  String get distanceToHead {
    return Intl.message(
      'Entfernung zum Zugkopf',
      name: 'distanceToHead',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung von mir`
  String get distanceToMe {
    return Intl.message(
      'Entfernung von mir',
      name: 'distanceToMe',
      desc: '',
      args: [],
    );
  }

  /// `Entfernung zum Zugende`
  String get distanceToTail {
    return Intl.message(
      'Entfernung zum Zugende',
      name: 'distanceToTail',
      desc: '',
      args: [],
    );
  }

  /// `Fertig`
  String get done {
    return Intl.message(
      'Fertig',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in ändern`
  String get editfriend {
    return Intl.message(
      'Freund:in ändern',
      name: 'editfriend',
      desc: '',
      args: [],
    );
  }

  /// `Um die BladeNight-App auch im Hintergrund (Standort mit Freunden teilen und Zuggenauigkeit zu erhöhen) ohne das der Bildschirm an ist, sollte die Standortfunktion 'Immer zulassen' aktiviert werden.\nWeiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.`
  String get enableAlwaysLocationInfotext {
    return Intl.message(
      'Um die BladeNight-App auch im Hintergrund (Standort mit Freunden teilen und Zuggenauigkeit zu erhöhen) ohne das der Bildschirm an ist, sollte die Standortfunktion \'Immer zulassen\' aktiviert werden.\nWeiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.',
      name: 'enableAlwaysLocationInfotext',
      desc: '',
      args: [],
    );
  }

  /// `Bitte 6-stelligen Code eingeben`
  String get enter6digitcode {
    return Intl.message(
      'Bitte 6-stelligen Code eingeben',
      name: 'enter6digitcode',
      desc: '',
      args: [],
    );
  }

  /// `Code: `
  String get entercode {
    return Intl.message(
      'Code: ',
      name: 'entercode',
      desc: '',
      args: [],
    );
  }

  /// `Name eingeben.`
  String get enterfriendname {
    return Intl.message(
      'Name eingeben.',
      name: 'enterfriendname',
      desc: '',
      args: [],
    );
  }

  /// `Name:`
  String get entername {
    return Intl.message(
      'Name:',
      name: 'entername',
      desc: '',
      args: [],
    );
  }

  /// `Termine`
  String get events {
    return Intl.message(
      'Termine',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Exportieren`
  String get export {
    return Intl.message(
      'Exportieren',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Achtung! Dies sichert alle Freunde und die Kennung vom Gerät. Dies kann sensible Daten enthalten, wie zum Beispiel Namen.`
  String get exportWarning {
    return Intl.message(
      'Achtung! Dies sichert alle Freunde und die Kennung vom Gerät. Dies kann sensible Daten enthalten, wie zum Beispiel Namen.',
      name: 'exportWarning',
      desc: '',
      args: [],
    );
  }

  /// `Export Freunde und Id.`
  String get exportWarningTitle {
    return Intl.message(
      'Export Freunde und Id.',
      name: 'exportWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fehlgeschlagen!`
  String get failed {
    return Intl.message(
      'Fehlgeschlagen!',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Ziel / Ende`
  String get finish {
    return Intl.message(
      'Ziel / Ende',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Beendet`
  String get finished {
    return Intl.message(
      'Beendet',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Tracking gestoppt - Zeitüberschreitung`
  String get finishForceStopTimeoutTitle {
    return Intl.message(
      'Tracking gestoppt - Zeitüberschreitung',
      name: 'finishForceStopTimeoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tracking gestoppt - Ende der BladeNight`
  String get finishForceStopEventOverTitle {
    return Intl.message(
      'Tracking gestoppt - Ende der BladeNight',
      name: 'finishForceStopEventOverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ziel erreicht - Tracking beendet.`
  String get finishReachedStopedTracking {
    return Intl.message(
      'Ziel erreicht - Tracking beendet.',
      name: 'finishReachedStopedTracking',
      desc: '',
      args: [],
    );
  }

  /// `Ziel erreicht - Tracking bitte Tracking anhalten.`
  String get finishReachedtargetReachedPleaseStopTracking {
    return Intl.message(
      'Ziel erreicht - Tracking bitte Tracking anhalten.',
      name: 'finishReachedtargetReachedPleaseStopTracking',
      desc: '',
      args: [],
    );
  }

  /// `Ziel erreicht`
  String get finishReachedTitle {
    return Intl.message(
      'Ziel erreicht',
      name: 'finishReachedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Weiter`
  String get forward {
    return Intl.message(
      'Weiter',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Automatischer Trackingstopp nach max. {timeout}min. BladeNight beendet. (Lange drücken auf ▶️ deaktiviert Autostop)`
  String finishStopTrackingTimeout(Object timeout) {
    return Intl.message(
      'Automatischer Trackingstopp nach max. ${timeout}min. BladeNight beendet. (Lange drücken auf ▶️ deaktiviert Autostop)',
      name: 'finishStopTrackingTimeout',
      desc: '',
      args: [timeout],
    );
  }

  /// `Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.(Standard inaktiv)`
  String get fitnessPermissionSettingsText {
    return Intl.message(
      'Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.(Standard inaktiv)',
      name: 'fitnessPermissionSettingsText',
      desc: '',
      args: [],
    );
  }

  /// `Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren. Die Abfrage erfolgt in den nächsten Schritten.`
  String get fitnessPermissionInfoText {
    return Intl.message(
      'Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren. Die Abfrage erfolgt in den nächsten Schritten.',
      name: 'fitnessPermissionInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Bewegungssensor / Körperliche Aktivität`
  String get fitnessPermissionInfoTextTitle {
    return Intl.message(
      'Bewegungssensor / Körperliche Aktivität',
      name: 'fitnessPermissionInfoTextTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bewegungssensor deaktiviert`
  String get fitnessPermissionSwitchSettingsText {
    return Intl.message(
      'Bewegungssensor deaktiviert',
      name: 'fitnessPermissionSwitchSettingsText',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in`
  String get friend {
    return Intl.message(
      'Freund:in',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in ist`
  String get friendIs {
    return Intl.message(
      'Freund:in ist',
      name: 'friendIs',
      desc: '',
      args: [],
    );
  }

  /// `Freunde`
  String get friends {
    return Intl.message(
      'Freunde',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Bitte unterstütze weiter die genaue Darstellung des BladeNightzuges.\nAusserdem werden deine Freunde dich vermissen!`
  String get friendswillmissyou {
    return Intl.message(
      'Bitte unterstütze weiter die genaue Darstellung des BladeNightzuges.\nAusserdem werden deine Freunde dich vermissen!',
      name: 'friendswillmissyou',
      desc: '',
      args: [],
    );
  }

  /// `von`
  String get from {
    return Intl.message(
      'von',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Nicht geplant`
  String get noEvent {
    return Intl.message(
      'Nicht geplant',
      name: 'noEvent',
      desc: '',
      args: [],
    );
  }

  /// `Wir fahren gerade ⏳`
  String get running {
    return Intl.message(
      'Wir fahren gerade ⏳',
      name: 'running',
      desc: '',
      args: [],
    );
  }

  /// `Lade Serverdaten ...`
  String get getwebdata {
    return Intl.message(
      'Lade Serverdaten ...',
      name: 'getwebdata',
      desc: '',
      args: [],
    );
  }

  /// `Zugkopf`
  String get head {
    return Intl.message(
      'Zugkopf',
      name: 'head',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get home {
    return Intl.message(
      'Info',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Importieren`
  String get import {
    return Intl.message(
      'Importieren',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Achtung dies überschreibt alle Freunde und die Kennung. Vorher Daten exportieren! Achtung die App auf dem Gerät von dessen exportiert wurde löschen!`
  String get importWarning {
    return Intl.message(
      'Achtung dies überschreibt alle Freunde und die Kennung. Vorher Daten exportieren! Achtung die App auf dem Gerät von dessen exportiert wurde löschen!',
      name: 'importWarning',
      desc: '',
      args: [],
    );
  }

  /// `Import Freunde und Id.`
  String get importWarningTitle {
    return Intl.message(
      'Import Freunde und Id.',
      name: 'importWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Entwicklung in Arbeit ...`
  String get inprogress {
    return Intl.message(
      'Entwicklung in Arbeit ...',
      name: 'inprogress',
      desc: '',
      args: [],
    );
  }

  /// `ungültiger Code`
  String get internalerror_invalidcode {
    return Intl.message(
      'ungültiger Code',
      name: 'internalerror_invalidcode',
      desc: '',
      args: [],
    );
  }

  /// `Fehler - Freund:in schon verlinkt?`
  String get internalerror_seemslinked {
    return Intl.message(
      'Fehler - Freund:in schon verlinkt?',
      name: 'internalerror_seemslinked',
      desc: '',
      args: [],
    );
  }

  /// `Code unbekannt`
  String get invalidcode {
    return Intl.message(
      'Code unbekannt',
      name: 'invalidcode',
      desc: '',
      args: [],
    );
  }

  /// `{name} einladen`
  String invitebyname(Object name) {
    return Intl.message(
      '$name einladen',
      name: 'invitebyname',
      desc: 'Lade eine(n) Freund:in ein.',
      args: [name],
    );
  }

  /// `Freund:in einladen`
  String get invitenewfriend {
    return Intl.message(
      'Freund:in einladen',
      name: 'invitenewfriend',
      desc: '',
      args: [],
    );
  }

  /// `ist`
  String get ist {
    return Intl.message(
      'ist',
      name: 'ist',
      desc: '',
      args: [],
    );
  }

  /// `In Karte anzeigen?`
  String get isuseractive {
    return Intl.message(
      'In Karte anzeigen?',
      name: 'isuseractive',
      desc: '',
      args: [],
    );
  }

  /// `Letztes Update`
  String get lastupdate {
    return Intl.message(
      'Letztes Update',
      name: 'lastupdate',
      desc: '',
      args: [],
    );
  }

  /// `Lasse Einstellung`
  String get leavewheninuse {
    return Intl.message(
      'Lasse Einstellung',
      name: 'leavewheninuse',
      desc: '',
      args: [],
    );
  }

  /// `Länge`
  String get length {
    return Intl.message(
      'Länge',
      name: 'length',
      desc: '',
      args: [],
    );
  }

  /// `Verfolgt die Bladnight ohne App im Browser`
  String get liveMapInBrowser {
    return Intl.message(
      'Verfolgt die Bladnight ohne App im Browser',
      name: 'liveMapInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Livekarte im Browser`
  String get liveMapInBrowserInfoHeader {
    return Intl.message(
      'Livekarte im Browser',
      name: 'liveMapInBrowserInfoHeader',
      desc: '',
      args: [],
    );
  }

  /// `Lade ...`
  String get loading {
    return Intl.message(
      'Lade ...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Bitte Start ▶️ drücken! Standortübertragung ist in den Einstellungen deaktiviert oder noch nie gestartet! Tracking nicht möglich.`
  String get locationServiceOff {
    return Intl.message(
      'Bitte Start ▶️ drücken! Standortübertragung ist in den Einstellungen deaktiviert oder noch nie gestartet! Tracking nicht möglich.',
      name: 'locationServiceOff',
      desc: '',
      args: [],
    );
  }

  /// `Standortübertragung gestartet und aktiv.`
  String get locationServiceRunning {
    return Intl.message(
      'Standortübertragung gestartet und aktiv.',
      name: 'locationServiceRunning',
      desc: '',
      args: [],
    );
  }

  /// `Karte`
  String get map {
    return Intl.message(
      'Karte',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Karte folgt meiner Position.`
  String get mapFollowLocation {
    return Intl.message(
      'Karte folgt meiner Position.',
      name: 'mapFollowLocation',
      desc: '',
      args: [],
    );
  }

  /// `Karte folgt mir gestoppt!`
  String get mapFollowStopped {
    return Intl.message(
      'Karte folgt mir gestoppt!',
      name: 'mapFollowStopped',
      desc: '',
      args: [],
    );
  }

  /// `Karte folgt Zugkopfposition.`
  String get mapFollowTrain {
    return Intl.message(
      'Karte folgt Zugkopfposition.',
      name: 'mapFollowTrain',
      desc: '',
      args: [],
    );
  }

  /// `Karte folgt Zugkopf gestoppt.`
  String get mapFollowTrainStopped {
    return Intl.message(
      'Karte folgt Zugkopf gestoppt.',
      name: 'mapFollowTrainStopped',
      desc: '',
      args: [],
    );
  }

  /// `Karte auf Start. Kein verfolgen.`
  String get mapToStartNoFollowing {
    return Intl.message(
      'Karte auf Start. Kein verfolgen.',
      name: 'mapToStartNoFollowing',
      desc: '',
      args: [],
    );
  }

  /// `Ich`
  String get me {
    return Intl.message(
      'Ich',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `gef.Strecke`
  String get metersOnRoute {
    return Intl.message(
      'gef.Strecke',
      name: 'metersOnRoute',
      desc: '',
      args: [],
    );
  }

  /// `Du musst einen Namen eingeben!`
  String get mustentername {
    return Intl.message(
      'Du musst einen Namen eingeben!',
      name: 'mustentername',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, Name schon vergeben!`
  String get nameexists {
    return Intl.message(
      'Sorry, Name schon vergeben!',
      name: 'nameexists',
      desc: '',
      args: [],
    );
  }

  /// `Netzwerkfehler - Keine Daten!`
  String get networkerror {
    return Intl.message(
      'Netzwerkfehler - Keine Daten!',
      name: 'networkerror',
      desc: '',
      args: [],
    );
  }

  /// `Neue GPS Daten`
  String get newGPSDatareceived {
    return Intl.message(
      'Neue GPS Daten',
      name: 'newGPSDatareceived',
      desc: '',
      args: [],
    );
  }

  /// `Nächste BladeNight`
  String get nextEvent {
    return Intl.message(
      'Nächste BladeNight',
      name: 'nextEvent',
      desc: '',
      args: [],
    );
  }

  /// `Nein`
  String get no {
    return Intl.message(
      'Nein',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Standort 'Während der Benutzung' ist eingestellt. Daher ist keine Hintergrundaktualisierung aktiviert. Um die Darstellung des BladeNight-Zuges so genau wie möglich zu bekommen und deine Postion ohne Einschränkung mit Freunden zu teilen, bitten wir Dich die App offen halten oder die Einstellung auf 'Immer zulassen' zu ändern. Danke.`
  String get noBackgroundlocationLeaveAppOpen {
    return Intl.message(
      'Standort \'Während der Benutzung\' ist eingestellt. Daher ist keine Hintergrundaktualisierung aktiviert. Um die Darstellung des BladeNight-Zuges so genau wie möglich zu bekommen und deine Postion ohne Einschränkung mit Freunden zu teilen, bitten wir Dich die App offen halten oder die Einstellung auf \'Immer zulassen\' zu ändern. Danke.',
      name: 'noBackgroundlocationLeaveAppOpen',
      desc: '',
      args: [],
    );
  }

  /// `Hinweis, keine Hintergrundaktualisierung.`
  String get noBackgroundlocationTitle {
    return Intl.message(
      'Hinweis, keine Hintergrundaktualisierung.',
      name: 'noBackgroundlocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Keine Daten empfangen!`
  String get nodatareceived {
    return Intl.message(
      'Keine Daten empfangen!',
      name: 'nodatareceived',
      desc: '',
      args: [],
    );
  }

  /// `Aktuell keine Veranstaltung.`
  String get noEventStarted {
    return Intl.message(
      'Aktuell keine Veranstaltung.',
      name: 'noEventStarted',
      desc: '',
      args: [],
    );
  }

  /// `Autostop - da keine Veranstaltung`
  String get noEventStartedAutoStop {
    return Intl.message(
      'Autostop - da keine Veranstaltung',
      name: 'noEventStartedAutoStop',
      desc: '',
      args: [],
    );
  }

  /// `Keine Veranstaltung seit mindestens {timeout} min. aktiv - Tracking automatisch beendet`
  String noEventTimeOut(Object timeout) {
    return Intl.message(
      'Keine Veranstaltung seit mindestens $timeout min. aktiv - Tracking automatisch beendet',
      name: 'noEventTimeOut',
      desc: '',
      args: [timeout],
    );
  }

  /// `Kein GPS`
  String get nogps {
    return Intl.message(
      'Kein GPS',
      name: 'nogps',
      desc: '',
      args: [],
    );
  }

  /// `GPS nicht aktiviert`
  String get noGpsAllowed {
    return Intl.message(
      'GPS nicht aktiviert',
      name: 'noGpsAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Es ist scheinbar kein GPS im Gerät vorhanden oder für die App deaktiviert. Bitte die Einstellungen prüfen.`
  String get nogpsenabled {
    return Intl.message(
      'Es ist scheinbar kein GPS im Gerät vorhanden oder für die App deaktiviert. Bitte die Einstellungen prüfen.',
      name: 'nogpsenabled',
      desc: '',
      args: [],
    );
  }

  /// `Bitte System-Einstellungen (Einstellungen -> Standort -> Standortzugriff von Apps -> BladeNight) prüfen, da keine Standortfreigabe.`
  String get noLocationPermissionGrantedAlertAndroid {
    return Intl.message(
      'Bitte System-Einstellungen (Einstellungen -> Standort -> Standortzugriff von Apps -> BladeNight) prüfen, da keine Standortfreigabe.',
      name: 'noLocationPermissionGrantedAlertAndroid',
      desc: '',
      args: [],
    );
  }

  /// `Bitte iOS Einstellunge prüfen, da keine Standortfreigabe. Diese müsste in den Telefon-Einstellungen unter Datenschutz - Ortungsdienste - BladnightApp freigegeben werden.`
  String get noLocationPermissionGrantedAlertiOS {
    return Intl.message(
      'Bitte iOS Einstellunge prüfen, da keine Standortfreigabe. Diese müsste in den Telefon-Einstellungen unter Datenschutz - Ortungsdienste - BladnightApp freigegeben werden.',
      name: 'noLocationPermissionGrantedAlertiOS',
      desc: '',
      args: [],
    );
  }

  /// `Info Standortfreigabe`
  String get noLocationPermissionGrantedAlertTitle {
    return Intl.message(
      'Info Standortfreigabe',
      name: 'noLocationPermissionGrantedAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Die BladeNight wurde leider abgesagt.`
  String get note_bladenightCanceled {
    return Intl.message(
      'Die BladeNight wurde leider abgesagt.',
      name: 'note_bladenightCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Nächste BladeNight startet in 5 minuten. Tracking einschalten nicht vergessen !!`
  String get note_bladenightStartInFiveMinutesStartTracking {
    return Intl.message(
      'Nächste BladeNight startet in 5 minuten. Tracking einschalten nicht vergessen !!',
      name: 'note_bladenightStartInFiveMinutesStartTracking',
      desc: '',
      args: [],
    );
  }

  /// `Nächste BladeNight startet in 6 Stunden.`
  String get note_bladenightStartInSixHoursStartTracking {
    return Intl.message(
      'Nächste BladeNight startet in 6 Stunden.',
      name: 'note_bladenightStartInSixHoursStartTracking',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight Status geändert - Bitte in App prüfen`
  String get note_statuschanged {
    return Intl.message(
      'BladeNight Status geändert - Bitte in App prüfen',
      name: 'note_statuschanged',
      desc: '',
      args: [],
    );
  }

  /// `Veralted bitte,neu anlegen/löschen!`
  String get notKnownOnServer {
    return Intl.message(
      'Veralted bitte,neu anlegen/löschen!',
      name: 'notKnownOnServer',
      desc: '',
      args: [],
    );
  }

  /// `Nicht auf der Strecke!`
  String get notOnRoute {
    return Intl.message(
      'Nicht auf der Strecke!',
      name: 'notOnRoute',
      desc: '',
      args: [],
    );
  }

  /// `Kein Tracking!`
  String get notracking {
    return Intl.message(
      'Kein Tracking!',
      name: 'notracking',
      desc: '',
      args: [],
    );
  }

  /// `Auf Karte nicht angezeigt`
  String get notVisibleOnMap {
    return Intl.message(
      'Auf Karte nicht angezeigt',
      name: 'notVisibleOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Jetzt`
  String get now {
    return Intl.message(
      'Jetzt',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `am`
  String get on {
    return Intl.message(
      'am',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `GPS nur wenn App im Vordergrund freigegeben. Bitte Systemeinstellungen prüfen`
  String get onlyWhileInUse {
    return Intl.message(
      'GPS nur wenn App im Vordergrund freigegeben. Bitte Systemeinstellungen prüfen',
      name: 'onlyWhileInUse',
      desc: '',
      args: [],
    );
  }

  /// `Standortfreigabe nur 'Zugriff nur während der Nutzung der App zulassen'`
  String get onlyWhenInUseEnabled {
    return Intl.message(
      'Standortfreigabe nur \'Zugriff nur während der Nutzung der App zulassen\'',
      name: 'onlyWhenInUseEnabled',
      desc: '',
      args: [],
    );
  }

  /// `auf der Strecke`
  String get onRoute {
    return Intl.message(
      'auf der Strecke',
      name: 'onRoute',
      desc: '',
      args: [],
    );
  }

  /// `Öffne Systemeinstellungen`
  String get openOperatingSystemSettings {
    return Intl.message(
      'Öffne Systemeinstellungen',
      name: 'openOperatingSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Eigene`
  String get own {
    return Intl.message(
      'Eigene',
      name: 'own',
      desc: '',
      args: [],
    );
  }

  /// `Geplant ⏰`
  String get pending {
    return Intl.message(
      'Geplant ⏰',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Farbe wählen`
  String get pickcolor {
    return Intl.message(
      'Farbe wählen',
      name: 'pickcolor',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Reset in Einstellungen`
  String get resetInSettings {
    return Intl.message(
      'Reset in Einstellungen',
      name: 'resetInSettings',
      desc: '',
      args: [],
    );
  }

  /// `ges. GPS gefahren`
  String get distanceDrivenOdo {
    return Intl.message(
      'ges. GPS gefahren',
      name: 'distanceDrivenOdo',
      desc: '',
      args: [],
    );
  }

  /// `Tachometer lange drücken zum Reset des km Zählers (ODO-Meter)`
  String get resetLongPress {
    return Intl.message(
      'Tachometer lange drücken zum Reset des km Zählers (ODO-Meter)',
      name: 'resetLongPress',
      desc: '',
      args: [],
    );
  }

  /// `Teilnehmer`
  String get participant {
    return Intl.message(
      'Teilnehmer',
      name: 'participant',
      desc: '',
      args: [],
    );
  }

  /// `Positiv vor mir, Negativ hinter mir.`
  String get positiveInFront {
    return Intl.message(
      'Positiv vor mir, Negativ hinter mir.',
      name: 'positiveInFront',
      desc: '',
      args: [],
    );
  }

  /// `Weiter`
  String get proceed {
    return Intl.message(
      'Weiter',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben.Hier sollte  'Bei der Nutzung der App zulassen' gewählt werden. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung "Immer zulassen" die zu einem späteren Zeitpunkt (2.Schritt über Systemeinstellungen) erfolgt. Dies ermöglicht das Tracking auch wenn du eine andere App im Vordergrund geöffnet hast. Mit "Während der Benutzung" musst du die BladeNight immer im Vordergrund offen halten um uns zu unterstützen und deinen Standort zu teilen.Weiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.`
  String get prominentdisclosuretrackingprealertandroidFromAndroid_V11 {
    return Intl.message(
      'Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben.Hier sollte  \'Bei der Nutzung der App zulassen\' gewählt werden. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung "Immer zulassen" die zu einem späteren Zeitpunkt (2.Schritt über Systemeinstellungen) erfolgt. Dies ermöglicht das Tracking auch wenn du eine andere App im Vordergrund geöffnet hast. Mit "Während der Benutzung" musst du die BladeNight immer im Vordergrund offen halten um uns zu unterstützen und deinen Standort zu teilen.Weiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.',
      name: 'prominentdisclosuretrackingprealertandroidFromAndroid_V11',
      desc: '',
      args: [],
    );
  }

  /// `Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung "Bei der Nutzung der App zulassen".`
  String get prominentdisclosuretrackingprealertandroidToAndroid_V10x {
    return Intl.message(
      'Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung "Bei der Nutzung der App zulassen".',
      name: 'prominentdisclosuretrackingprealertandroidToAndroid_V10x',
      desc: '',
      args: [],
    );
  }

  /// `QRCode - Link zum teilen der aktuellen BladeNight-Daten ohne App`
  String get qrcoderouteinfoheader {
    return Intl.message(
      'QRCode - Link zum teilen der aktuellen BladeNight-Daten ohne App',
      name: 'qrcoderouteinfoheader',
      desc: '',
      args: [],
    );
  }

  /// `empfangen`
  String get received {
    return Intl.message(
      'empfangen',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Neu laden`
  String get reload {
    return Intl.message(
      'Neu laden',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `rel. Zeitdiff.`
  String get reltime {
    return Intl.message(
      'rel. Zeitdiff.',
      name: 'reltime',
      desc: '',
      args: [],
    );
  }

  /// `Reset km-Zähler und eigene Routenpunkte`
  String get resetOdoMeterTitle {
    return Intl.message(
      'Reset km-Zähler und eigene Routenpunkte',
      name: 'resetOdoMeterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Km-Zähler auf 0 setzen und eigene gefahrene Routenpunkte auf Karte (angezeigte gefahrene Route kann vorher in Einstellungen exportiert werden bzw. werden auch beim schließen der App gelöscht) ?`
  String get resetOdoMeter {
    return Intl.message(
      'Km-Zähler auf 0 setzen und eigene gefahrene Routenpunkte auf Karte (angezeigte gefahrene Route kann vorher in Einstellungen exportiert werden bzw. werden auch beim schließen der App gelöscht) ?',
      name: 'resetOdoMeter',
      desc: '',
      args: [],
    );
  }

  /// `Information, warum die Standortfreigeben notwendig wäre.`
  String get requestLocationPermissionTitle {
    return Intl.message(
      'Information, warum die Standortfreigeben notwendig wäre.',
      name: 'requestLocationPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Standort - Immer zulassen`
  String get requestAlwaysPermissionTitle {
    return Intl.message(
      'Standort - Immer zulassen',
      name: 'requestAlwaysPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Strecke`
  String get route {
    return Intl.message(
      'Strecke',
      name: 'route',
      desc: '',
      args: [],
    );
  }

  /// `Routenverlauf`
  String get routeoverview {
    return Intl.message(
      'Routenverlauf',
      name: 'routeoverview',
      desc: '',
      args: [],
    );
  }

  /// `Entfernen`
  String get remove {
    return Intl.message(
      'Entfernen',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `nicht verfügbar`
  String get notAvailable {
    return Intl.message(
      'nicht verfügbar',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Daten vorhanden`
  String get tracking {
    return Intl.message(
      'Daten vorhanden',
      name: 'tracking',
      desc: '',
      args: [],
    );
  }

  /// `Speichern`
  String get save {
    return Intl.message(
      'Speichern',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Scrolle Karte zu ...`
  String get scrollMapTo {
    return Intl.message(
      'Scrolle Karte zu ...',
      name: 'scrollMapTo',
      desc: '',
      args: [],
    );
  }

  /// `Warte auf Internetverbindung ...`
  String get seemsoffline {
    return Intl.message(
      'Warte auf Internetverbindung ...',
      name: 'seemsoffline',
      desc: '',
      args: [],
    );
  }

  /// `Link senden`
  String get sendlink {
    return Intl.message(
      'Link senden',
      name: 'sendlink',
      desc: '',
      args: [],
    );
  }

  /// `Dies ist die Einladung um deine(n) Freund:in (Absender der Nachricht) in der BladeNightApp zu sehen und euch im Skaterzug wiederzufinden. Wenn du das möchtest lade Dir die Baldenigthapp und gib den Code: {requestid} ein.\nWenn die App schon installiert ist benutze den link  'bna://bladenight.app?code={requestid}' oder 'https://bladenight.app?code={requestid}'auf dem Telefon. \nViel Spass beim skaten.\nDie App ist verfügbar im Playstore \n{playStoreLink} und im Apple App Store \n{iosAppStoreLink}`
  String sendlinkdescription(
      Object requestid, Object playStoreLink, Object iosAppStoreLink) {
    return Intl.message(
      'Dies ist die Einladung um deine(n) Freund:in (Absender der Nachricht) in der BladeNightApp zu sehen und euch im Skaterzug wiederzufinden. Wenn du das möchtest lade Dir die Baldenigthapp und gib den Code: $requestid ein.\nWenn die App schon installiert ist benutze den link  \'bna://bladenight.app?code=$requestid\' oder \'https://bladenight.app?code=$requestid\'auf dem Telefon. \nViel Spass beim skaten.\nDie App ist verfügbar im Playstore \n$playStoreLink und im Apple App Store \n$iosAppStoreLink',
      name: 'sendlinkdescription',
      desc: 'Sende den Code {requestid} an deine(n) Freund:in',
      args: [requestid, playStoreLink, iosAppStoreLink],
    );
  }

  /// `Sende link an BladeNight-App. Ihr könnt euch gegenseitig sehen.`
  String get sendlinksubject {
    return Intl.message(
      'Sende link an BladeNight-App. Ihr könnt euch gegenseitig sehen.',
      name: 'sendlinksubject',
      desc: '',
      args: [],
    );
  }

  /// `Warte auf Server ... !`
  String get serverNotReachable {
    return Intl.message(
      'Warte auf Server ... !',
      name: 'serverNotReachable',
      desc: '',
      args: [],
    );
  }

  /// `Fehler beim Verbinden`
  String get sessionConnectionError {
    return Intl.message(
      'Fehler beim Verbinden',
      name: 'sessionConnectionError',
      desc: '',
      args: [],
    );
  }

  /// `Logdateien löschen`
  String get setClearLogs {
    return Intl.message(
      'Logdateien löschen',
      name: 'setClearLogs',
      desc: '',
      args: [],
    );
  }

  /// `Farbe ändern`
  String get setcolor {
    return Intl.message(
      'Farbe ändern',
      name: 'setcolor',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get setexportDataHeader {
    return Intl.message(
      'Export',
      name: 'setexportDataHeader',
      desc: '',
      args: [],
    );
  }

  /// `Export Id und Freunde`
  String get setexportIdAndFriends {
    return Intl.message(
      'Export Id und Freunde',
      name: 'setexportIdAndFriends',
      desc: '',
      args: [],
    );
  }

  /// `Export Logdaten (Support) it@huth.app`
  String get setExportLogSupport {
    return Intl.message(
      'Export Logdaten (Support) it@huth.app',
      name: 'setExportLogSupport',
      desc: '',
      args: [],
    );
  }

  /// `Hier Datensatz einfügen incl. bna:`
  String get setInsertImportDataset {
    return Intl.message(
      'Hier Datensatz einfügen incl. bna:',
      name: 'setInsertImportDataset',
      desc: '',
      args: [],
    );
  }

  /// `Datenlogger`
  String get setLogData {
    return Intl.message(
      'Datenlogger',
      name: 'setLogData',
      desc: '',
      args: [],
    );
  }

  /// `Eigene Farbe in Karte`
  String get setMeColor {
    return Intl.message(
      'Eigene Farbe in Karte',
      name: 'setMeColor',
      desc: '',
      args: [],
    );
  }

  /// `Öffne Systemeinstellungen`
  String get setOpenSystemSettings {
    return Intl.message(
      'Öffne Systemeinstellungen',
      name: 'setOpenSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Text- und Symbolfarben im Normalmodus ändern`
  String get setPrimaryColor {
    return Intl.message(
      'Text- und Symbolfarben im Normalmodus ändern',
      name: 'setPrimaryColor',
      desc: '',
      args: [],
    );
  }

  /// `Text- und Symbolfarben im Dunkelmodus ändern`
  String get setPrimaryDarkColor {
    return Intl.message(
      'Text- und Symbolfarben im Dunkelmodus ändern',
      name: 'setPrimaryDarkColor',
      desc: '',
      args: [],
    );
  }

  /// `Import Id und Freunde starten`
  String get setStartImport {
    return Intl.message(
      'Import Id und Freunde starten',
      name: 'setStartImport',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get setSystem {
    return Intl.message(
      'System',
      name: 'setSystem',
      desc: '',
      args: [],
    );
  }

  /// `Einstellungen`
  String get settings {
    return Intl.message(
      'Einstellungen',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Nur Anzeige`
  String get showonly {
    return Intl.message(
      'Nur Anzeige',
      name: 'showonly',
      desc: '',
      args: [],
    );
  }

  /// `Zeige Teilnehmer`
  String get showFullProcession {
    return Intl.message(
      'Zeige Teilnehmer',
      name: 'showFullProcession',
      desc: '',
      args: [],
    );
  }

  /// `Zeige Teilnehmer (auf 100 aus dem Zug limitiert) in der Karte. Funktioniert nur bei eigener Standortfreigabe.`
  String get showFullProcessionTitle {
    return Intl.message(
      'Zeige Teilnehmer (auf 100 aus dem Zug limitiert) in der Karte. Funktioniert nur bei eigener Standortfreigabe.',
      name: 'showFullProcessionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Darstellung aktueller Verlauf der Münchener BladeNight`
  String get showProcession {
    return Intl.message(
      'Darstellung aktueller Verlauf der Münchener BladeNight',
      name: 'showProcession',
      desc: '',
      args: [],
    );
  }

  /// `Zeige QRCode zum Weblink`
  String get showWeblinkToRoute {
    return Intl.message(
      'Zeige QRCode zum Weblink',
      name: 'showWeblinkToRoute',
      desc: '',
      args: [],
    );
  }

  /// `Geschwindigkeit`
  String get speed {
    return Intl.message(
      'Geschwindigkeit',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Startpunkt`
  String get start {
    return Intl.message(
      'Startpunkt',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Tracking ohne Teilnahme`
  String get startLocationWithoutParticipating {
    return Intl.message(
      'Tracking ohne Teilnahme',
      name: 'startLocationWithoutParticipating',
      desc: '',
      args: [],
    );
  }

  /// `Bitte Aufmerksam lesen.\nDies startet die Standortdarstellung auf der Karte ohne Teilnahme an der BladeNight und überträgt zur Berechnung der Zeiten deinen Standort auf den Server. Deine Freunde im Zug werden Dir angezeigt. Die Zeit zum Zuganfang /-ende von deinem Standort werden berechnet. Weiterhin, werden deine Geschwindigkeit und Trackingdaten aufgezeichnet die du speichern kannst. Bitte diese Funktion nicht verwenden, wenn du an der BladeNight teilnimmst. Der Modus muss manuell beendet werden. \nSoll dies gestartet werden?`
  String get startLocationWithoutParticipatingInfo {
    return Intl.message(
      'Bitte Aufmerksam lesen.\nDies startet die Standortdarstellung auf der Karte ohne Teilnahme an der BladeNight und überträgt zur Berechnung der Zeiten deinen Standort auf den Server. Deine Freunde im Zug werden Dir angezeigt. Die Zeit zum Zuganfang /-ende von deinem Standort werden berechnet. Weiterhin, werden deine Geschwindigkeit und Trackingdaten aufgezeichnet die du speichern kannst. Bitte diese Funktion nicht verwenden, wenn du an der BladeNight teilnimmst. Der Modus muss manuell beendet werden. \nSoll dies gestartet werden?',
      name: 'startLocationWithoutParticipatingInfo',
      desc: '',
      args: [],
    );
  }

  /// `Teilnahme an BladeNight starten`
  String get startParticipationTracking {
    return Intl.message(
      'Teilnahme an BladeNight starten',
      name: 'startParticipationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Startpunkt\nDeutsches Verkehrsmuseum\nSchwanthalerhöhe München`
  String get startPoint {
    return Intl.message(
      'Startpunkt\nDeutsches Verkehrsmuseum\nSchwanthalerhöhe München',
      name: 'startPoint',
      desc: '',
      args: [],
    );
  }

  /// `Startzeit`
  String get startTime {
    return Intl.message(
      'Startzeit',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Aktiv`
  String get status_active {
    return Intl.message(
      'Aktiv',
      name: 'status_active',
      desc: '',
      args: [],
    );
  }

  /// `Inaktiv`
  String get status_inactive {
    return Intl.message(
      'Inaktiv',
      name: 'status_inactive',
      desc: '',
      args: [],
    );
  }

  /// `Veraltet`
  String get status_obsolete {
    return Intl.message(
      'Veraltet',
      name: 'status_obsolete',
      desc: '',
      args: [],
    );
  }

  /// `Ausstehend`
  String get status_pending {
    return Intl.message(
      'Ausstehend',
      name: 'status_pending',
      desc: '',
      args: [],
    );
  }

  /// `Stoppe Standort wirklich?`
  String get stopLocationTracking {
    return Intl.message(
      'Stoppe Standort wirklich?',
      name: 'stopLocationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Stoppe Position ohne Teilnahme`
  String get stopLocationWithoutParticipating {
    return Intl.message(
      'Stoppe Position ohne Teilnahme',
      name: 'stopLocationWithoutParticipating',
      desc: '',
      args: [],
    );
  }

  /// `Stoppe Teilnahme/ Tracking`
  String get stopParticipationTracking {
    return Intl.message(
      'Stoppe Teilnahme/ Tracking',
      name: 'stopParticipationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Eventzeit ({timeout} min) überzogen. Tracking abschalten nicht vergessen!`
  String stopTrackingTimeOut(Object timeout) {
    return Intl.message(
      'Eventzeit ($timeout min) überzogen. Tracking abschalten nicht vergessen!',
      name: 'stopTrackingTimeOut',
      desc: '',
      args: [timeout],
    );
  }

  /// `Senden`
  String get submit {
    return Intl.message(
      'Senden',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Setze Status`
  String get setState {
    return Intl.message(
      'Setze Status',
      name: 'setState',
      desc: '',
      args: [],
    );
  }

  /// `Symbole`
  String get symbols {
    return Intl.message(
      'Symbole',
      name: 'symbols',
      desc: '',
      args: [],
    );
  }

  /// `Zugende`
  String get tail {
    return Intl.message(
      'Zugende',
      name: 'tail',
      desc: '',
      args: [],
    );
  }

  /// `Sende an '{name}' den Code \n\n{requestid}\nEr/Sie/es muss den Code in dessen BladeNight App bestätigen. \nDer Code ist 60 min gültig!\nBitte über ↻ den Status manuell aktualisieren.`
  String tellcode(Object name, Object requestid) {
    return Intl.message(
      'Sende an \'$name\' den Code \n\n$requestid\nEr/Sie/es muss den Code in dessen BladeNight App bestätigen. \nDer Code ist 60 min gültig!\nBitte über ↻ den Status manuell aktualisieren.',
      name: 'tellcode',
      desc: 'Sende den Code an deine(n) Freund:in',
      args: [name, requestid],
    );
  }

  /// `Danke fürs Teilnehmen.`
  String get thanksForParticipating {
    return Intl.message(
      'Danke fürs Teilnehmen.',
      name: 'thanksForParticipating',
      desc: '',
      args: [],
    );
  }

  /// `{time} Uhr`
  String timeIntl(DateTime time) {
    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$timeString Uhr',
      name: 'timeIntl',
      desc: '',
      args: [timeString],
    );
  }

  /// `Zeitüberschreitung Dauer der BladeNight`
  String get timeOutDurationExceedTitle {
    return Intl.message(
      'Zeitüberschreitung Dauer der BladeNight',
      name: 'timeOutDurationExceedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stand von`
  String get timeStamp {
    return Intl.message(
      'Stand von',
      name: 'timeStamp',
      desc: '',
      args: [],
    );
  }

  /// `Dauer bis zum Ziel (ca.)`
  String get timeToFinish {
    return Intl.message(
      'Dauer bis zum Ziel (ca.)',
      name: 'timeToFinish',
      desc: '',
      args: [],
    );
  }

  /// `Dauer zum Freund (ca.)`
  String get timeToFriend {
    return Intl.message(
      'Dauer zum Freund (ca.)',
      name: 'timeToFriend',
      desc: '',
      args: [],
    );
  }

  /// `Dauer zum Zugkopf (ca.)`
  String get timeToHead {
    return Intl.message(
      'Dauer zum Zugkopf (ca.)',
      name: 'timeToHead',
      desc: '',
      args: [],
    );
  }

  /// `Dauer von mir (ca.)`
  String get timeToMe {
    return Intl.message(
      'Dauer von mir (ca.)',
      name: 'timeToMe',
      desc: '',
      args: [],
    );
  }

  /// `Dauer zum Zugende (ca).`
  String get timeToTail {
    return Intl.message(
      'Dauer zum Zugende (ca).',
      name: 'timeToTail',
      desc: '',
      args: [],
    );
  }

  /// `Heute`
  String get today {
    return Intl.message(
      'Heute',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Morgen`
  String get tomorrow {
    return Intl.message(
      'Morgen',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Tracker`
  String get trackers {
    return Intl.message(
      'Tracker',
      name: 'trackers',
      desc: '',
      args: [],
    );
  }

  /// `Tracking wieder gestartet`
  String get trackingRestarted {
    return Intl.message(
      'Tracking wieder gestartet',
      name: 'trackingRestarted',
      desc: '',
      args: [],
    );
  }

  /// `Skater-Zug`
  String get train {
    return Intl.message(
      'Skater-Zug',
      name: 'train',
      desc: '',
      args: [],
    );
  }

  /// `Zuglänge`
  String get trainlength {
    return Intl.message(
      'Zuglänge',
      name: 'trainlength',
      desc: '',
      args: [],
    );
  }

  /// `Dies kann nur in den Systemeinstellungen geändert werden! Versuche Systemeinstellungen zu öffnen?`
  String get tryOpenAppSettings {
    return Intl.message(
      'Dies kann nur in den Systemeinstellungen geändert werden! Versuche Systemeinstellungen zu öffnen?',
      name: 'tryOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Verstanden`
  String get understand {
    return Intl.message(
      'Verstanden',
      name: 'understand',
      desc: '',
      args: [],
    );
  }

  /// `unbekannt`
  String get unknown {
    return Intl.message(
      'unbekannt',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `unbek. Fehler`
  String get unknownerror {
    return Intl.message(
      'unbek. Fehler',
      name: 'unknownerror',
      desc: '',
      args: [],
    );
  }

  /// `Meine GPS-Geschwindigkeit.`
  String get userSpeed {
    return Intl.message(
      'Meine GPS-Geschwindigkeit.',
      name: 'userSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Freund:in verknüpfen`
  String get validatefriend {
    return Intl.message(
      'Freund:in verknüpfen',
      name: 'validatefriend',
      desc: '',
      args: [],
    );
  }

  /// `Version:`
  String get version {
    return Intl.message(
      'Version:',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Auf Karte angezeigt.`
  String get visibleOnMap {
    return Intl.message(
      'Auf Karte angezeigt.',
      name: 'visibleOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Wartezeit`
  String get waittime {
    return Intl.message(
      'Wartezeit',
      name: 'waittime',
      desc: '',
      args: [],
    );
  }

  /// `wurde leider abgesagt! Bitte prüfe dies auf https://bladenight-muenchen.de`
  String get wasCanceledPleaseCheck {
    return Intl.message(
      'wurde leider abgesagt! Bitte prüfe dies auf https://bladenight-muenchen.de',
      name: 'wasCanceledPleaseCheck',
      desc: '',
      args: [],
    );
  }

  /// `Ja`
  String get yes {
    return Intl.message(
      'Ja',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `war gestern`
  String get yesterday {
    return Intl.message(
      'war gestern',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Aktuell ist keine Veranstaltung geplant.`
  String get noEventPlanned {
    return Intl.message(
      'Aktuell ist keine Veranstaltung geplant.',
      name: 'noEventPlanned',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard`
  String get bladeGuard {
    return Intl.message(
      'Bladeguard',
      name: 'bladeGuard',
      desc: '',
      args: [],
    );
  }

  /// `Eigene Fahrlinie zeigen`
  String get showOwnTrack {
    return Intl.message(
      'Eigene Fahrlinie zeigen',
      name: 'showOwnTrack',
      desc: '',
      args: [],
    );
  }

  /// `Werde Bladeguard`
  String get becomeBladeguard {
    return Intl.message(
      'Werde Bladeguard',
      name: 'becomeBladeguard',
      desc: '',
      args: [],
    );
  }

  /// `Passwort vergessen`
  String get forgotPassword {
    return Intl.message(
      'Passwort vergessen',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email eingeben`
  String get enterEmail {
    return Intl.message(
      'Email eingeben',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Anmelden`
  String get login {
    return Intl.message(
      'Anmelden',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Passwort eingeben`
  String get enterPassword {
    return Intl.message(
      'Passwort eingeben',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Batterieoptimierung ändern`
  String get ignoreBatteriesOptimisationTitle {
    return Intl.message(
      'Batterieoptimierung ändern',
      name: 'ignoreBatteriesOptimisationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hinweis - manche Hersteller schalten die Apps durch ungünstige Batterieoptimierungen ab oder schließen die App. In dem Falle bitte versuchen die Batterieoptimierung für die App zu deaktivieren. Einstellung keine Beschränkung.`
  String get ignoreBatteriesOptimisation {
    return Intl.message(
      'Hinweis - manche Hersteller schalten die Apps durch ungünstige Batterieoptimierungen ab oder schließen die App. In dem Falle bitte versuchen die Batterieoptimierung für die App zu deaktivieren. Einstellung keine Beschränkung.',
      name: 'ignoreBatteriesOptimisation',
      desc: '',
      args: [],
    );
  }

  /// `Ich bin`
  String get iam {
    return Intl.message(
      'Ich bin',
      name: 'iam',
      desc: '',
      args: [],
    );
  }

  /// `Zuletzt gesehen`
  String get lastseen {
    return Intl.message(
      'Zuletzt gesehen',
      name: 'lastseen',
      desc: '',
      args: [],
    );
  }

  /// `nie`
  String get never {
    return Intl.message(
      'nie',
      name: 'never',
      desc: '',
      args: [],
    );
  }

  /// `Testimplementierung, da MIUI Xiaomi Handys durch agressives Speichermanagemant die Apps killen und diese somit nicht mehr funktioniert. Wenn die App in den Hintergrund wechselt oder gekillt wird, wird trotzdem weiter der Standort übermittelt (BETA) `
  String get allowHeadlessHeader {
    return Intl.message(
      'Testimplementierung, da MIUI Xiaomi Handys durch agressives Speichermanagemant die Apps killen und diese somit nicht mehr funktioniert. Wenn die App in den Hintergrund wechselt oder gekillt wird, wird trotzdem weiter der Standort übermittelt (BETA) ',
      name: 'allowHeadlessHeader',
      desc: '',
      args: [],
    );
  }

  /// `Hintergrund update aktiv`
  String get allowHeadless {
    return Intl.message(
      'Hintergrund update aktiv',
      name: 'allowHeadless',
      desc: '',
      args: [],
    );
  }

  /// `Wird ignoriert`
  String get isIgnoring {
    return Intl.message(
      'Wird ignoriert',
      name: 'isIgnoring',
      desc: '',
      args: [],
    );
  }

  /// `Hersteller`
  String get manufacturer {
    return Intl.message(
      'Hersteller',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Modell`
  String get model {
    return Intl.message(
      'Modell',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  /// `App aktiv lassen, heißt, das die App im wake mode ist und das Tracking aktiv ist. Wird bei kleiner 20% Akku deaktiviert.`
  String get allowWakeLockHeader {
    return Intl.message(
      'App aktiv lassen, heißt, das die App im wake mode ist und das Tracking aktiv ist. Wird bei kleiner 20% Akku deaktiviert.',
      name: 'allowWakeLockHeader',
      desc: '',
      args: [],
    );
  }

  /// `App im Vordergrund aktiv lassen?`
  String get allowWakeLock {
    return Intl.message(
      'App im Vordergrund aktiv lassen?',
      name: 'allowWakeLock',
      desc: '',
      args: [],
    );
  }

  /// `Sondereinstellungen - nur in Sonderfällen ändern!`
  String get specialfunction {
    return Intl.message(
      'Sondereinstellungen - nur in Sonderfällen ändern!',
      name: 'specialfunction',
      desc: '',
      args: [],
    );
  }

  /// `Icongröße: `
  String get setIconSize {
    return Intl.message(
      'Icongröße: ',
      name: 'setIconSize',
      desc: '',
      args: [],
    );
  }

  /// `Eigene Icongröße sowie die von Freunden, Zuganfang und -ende auf der Karte anpassen`
  String get setIconSizeTitle {
    return Intl.message(
      'Eigene Icongröße sowie die von Freunden, Zuganfang und -ende auf der Karte anpassen',
      name: 'setIconSizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Nutze Openstreetmap`
  String get openStreetMapText {
    return Intl.message(
      'Nutze Openstreetmap',
      name: 'openStreetMapText',
      desc: '',
      args: [],
    );
  }

  /// `Openstreetmap Kartenteile laden / Neustart erforderlich`
  String get openStreetMap {
    return Intl.message(
      'Openstreetmap Kartenteile laden / Neustart erforderlich',
      name: 'openStreetMap',
      desc: '',
      args: [],
    );
  }

  /// `Daten könnten nicht aktuell sein.`
  String get dataCouldBeOutdated {
    return Intl.message(
      'Daten könnten nicht aktuell sein.',
      name: 'dataCouldBeOutdated',
      desc: '',
      args: [],
    );
  }

  /// `Keine Standortfreigabe, Bitte Einstellungen des Gerätes prüfen`
  String get noLocationPermitted {
    return Intl.message(
      'Keine Standortfreigabe, Bitte Einstellungen des Gerätes prüfen',
      name: 'noLocationPermitted',
      desc: '',
      args: [],
    );
  }

  /// `Usertracking exportieren`
  String get exportUserTracking {
    return Intl.message(
      'Usertracking exportieren',
      name: 'exportUserTracking',
      desc: '',
      args: [],
    );
  }

  /// `Das aktuell sichtbare gefahrene Routenlinie als GPX exportieren`
  String get exportUserTrackingHeader {
    return Intl.message(
      'Das aktuell sichtbare gefahrene Routenlinie als GPX exportieren',
      name: 'exportUserTrackingHeader',
      desc: '',
      args: [],
    );
  }

  /// `Setze Strecke`
  String get setRoute {
    return Intl.message(
      'Setze Strecke',
      name: 'setRoute',
      desc: '',
      args: [],
    );
  }

  /// `Anfrage gesendet - Dauert ca. 30s.`
  String get sendData30sec {
    return Intl.message(
      'Anfrage gesendet - Dauert ca. 30s.',
      name: 'sendData30sec',
      desc: '',
      args: [],
    );
  }

  /// `Keine Auswahl da keine Aktion`
  String get noChoiceNoAction {
    return Intl.message(
      'Keine Auswahl da keine Aktion',
      name: 'noChoiceNoAction',
      desc: '',
      args: [],
    );
  }

  /// `Autostopp Tracking, da die BladeNight Veranstaltung beendet ist. (Lange drücken auf ▶️ deaktiviert Autostopp)`
  String get finishStopTrackingEventOver {
    return Intl.message(
      'Autostopp Tracking, da die BladeNight Veranstaltung beendet ist. (Lange drücken auf ▶️ deaktiviert Autostopp)',
      name: 'finishStopTrackingEventOver',
      desc: '',
      args: [],
    );
  }

  /// `Empfange Bladeguard Infos`
  String get receiveBladeGuardInfos {
    return Intl.message(
      'Empfange Bladeguard Infos',
      name: 'receiveBladeGuardInfos',
      desc: '',
      args: [],
    );
  }

  /// `Ich bin aktiver Bladeguard und möchte Infos erhalten. Passwort bitte beim Teamleiter oder Skatemunich mit Teamnummer erfragen (anonym d.h. Es werden keine Daten verknüpft)`
  String get iAmBladeGuardTitle {
    return Intl.message(
      'Ich bin aktiver Bladeguard und möchte Infos erhalten. Passwort bitte beim Teamleiter oder Skatemunich mit Teamnummer erfragen (anonym d.h. Es werden keine Daten verknüpft)',
      name: 'iAmBladeGuardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ich bin Bladeguard`
  String get iAmBladeGuard {
    return Intl.message(
      'Ich bin Bladeguard',
      name: 'iAmBladeGuard',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard--Teilnahme-Abfrage per Push-Mitteilung durchführen?`
  String get pushMessageParticipateAsBladeGuardTitle {
    return Intl.message(
      'Bladeguard--Teilnahme-Abfrage per Push-Mitteilung durchführen?',
      name: 'pushMessageParticipateAsBladeGuardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard-Abfrage Push`
  String get pushMessageParticipateAsBladeGuard {
    return Intl.message(
      'Bladeguard-Abfrage Push',
      name: 'pushMessageParticipateAsBladeGuard',
      desc: '',
      args: [],
    );
  }

  /// `Infos von SkateMunich per Push über Veranstaltungen empfangen?`
  String get pushMessageSkateMunichInfosTitle {
    return Intl.message(
      'Infos von SkateMunich per Push über Veranstaltungen empfangen?',
      name: 'pushMessageSkateMunichInfosTitle',
      desc: '',
      args: [],
    );
  }

  /// `Skatemunich Infos`
  String get pushMessageSkateMunichInfos {
    return Intl.message(
      'Skatemunich Infos',
      name: 'pushMessageSkateMunichInfos',
      desc: '',
      args: [],
    );
  }

  /// `Markiere meine Position als Zugkopf`
  String get markMeAsHead {
    return Intl.message(
      'Markiere meine Position als Zugkopf',
      name: 'markMeAsHead',
      desc: '',
      args: [],
    );
  }

  /// `Markiere meine Position als Zugende`
  String get markMeAsTail {
    return Intl.message(
      'Markiere meine Position als Zugende',
      name: 'markMeAsTail',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `App-Id `
  String get appId {
    return Intl.message(
      'App-Id ',
      name: 'appId',
      desc: '',
      args: [],
    );
  }

  /// `App-Id `
  String get appIdTitle {
    return Intl.message(
      'App-Id ',
      name: 'appIdTitle',
      desc: '',
      args: [],
    );
  }

  /// `App zwischen Hell- und Dunkelmodus unabhängig der Systemeinstellungen ändern.`
  String get setDarkModeTitle {
    return Intl.message(
      'App zwischen Hell- und Dunkelmodus unabhängig der Systemeinstellungen ändern.',
      name: 'setDarkModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dunkelmodus aktivieren`
  String get setDarkMode {
    return Intl.message(
      'Dunkelmodus aktivieren',
      name: 'setDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `seit`
  String get since {
    return Intl.message(
      'seit',
      name: 'since',
      desc: '',
      args: [],
    );
  }

  /// `Welches Team bist du?`
  String get setTeam {
    return Intl.message(
      'Welches Team bist du?',
      name: 'setTeam',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard Team`
  String get bgTeam {
    return Intl.message(
      'Bladeguard Team',
      name: 'bgTeam',
      desc: '',
      args: [],
    );
  }

  /// `Einige Einstellungen sind nicht verfügbar da keine Internetverbindung besteht.`
  String get someSettingsNotAvailableBecauseOffline {
    return Intl.message(
      'Einige Einstellungen sind nicht verfügbar da keine Internetverbindung besteht.',
      name: 'someSettingsNotAvailableBecauseOffline',
      desc: '',
      args: [],
    );
  }

  /// `Onesignal Push Benachrichtigungen aktivieren. Hiermit können allgemeine Informationen per Push-Mitteilung z.B. ob die Bladenight stattfindet empfangen werden. Empfohlene Einstellung 'Ein'.`
  String get enableOnesignalPushMessageTitle {
    return Intl.message(
      'Onesignal Push Benachrichtigungen aktivieren. Hiermit können allgemeine Informationen per Push-Mitteilung z.B. ob die Bladenight stattfindet empfangen werden. Empfohlene Einstellung \'Ein\'.',
      name: 'enableOnesignalPushMessageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Push Mitteilung aktiv`
  String get enableOnesignalPushMessage {
    return Intl.message(
      'Push Mitteilung aktiv',
      name: 'enableOnesignalPushMessage',
      desc: '',
      args: [],
    );
  }

  /// `Nutze alternativen Standorttreiber bei Problemen mit dem GPS Empfang`
  String get alternativeLocationProviderTitle {
    return Intl.message(
      'Nutze alternativen Standorttreiber bei Problemen mit dem GPS Empfang',
      name: 'alternativeLocationProviderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Nutze Alternative`
  String get alternativeLocationProvider {
    return Intl.message(
      'Nutze Alternative',
      name: 'alternativeLocationProvider',
      desc: '',
      args: [],
    );
  }

  /// `Dies ist die zugewiesene Id für den Empfang von Push-Nachrichten. Teilen Sie uns die ID mit, wenn Sie Probleme beim Empfang von Push-Nachrichten haben.`
  String get oneSignalIdTitle {
    return Intl.message(
      'Dies ist die zugewiesene Id für den Empfang von Push-Nachrichten. Teilen Sie uns die ID mit, wenn Sie Probleme beim Empfang von Push-Nachrichten haben.',
      name: 'oneSignalIdTitle',
      desc: '',
      args: [],
    );
  }

  /// `OneSignal-Id: `
  String get oneSignalId {
    return Intl.message(
      'OneSignal-Id: ',
      name: 'oneSignalId',
      desc: '',
      args: [],
    );
  }

  /// `Startpunkt`
  String get startPointTitle {
    return Intl.message(
      'Startpunkt',
      name: 'startPointTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Localize> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Localize> load(Locale locale) => Localize.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
