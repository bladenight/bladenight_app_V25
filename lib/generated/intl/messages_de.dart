// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(batteryLevel) =>
      "Tracking automatisch wegen niedrigen Akkustand ${batteryLevel} % gestoppt";

  static String m1(bladeguardRegisterlink, bladeguardPrivacyLink) =>
      "<h2>Voraussetzungen und Regeln:</h2><ul><li>Du bist mind. 16 Jahre alt.</li><li>Du stehst sicher auf Inline Skates und kannst bremsen.</li><li>Du kennst die Regeln im Straßenverkehr</li><li>Du bist hilfsbereit, freundlich und Teamplayer</li><li>Du liest das Schulungsmodul und beantwortest die Verständnisfragen.</li></ul><p>Dir entstehen als Bladeguard keine Kosten. Du kannst dich jederzeit wieder abmelden. <h3>Hier gehts zur <a href=\"${bladeguardRegisterlink}\">Onlineanmeldung</a> und zum <a href=\"${bladeguardPrivacyLink}\">Datenschutz</a></p></h3>";

  static String m2(date) => "${date}";

  static String m3(date, time) => "${date} ${time}Uhr";

  static String m4(date, time) => "${date} ${time}Uhr";

  static String m5(date, time) => "${date} ${time}Uhr";

  static String m6(name) =>
      "Lösche die Verknüpfung mit ${name}. Keine Wiederherstllung möglich.";

  static String m7(name) => "Ändere von ${name} den Namen und Farbe";

  static String m8(timeout) =>
      "Automatischer Trackingstopp nach max. ${timeout} min. BladeNight beendet. (Lange drücken auf ▶️ deaktiviert Autostop)";

  static String m9(code) =>
      "Alternativ kann dein Freund den Barcode mit der Kamera scannen oder dich mit dem Code ${code} verbinden";

  static String m10(bladeguardPrivacyLink) =>
      "Wir benötigen Unterstützung von Ehrenamtlichen. Als Bladeguard unterstützt du die BladeNight aktiv. Es gelten die <a href=\"${bladeguardPrivacyLink}\">Münchener BladeNight Datenschutzbestimmungen</a></p>";

  static String m11(name) => "${name} einladen";

  static String m12(linkDescription, link) =>
      "Du hast den Link zu \n${linkDescription} (${link}) angewählt und wirst nun zum Internet-Browser weitergeleitet. Bitte wechsele zu dieser App zurück, wenn du fertig sind. Die App läuft im Hintergrund weiter. ";

  static String m13(deviceName) =>
      "<h3>Wichtige Hinweise!</h3><ul><li>Dein Freund muss den gleichen Telefontyp verwenden. Apple zu Android funktioniert nicht. Nutze in dem Fall das Code pairing.</li><li>Dein Freund muss in max. 2 m Entfernung von Dir sein!</li><li>Bitte bei deinem Freund in der BladeNight!-App den Tab Freunde öffnen lassen.</li><li>Dort Plus oben rechts wählen<span class=\"icon\">plus</span></li><li>Freund:in neben Dir hinzufügen wählen</li><li>Nun mit diesem Gerät <b><em>${deviceName}</em></b> koppeln.</li><li>Alternativ kannst du von deinem Freund den Barcode mit der Kamera scannen oder die Verbindung mit der Option Freund mit Code hinzufügen nutzen</li></ul>Du kannst deinen übermittelten Namen im Textfeld ändern. Dieser ist nur ausschließlich zum übertragen per Direktverbindung.";

  static String m14(deviceName, code) =>
      "<h3>Wichtige Hinweise!</h3><ul><li>Dein Freund kann via Freund:in mit Code hinzufügen den <br>Code <b>${code}</b> eingeben oder den Barcode mit der Kamera scannen</li><li>Alternativ: Dein Freund muss den gleichen Telefontyp verwenden. Apple zu Android funktioniert nicht.</li><li>Dein Freund muss in max. 2 m Entfernung von Dir sein!</li><li>Bitte bei deinem Freund in der BladeNight!-App den Tab Freunde öffnen lassen.</li><li>Dort Plus oben rechts wählen<span class=\"icon\">plus</span></li><li>Freund:in neben Dir annehmen wählen</li><li>Nun mit diesem Gerät <b><em>${deviceName}</em></b> koppeln.</li></ul>Du kannst deinen übermittelten Namen im Textfeld ändern. Dieser ist nur ausschließlich zum übertragen per Direktverbindung / Scan.";

  static String m15(distInMeter) =>
      "Du musst in der Nähe des Startpunktes sein, bist aber min. ${distInMeter} m entfernt. Falls du dich verspätest bitte deinen Teamleiter informieren.";

  static String m16(timeout) =>
      "Keine Veranstaltung seit mindestens ${timeout} min. aktiv - Tracking automatisch beendet";

  static String m17(friendName, myName, code) =>
      "Dein Freund (${friendName}) kann auch diesen Barcode fotografieren und erhält die Daten automatisch in seiner App. Dies ist dein oben eingetragener Name: ${myName} und Code: ${code}, wenn die BladeNightApp auf seinem Handy installiert ist.";

  static String m18(
    requestId,
    bnaLink,
    myName,
    playStoreLink,
    iosAppStoreLink,
  ) =>
      "Dies ist die Einladung um deine(n) Freund:in (Absender der Nachricht) in der BladeNightApp zu sehen und euch im Skaterzug wiederzufinden. Wenn du das möchtest lade Dir die Baldenigthapp und gib den Code: ${requestId} ein.\nWenn die App schon installiert ist benutze den link ${bnaLink} auf dem Telefon. \nViel Spass beim skaten.\nDie App ist verfügbar im Playstore \n${playStoreLink} und im Apple App Store \n${iosAppStoreLink}";

  static String m19(timeout) =>
      "Eventzeit (${timeout} min) überzogen. Tracking abschalten nicht vergessen!";

  static String m20(name, requestid) =>
      "Sende an \'${name}\' den Code \n${requestid}\nDein(e) Freund:in muss den Code in dessen BladeNight-App bestätigen.\nDer Code ist 60 min gültig!\nBitte über ↻ den Status manuell aktualisieren.";

  static String m21(time) => "${time} Uhr";

  static String m22(level) =>
      "Tracking gestoppt wegen niedriger Batterie ${level}%. Um dies zu vermeiden, deaktivieren Sie Autostop in den Einstellungen";

  static String m23(level) =>
      "Display bleibt ist aktiviert - Warnung, das Batterieladung niedrig ${level}%.";

  static String m24(date) => "${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_appinfo": MessageLookupByLibrary.simpleMessage(
      "Die App wird kostenfrei vom Herausgeber exclusiv für die Münchener BladeNight und  Skatemunich e.V. und dessen Sponsoren bereitgestellt.\nDie App bietet allen BladeNight Teilnehmern folgende Funktionen an:\n\t-Übersicht der kommenden und vergangenen Termine\n- Anzeige der Strecken auf der Karte\n- Live Anzeige des Zuges während der BladeNight\n- Live Anzeige der eigenen Position auf der Strecke und innerhalb des Zuges\n- Freunde hinzufügen und Live verfolgen",
    ),
    "about_appprivacy": MessageLookupByLibrary.simpleMessage(
      "Diese App benutzt eine eindeutige Id die beim ersten Start der App lokal gespeichert wird.\nDiese Id wird auf dem Server benutzt um Freunde zu verknüpfen und die Position zu teilen. Diese wird nur zwischen der eigenen App und Server übertragen.\nWeiterhin wird die App-Versionsnummer und Telefonhersteller (Apple oder Android) zur Prüfung der korrekten Kommunikation übermittelt.\nDie Id ist auf dem Server mit den verknüpften Freunden gespeichert.\nDas Löschen und Neuinstallieren der App löscht die Id und die Freunde müssen neu verknüpft werden.\nDie Daten werden nicht an Dritte weitergegeben oder anderweitig verwendet.\nDeine Standortdaten werden während der Veranstaltung benutzt um Start und Ende des Zuges auf der Strecke zu berechnen und darzustellen und die Entfernung zu Freunden und zum Ziel zu berechnen.\nEs werden keine persönlichen Daten erfasst. Die Namen der Freunde sind nur lokal in der App gespeichert.\nDas Benutzen der App, Emailfunktion, Bladeguardfunktionen und Webseite https://bladenight-muenchen.de unterliegt den Datenschutzbestimmungen von Skatemunich e.V.\n Diese sind unter https://bladenight-muenchen.de/datenschutzerklaerung einsehbar. Die persönlichen Daten werden ausschließlich zur Durchführung der Münchener BladeNight erhoben und verarbeitet. Fragen dazu gern per Kontaktformular",
    ),
    "about_bnapp": MessageLookupByLibrary.simpleMessage(
      "Über die BladeNight App",
    ),
    "about_crashlytics": MessageLookupByLibrary.simpleMessage(
      "Um die Stabilität und Zuverlässigkeit dieser App zu verbessern, sind wir auf anonymisierte Absturzberichte angewiesen. Wir nutzen hierzu „Firebase Crashlytics“, ein Dienst der Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIm Falle eines Absturzes werden anonyme Informationen an die Server von Google in die USA übertragen (Zustand der App zum Zeitpunkt des Absturzes, Installation UUID, Crash-Trace, Hersteller und Betriebssystem des Handys, letzte Log-Meldungen). Diese Informationen enthalten keine personenbezogenen Daten.\n\nAbsturzberichte werden nur mit Ihrer ausdrücklichen Zustimmung versendet. Bei der Verwendung von iOS-Apps können Sie die Zustimmung in den Einstellungen der App oder nach einem Absturz erteilen. Bei Android-Apps besteht bei der Einrichtung des mobilen Endgeräts die Möglichkeit, generell der Übermittlung von Absturzbenachrichtigungen an Google und App-Entwickler zuzustimmen.\n\nRechtsgrundlage für die Datenübermittlung ist Art. 6 Abs. 1 lit. a DSGVO.\n\nSie können Ihre Einwilligung jederzeit widerrufen indem Sie in den Einstellungen der iOS-Apps die Funktion „Absturzberichte“ deaktivieren (in den Magazin-Apps befindet sich der Eintrag im Menüpunkt „Kommunikation“).\n\nBei den Android-Apps erfolgt die Deaktivierung grundlegend in den Android-Einstellungen. Öffnen Sie hierzu die Einstellungen App, wählen den Punkt „Google“ und dort im Dreipunkt-Menü oben rechts den Menüpunkt „Nutzung & Diagnose“. Hier können Sie das Senden der entsprechenden Daten deaktivieren. Weitere Informationen finden Sie in der Hilfe zu Ihrem Google-Konto.\n\nWeitere Informationen zum Datenschutz erhalten Sie in den Datenschutzhinweisen von Firebase Crashlytics unter https://firebase.google.com/support/privacy sowie https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies",
    ),
    "about_feedback": MessageLookupByLibrary.simpleMessage(
      "Dein Feedback ist willkommen.\nSende uns eine E-Mail an:",
    ),
    "about_h_androidapplicationflutter": MessageLookupByLibrary.simpleMessage(
      "BladeNight-App iOS/Android (2022)",
    ),
    "about_h_androidapplicationflutter_23":
        MessageLookupByLibrary.simpleMessage(
          "BladeNight-App iOS/Android (2023-2024)",
        ),
    "about_h_androidapplicationv1": MessageLookupByLibrary.simpleMessage(
      "Android App V1 (2013)",
    ),
    "about_h_androidapplicationv2": MessageLookupByLibrary.simpleMessage(
      "Android App V2 (2014-2022)",
    ),
    "about_h_androidapplicationv3": MessageLookupByLibrary.simpleMessage(
      "Android App V3 (2023-2024)",
    ),
    "about_h_bnapp": MessageLookupByLibrary.simpleMessage("Wofür ist die App"),
    "about_h_crashlytics": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics",
    ),
    "about_h_feedback": MessageLookupByLibrary.simpleMessage(
      "Feedback zur BladeNight",
    ),
    "about_h_homepage": MessageLookupByLibrary.simpleMessage("Internetseite"),
    "about_h_impressum": MessageLookupByLibrary.simpleMessage("Impressum"),
    "about_h_licences": MessageLookupByLibrary.simpleMessage("Lizenzen"),
    "about_h_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
      "OneSignal Datenschutzerklärung",
    ),
    "about_h_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Open Street Map Datenschutzerklärung",
    ),
    "about_h_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
    "about_h_serverapp": MessageLookupByLibrary.simpleMessage(
      "Serverprogrammierung",
    ),
    "about_h_version": MessageLookupByLibrary.simpleMessage("Version:"),
    "about_impressum": MessageLookupByLibrary.simpleMessage(
      "Betreiber und Veranstalter der Münchener BladeNight:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nVertreten durch:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de",
    ),
    "about_kilianlars": MessageLookupByLibrary.simpleMessage(
      "Kilian Schulte\nLars Huth",
    ),
    "about_lars": MessageLookupByLibrary.simpleMessage("Lars Huth"),
    "about_licences": MessageLookupByLibrary.simpleMessage(
      "GNU General Public License v3.0",
    ),
    "about_olivier": MessageLookupByLibrary.simpleMessage("Olivier Croquette"),
    "about_olivierandbenjamin": MessageLookupByLibrary.simpleMessage(
      "Benjamin Uekermann\nOlivier Croquette",
    ),
    "about_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
      "Wir verwenden für unsere Website OneSignal, eine Mobile-Marketing-Plattform. Dienstanbieter ist das amerikanische Unternehmen OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal verarbeitet Daten u.a. auch in den USA. Wir weisen darauf hin, dass nach Meinung des Europäischen Gerichtshofs derzeit kein angemessenes Schutzniveau für den Datentransfer in die USA besteht. Dies kann mit verschiedenen Risiken für die Rechtmäßigkeit und Sicherheit der Datenverarbeitung einhergehen.\n\nAls Grundlage der Datenverarbeitung bei Empfängern mit Sitz in Drittstaaten (außerhalb der Europäischen Union, Island, Liechtenstein, Norwegen, also insbesondere in den USA) oder einer Datenweitergabe dorthin verwendet OneSignal von der EU-Kommission genehmigte Standardvertragsklauseln (= Art. 46. Abs. 2 und 3 DSGVO). Diese Klauseln verpflichten OneSignal, das EU-Datenschutzniveau bei der Verarbeitung relevanter Daten auch außerhalb der EU einzuhalten. Diese Klauseln basieren auf einem Durchführungsbeschluss der EU-Kommission. Sie finden den Beschluss sowie die Klauseln u.a. hier: https://germany.representation.ec.europa.eu/index_de.\n\nMehr über die Daten, die durch die Verwendung von OneSignal verarbeitet werden, erfahren Sie in der Privacy Policy auf https://onesignal.com/privacy.\n\nAlle Texte sind urheberrechtlich geschützt.\n\nQuelle: Erstellt mit dem Datenschutz Generator von AdSimple",
    ),
    "about_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Daten, die wir automatisch erhalten\n\nDie OSMF betreibt eine Reihe von Diensten für die OpenStreetMap-Gemeinschaft, z. B. die Website openstreetmap.org, die Online-Karte im \"Standard\"-Stil, die OSM-API und die Nominatim-Suchfunktion.\n\nWenn Sie eine OSMF-Website besuchen, über einen Browser oder über Anwendungen, die die bereitgestellten APIs nutzen, auf einen der Dienste zugreifen, werden Aufzeichnungen über diese Nutzung erstellt, wir sammeln Informationen über Ihren Browser oder Ihre Anwendung und Ihre Interaktion mit unserer Website, einschließlich (a) IP-Adresse, (b) Browser- und Gerätetyp, (c) Betriebssystem, (d) verweisende Webseite, (e) Datum und Uhrzeit der Seitenbesuche und (f) die auf unseren Websites aufgerufenen Seiten.\n\nDarüber hinaus können wir Software zur Verfolgung der Benutzerinteraktion einsetzen, die zusätzliche Aufzeichnungen über die Benutzeraktivität erstellt, z. B. Piwik.\n\nDienste, die Geo-DNS oder ähnliche Mechanismen verwenden, um die Last auf geografisch verteilte Server zu verteilen, erzeugen möglicherweise eine Aufzeichnung Ihres Standorts in großem Umfang (z. B. ermittelt das OSMF-Kachel-Cache-Netzwerk das Land, in dem Sie sich wahrscheinlich befinden, und leitet Ihre Anfragen an einen entsprechenden Server weiter).\n\nDiese Aufzeichnungen werden auf folgende Weise verwendet oder können verwendet werden:\n\nzur Unterstützung des Betriebs der Dienste aus technischer, sicherheitstechnischer und planerischer Sicht.\nals anonymisierte, zusammengefasste Daten für Forschungs- und andere Zwecke. Solche Daten können über https://planet.openstreetmap.org oder andere Kanäle öffentlich angeboten und von Dritten genutzt werden.\num den OpenStreetMap-Datensatz zu verbessern. Zum Beispiel durch die Analyse von Nominatim-Abfragen auf fehlende Adressen und Postleitzahlen und die Bereitstellung solcher Daten für die OSM-Community.\nDie auf den Systemen gesammelten Daten sind für die Systemadministratoren und die entsprechenden OSMF-Arbeitsgruppen, z. B. die Datenarbeitsgruppe, zugänglich. Es werden keine persönlichen Informationen oder Informationen, die mit einer Person in Verbindung gebracht werden können, an Dritte weitergegeben, es sei denn, dies ist gesetzlich vorgeschrieben.\n\nDie von Piwik gespeicherten IP-Adressen werden auf zwei Bytes gekürzt und die detaillierten Nutzungsdaten werden 180 Tage lang aufbewahrt.\n\nDa diese Speicherung nur vorübergehend erfolgt, ist es uns im Allgemeinen nicht möglich, Zugang zu IP-Adressen oder den damit verbundenen Protokollen zu gewähren.\n\nDie oben genannten Daten werden auf der Grundlage eines berechtigten Interesses verarbeitet (siehe Artikel 6 Absatz 1 Buchstabe f der DSGVO).",
    ),
    "actualInformations": MessageLookupByLibrary.simpleMessage(
      "Aktuelle Informationen",
    ),
    "addEvent": MessageLookupByLibrary.simpleMessage("Event hinzufügen"),
    "addFriendWithCodeHeader": MessageLookupByLibrary.simpleMessage(
      "Erzeuge eine Code um eine Freund:in-Verknüpfung herzustellen",
    ),
    "addNearBy": MessageLookupByLibrary.simpleMessage(
      "Freund:in neben Dir hinzufügen",
    ),
    "addNewFriendHeader": MessageLookupByLibrary.simpleMessage(
      "Wenn dein(e) Freund:in einen Code erzeugt hat, kannst du dich mit ihm/ihr koppeln.",
    ),
    "addfriendwithcode": MessageLookupByLibrary.simpleMessage(
      "Freund:in mit Code hinzufügen",
    ),
    "addnewfriend": MessageLookupByLibrary.simpleMessage(
      "Freund:in neu anlegen",
    ),
    "admin": MessageLookupByLibrary.simpleMessage("Administrator"),
    "aheadOfMe": MessageLookupByLibrary.simpleMessage("vor mir"),
    "alignDirectionAndPositionOnUpdate": MessageLookupByLibrary.simpleMessage(
      "Kartenausrichtung bei Positions- und Richtungswechsel",
    ),
    "alignDirectionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Kartenausrichtung bei Richtungswechsel",
    ),
    "alignNever": MessageLookupByLibrary.simpleMessage(
      "Keine Kartenausrichtung",
    ),
    "alignPositionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Kartenausrichtung bei Positionsänderungen",
    ),
    "allowHeadless": MessageLookupByLibrary.simpleMessage(
      "Hintergrund update aktiv",
    ),
    "allowHeadlessHeader": MessageLookupByLibrary.simpleMessage(
      "Testimplementierung, da MIUI Xiaomi Handys durch agressives Speichermanagemant die Apps killen und diese somit nicht mehr funktioniert. Wenn die App in den Hintergrund wechselt oder gekillt wird, wird trotzdem weiter der Standort übermittelt (BETA) ",
    ),
    "allowWakeLock": MessageLookupByLibrary.simpleMessage(
      "Display aktiv lassen?",
    ),
    "allowWakeLockHeader": MessageLookupByLibrary.simpleMessage(
      "Das Display an lassen wenn das Tracking aktiv ist. Die Funktion wird bei kleiner 30% Akku deaktiviert. Abschalten des Displays ist weiterhin möglich.",
    ),
    "alternativeLocationProvider": MessageLookupByLibrary.simpleMessage(
      "Nutze Alternative",
    ),
    "alternativeLocationProviderTitle": MessageLookupByLibrary.simpleMessage(
      "Nutze alternativen Standorttreiber bei Problemen mit dem GPS Empfang",
    ),
    "alwaysLocationPermissionRecommend": MessageLookupByLibrary.simpleMessage(
      "\'Standortfreigabe immer\' ist empfohlen oder Display ein, um den Verlust des GPS-Signals wenn die App im Hintergrund ist zu vermeiden !",
    ),
    "alwaysLocationPermissionRecommendTitle":
        MessageLookupByLibrary.simpleMessage(
          "Bitte \'Standortfreigabe immer\' aktivieren",
        ),
    "alwaysPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Standortfreigabe permanent verweigert oder im System gesperrt!",
    ),
    "alwaysPermantlyDenied": MessageLookupByLibrary.simpleMessage(
      "Standortfreigabe für \'Immer erlauben\' scheint permanent verboten!",
    ),
    "anonymous": MessageLookupByLibrary.simpleMessage("Anonym"),
    "appId": MessageLookupByLibrary.simpleMessage("App-Id "),
    "appIdTitle": MessageLookupByLibrary.simpleMessage("App-Id "),
    "appInfo": MessageLookupByLibrary.simpleMessage("App info"),
    "appInitialisationError": MessageLookupByLibrary.simpleMessage(
      "Ladefehler der App.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("BladeNight München"),
    "appOutDated": MessageLookupByLibrary.simpleMessage(
      "Appversion veralted!\nBitte im Store aktualisieren.",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "appsupport": MessageLookupByLibrary.simpleMessage(
      "App-Support/ Feedback/ Vorschläge",
    ),
    "apptrackingtransparancy": MessageLookupByLibrary.simpleMessage(
      "Wir schützen uns um Ihre Privatsphäre und Datensicherheit.\nUm uns dabei zu helfen, das BladeNight-Erlebnis zu verbessern, übertragen wir Ihren Standort auf unseren Server. Dies Information beinhaltet eine beim ersten Start der App erstellte eindeutige ID, um die Zuordnung der Freunde zu ermöglichen. Diese Daten werden niemals an Dritte weitergegeben oder für Werbezwecke verwendet.",
    ),
    "at": MessageLookupByLibrary.simpleMessage("am"),
    "autoStartTracking": MessageLookupByLibrary.simpleMessage(
      "Tracking autom. gestartet während BladeNight - Autostart aktiv. Um dies zu deaktivieren, bitte Auto-Start/Stop-Tracking in Einstellung ausschalten",
    ),
    "autoStartTrackingInfo": MessageLookupByLibrary.simpleMessage(
      "Starte Standortfreigabe automatisch",
    ),
    "autoStartTrackingInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Es besteht die Möglichkeit beim Start der BladeNight, die Standortfreigabe automatisch zu starten, wenn die App geöffnet ist. Sobald die App geschlossen wurde oder die Hintergrundaktivität nicht freigegeben ist, wird auch keine Standortfreigabe aktiviert. Soll die BladeNight!-Teilnahme automatisch starten, wenn die App geöffnet ist? ",
    ),
    "autoStartTrackingTitle": MessageLookupByLibrary.simpleMessage(
      "Tracking automatisch gestartet...",
    ),
    "autoStopTracking": MessageLookupByLibrary.simpleMessage(
      "Stoppe Tracking automatisch",
    ),
    "autoStopTrackingDueLowBattery": m0,
    "automatedStopInfo": MessageLookupByLibrary.simpleMessage(
      "Durch langes drücken auf ▶️ wird der automatische Trackingstopp aktiviert. Das heißt, solange die App geöffnet ist, wird nach dem erreichen des Zieles der BladeNight das Tracking und Freundefreigabe automatisch gestoppt.\nWiederholt langes drücken auf  ▶️,⏸︎,⏹︎ stellt auf manuell Stopp oder Autostopp um.",
    ),
    "automatedStopSettingText": MessageLookupByLibrary.simpleMessage(
      "Tracking Auto-Stopp ",
    ),
    "automatedStopSettingTitle": MessageLookupByLibrary.simpleMessage(
      "Stoppe das Bladenight-Trackings automatisch. (Eventende oder Absage)",
    ),
    "becomeBladeguard": MessageLookupByLibrary.simpleMessage(
      "Werde Bladeguard",
    ),
    "behindMe": MessageLookupByLibrary.simpleMessage("hinter mir"),
    "bgNotificationText": MessageLookupByLibrary.simpleMessage(
      "Das Hintergrundstandortupdate ist aktiv. Danke fürs mitmachen.",
    ),
    "bgNotificationTitle": MessageLookupByLibrary.simpleMessage(
      "BladeNight Hintergrundstandortupdate",
    ),
    "bgTeam": MessageLookupByLibrary.simpleMessage("Bladeguard Team"),
    "bgTodayIsRegistered": MessageLookupByLibrary.simpleMessage(
      "Du bist heute als Bladeguard eingetragen.",
    ),
    "bgTodayNotParticipation": MessageLookupByLibrary.simpleMessage(
      "Ich kann heute doch nicht als Bladeguard teilnehmen und möchte mich wieder austragen.",
    ),
    "bgTodayNotRegistered": MessageLookupByLibrary.simpleMessage(
      "Du bist heute noch nicht als Bladeguard eingetragen!",
    ),
    "bgTodayTapToRegister": MessageLookupByLibrary.simpleMessage(
      "Hier tippen und für heute als Bladeguard eintragen!",
    ),
    "bgTodayTapToUnRegister": MessageLookupByLibrary.simpleMessage(
      "Hier tippen und für heute als Bladeguard wieder austragen!",
    ),
    "bgUpdatePhone": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "birthday": MessageLookupByLibrary.simpleMessage("Geburtstag"),
    "bladeGuard": MessageLookupByLibrary.simpleMessage("Bladeguard"),
    "bladeGuardSettings": MessageLookupByLibrary.simpleMessage(
      "Bladeguard Einstellungen",
    ),
    "bladeGuardSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Bladeguardeinstellungen aufrufen",
    ),
    "bladeguardAtStartPointTitle": MessageLookupByLibrary.simpleMessage(
      "BladenightApp - Vor Ort registriert",
    ),
    "bladeguardInfo": m1,
    "bladenight": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "bladenightInfoTitleApp": MessageLookupByLibrary.simpleMessage(
      "Information zur Münchner BladeNight",
    ),
    "bladenightInfoTitleWeb": MessageLookupByLibrary.simpleMessage(
      "WebApp and Information zur Münchner BladeNight",
    ),
    "bladenightUpdate": MessageLookupByLibrary.simpleMessage(
      "BladeNight Update",
    ),
    "bladenightViewerTracking": MessageLookupByLibrary.simpleMessage(
      "Zuschauermodus mit Standort",
    ),
    "bladenighttracking": MessageLookupByLibrary.simpleMessage(
      "Zuschauermodus, Teilnehmer ▶️ drücken.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbruch"),
    "canceled": MessageLookupByLibrary.simpleMessage("Abgesagt 😞"),
    "change": MessageLookupByLibrary.simpleMessage("Ändern"),
    "changeDarkColor": MessageLookupByLibrary.simpleMessage(
      "Ändere Dunkelmodus Farbe",
    ),
    "changeLightColor": MessageLookupByLibrary.simpleMessage(
      "Ändere Normalmodus Farbe",
    ),
    "changeMeColor": MessageLookupByLibrary.simpleMessage(
      "Ändere Eigene Farbe",
    ),
    "changetoalways": MessageLookupByLibrary.simpleMessage(
      "Zu \'Immer zulassen\' ändern",
    ),
    "checkBgRegistration": MessageLookupByLibrary.simpleMessage(
      "Prüfen ob du registriert bist.",
    ),
    "checkNearbyCounterSide": MessageLookupByLibrary.simpleMessage(
      "Bitte das Gerät deines Freundes zum Koppeln bestätigen",
    ),
    "chooseDeviceToLink": MessageLookupByLibrary.simpleMessage(
      "Bitte Gerät zum koppeln wählen !",
    ),
    "clearLogsQuestion": MessageLookupByLibrary.simpleMessage(
      "Logdaten wirklich löschen?",
    ),
    "clearLogsTitle": MessageLookupByLibrary.simpleMessage(
      "Logdaten sollen gelöscht werden!",
    ),
    "clearMessages": MessageLookupByLibrary.simpleMessage(
      "Wirklich alle Nachrichten löschen?",
    ),
    "clearMessagesTitle": MessageLookupByLibrary.simpleMessage(
      "Nachrichten löschen",
    ),
    "closeApp": MessageLookupByLibrary.simpleMessage("App wirklich schließen?"),
    "codeExpired": MessageLookupByLibrary.simpleMessage(
      "Code zu alt! Eintrag bitte löschen und Freund:in neu einladen!",
    ),
    "codecontainsonlydigits": MessageLookupByLibrary.simpleMessage(
      "Fehler, Code darf nur Ziffern enthalten!",
    ),
    "collectionStop": MessageLookupByLibrary.simpleMessage("Sammelstopp"),
    "confirmed": MessageLookupByLibrary.simpleMessage("Wir fahren"),
    "connected": MessageLookupByLibrary.simpleMessage("Verbunden"),
    "connecting": MessageLookupByLibrary.simpleMessage("Koppeln"),
    "copiedtoclipboard": MessageLookupByLibrary.simpleMessage(
      "Code in Zwischenablage kopiert",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Code kopieren"),
    "couldNotOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "Konnte App-Einstellung nicht öffnen!",
    ),
    "dataCouldBeOutdated": MessageLookupByLibrary.simpleMessage(
      "Daten könnten nicht aktuell sein.",
    ),
    "dateIntl": m2,
    "dateTimeDayIntl": m3,
    "dateTimeIntl": m4,
    "dateTimeSecIntl": m5,
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deleteEvent": MessageLookupByLibrary.simpleMessage("Event löschen"),
    "deleteFriendHeader": m6,
    "deleteMessage": MessageLookupByLibrary.simpleMessage("Nachricht löschen"),
    "deletefriend": MessageLookupByLibrary.simpleMessage("Freund:in löschen"),
    "deny": MessageLookupByLibrary.simpleMessage("Ablehnen"),
    "devicesAlreadyConnected": MessageLookupByLibrary.simpleMessage(
      "Geräte sind bereits verbunden",
    ),
    "disconnect": MessageLookupByLibrary.simpleMessage("Verb. trennen"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Nicht verbunden"),
    "distance": MessageLookupByLibrary.simpleMessage("Entfernung"),
    "distanceDriven": MessageLookupByLibrary.simpleMessage(
      "Position auf Strecke",
    ),
    "distanceDrivenOdo": MessageLookupByLibrary.simpleMessage(
      "ges. GPS gefahren",
    ),
    "distanceToFinish": MessageLookupByLibrary.simpleMessage(
      "Entfernung zum Ziel",
    ),
    "distanceToFriend": MessageLookupByLibrary.simpleMessage(
      "Entfernung zum Freund",
    ),
    "distanceToHead": MessageLookupByLibrary.simpleMessage(
      "Entfernung zum Zugkopf",
    ),
    "distanceToMe": MessageLookupByLibrary.simpleMessage("Entfernung von mir"),
    "distanceToTail": MessageLookupByLibrary.simpleMessage(
      "Entfernung zum Zugende",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Fertig"),
    "editEvent": MessageLookupByLibrary.simpleMessage("Event ändern"),
    "editFriendHeader": m7,
    "editfriend": MessageLookupByLibrary.simpleMessage("Freund:in ändern"),
    "enableAlwaysLocationGeofenceText": MessageLookupByLibrary.simpleMessage(
      "Für das automatische vor Ort einloggen sollte die Standortfreigabe auf immer stehen. Sollen die Systemeinstellungen geöffnet werden?",
    ),
    "enableAlwaysLocationInfotext": MessageLookupByLibrary.simpleMessage(
      "Um die BladeNight-App auch im Hintergrund (Standort mit Freunden teilen und Zuggenauigkeit zu erhöhen) ohne das der Bildschirm an ist, sollte die Standortfunktion \'Immer zulassen\' aktiviert werden.\nWeiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn dein Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.",
    ),
    "enableOnesignalPushMessage": MessageLookupByLibrary.simpleMessage(
      "Push Mitteilung aktiv",
    ),
    "enableOnesignalPushMessageTitle": MessageLookupByLibrary.simpleMessage(
      "Onesignal Push Benachrichtigungen aktivieren. Hiermit können allgemeine Informationen per Push-Mitteilung z.B. ob die BladeNight stattfindet empfangen werden. Empfohlene Einstellung \'Ein\'.",
    ),
    "enter6digitcode": MessageLookupByLibrary.simpleMessage(
      "Bitte 6-stelligen Code eingeben",
    ),
    "enterBgPassword": MessageLookupByLibrary.simpleMessage(
      "Sicherheits-Passwort Bladeguard eingeben",
    ),
    "enterBirthday": MessageLookupByLibrary.simpleMessage("Dein Geburtstag "),
    "enterEmail": MessageLookupByLibrary.simpleMessage("Email eingeben"),
    "enterPassword": MessageLookupByLibrary.simpleMessage("Passwort eingeben"),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Deine Mobiltelefonnummer (Nur für die BladeNight und falls die Polizei bei der Ordnerprüfung dich sehen möchte.)",
    ),
    "entercode": MessageLookupByLibrary.simpleMessage("Code: "),
    "enterfriendname": MessageLookupByLibrary.simpleMessage("Name eingeben"),
    "entername": MessageLookupByLibrary.simpleMessage("Name:"),
    "eventNotStarted": MessageLookupByLibrary.simpleMessage(
      "Noch nicht gestartet",
    ),
    "eventOn": MessageLookupByLibrary.simpleMessage("BladeNight am"),
    "events": MessageLookupByLibrary.simpleMessage("Termine"),
    "export": MessageLookupByLibrary.simpleMessage("Exportieren"),
    "exportLogData": MessageLookupByLibrary.simpleMessage(
      "Sende Logdaten für Support oder Featureanfrage",
    ),
    "exportUserTracking": MessageLookupByLibrary.simpleMessage(
      "Usertracking exportieren",
    ),
    "exportUserTrackingHeader": MessageLookupByLibrary.simpleMessage(
      "Das Tracking des gewählten Datums als GPX exportieren",
    ),
    "exportWarning": MessageLookupByLibrary.simpleMessage(
      "Achtung! Dies sichert alle Freunde und die Kennung vom Gerät. Dies kann sensible Daten enthalten, wie zum Beispiel Namen.",
    ),
    "exportWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Export Freunde und Id.",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("Fehlgeschlagen!"),
    "failedAddNearbyTryCode": MessageLookupByLibrary.simpleMessage(
      "Bitte versuche die Verbindung mit einem Code herzustellen. Fragen dazu deinen Freund nach dem angezeigten Code in seiner \'Freunde\'-Übersicht. Du kannst dich nur einmal mit demselben Freund verbinden.",
    ),
    "finish": MessageLookupByLibrary.simpleMessage("Ziel / Ende"),
    "finishForceStopEventOverTitle": MessageLookupByLibrary.simpleMessage(
      "Tracking gestoppt - Ende der BladeNight",
    ),
    "finishForceStopTimeoutTitle": MessageLookupByLibrary.simpleMessage(
      "Tracking gestoppt - Zeitüberschreitung",
    ),
    "finishReachedStopedTracking": MessageLookupByLibrary.simpleMessage(
      "Ziel erreicht - Tracking beendet.",
    ),
    "finishReachedTitle": MessageLookupByLibrary.simpleMessage("Ziel erreicht"),
    "finishReachedtargetReachedPleaseStopTracking":
        MessageLookupByLibrary.simpleMessage(
          "Ziel erreicht - Tracking bitte Tracking anhalten.",
        ),
    "finishStopTrackingEventOver": MessageLookupByLibrary.simpleMessage(
      "Autostopp Tracking, da die BladeNight Veranstaltung beendet ist. (Lange drücken auf ▶️ deaktiviert Autostopp)",
    ),
    "finishStopTrackingTimeout": m8,
    "finished": MessageLookupByLibrary.simpleMessage("Beendet"),
    "fireBaseCrashlytics": MessageLookupByLibrary.simpleMessage(
      "Crashlytics an/aus",
    ),
    "fireBaseCrashlyticsHeader": MessageLookupByLibrary.simpleMessage(
      "Um die App zu verbessern, werden Absturzprotokolle an Crashlytics gesendet. Dies kann hier unterdrückt werden.",
    ),
    "fitnessPermissionInfoText": MessageLookupByLibrary.simpleMessage(
      "Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn dein Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren. Die Abfrage erfolgt in den nächsten Schritten.",
    ),
    "fitnessPermissionInfoTextTitle": MessageLookupByLibrary.simpleMessage(
      "Bewegungssensor / Körperliche Aktivität",
    ),
    "fitnessPermissionSettingsText": MessageLookupByLibrary.simpleMessage(
      "Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn dein Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.",
    ),
    "fitnessPermissionSwitchSettingsText": MessageLookupByLibrary.simpleMessage(
      "Bewegungssensor aktiv",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort vergessen",
    ),
    "forward": MessageLookupByLibrary.simpleMessage("Weiter"),
    "friend": MessageLookupByLibrary.simpleMessage("Freund:in"),
    "friendIs": MessageLookupByLibrary.simpleMessage("Freund:in ist"),
    "friendScanQrCode": m9,
    "friends": MessageLookupByLibrary.simpleMessage("Freunde"),
    "friendswillmissyou": MessageLookupByLibrary.simpleMessage(
      "Bitte unterstütze weiter die genaue Darstellung des BladeNight-Zuges.\nAusserdem werden deine Freunde dich vermissen!",
    ),
    "from": MessageLookupByLibrary.simpleMessage("vom"),
    "geoFencing": MessageLookupByLibrary.simpleMessage("Geofencing aktiv"),
    "geoFencingTitle": MessageLookupByLibrary.simpleMessage(
      "Bladeguard vor Ort - per Geofencing erlauben. Wenn du im Umkreis des Startpunktes bist, wirst du automatisch als BladeGuard digital angemeldet. Standortfreigabe muss auf immer stehen (beta)",
    ),
    "getwebdata": MessageLookupByLibrary.simpleMessage("Lade Serverdaten ..."),
    "head": MessageLookupByLibrary.simpleMessage("Zugkopf"),
    "home": MessageLookupByLibrary.simpleMessage("Info"),
    "iAmBladeGuard": MessageLookupByLibrary.simpleMessage(
      "Ich bin bereits Bladeguard",
    ),
    "iAmBladeGuardTitle": m10,
    "iam": MessageLookupByLibrary.simpleMessage("Ich bin"),
    "ignoreBatteriesOptimisation": MessageLookupByLibrary.simpleMessage(
      "Hinweis - manche Hersteller schalten die Apps durch ungünstige Batterieoptimierungen ab oder schließen die App. In dem Falle bitte versuchen die Batterieoptimierung für die App zu deaktivieren. Einstellung keine Beschränkung.",
    ),
    "ignoreBatteriesOptimisationTitle": MessageLookupByLibrary.simpleMessage(
      "Batterieoptimierung ändern",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Importieren"),
    "importWarning": MessageLookupByLibrary.simpleMessage(
      "Achtung dies überschreibt alle Freunde und die Kennung. Vorher Daten exportieren! Achtung die App auf dem Gerät von dessen exportiert wurde löschen!",
    ),
    "importWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Import Freunde und Id.",
    ),
    "inprogress": MessageLookupByLibrary.simpleMessage(
      "Entwicklung in Arbeit ...",
    ),
    "internalerror_invalidcode": MessageLookupByLibrary.simpleMessage(
      "ungültiger Code",
    ),
    "internalerror_seemslinked": MessageLookupByLibrary.simpleMessage(
      "Fehler - Freund:in schon verlinkt?",
    ),
    "invalidEMail": MessageLookupByLibrary.simpleMessage(
      "Email nicht gefunden!",
    ),
    "invalidLoginData": MessageLookupByLibrary.simpleMessage(
      "Email nicht gefunden oder falsches Geburtsdatum. Eventuell E-Mmail Unterstützung wählen.",
    ),
    "invalidcode": MessageLookupByLibrary.simpleMessage("Code unbekannt"),
    "invitebyname": m11,
    "invitenewfriend": MessageLookupByLibrary.simpleMessage(
      "Freund:in einladen",
    ),
    "isIgnoring": MessageLookupByLibrary.simpleMessage("Wird ignoriert"),
    "ist": MessageLookupByLibrary.simpleMessage("ist"),
    "isuseractive": MessageLookupByLibrary.simpleMessage("In Karte anzeigen?"),
    "lastseen": MessageLookupByLibrary.simpleMessage("Zuletzt gesehen"),
    "lastupdate": MessageLookupByLibrary.simpleMessage("Letztes Update"),
    "later": MessageLookupByLibrary.simpleMessage("Später"),
    "lead": MessageLookupByLibrary.simpleMessage("Zuganfang/ende"),
    "leadspec": MessageLookupByLibrary.simpleMessage("Zug+Spezial"),
    "leaveAppWarning": m12,
    "leaveAppWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Externen Link öffnen?",
    ),
    "leavewheninuse": MessageLookupByLibrary.simpleMessage(
      "Lasse \'Standortfreigabe während Nutzung\'",
    ),
    "length": MessageLookupByLibrary.simpleMessage("Länge"),
    "linkAsBrowserDevice": m13,
    "linkNearBy": MessageLookupByLibrary.simpleMessage(
      "Freund:in neben Dir annehmen",
    ),
    "linkOnOtherDevice": m14,
    "linkingFailed": MessageLookupByLibrary.simpleMessage(
      "Verknüpfung fehlgeschlagen",
    ),
    "linkingSuccessful": MessageLookupByLibrary.simpleMessage(
      "Verknüpfung erfolgreich",
    ),
    "liveMapInBrowser": MessageLookupByLibrary.simpleMessage(
      "Verfolgt die Bladnight ohne App im Browser",
    ),
    "liveMapInBrowserInfoHeader": MessageLookupByLibrary.simpleMessage(
      "Livekarte im Browser",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Lade ..."),
    "locationNotPrecise": MessageLookupByLibrary.simpleMessage(
      "Bitte die Standortfreigabe auf \'Genau\'\' in den Systemeinstellungen ändern, da die App sonst nicht korrekt arbeitet!",
    ),
    "locationNotPreciseTitle": MessageLookupByLibrary.simpleMessage(
      "Standort ungenau",
    ),
    "locationServiceOff": MessageLookupByLibrary.simpleMessage(
      "Standortübertragung ist in den Einstellungen deaktiviert oder noch nie gestartet! Tracking nicht möglich.",
    ),
    "locationServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Standortübertragung aktiv.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "loginThreeHoursBefore": MessageLookupByLibrary.simpleMessage(
      "Digitale Anmeldung 3 Stunden vor Start in der Nähe des Startpunktes möglich!",
    ),
    "manufacturer": MessageLookupByLibrary.simpleMessage("Hersteller"),
    "map": MessageLookupByLibrary.simpleMessage("Karte"),
    "mapAlign": MessageLookupByLibrary.simpleMessage("Kartenausrichtung"),
    "mapFollow": MessageLookupByLibrary.simpleMessage("Auf Karte verfolgen"),
    "mapFollowLocation": MessageLookupByLibrary.simpleMessage(
      "Karte folgt meiner Position.",
    ),
    "mapFollowStopped": MessageLookupByLibrary.simpleMessage(
      "Karte folgt mir gestoppt!",
    ),
    "mapFollowTrain": MessageLookupByLibrary.simpleMessage(
      "Karte folgt Zugkopfposition.",
    ),
    "mapFollowTrainStopped": MessageLookupByLibrary.simpleMessage(
      "Karte folgt Zugkopf gestoppt.",
    ),
    "mapToStartNoFollowing": MessageLookupByLibrary.simpleMessage(
      "Karte auf Start. Kein verfolgen.",
    ),
    "markMeAsHead": MessageLookupByLibrary.simpleMessage(
      "Markiere meine Position als Zugkopf",
    ),
    "markMeAsTail": MessageLookupByLibrary.simpleMessage(
      "Markiere meine Position als Zugende",
    ),
    "me": MessageLookupByLibrary.simpleMessage("Ich"),
    "menu": MessageLookupByLibrary.simpleMessage("Auswahl"),
    "message": MessageLookupByLibrary.simpleMessage("Nachricht"),
    "messages": MessageLookupByLibrary.simpleMessage("Nachrichten"),
    "metersOnRoute": MessageLookupByLibrary.simpleMessage("gef.Strecke"),
    "missingName": MessageLookupByLibrary.simpleMessage(
      "Feld muss min. 1 Zeichen enthalten",
    ),
    "model": MessageLookupByLibrary.simpleMessage("Modell"),
    "mustNearbyStartingPoint": m15,
    "mustentername": MessageLookupByLibrary.simpleMessage(
      "Du musst einen Namen eingeben!",
    ),
    "myName": MessageLookupByLibrary.simpleMessage("Mein Name:"),
    "myNameHeader": MessageLookupByLibrary.simpleMessage(
      "Der angegebene Name wird bei der Verknüpfung mit deinem Freund an das 2. Gerät übertragen. Der Name ist nur lokal gespeichert und dient der vereinfachten Verknüpfung per lokaler Verbindung.Es muss auf beiden Geräten eine Internetverbindung bestehen um den Code vom Server abzuholen. Alternativ kann auch ohne Name per Code verknüpft werden.",
    ),
    "mySpeed": MessageLookupByLibrary.simpleMessage(
      "Meine Geschwindigkeit auf Route",
    ),
    "nameexists": MessageLookupByLibrary.simpleMessage(
      "Sorry, Name schon vergeben!",
    ),
    "networkerror": MessageLookupByLibrary.simpleMessage(
      "Netzwerkfehler - Keine Daten!",
    ),
    "never": MessageLookupByLibrary.simpleMessage("nie"),
    "newGPSDatareceived": MessageLookupByLibrary.simpleMessage(
      "Neue GPS Daten",
    ),
    "nextEvent": MessageLookupByLibrary.simpleMessage("Nächste BladeNight!"),
    "no": MessageLookupByLibrary.simpleMessage("Nein"),
    "noBackgroundlocationLeaveAppOpen": MessageLookupByLibrary.simpleMessage(
      "Standort \'Während der Benutzung\' ist eingestellt. Daher ist keine Hintergrundaktualisierung aktiviert. Um die Darstellung des BladeNight-Zuges so genau wie möglich zu bekommen und deine Postion ohne Einschränkung mit Freunden zu teilen, bitten wir Dich die App offen halten oder die Einstellung auf \'Immer zulassen\' zu ändern. Danke.",
    ),
    "noBackgroundlocationTitle": MessageLookupByLibrary.simpleMessage(
      "Hinweis, keine Hintergrundaktualisierung.",
    ),
    "noChoiceNoAction": MessageLookupByLibrary.simpleMessage(
      "Keine Auswahl, daher keine Aktion",
    ),
    "noEvent": MessageLookupByLibrary.simpleMessage("Aktuell keine Termine"),
    "noEventPlanned": MessageLookupByLibrary.simpleMessage(
      "Aktuell ist keine Veranstaltung geplant.",
    ),
    "noEventStarted": MessageLookupByLibrary.simpleMessage(
      "Aktuell keine Veranstaltung.",
    ),
    "noEventStartedAutoStop": MessageLookupByLibrary.simpleMessage(
      "Autostop - da keine Veranstaltung",
    ),
    "noEventTimeOut": m16,
    "noGpsAllowed": MessageLookupByLibrary.simpleMessage("GPS nicht aktiviert"),
    "noLocationAvailable": MessageLookupByLibrary.simpleMessage(
      "Kein Standort",
    ),
    "noLocationPermissionGrantedAlertAndroid": MessageLookupByLibrary.simpleMessage(
      "Bitte System-Einstellungen (Einstellungen -> Standort -> Standortzugriff von Apps -> BladeNight) prüfen, da keine Standortfreigabe.",
    ),
    "noLocationPermissionGrantedAlertTitle":
        MessageLookupByLibrary.simpleMessage(
          "Achtung fehlende Standortfreigabe",
        ),
    "noLocationPermissionGrantedAlertiOS": MessageLookupByLibrary.simpleMessage(
      "Bitte iOS Einstellunge prüfen, da keine Standortfreigabe. Diese müsste in den Telefon-Einstellungen unter Datenschutz - Ortungsdienste - BladnightApp freigegeben werden.",
    ),
    "noLocationPermitted": MessageLookupByLibrary.simpleMessage(
      "Keine Standortfreigabe, Bitte Einstellungen des Gerätes prüfen",
    ),
    "noLocationRequestPermission": MessageLookupByLibrary.simpleMessage(
      "Standortfreigabe notwendig für Vor-Ort-Anmeldung - Tippen zur Aktivierung",
    ),
    "noNearbyService": MessageLookupByLibrary.simpleMessage(
      "Nah-Gerätesuche nicht aktiv",
    ),
    "noSelfRelationAllowed": MessageLookupByLibrary.simpleMessage(
      "Beziehung mit sich selbst ist nicht erlaubt",
    ),
    "noValidPendingRelationShip": MessageLookupByLibrary.simpleMessage(
      "Keine gültige Beziehungsverknüpfung",
    ),
    "nodatareceived": MessageLookupByLibrary.simpleMessage(
      "Keine Daten empfangen!",
    ),
    "nogps": MessageLookupByLibrary.simpleMessage("Kein GPS"),
    "nogpsenabled": MessageLookupByLibrary.simpleMessage(
      "Es ist scheinbar kein GPS im Gerät vorhanden oder für die App deaktiviert. Bitte die Einstellungen prüfen.",
    ),
    "notAvailable": MessageLookupByLibrary.simpleMessage("nicht verfügbar"),
    "notKnownOnServer": MessageLookupByLibrary.simpleMessage(
      "Veralted bitte,neu anlegen/löschen!",
    ),
    "notOnRoute": MessageLookupByLibrary.simpleMessage(
      "Nicht im BladeNight-Zug!",
    ),
    "notVisibleOnMap": MessageLookupByLibrary.simpleMessage(
      "Auf Karte nicht angezeigt",
    ),
    "note_bladenightCanceled": MessageLookupByLibrary.simpleMessage(
      "Die BladeNight wurde leider abgesagt.",
    ),
    "note_bladenightStartInFiveMinutesStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "Nächste BladeNight! startet in 5 minuten. Tracking einschalten nicht vergessen !!",
        ),
    "note_bladenightStartInSixHoursStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "Nächste BladeNight! startet in 6 Stunden.",
        ),
    "note_statuschanged": MessageLookupByLibrary.simpleMessage(
      "BladeNight! Status geändert - Bitte in App prüfen",
    ),
    "notification": MessageLookupByLibrary.simpleMessage("Notification"),
    "notracking": MessageLookupByLibrary.simpleMessage("Kein Tracking!"),
    "now": MessageLookupByLibrary.simpleMessage("Jetzt"),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on": MessageLookupByLibrary.simpleMessage("am"),
    "onRoute": MessageLookupByLibrary.simpleMessage("auf der Strecke"),
    "oneSignalId": MessageLookupByLibrary.simpleMessage("OneSignal-Id: "),
    "oneSignalIdTitle": MessageLookupByLibrary.simpleMessage(
      "Dies ist die zugewiesene Id für den Empfang von Push-Nachrichten. Teilen Sie uns die ID mit, wenn Du Probleme beim Empfang von Push-Nachrichten hast.",
    ),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "onlyReducedLocationAccuracyText": MessageLookupByLibrary.simpleMessage(
      "Nur ungefährer Standort ist freigegeben. Dies kann zur Fehldarstellung der Veranstaltung führen und ist nicht erlaubt. Du kannst die Standortfunktion nicht nutzen!",
    ),
    "onlyReducedLocationAccuracyTitle": MessageLookupByLibrary.simpleMessage(
      "Nur ungefährer Standort",
    ),
    "onlyTracking": MessageLookupByLibrary.simpleMessage(
      "Nur Routenaufzeichnung aktiv",
    ),
    "onlyWhenInUseEnabled": MessageLookupByLibrary.simpleMessage(
      "Standortfreigabe \'Während Nutzung der App\' freigegeben",
    ),
    "onlyWhileInUse": MessageLookupByLibrary.simpleMessage(
      "Standortfreigabe \'Während App in Benutzung\' erteilt.",
    ),
    "onsiteCount": MessageLookupByLibrary.simpleMessage(
      "Bladeguards vor Ort angemeldet",
    ),
    "openOperatingSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Öffne Systemeinstellungen",
    ),
    "openStreetMap": MessageLookupByLibrary.simpleMessage(
      "Openstreetmap Kartenteile laden / Neustart erforderlich",
    ),
    "openStreetMapText": MessageLookupByLibrary.simpleMessage(
      "Nutze Openstreetmap",
    ),
    "own": MessageLookupByLibrary.simpleMessage("Eigene"),
    "participant": MessageLookupByLibrary.simpleMessage("Teilnehmer"),
    "pending": MessageLookupByLibrary.simpleMessage("Geplant"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Tel:"),
    "pickcolor": MessageLookupByLibrary.simpleMessage("Farbe wählen"),
    "polyLinesAmount": MessageLookupByLibrary.simpleMessage(
      "Auf manchen Geräten führt eine hohe Anzahl an eigenen Routenpunkten dazu das die Karte sehr langsam wird. Empfehlung 200-2000 Einzellinien der Route. Die Fahrlinie wird bei überschreiten der Anzahl Punkte reduziert.",
    ),
    "polyLinesAmountHeader": MessageLookupByLibrary.simpleMessage("Anzahl"),
    "polyLinesTolerance": MessageLookupByLibrary.simpleMessage(
      "Auf manchen Geräten führt eine hohe Anzahl an eigenen Routenpunkten dazu das die Karte sehr langsam wird. Die Fahrlinie wird reduziert hier kann man die Toleranz einstellen je höher umso ungenauer. Kleiner/links = langsam und genauer/ Größer/rechts = schneller und gröbere Darstellung",
    ),
    "polyLinesToleranceHeader": MessageLookupByLibrary.simpleMessage(
      "Toleranz",
    ),
    "position": MessageLookupByLibrary.simpleMessage("Position"),
    "positiveInFront": MessageLookupByLibrary.simpleMessage(
      "Positiv vor mir, Negativ hinter mir.",
    ),
    "proceed": MessageLookupByLibrary.simpleMessage("Weiter"),
    "prominentdisclosuretrackingprealertandroidFromAndroid_V11":
        MessageLookupByLibrary.simpleMessage(
          "Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNight-Zuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben.Hier sollte  \'Bei der Nutzung der App zulassen\' gewählt werden. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung \"Immer zulassen\" die zu einem späteren Zeitpunkt (2.Schritt über Systemeinstellungen) erfolgt. Dies ermöglicht das Tracking auch wenn du eine andere App im Vordergrund geöffnet hast. Mit \"Während der Benutzung\" musst du die BladeNight immer im Vordergrund offen halten um uns zu unterstützen und deinen Standort zu teilen.Weiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn dein Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.",
        ),
    "prominentdisclosuretrackingprealertandroidToAndroid_V10x":
        MessageLookupByLibrary.simpleMessage(
          "Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNight-Zuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung \"Bei der Nutzung der App zulassen\".",
        ),
    "pushMessageParticipateAsBladeGuard": MessageLookupByLibrary.simpleMessage(
      "Bladeguard Push",
    ),
    "pushMessageParticipateAsBladeGuardTitle":
        MessageLookupByLibrary.simpleMessage(
          "Bladeguard-Informationen per Push-Mitteilung erhalten?",
        ),
    "pushMessageSkateMunichInfos": MessageLookupByLibrary.simpleMessage(
      "Skatemunich Infos",
    ),
    "pushMessageSkateMunichInfosTitle": MessageLookupByLibrary.simpleMessage(
      "Infos von SkateMunich per Push über Veranstaltungen empfangen?",
    ),
    "qrcoderouteinfoheader": MessageLookupByLibrary.simpleMessage(
      "QRCode - Link zum teilen der aktuellen BladeNight-Daten ohne App",
    ),
    "receiveBladeGuardInfos": MessageLookupByLibrary.simpleMessage(
      "Empfange Bladeguard Infos",
    ),
    "received": MessageLookupByLibrary.simpleMessage("empfangen"),
    "refresh": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "refreshHeader": MessageLookupByLibrary.simpleMessage(
      "Daten aktualisieren",
    ),
    "register": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "registeredAs": MessageLookupByLibrary.simpleMessage("Angemeldet als:"),
    "reload": MessageLookupByLibrary.simpleMessage("Neu laden"),
    "reltime": MessageLookupByLibrary.simpleMessage("rel. Zeitdiff."),
    "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
    "requestAlwaysPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Standort - Immer zulassen",
    ),
    "requestLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Information, warum die Standortfreigeben notwendig wäre.",
    ),
    "requestOffSite": MessageLookupByLibrary.simpleMessage(
      "Du möchtest dich heute wirklich als Bladeguard wieder abmelden. Wir brauchen jeden. Überlege es Dir noch einmal. ",
    ),
    "requestOffSiteTitle": MessageLookupByLibrary.simpleMessage(
      "Vor-Ort-Abmeldung ?",
    ),
    "resetInSettings": MessageLookupByLibrary.simpleMessage(
      "Reset in Einstellungen",
    ),
    "resetLongPress": MessageLookupByLibrary.simpleMessage(
      "Tachometer lange drücken zum Reset des km Zählers (ODO-Meter)",
    ),
    "resetOdoMeter": MessageLookupByLibrary.simpleMessage(
      "Km-Zähler auf 0 setzen und eigene gefahrene Routenpunkte auf Karte löschen?",
    ),
    "resetOdoMeterTitle": MessageLookupByLibrary.simpleMessage(
      "Reset km-Zähler und eigene Routenpunkte",
    ),
    "resetTrackPointsStore": MessageLookupByLibrary.simpleMessage(
      "Lösche alle Routendaten",
    ),
    "resetTrackPointsStoreTitle": MessageLookupByLibrary.simpleMessage(
      "Lösche alle aufgezeichneten und gespeicherten Tracks",
    ),
    "restartRequired": MessageLookupByLibrary.simpleMessage(
      "Neustart erforderlich! Bitte App schließen und neu öffnen !!!",
    ),
    "route": MessageLookupByLibrary.simpleMessage("Strecke"),
    "routeoverview": MessageLookupByLibrary.simpleMessage("Routenverlauf"),
    "running": MessageLookupByLibrary.simpleMessage("Wir fahren gerade"),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "scanCodeForFriend": m17,
    "scrollMapTo": MessageLookupByLibrary.simpleMessage("Scrolle Karte zu ..."),
    "searchNearby": MessageLookupByLibrary.simpleMessage(
      "Suche Geräte in der Nähe ...",
    ),
    "seemsoffline": MessageLookupByLibrary.simpleMessage(
      "Warte auf Internetverbindung ...",
    ),
    "selectDate": MessageLookupByLibrary.simpleMessage("Eventdatum wählen"),
    "selectTrackingType": MessageLookupByLibrary.simpleMessage(
      "Trackingtypauswahl",
    ),
    "sendData30sec": MessageLookupByLibrary.simpleMessage(
      "Anfrage gesendet - Dauert ca. 30s.",
    ),
    "sendMail": MessageLookupByLibrary.simpleMessage(
      "Ich habe ein Problem! (Email-Support)",
    ),
    "sendlink": MessageLookupByLibrary.simpleMessage("Link senden"),
    "sendlinkdescription": m18,
    "sendlinksubject": MessageLookupByLibrary.simpleMessage(
      "Sende link an BladeNight-App. Ihr könnt euch gegenseitig sehen.",
    ),
    "serverConnected": MessageLookupByLibrary.simpleMessage("Server verbunden"),
    "serverNotReachable": MessageLookupByLibrary.simpleMessage(
      "Warte auf Verbindung ..",
    ),
    "serverVersion": MessageLookupByLibrary.simpleMessage("Serverversion"),
    "sessionConnectionError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Verbinden",
    ),
    "setClearLogs": MessageLookupByLibrary.simpleMessage("Logdateien löschen"),
    "setDarkMode": MessageLookupByLibrary.simpleMessage(
      "Dunkelmodus aktivieren",
    ),
    "setDarkModeTitle": MessageLookupByLibrary.simpleMessage(
      "App-Layout Hell- und Dunkelmodus ändern.",
    ),
    "setExportLogSupport": MessageLookupByLibrary.simpleMessage(
      "Export Logdaten an Support",
    ),
    "setIconSize": MessageLookupByLibrary.simpleMessage("Icongröße: "),
    "setIconSizeTitle": MessageLookupByLibrary.simpleMessage(
      "Eigene Icongröße sowie die von Freunden, Zuganfang und -ende auf der Karte anpassen",
    ),
    "setInsertImportDataset": MessageLookupByLibrary.simpleMessage(
      "Hier Datensatz einfügen incl. bna:",
    ),
    "setLogData": MessageLookupByLibrary.simpleMessage("Datenlogger"),
    "setLogLevel": MessageLookupByLibrary.simpleMessage("Loglevel einstellen"),
    "setMeColor": MessageLookupByLibrary.simpleMessage("Eigene Farbe in Karte"),
    "setOpenSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Öffne Systemeinstellungen",
    ),
    "setPrimaryColor": MessageLookupByLibrary.simpleMessage(
      "Text- und Symbolfarben im Normalmodus/Hell ändern",
    ),
    "setPrimaryDarkColor": MessageLookupByLibrary.simpleMessage(
      "Text- und Symbolfarben im Dunkelmodus ändern",
    ),
    "setRoute": MessageLookupByLibrary.simpleMessage("Setze Strecke"),
    "setStartImport": MessageLookupByLibrary.simpleMessage(
      "Import Id und Freunde starten",
    ),
    "setState": MessageLookupByLibrary.simpleMessage("Setze Status"),
    "setSystem": MessageLookupByLibrary.simpleMessage("System"),
    "setTeam": MessageLookupByLibrary.simpleMessage("Welches Team bist du?"),
    "setcolor": MessageLookupByLibrary.simpleMessage("Farbe ändern"),
    "setexportDataHeader": MessageLookupByLibrary.simpleMessage("Export"),
    "setexportIdAndFriends": MessageLookupByLibrary.simpleMessage(
      "Export Id und Freunde",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "showCompass": MessageLookupByLibrary.simpleMessage("Kompass zeigen"),
    "showCompassTitle": MessageLookupByLibrary.simpleMessage(
      "Zeige Kompass auf Karte",
    ),
    "showFullProcession": MessageLookupByLibrary.simpleMessage(
      "Zeige Teilnehmer",
    ),
    "showFullProcessionTitle": MessageLookupByLibrary.simpleMessage(
      "Zeige Teilnehmer (auf 100 aus dem Zug limitiert) in der Karte. Funktioniert nur bei eigener Standortfreigabe.",
    ),
    "showLogData": MessageLookupByLibrary.simpleMessage("Zeige Log Monitor"),
    "showOwnColoredTrack": MessageLookupByLibrary.simpleMessage(
      "Coloriere Route",
    ),
    "showOwnTrack": MessageLookupByLibrary.simpleMessage(
      "Eigene Fahrlinie zeigen. Es kann die eigene Fahrt aufgezeichnet werden und dargestellt werden. Die Colorierte Route zeigt auch die Geschwindigkeit, kann aber je nach Gerät beim zoomen etc. zu ruckeln führen.",
    ),
    "showOwnTrackSwitchTitle": MessageLookupByLibrary.simpleMessage(
      "Fahrlinie zeigen",
    ),
    "showProcession": MessageLookupByLibrary.simpleMessage(
      "Darstellung aktueller Verlauf der Münchener BladeNight",
    ),
    "showWeblinkToRoute": MessageLookupByLibrary.simpleMessage(
      "Zeige QRCode zum Weblink",
    ),
    "showonly": MessageLookupByLibrary.simpleMessage("Nur Anzeige"),
    "since": MessageLookupByLibrary.simpleMessage("seit"),
    "someSettingsNotAvailableBecauseOffline": MessageLookupByLibrary.simpleMessage(
      "Einige Einstellungen sind nicht verfügbar da keine Serververbindung besteht.",
    ),
    "spec": MessageLookupByLibrary.simpleMessage("Spezial"),
    "specialfunction": MessageLookupByLibrary.simpleMessage(
      "Sondereinstellungen - nur nach Rücksprache ändern!",
    ),
    "speed": MessageLookupByLibrary.simpleMessage("Geschwindigkeit"),
    "sponsors": MessageLookupByLibrary.simpleMessage(
      "Danke an unsere Unterstützer",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Tracking ohne Teilnahme",
    ),
    "startLocationWithoutParticipatingInfo": MessageLookupByLibrary.simpleMessage(
      "Tracking ohne Teilnahme\nDies startet die Standortdarstellung auf der Karte ohne Teilnahme an der BladeNight und überträgt zur Berechnung der Zeiten deinen Standort auf den Server. Deine Freunde im Zug werden Dir angezeigt. Die Zeit zum Zuganfang /-ende von deinem Standort werden berechnet. Weiterhin, werden deine Geschwindigkeit und Trackingdaten aufgezeichnet die du speichern kannst. Bitte diese Funktion nicht verwenden, wenn du an der BladeNight teilnimmst. Der Modus muss manuell beendet werden. \nSoll dies gestartet werden?",
    ),
    "startNoParticipationShort": MessageLookupByLibrary.simpleMessage(
      "Zeige deine Position",
    ),
    "startParticipation": MessageLookupByLibrary.simpleMessage(
      "Teilnahme starten\nDu bist aktiver Skater im Zug und möchtest die Darstellung des BladeNight-Zuges unterstützen. Danke wenn du Teilnahme an Bladenight starten drückst.",
    ),
    "startParticipationHeader": MessageLookupByLibrary.simpleMessage(
      "Du fährst heute bei der Bladenight mit und möchtest die Darstellung des Zuges unterstützen und deinen Standort mit Freunden teilen. Dies ist auch notwendig um dich als Bladeguard vor Ort zu einzutragen.Standortfreigabe starten?",
    ),
    "startParticipationShort": MessageLookupByLibrary.simpleMessage(
      "Teilnahme starten",
    ),
    "startParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Teilnahme an BladeNight starten",
    ),
    "startPoint": MessageLookupByLibrary.simpleMessage(
      "Start: München - Bavariapark",
    ),
    "startPointTitle": MessageLookupByLibrary.simpleMessage("Startpunkt"),
    "startTime": MessageLookupByLibrary.simpleMessage("Startzeit"),
    "startTrackingOnly": MessageLookupByLibrary.simpleMessage(
      "Starte Routenaufzeichnung",
    ),
    "startTrackingOnlyTitle": MessageLookupByLibrary.simpleMessage(
      "Starte die Routenaufzeichnung ohne die Standortdaten an den Server zu übermitteln.",
    ),
    "startsIn": MessageLookupByLibrary.simpleMessage("Startet in"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "status_active": MessageLookupByLibrary.simpleMessage("Aktiv"),
    "status_inactive": MessageLookupByLibrary.simpleMessage("Inaktiv"),
    "status_obsolete": MessageLookupByLibrary.simpleMessage("Veraltet"),
    "status_pending": MessageLookupByLibrary.simpleMessage("Ausstehend"),
    "stopLocationTracking": MessageLookupByLibrary.simpleMessage(
      "Stoppe Tracking wirklich?",
    ),
    "stopLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Stoppe Position ohne Teilnahme",
    ),
    "stopParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Stoppe Teilnahme/ Tracking",
    ),
    "stopTrackingTimeOut": m19,
    "submit": MessageLookupByLibrary.simpleMessage("Senden"),
    "symbols": MessageLookupByLibrary.simpleMessage("Symbole"),
    "tail": MessageLookupByLibrary.simpleMessage("Zugende"),
    "tellcode": m20,
    "thanksForParticipating": MessageLookupByLibrary.simpleMessage(
      "Danke fürs Teilnehmen.",
    ),
    "timeIntl": m21,
    "timeOutDurationExceedTitle": MessageLookupByLibrary.simpleMessage(
      "Zeitüberschreitung Dauer der BladeNight",
    ),
    "timeStamp": MessageLookupByLibrary.simpleMessage("Stand von"),
    "timeToFinish": MessageLookupByLibrary.simpleMessage(
      "Dauer bis zum Ziel (ca.)",
    ),
    "timeToFriend": MessageLookupByLibrary.simpleMessage(
      "Dauer zum Freund (ca.)",
    ),
    "timeToHead": MessageLookupByLibrary.simpleMessage(
      "Dauer zum Zugkopf (ca.)",
    ),
    "timeToMe": MessageLookupByLibrary.simpleMessage("Dauer von mir (ca.)"),
    "timeToTail": MessageLookupByLibrary.simpleMessage(
      "Dauer zum Zugende (ca.)",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Heute"),
    "todayNo": MessageLookupByLibrary.simpleMessage("Heute nein"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Morgen"),
    "trackPointsExporting": MessageLookupByLibrary.simpleMessage(
      "Folgende Routenpunkte werden exportiert: ",
    ),
    "trackers": MessageLookupByLibrary.simpleMessage("Tracker"),
    "tracking": MessageLookupByLibrary.simpleMessage("Daten vorhanden"),
    "trackingPoints": MessageLookupByLibrary.simpleMessage(
      "Aufgezeichnete Routenpunkte",
    ),
    "trackingRestarted": MessageLookupByLibrary.simpleMessage(
      "Tracking wieder gestartet",
    ),
    "trackingStoppedLowBat": m22,
    "train": MessageLookupByLibrary.simpleMessage("Skater-Zug"),
    "trainlength": MessageLookupByLibrary.simpleMessage("Zuglänge"),
    "tryOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "Dies kann nur in den Systemeinstellungen geändert werden! Versuche Systemeinstellungen zu öffnen?",
    ),
    "understand": MessageLookupByLibrary.simpleMessage("Verstanden"),
    "unknown": MessageLookupByLibrary.simpleMessage("unbekannt"),
    "unknownerror": MessageLookupByLibrary.simpleMessage("unbek. Fehler"),
    "updatePhone": MessageLookupByLibrary.simpleMessage("UpdatePhone"),
    "updating": MessageLookupByLibrary.simpleMessage("Aktualisiere Daten"),
    "userSpeed": MessageLookupByLibrary.simpleMessage(
      "Meine GPS-Geschwindigkeit.",
    ),
    "validatefriend": MessageLookupByLibrary.simpleMessage(
      "Freund:in verknüpfen",
    ),
    "version": MessageLookupByLibrary.simpleMessage("Version:"),
    "visibleOnMap": MessageLookupByLibrary.simpleMessage(
      "Auf Karte angezeigt.",
    ),
    "waitForLocation": MessageLookupByLibrary.simpleMessage(
      "Ermittle Standort",
    ),
    "waiting": MessageLookupByLibrary.simpleMessage("Wartend..."),
    "waittime": MessageLookupByLibrary.simpleMessage("Wartezeit"),
    "wakelockDisabled": MessageLookupByLibrary.simpleMessage(
      "Display schaltet ab - Akku laden",
    ),
    "wakelockEnabled": MessageLookupByLibrary.simpleMessage(
      "Display bleibt an",
    ),
    "wakelockWarnBattery": m23,
    "warning": MessageLookupByLibrary.simpleMessage("Achtung!"),
    "wasCanceledPleaseCheck": MessageLookupByLibrary.simpleMessage(
      "wurde leider abgesagt! Bitte prüfe dies auf https://bladenight-muenchen.de",
    ),
    "weekdayIntl": m24,
    "yes": MessageLookupByLibrary.simpleMessage("Ja"),
    "yesterday": MessageLookupByLibrary.simpleMessage("war gestern"),
  };
}
