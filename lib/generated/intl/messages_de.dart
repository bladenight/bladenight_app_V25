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

  static String m0(date) => "${date}";

  static String m1(date, time) => "${date} ${time}Uhr";

  static String m2(date, time) => "${date} ${time}Uhr";

  static String m3(date, time) => "${date} ${time}Uhr";

  static String m4(timeout) =>
      "Automatischer Trackingstopp nach max. ${timeout}min. BladeNight beendet. (Lange drücken auf ▶️ deaktiviert Autostop)";

  static String m5(name) => "${name} einladen";

  static String m6(deviceName) =>
      "Dein Freund muss in max. 2 m Entfernung von Dir sein!\n- Bitte bei deinem Freund in der Bladenight-App den Tab Freunde öffnen lassen.\n- Dort Plus oben rechts wählen\n- Freund:in neben Dir annehmen wählen\n- Nun mit diesem Gerät ${deviceName} koppeln.\n- Du kannst deinen übermittelten Namen im Textfeld oben ändern.";

  static String m7(timeout) =>
      "Keine Veranstaltung seit mindestens ${timeout} min. aktiv - Tracking automatisch beendet";

  static String m8(requestid, playStoreLink, iosAppStoreLink) =>
      "Dies ist die Einladung um deine(n) Freund:in (Absender der Nachricht) in der BladeNightApp zu sehen und euch im Skaterzug wiederzufinden. Wenn du das möchtest lade Dir die Baldenigthapp und gib den Code: ${requestid} ein.\nWenn die App schon installiert ist benutze den link  \'bna://bladenight.app?code=${requestid}\' oder \'https://bladenight.app?code=${requestid}\'auf dem Telefon. \nViel Spass beim skaten.\nDie App ist verfügbar im Playstore \n${playStoreLink} und im Apple App Store \n${iosAppStoreLink}";

  static String m9(timeout) =>
      "Eventzeit (${timeout} min) überzogen. Tracking abschalten nicht vergessen!";

  static String m10(name, requestid) =>
      "Sende an \'${name}\' den Code \n\n${requestid}\nEr/Sie/es muss den Code in dessen BladeNight App bestätigen. \nDer Code ist 60 min gültig!\nBitte über ↻ den Status manuell aktualisieren.";

  static String m11(time) => "${time} Uhr";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_appinfo": MessageLookupByLibrary.simpleMessage(
            "Die App wird kostenfrei vom Herausgeber zur Information zur Münchener Bladnight, für Skatemunich e.V. und dessen Sponsoren bereitgestellt.\nDie App bietet allen BladeNight Teilnehmern folgende Funktionen an:\n\t-Übersicht der kommenden und vergangenen Termine\n- Anzeige der Strecken auf der Karte\n- Live Anzeige des Zuges während der BladeNight\n- Live Anzeige der eigenen Position auf der Strecke und innerhalb des Zuges\n- Freunde hinzufügen und Live verfolgen"),
        "about_appprivacy": MessageLookupByLibrary.simpleMessage(
            "Diese App benutzt eine eindeutige Id die beim ersten Start der App lokal gespeichert wird.\nDiese Id wird auf dem Server benutzt um Freunde zu verknüpfen und die Position zu teilen. Diese wird nur zwischen der eigenen App und Server übertragen.\nWeiterhin wird die App-Versionsnummer und Telefonhersteller (Apple oder Android) zur Prüfung der korrekten Kommunikation übermittelt.\nDie Id ist auf dem Server mit den verknüpften Freunden gespeichert.\nDas Löschen und Neuinstallieren der App löscht die Id und die Freunde müssen neu verknüpft werden, da die Id nicht wiederhergestellt werden kann.\nDie Daten werden nicht an Dritte weitergegeben oder anderweitig verwendet.\nDeine Standortdaten werden während der Veranstaltung benutzt um Start und Ende des Zuges auf der Strecke zu berechnen und darzustellen und die Entfernung zu Freunden und zum Ziel zu berechnen.\nEs werden keine persönlichen Daten erfasst. Die Namen der Freunde sind nur lokal in der App gespeichert.\nDas Benutzen der Emailfunktion und Webseite von Skatemunich unterliegt den Datenschutzbestimmungen von Skatemunich (https://www.skatemunich.de/datenschutzerklaerung/)\nDer Quellcode ist Opensource und kann jederzeit eingesehen werden."),
        "about_bnapp":
            MessageLookupByLibrary.simpleMessage("Über die BladeNight App"),
        "about_crashlytics": MessageLookupByLibrary.simpleMessage(
            "Um die Stabilität und Zuverlässigkeit dieser App zu verbessern, sind wir auf anonymisierte Absturzberichte angewiesen. Wir nutzen hierzu „Firebase Crashlytics“, ein Dienst der Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIm Falle eines Absturzes werden anonyme Informationen an die Server von Google in die USA übertragen (Zustand der App zum Zeitpunkt des Absturzes, Installation UUID, Crash-Trace, Hersteller und Betriebssystem des Handys, letzte Log-Meldungen). Diese Informationen enthalten keine personenbezogenen Daten.\n\nAbsturzberichte werden nur mit Ihrer ausdrücklichen Zustimmung versendet. Bei der Verwendung von iOS-Apps können Sie die Zustimmung in den Einstellungen der App oder nach einem Absturz erteilen. Bei Android-Apps besteht bei der Einrichtung des mobilen Endgeräts die Möglichkeit, generell der Übermittlung von Absturzbenachrichtigungen an Google und App-Entwickler zuzustimmen.\n\nRechtsgrundlage für die Datenübermittlung ist Art. 6 Abs. 1 lit. a DSGVO.\n\nSie können Ihre Einwilligung jederzeit widerrufen indem Sie in den Einstellungen der iOS-Apps die Funktion „Absturzberichte“ deaktivieren (in den Magazin-Apps befindet sich der Eintrag im Menüpunkt „Kommunikation“).\n\nBei den Android-Apps erfolgt die Deaktivierung grundlegend in den Android-Einstellungen. Öffnen Sie hierzu die Einstellungen App, wählen den Punkt „Google“ und dort im Dreipunkt-Menü oben rechts den Menüpunkt „Nutzung & Diagnose“. Hier können Sie das Senden der entsprechenden Daten deaktivieren. Weitere Informationen finden Sie in der Hilfe zu Ihrem Google-Konto.\n\nWeitere Informationen zum Datenschutz erhalten Sie in den Datenschutzhinweisen von Firebase Crashlytics unter https://firebase.google.com/support/privacy sowie https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies"),
        "about_feedback": MessageLookupByLibrary.simpleMessage(
            "Dein Feedback ist willkommen.\nSende uns eine E-Mail an:"),
        "about_h_androidapplicationflutter":
            MessageLookupByLibrary.simpleMessage(
                "BladeNight-App iOS/Android (2022)"),
        "about_h_androidapplicationflutter_23":
            MessageLookupByLibrary.simpleMessage(
                "BladeNight-App iOS/Android (2023)"),
        "about_h_androidapplicationv1":
            MessageLookupByLibrary.simpleMessage("Android App V1 (2013)"),
        "about_h_androidapplicationv2":
            MessageLookupByLibrary.simpleMessage("Android App V2 (2014-2022)"),
        "about_h_androidapplicationv3":
            MessageLookupByLibrary.simpleMessage("Android App V3 (2023)"),
        "about_h_bnapp":
            MessageLookupByLibrary.simpleMessage("Wofür ist die App"),
        "about_h_crashlytics":
            MessageLookupByLibrary.simpleMessage("Firebase Crashlytics"),
        "about_h_feedback":
            MessageLookupByLibrary.simpleMessage("Feedback zur BladeNight"),
        "about_h_homepage":
            MessageLookupByLibrary.simpleMessage("Internetseite"),
        "about_h_impressum": MessageLookupByLibrary.simpleMessage("Impressum"),
        "about_h_licences": MessageLookupByLibrary.simpleMessage("Lizenzen"),
        "about_h_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
            "OneSignal Datenschutzerklärung"),
        "about_h_open_street_map": MessageLookupByLibrary.simpleMessage(
            "Open Street Map Datenschutzerklärung"),
        "about_h_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
        "about_h_serverapp":
            MessageLookupByLibrary.simpleMessage("Serverprogrammierung"),
        "about_h_version": MessageLookupByLibrary.simpleMessage("Version:"),
        "about_impressum": MessageLookupByLibrary.simpleMessage(
            "Betreiber und Veranstalter der Münchener BladeNight:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nVertreten durch:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de"),
        "about_kilianlars":
            MessageLookupByLibrary.simpleMessage("Kilian Schulte\nLars Huth"),
        "about_lars": MessageLookupByLibrary.simpleMessage("Lars Huth"),
        "about_licences": MessageLookupByLibrary.simpleMessage(
            "GNU General Public License v3.0"),
        "about_olivier":
            MessageLookupByLibrary.simpleMessage("Olivier Croquette"),
        "about_olivierandbenjamin": MessageLookupByLibrary.simpleMessage(
            "Benjamin Uekermann\nOlivier Croquette"),
        "about_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
            "Wir verwenden für unsere Website OneSignal, eine Mobile-Marketing-Plattform. Dienstanbieter ist das amerikanische Unternehmen OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal verarbeitet Daten u.a. auch in den USA. Wir weisen darauf hin, dass nach Meinung des Europäischen Gerichtshofs derzeit kein angemessenes Schutzniveau für den Datentransfer in die USA besteht. Dies kann mit verschiedenen Risiken für die Rechtmäßigkeit und Sicherheit der Datenverarbeitung einhergehen.\n\nAls Grundlage der Datenverarbeitung bei Empfängern mit Sitz in Drittstaaten (außerhalb der Europäischen Union, Island, Liechtenstein, Norwegen, also insbesondere in den USA) oder einer Datenweitergabe dorthin verwendet OneSignal von der EU-Kommission genehmigte Standardvertragsklauseln (= Art. 46. Abs. 2 und 3 DSGVO). Diese Klauseln verpflichten OneSignal, das EU-Datenschutzniveau bei der Verarbeitung relevanter Daten auch außerhalb der EU einzuhalten. Diese Klauseln basieren auf einem Durchführungsbeschluss der EU-Kommission. Sie finden den Beschluss sowie die Klauseln u.a. hier: https://germany.representation.ec.europa.eu/index_de.\n\nMehr über die Daten, die durch die Verwendung von OneSignal verarbeitet werden, erfahren Sie in der Privacy Policy auf https://onesignal.com/privacy.\n\nAlle Texte sind urheberrechtlich geschützt.\n\nQuelle: Erstellt mit dem Datenschutz Generator von AdSimple"),
        "about_open_street_map": MessageLookupByLibrary.simpleMessage(
            "Daten, die wir automatisch erhalten\n\nDie OSMF betreibt eine Reihe von Diensten für die OpenStreetMap-Gemeinschaft, z. B. die Website openstreetmap.org, die Online-Karte im \"Standard\"-Stil, die OSM-API und die Nominatim-Suchfunktion.\n\nWenn Sie eine OSMF-Website besuchen, über einen Browser oder über Anwendungen, die die bereitgestellten APIs nutzen, auf einen der Dienste zugreifen, werden Aufzeichnungen über diese Nutzung erstellt, wir sammeln Informationen über Ihren Browser oder Ihre Anwendung und Ihre Interaktion mit unserer Website, einschließlich (a) IP-Adresse, (b) Browser- und Gerätetyp, (c) Betriebssystem, (d) verweisende Webseite, (e) Datum und Uhrzeit der Seitenbesuche und (f) die auf unseren Websites aufgerufenen Seiten.\n\nDarüber hinaus können wir Software zur Verfolgung der Benutzerinteraktion einsetzen, die zusätzliche Aufzeichnungen über die Benutzeraktivität erstellt, z. B. Piwik.\n\nDienste, die Geo-DNS oder ähnliche Mechanismen verwenden, um die Last auf geografisch verteilte Server zu verteilen, erzeugen möglicherweise eine Aufzeichnung Ihres Standorts in großem Umfang (z. B. ermittelt das OSMF-Kachel-Cache-Netzwerk das Land, in dem Sie sich wahrscheinlich befinden, und leitet Ihre Anfragen an einen entsprechenden Server weiter).\n\nDiese Aufzeichnungen werden auf folgende Weise verwendet oder können verwendet werden:\n\nzur Unterstützung des Betriebs der Dienste aus technischer, sicherheitstechnischer und planerischer Sicht.\nals anonymisierte, zusammengefasste Daten für Forschungs- und andere Zwecke. Solche Daten können über https://planet.openstreetmap.org oder andere Kanäle öffentlich angeboten und von Dritten genutzt werden.\num den OpenStreetMap-Datensatz zu verbessern. Zum Beispiel durch die Analyse von Nominatim-Abfragen auf fehlende Adressen und Postleitzahlen und die Bereitstellung solcher Daten für die OSM-Community.\nDie auf den Systemen gesammelten Daten sind für die Systemadministratoren und die entsprechenden OSMF-Arbeitsgruppen, z. B. die Datenarbeitsgruppe, zugänglich. Es werden keine persönlichen Informationen oder Informationen, die mit einer Person in Verbindung gebracht werden können, an Dritte weitergegeben, es sei denn, dies ist gesetzlich vorgeschrieben.\n\nDie von Piwik gespeicherten IP-Adressen werden auf zwei Bytes gekürzt und die detaillierten Nutzungsdaten werden 180 Tage lang aufbewahrt.\n\nDa diese Speicherung nur vorübergehend erfolgt, ist es uns im Allgemeinen nicht möglich, Zugang zu IP-Adressen oder den damit verbundenen Protokollen zu gewähren.\n\nDie oben genannten Daten werden auf der Grundlage eines berechtigten Interesses verarbeitet (siehe Artikel 6 Absatz 1 Buchstabe f der DSGVO)."),
        "actualInformations":
            MessageLookupByLibrary.simpleMessage("Aktuelle Informationen"),
        "addNearBy": MessageLookupByLibrary.simpleMessage(
            "Freund:in neben Dir hinzufügen"),
        "addfriendwithcode": MessageLookupByLibrary.simpleMessage(
            "Freund:in mit Code hinzufügen"),
        "addnewfriend":
            MessageLookupByLibrary.simpleMessage("Freund:in neu anlegen"),
        "aheadOfMe": MessageLookupByLibrary.simpleMessage("vor mir"),
        "allowHeadless":
            MessageLookupByLibrary.simpleMessage("Hintergrund update aktiv"),
        "allowHeadlessHeader": MessageLookupByLibrary.simpleMessage(
            "Testimplementierung, da MIUI Xiaomi Handys durch agressives Speichermanagemant die Apps killen und diese somit nicht mehr funktioniert. Wenn die App in den Hintergrund wechselt oder gekillt wird, wird trotzdem weiter der Standort übermittelt (BETA) "),
        "allowWakeLock": MessageLookupByLibrary.simpleMessage(
            "App im Vordergrund aktiv lassen?"),
        "allowWakeLockHeader": MessageLookupByLibrary.simpleMessage(
            "App aktiv lassen, heißt, das die App im wake mode ist und das Tracking aktiv ist. Wird bei kleiner 20% Akku deaktiviert."),
        "alternativeLocationProvider":
            MessageLookupByLibrary.simpleMessage("Nutze Alternative"),
        "alternativeLocationProviderTitle": MessageLookupByLibrary.simpleMessage(
            "Nutze alternativen Standorttreiber bei Problemen mit dem GPS Empfang"),
        "alwaysPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
            "Standortfreigabe permanent verweigert oder im System gesperrt!"),
        "alwaysPermantlyDenied": MessageLookupByLibrary.simpleMessage(
            "Standortfreigabe für \'Immer erlauben\' scheint permanent verboten!"),
        "anonymous": MessageLookupByLibrary.simpleMessage("Anonym"),
        "appId": MessageLookupByLibrary.simpleMessage("App-Id "),
        "appIdTitle": MessageLookupByLibrary.simpleMessage("App-Id "),
        "appOutDated": MessageLookupByLibrary.simpleMessage(
            "Appversion veralted!\nBitte im Store aktualisieren."),
        "appTitle": MessageLookupByLibrary.simpleMessage("BladeNight"),
        "appsupport": MessageLookupByLibrary.simpleMessage(
            "App-Support/ Feedback/ Vorschläge"),
        "apptrackingtransparancy": MessageLookupByLibrary.simpleMessage(
            "Wir schützen uns um Ihre Privatsphäre und Datensicherheit.\nUm uns dabei zu helfen, das BladeNight-Erlebnis zu verbessern, übertragen wir Ihren Standort auf unseren Server. Dies Information beinhaltet eine beim ersten Start der App erstellte eindeutige ID, um die Zuordnung der Freunde zu ermöglichen. Diese Daten werden niemals an Dritte weitergegeben oder für Werbezwecke verwendet."),
        "at": MessageLookupByLibrary.simpleMessage("am"),
        "autoStopTracking":
            MessageLookupByLibrary.simpleMessage("Stoppe Tracking automatisch"),
        "automatedStopInfo": MessageLookupByLibrary.simpleMessage(
            "Durch langes drücken auf ▶️ wird der automatische Trackingstopp aktiviert. Das heißt, solange die App geöffnet ist, wird nach dem erreichen des Zieles der BladeNight das Tracking und Freundefreigabe automatisch gestoppt.\nWiederholt langes drücken auf  ▶️,⏸︎,⏹︎ stellt auf manuell Stopp oder Autostopp um."),
        "becomeBladeguard":
            MessageLookupByLibrary.simpleMessage("Werde Bladeguard"),
        "behindMe": MessageLookupByLibrary.simpleMessage("hinter mir"),
        "bgNotificationText": MessageLookupByLibrary.simpleMessage(
            "Das Hintergrundstandortupdate ist aktiv. Danke fürs mitmachen."),
        "bgNotificationTitle": MessageLookupByLibrary.simpleMessage(
            "BladeNight Hintergrundstandortupdate"),
        "bgTeam": MessageLookupByLibrary.simpleMessage("Bladeguard Team"),
        "bladeGuard": MessageLookupByLibrary.simpleMessage("Bladeguard"),
        "bladenight": MessageLookupByLibrary.simpleMessage("BladeNight"),
        "bladenightUpdate":
            MessageLookupByLibrary.simpleMessage("BladeNight Update"),
        "bladenightViewerTracking":
            MessageLookupByLibrary.simpleMessage("Zuschauermodus mit GPS"),
        "bladenighttracking": MessageLookupByLibrary.simpleMessage(
            "Zuschauermodus, Teilnehmer ▶️ drücken."),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbruch"),
        "canceled": MessageLookupByLibrary.simpleMessage("Abgesagt 😞"),
        "change": MessageLookupByLibrary.simpleMessage("Ändern"),
        "changetoalways": MessageLookupByLibrary.simpleMessage(
            "Zu \'Immer zulassen\' ändern"),
        "chooseDeviceToLink": MessageLookupByLibrary.simpleMessage(
            "Bitte Gerät zum koppeln wählen !"),
        "clearLogsQuestion":
            MessageLookupByLibrary.simpleMessage("Logdaten wirklich löschen?"),
        "clearLogsTitle": MessageLookupByLibrary.simpleMessage(
            "Logdaten sollen gelöscht werden!"),
        "clearMessages": MessageLookupByLibrary.simpleMessage(
            "Wirklich alle Nachrichten löschen?"),
        "clearMessagesTitle":
            MessageLookupByLibrary.simpleMessage("Nachrichten löschen"),
        "closeApp":
            MessageLookupByLibrary.simpleMessage("App wirklich schließen?"),
        "codecontainsonlydigits": MessageLookupByLibrary.simpleMessage(
            "Fehler, Code darf nur Ziffern enthalten!"),
        "confirmed": MessageLookupByLibrary.simpleMessage("Wir fahren 😃"),
        "connected": MessageLookupByLibrary.simpleMessage("Verbunden"),
        "connecting": MessageLookupByLibrary.simpleMessage("Koppeln"),
        "copiedtoclipboard": MessageLookupByLibrary.simpleMessage(
            "Code in Zwischenablage kopiert"),
        "copy": MessageLookupByLibrary.simpleMessage("Code kopieren"),
        "couldNotOpenAppSettings": MessageLookupByLibrary.simpleMessage(
            "Konnte App-Einstellung nicht öffnen!"),
        "dataCouldBeOutdated": MessageLookupByLibrary.simpleMessage(
            "Daten könnten nicht aktuell sein."),
        "dateIntl": m0,
        "dateTimeDayIntl": m1,
        "dateTimeIntl": m2,
        "dateTimeSecIntl": m3,
        "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Nachricht löschen"),
        "deletefriend":
            MessageLookupByLibrary.simpleMessage("Freund:in löschen"),
        "deny": MessageLookupByLibrary.simpleMessage("Ablehnen"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Verb. trennen"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Nicht verbunden"),
        "distance": MessageLookupByLibrary.simpleMessage("Entfernung"),
        "distanceDriven":
            MessageLookupByLibrary.simpleMessage("Position auf Strecke"),
        "distanceDrivenOdo":
            MessageLookupByLibrary.simpleMessage("ges. GPS gefahren"),
        "distanceToFinish":
            MessageLookupByLibrary.simpleMessage("Entfernung zum Ziel"),
        "distanceToFriend":
            MessageLookupByLibrary.simpleMessage("Entfernung zum Freund"),
        "distanceToHead":
            MessageLookupByLibrary.simpleMessage("Entfernung zum Zugkopf"),
        "distanceToMe":
            MessageLookupByLibrary.simpleMessage("Entfernung von mir"),
        "distanceToTail":
            MessageLookupByLibrary.simpleMessage("Entfernung zum Zugende"),
        "done": MessageLookupByLibrary.simpleMessage("Fertig"),
        "editfriend": MessageLookupByLibrary.simpleMessage("Freund:in ändern"),
        "enableAlwaysLocationInfotext": MessageLookupByLibrary.simpleMessage(
            "Um die BladeNight-App auch im Hintergrund (Standort mit Freunden teilen und Zuggenauigkeit zu erhöhen) ohne das der Bildschirm an ist, sollte die Standortfunktion \'Immer zulassen\' aktiviert werden.\nWeiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren."),
        "enableOnesignalPushMessage":
            MessageLookupByLibrary.simpleMessage("Push Mitteilung aktiv"),
        "enableOnesignalPushMessageTitle": MessageLookupByLibrary.simpleMessage(
            "Onesignal Push Benachrichtigungen aktivieren. Hiermit können allgemeine Informationen per Push-Mitteilung z.B. ob die Bladenight stattfindet empfangen werden. Empfohlene Einstellung \'Ein\'."),
        "enter6digitcode": MessageLookupByLibrary.simpleMessage(
            "Bitte 6-stelligen Code eingeben"),
        "enterEmail": MessageLookupByLibrary.simpleMessage("Email eingeben"),
        "enterPassword":
            MessageLookupByLibrary.simpleMessage("Passwort eingeben"),
        "entercode": MessageLookupByLibrary.simpleMessage("Code: "),
        "enterfriendname":
            MessageLookupByLibrary.simpleMessage("Name eingeben."),
        "entername": MessageLookupByLibrary.simpleMessage("Name:"),
        "events": MessageLookupByLibrary.simpleMessage("Termine"),
        "export": MessageLookupByLibrary.simpleMessage("Exportieren"),
        "exportLogData": MessageLookupByLibrary.simpleMessage(
            "Sende Logdaten für Support oder Featureanfrage"),
        "exportUserTracking":
            MessageLookupByLibrary.simpleMessage("Usertracking exportieren"),
        "exportUserTrackingHeader": MessageLookupByLibrary.simpleMessage(
            "Das aktuell sichtbare gefahrene Routenlinie als GPX exportieren"),
        "exportWarning": MessageLookupByLibrary.simpleMessage(
            "Achtung! Dies sichert alle Freunde und die Kennung vom Gerät. Dies kann sensible Daten enthalten, wie zum Beispiel Namen."),
        "exportWarningTitle":
            MessageLookupByLibrary.simpleMessage("Export Freunde und Id."),
        "failed": MessageLookupByLibrary.simpleMessage("Fehlgeschlagen!"),
        "failedAddNearbyTryCode": MessageLookupByLibrary.simpleMessage(
            "Bitte versuche die Verbindung mit einem Code herzustellen. Fragen dazu deinen Freund nach dem angezeigten Code in seiner \'Freunde\'-Übersicht. Du kannst dich nur einmal mit demselben Freund verbinden."),
        "finish": MessageLookupByLibrary.simpleMessage("Ziel / Ende"),
        "finishForceStopEventOverTitle": MessageLookupByLibrary.simpleMessage(
            "Tracking gestoppt - Ende der BladeNight"),
        "finishForceStopTimeoutTitle": MessageLookupByLibrary.simpleMessage(
            "Tracking gestoppt - Zeitüberschreitung"),
        "finishReachedStopedTracking": MessageLookupByLibrary.simpleMessage(
            "Ziel erreicht - Tracking beendet."),
        "finishReachedTitle":
            MessageLookupByLibrary.simpleMessage("Ziel erreicht"),
        "finishReachedtargetReachedPleaseStopTracking":
            MessageLookupByLibrary.simpleMessage(
                "Ziel erreicht - Tracking bitte Tracking anhalten."),
        "finishStopTrackingEventOver": MessageLookupByLibrary.simpleMessage(
            "Autostopp Tracking, da die BladeNight Veranstaltung beendet ist. (Lange drücken auf ▶️ deaktiviert Autostopp)"),
        "finishStopTrackingTimeout": m4,
        "finished": MessageLookupByLibrary.simpleMessage("Beendet"),
        "fitnessPermissionInfoText": MessageLookupByLibrary.simpleMessage(
            "Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren. Die Abfrage erfolgt in den nächsten Schritten."),
        "fitnessPermissionInfoTextTitle": MessageLookupByLibrary.simpleMessage(
            "Bewegungssensor / Körperliche Aktivität"),
        "fitnessPermissionSettingsText": MessageLookupByLibrary.simpleMessage(
            "Der Zugriff auf die Bewegungsaktivitätserkennung ist wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren.(Standard inaktiv)"),
        "fitnessPermissionSwitchSettingsText":
            MessageLookupByLibrary.simpleMessage("Bewegungssensor deaktiviert"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Passwort vergessen"),
        "forward": MessageLookupByLibrary.simpleMessage("Weiter"),
        "friend": MessageLookupByLibrary.simpleMessage("Freund:in"),
        "friendIs": MessageLookupByLibrary.simpleMessage("Freund:in ist"),
        "friends": MessageLookupByLibrary.simpleMessage("Freunde"),
        "friendswillmissyou": MessageLookupByLibrary.simpleMessage(
            "Bitte unterstütze weiter die genaue Darstellung des BladeNightzuges.\nAusserdem werden deine Freunde dich vermissen!"),
        "from": MessageLookupByLibrary.simpleMessage("von"),
        "getwebdata":
            MessageLookupByLibrary.simpleMessage("Lade Serverdaten ..."),
        "head": MessageLookupByLibrary.simpleMessage("Zugkopf"),
        "home": MessageLookupByLibrary.simpleMessage("Info"),
        "iAmBladeGuard":
            MessageLookupByLibrary.simpleMessage("Ich bin Bladeguard"),
        "iAmBladeGuardTitle": MessageLookupByLibrary.simpleMessage(
            "Ich bin aktiver Bladeguard und möchte Infos erhalten. Passwort bitte beim Teamleiter oder Skatemunich mit Teamnummer erfragen (anonym d.h. Es werden keine Daten verknüpft)"),
        "iam": MessageLookupByLibrary.simpleMessage("Ich bin"),
        "ignoreBatteriesOptimisation": MessageLookupByLibrary.simpleMessage(
            "Hinweis - manche Hersteller schalten die Apps durch ungünstige Batterieoptimierungen ab oder schließen die App. In dem Falle bitte versuchen die Batterieoptimierung für die App zu deaktivieren. Einstellung keine Beschränkung."),
        "ignoreBatteriesOptimisationTitle":
            MessageLookupByLibrary.simpleMessage("Batterieoptimierung ändern"),
        "import": MessageLookupByLibrary.simpleMessage("Importieren"),
        "importWarning": MessageLookupByLibrary.simpleMessage(
            "Achtung dies überschreibt alle Freunde und die Kennung. Vorher Daten exportieren! Achtung die App auf dem Gerät von dessen exportiert wurde löschen!"),
        "importWarningTitle":
            MessageLookupByLibrary.simpleMessage("Import Freunde und Id."),
        "inprogress":
            MessageLookupByLibrary.simpleMessage("Entwicklung in Arbeit ..."),
        "internalerror_invalidcode":
            MessageLookupByLibrary.simpleMessage("ungültiger Code"),
        "internalerror_seemslinked": MessageLookupByLibrary.simpleMessage(
            "Fehler - Freund:in schon verlinkt?"),
        "invalidcode": MessageLookupByLibrary.simpleMessage("Code unbekannt"),
        "invitebyname": m5,
        "invitenewfriend":
            MessageLookupByLibrary.simpleMessage("Freund:in einladen"),
        "isIgnoring": MessageLookupByLibrary.simpleMessage("Wird ignoriert"),
        "ist": MessageLookupByLibrary.simpleMessage("ist"),
        "isuseractive":
            MessageLookupByLibrary.simpleMessage("In Karte anzeigen?"),
        "lastseen": MessageLookupByLibrary.simpleMessage("Zuletzt gesehen"),
        "lastupdate": MessageLookupByLibrary.simpleMessage("Letztes Update"),
        "leavewheninuse":
            MessageLookupByLibrary.simpleMessage("Lasse Einstellung"),
        "length": MessageLookupByLibrary.simpleMessage("Länge"),
        "linkNearBy": MessageLookupByLibrary.simpleMessage(
            "Freund:in neben Dir annehmen"),
        "linkOnOtherDevice": m6,
        "linkingFailed":
            MessageLookupByLibrary.simpleMessage("Verknüpfung fehlgeschlagen"),
        "linkingSuccessful":
            MessageLookupByLibrary.simpleMessage("Verknüpfung erfolgreich"),
        "liveMapInBrowser": MessageLookupByLibrary.simpleMessage(
            "Verfolgt die Bladnight ohne App im Browser"),
        "liveMapInBrowserInfoHeader":
            MessageLookupByLibrary.simpleMessage("Livekarte im Browser"),
        "loading": MessageLookupByLibrary.simpleMessage("Lade ..."),
        "locationServiceOff": MessageLookupByLibrary.simpleMessage(
            "Bitte Start ▶️ drücken! Standortübertragung ist in den Einstellungen deaktiviert oder noch nie gestartet! Tracking nicht möglich."),
        "locationServiceRunning": MessageLookupByLibrary.simpleMessage(
            "Standortübertragung gestartet und aktiv."),
        "login": MessageLookupByLibrary.simpleMessage("Anmelden"),
        "manufacturer": MessageLookupByLibrary.simpleMessage("Hersteller"),
        "map": MessageLookupByLibrary.simpleMessage("Karte"),
        "mapFollowLocation": MessageLookupByLibrary.simpleMessage(
            "Karte folgt meiner Position."),
        "mapFollowStopped":
            MessageLookupByLibrary.simpleMessage("Karte folgt mir gestoppt!"),
        "mapFollowTrain": MessageLookupByLibrary.simpleMessage(
            "Karte folgt Zugkopfposition."),
        "mapFollowTrainStopped": MessageLookupByLibrary.simpleMessage(
            "Karte folgt Zugkopf gestoppt."),
        "mapToStartNoFollowing": MessageLookupByLibrary.simpleMessage(
            "Karte auf Start. Kein verfolgen."),
        "markMeAsHead": MessageLookupByLibrary.simpleMessage(
            "Markiere meine Position als Zugkopf"),
        "markMeAsTail": MessageLookupByLibrary.simpleMessage(
            "Markiere meine Position als Zugende"),
        "me": MessageLookupByLibrary.simpleMessage("Ich"),
        "message": MessageLookupByLibrary.simpleMessage("Nachricht"),
        "messages": MessageLookupByLibrary.simpleMessage("Nachrichten"),
        "metersOnRoute": MessageLookupByLibrary.simpleMessage("gef.Strecke"),
        "model": MessageLookupByLibrary.simpleMessage("Modell"),
        "mustentername": MessageLookupByLibrary.simpleMessage(
            "Du musst einen Namen eingeben!"),
        "myName": MessageLookupByLibrary.simpleMessage("Mein Name lautet"),
        "myNameHeader": MessageLookupByLibrary.simpleMessage(
            "Der angegebene Name wird bei der Verknüpfung mit deinem Freund an das 2. Gerät übertragen. Der Name ist nur lokal gespeichert und dient der vereinfachten Verknüpfung per lokaler Verbindung.Es muss auf beiden Geräten eine Internetverbindung bestehen um den Code vom Server abzuholen. Alternativ kann auch ohne Name per Code verknüpft werden."),
        "nameexists":
            MessageLookupByLibrary.simpleMessage("Sorry, Name schon vergeben!"),
        "networkerror": MessageLookupByLibrary.simpleMessage(
            "Netzwerkfehler - Keine Daten!"),
        "never": MessageLookupByLibrary.simpleMessage("nie"),
        "newGPSDatareceived":
            MessageLookupByLibrary.simpleMessage("Neue GPS Daten"),
        "nextEvent": MessageLookupByLibrary.simpleMessage("Nächste BladeNight"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "noBackgroundlocationLeaveAppOpen": MessageLookupByLibrary.simpleMessage(
            "Standort \'Während der Benutzung\' ist eingestellt. Daher ist keine Hintergrundaktualisierung aktiviert. Um die Darstellung des BladeNight-Zuges so genau wie möglich zu bekommen und deine Postion ohne Einschränkung mit Freunden zu teilen, bitten wir Dich die App offen halten oder die Einstellung auf \'Immer zulassen\' zu ändern. Danke."),
        "noBackgroundlocationTitle": MessageLookupByLibrary.simpleMessage(
            "Hinweis, keine Hintergrundaktualisierung."),
        "noChoiceNoAction": MessageLookupByLibrary.simpleMessage(
            "Keine Auswahl da keine Aktion"),
        "noEvent": MessageLookupByLibrary.simpleMessage("Nicht geplant"),
        "noEventPlanned": MessageLookupByLibrary.simpleMessage(
            "Aktuell ist keine Veranstaltung geplant."),
        "noEventStarted": MessageLookupByLibrary.simpleMessage(
            "Aktuell keine Veranstaltung."),
        "noEventStartedAutoStop": MessageLookupByLibrary.simpleMessage(
            "Autostop - da keine Veranstaltung"),
        "noEventTimeOut": m7,
        "noGpsAllowed":
            MessageLookupByLibrary.simpleMessage("GPS nicht aktiviert"),
        "noLocationAvailable":
            MessageLookupByLibrary.simpleMessage("Kein Standort bekannt"),
        "noLocationPermissionGrantedAlertAndroid":
            MessageLookupByLibrary.simpleMessage(
                "Bitte System-Einstellungen (Einstellungen -> Standort -> Standortzugriff von Apps -> BladeNight) prüfen, da keine Standortfreigabe."),
        "noLocationPermissionGrantedAlertTitle":
            MessageLookupByLibrary.simpleMessage("Info Standortfreigabe"),
        "noLocationPermissionGrantedAlertiOS": MessageLookupByLibrary.simpleMessage(
            "Bitte iOS Einstellunge prüfen, da keine Standortfreigabe. Diese müsste in den Telefon-Einstellungen unter Datenschutz - Ortungsdienste - BladnightApp freigegeben werden."),
        "noLocationPermitted": MessageLookupByLibrary.simpleMessage(
            "Keine Standortfreigabe, Bitte Einstellungen des Gerätes prüfen"),
        "nodatareceived":
            MessageLookupByLibrary.simpleMessage("Keine Daten empfangen!"),
        "nogps": MessageLookupByLibrary.simpleMessage("Kein GPS"),
        "nogpsenabled": MessageLookupByLibrary.simpleMessage(
            "Es ist scheinbar kein GPS im Gerät vorhanden oder für die App deaktiviert. Bitte die Einstellungen prüfen."),
        "notAvailable": MessageLookupByLibrary.simpleMessage("nicht verfügbar"),
        "notKnownOnServer": MessageLookupByLibrary.simpleMessage(
            "Veralted bitte,neu anlegen/löschen!"),
        "notOnRoute":
            MessageLookupByLibrary.simpleMessage("Nicht auf der Strecke!"),
        "notVisibleOnMap":
            MessageLookupByLibrary.simpleMessage("Auf Karte nicht angezeigt"),
        "note_bladenightCanceled": MessageLookupByLibrary.simpleMessage(
            "Die BladeNight wurde leider abgesagt."),
        "note_bladenightStartInFiveMinutesStartTracking":
            MessageLookupByLibrary.simpleMessage(
                "Nächste BladeNight startet in 5 minuten. Tracking einschalten nicht vergessen !!"),
        "note_bladenightStartInSixHoursStartTracking":
            MessageLookupByLibrary.simpleMessage(
                "Nächste BladeNight startet in 6 Stunden."),
        "note_statuschanged": MessageLookupByLibrary.simpleMessage(
            "BladeNight Status geändert - Bitte in App prüfen"),
        "notification": MessageLookupByLibrary.simpleMessage("Notification"),
        "notracking": MessageLookupByLibrary.simpleMessage("Kein Tracking!"),
        "now": MessageLookupByLibrary.simpleMessage("Jetzt"),
        "offline": MessageLookupByLibrary.simpleMessage("Offline"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "on": MessageLookupByLibrary.simpleMessage("am"),
        "onRoute": MessageLookupByLibrary.simpleMessage("auf der Strecke"),
        "oneSignalId": MessageLookupByLibrary.simpleMessage("OneSignal-Id: "),
        "oneSignalIdTitle": MessageLookupByLibrary.simpleMessage(
            "Dies ist die zugewiesene Id für den Empfang von Push-Nachrichten. Teilen Sie uns die ID mit, wenn Du Probleme beim Empfang von Push-Nachrichten haben."),
        "online": MessageLookupByLibrary.simpleMessage("Online"),
        "onlyWhenInUseEnabled": MessageLookupByLibrary.simpleMessage(
            "Standortfreigabe nur \'Zugriff nur während der Nutzung der App zulassen\'"),
        "onlyWhileInUse": MessageLookupByLibrary.simpleMessage(
            "GPS nur wenn App im Vordergrund freigegeben. Bitte Systemeinstellungen prüfen"),
        "openOperatingSystemSettings":
            MessageLookupByLibrary.simpleMessage("Öffne Systemeinstellungen"),
        "openStreetMap": MessageLookupByLibrary.simpleMessage(
            "Openstreetmap Kartenteile laden / Neustart erforderlich"),
        "openStreetMapText":
            MessageLookupByLibrary.simpleMessage("Nutze Openstreetmap"),
        "own": MessageLookupByLibrary.simpleMessage("Eigene"),
        "participant": MessageLookupByLibrary.simpleMessage("Teilnehmer"),
        "pending": MessageLookupByLibrary.simpleMessage("Geplant ⏰"),
        "pickcolor": MessageLookupByLibrary.simpleMessage("Farbe wählen"),
        "position": MessageLookupByLibrary.simpleMessage("Position"),
        "positiveInFront": MessageLookupByLibrary.simpleMessage(
            "Positiv vor mir, Negativ hinter mir."),
        "proceed": MessageLookupByLibrary.simpleMessage("Weiter"),
        "prominentdisclosuretrackingprealertandroidFromAndroid_V11":
            MessageLookupByLibrary.simpleMessage(
                "Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben.Hier sollte  \'Bei der Nutzung der App zulassen\' gewählt werden. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung \"Immer zulassen\" die zu einem späteren Zeitpunkt (2.Schritt über Systemeinstellungen) erfolgt. Dies ermöglicht das Tracking auch wenn du eine andere App im Vordergrund geöffnet hast. Mit \"Während der Benutzung\" musst du die BladeNight immer im Vordergrund offen halten um uns zu unterstützen und deinen Standort zu teilen.Weiterhin ist ein Zugriff auf die Bewegungsaktivitätserkennung (Körperliche Aktivität) wünschenswert. Dies erhöht die Akkueffizienz, indem die Standortverfolgung intelligent ausgeschaltet wird, wenn Ihr Gerät als stationär erkannt wird. Daher bitte diese Funktion aktivieren."),
        "prominentdisclosuretrackingprealertandroidToAndroid_V10x":
            MessageLookupByLibrary.simpleMessage(
                "Die BladeNight App benötigt deine Standortdaten zur Darstellung des BladeNightzuges und um deine Position mit deinen Freunden zu teilen. Dies während der App-Nutzung. Bitte die Standortfreigabe im nächsten Schritt freigeben. Falls du das ablehnst, kann nur der BladeNightzug ohne Standortfreigabe beobachtet werden. Bevorzugt ist die Einstellung \"Bei der Nutzung der App zulassen\"."),
        "pushMessageParticipateAsBladeGuard":
            MessageLookupByLibrary.simpleMessage("Bladeguard-Abfrage Push"),
        "pushMessageParticipateAsBladeGuardTitle":
            MessageLookupByLibrary.simpleMessage(
                "Bladeguard--Teilnahme-Abfrage per Push-Mitteilung durchführen?"),
        "pushMessageSkateMunichInfos":
            MessageLookupByLibrary.simpleMessage("Skatemunich Infos"),
        "pushMessageSkateMunichInfosTitle": MessageLookupByLibrary.simpleMessage(
            "Infos von SkateMunich per Push über Veranstaltungen empfangen?"),
        "qrcoderouteinfoheader": MessageLookupByLibrary.simpleMessage(
            "QRCode - Link zum teilen der aktuellen BladeNight-Daten ohne App"),
        "received": MessageLookupByLibrary.simpleMessage("empfangen"),
        "reload": MessageLookupByLibrary.simpleMessage("Neu laden"),
        "reltime": MessageLookupByLibrary.simpleMessage("rel. Zeitdiff."),
        "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "requestAlwaysPermissionTitle":
            MessageLookupByLibrary.simpleMessage("Standort - Immer zulassen"),
        "requestLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
            "Information, warum die Standortfreigeben notwendig wäre."),
        "resetInSettings":
            MessageLookupByLibrary.simpleMessage("Reset in Einstellungen"),
        "resetLongPress": MessageLookupByLibrary.simpleMessage(
            "Tachometer lange drücken zum Reset des km Zählers (ODO-Meter)"),
        "resetOdoMeter": MessageLookupByLibrary.simpleMessage(
            "Km-Zähler auf 0 setzen und eigene gefahrene Routenpunkte auf Karte (angezeigte gefahrene Route kann vorher in Einstellungen exportiert werden bzw. werden auch beim schließen der App gelöscht) ?"),
        "resetOdoMeterTitle": MessageLookupByLibrary.simpleMessage(
            "Reset km-Zähler und eigene Routenpunkte"),
        "restartRequired": MessageLookupByLibrary.simpleMessage(
            "Neustart erforderlich! Bitte App schließen und neu öffnen !!!"),
        "route": MessageLookupByLibrary.simpleMessage("Strecke"),
        "routeoverview": MessageLookupByLibrary.simpleMessage("Routenverlauf"),
        "running": MessageLookupByLibrary.simpleMessage("Wir fahren gerade ⏳"),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "scrollMapTo":
            MessageLookupByLibrary.simpleMessage("Scrolle Karte zu ..."),
        "seemsoffline": MessageLookupByLibrary.simpleMessage(
            "Warte auf Internetverbindung ..."),
        "sendData30sec": MessageLookupByLibrary.simpleMessage(
            "Anfrage gesendet - Dauert ca. 30s."),
        "sendlink": MessageLookupByLibrary.simpleMessage("Link senden"),
        "sendlinkdescription": m8,
        "sendlinksubject": MessageLookupByLibrary.simpleMessage(
            "Sende link an BladeNight-App. Ihr könnt euch gegenseitig sehen."),
        "serverNotReachable":
            MessageLookupByLibrary.simpleMessage("Warte auf Server ... !"),
        "sessionConnectionError":
            MessageLookupByLibrary.simpleMessage("Fehler beim Verbinden"),
        "setClearLogs":
            MessageLookupByLibrary.simpleMessage("Logdateien löschen"),
        "setDarkMode":
            MessageLookupByLibrary.simpleMessage("Dunkelmodus aktivieren"),
        "setDarkModeTitle": MessageLookupByLibrary.simpleMessage(
            "App zwischen Hell- und Dunkelmodus unabhängig der Systemeinstellungen ändern."),
        "setExportLogSupport": MessageLookupByLibrary.simpleMessage(
            "Export Logdaten (Support) it@huth.app"),
        "setIconSize": MessageLookupByLibrary.simpleMessage("Icongröße: "),
        "setIconSizeTitle": MessageLookupByLibrary.simpleMessage(
            "Eigene Icongröße sowie die von Freunden, Zuganfang und -ende auf der Karte anpassen"),
        "setInsertImportDataset": MessageLookupByLibrary.simpleMessage(
            "Hier Datensatz einfügen incl. bna:"),
        "setLogData": MessageLookupByLibrary.simpleMessage("Datenlogger"),
        "setMeColor":
            MessageLookupByLibrary.simpleMessage("Eigene Farbe in Karte"),
        "setOpenSystemSettings":
            MessageLookupByLibrary.simpleMessage("Öffne Systemeinstellungen"),
        "setPrimaryColor": MessageLookupByLibrary.simpleMessage(
            "Text- und Symbolfarben im Normalmodus/Hell ändern"),
        "setPrimaryDarkColor": MessageLookupByLibrary.simpleMessage(
            "Text- und Symbolfarben im Dunkelmodus ändern"),
        "setRoute": MessageLookupByLibrary.simpleMessage("Setze Strecke"),
        "setStartImport": MessageLookupByLibrary.simpleMessage(
            "Import Id und Freunde starten"),
        "setState": MessageLookupByLibrary.simpleMessage("Setze Status"),
        "setSystem": MessageLookupByLibrary.simpleMessage("System"),
        "setTeam":
            MessageLookupByLibrary.simpleMessage("Welches Team bist du?"),
        "setcolor": MessageLookupByLibrary.simpleMessage("Farbe ändern"),
        "setexportDataHeader": MessageLookupByLibrary.simpleMessage("Export"),
        "setexportIdAndFriends":
            MessageLookupByLibrary.simpleMessage("Export Id und Freunde"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "showFullProcession":
            MessageLookupByLibrary.simpleMessage("Zeige Teilnehmer"),
        "showFullProcessionTitle": MessageLookupByLibrary.simpleMessage(
            "Zeige Teilnehmer (auf 100 aus dem Zug limitiert) in der Karte. Funktioniert nur bei eigener Standortfreigabe."),
        "showOwnTrack":
            MessageLookupByLibrary.simpleMessage("Eigene Fahrlinie zeigen"),
        "showProcession": MessageLookupByLibrary.simpleMessage(
            "Darstellung aktueller Verlauf der Münchener BladeNight"),
        "showWeblinkToRoute":
            MessageLookupByLibrary.simpleMessage("Zeige QRCode zum Weblink"),
        "showonly": MessageLookupByLibrary.simpleMessage("Nur Anzeige"),
        "since": MessageLookupByLibrary.simpleMessage("seit"),
        "someSettingsNotAvailableBecauseOffline":
            MessageLookupByLibrary.simpleMessage(
                "Einige Einstellungen sind nicht verfügbar da keine Internetverbindung besteht."),
        "specialfunction": MessageLookupByLibrary.simpleMessage(
            "Sondereinstellungen - nur nach Rücksprache ändern!"),
        "speed": MessageLookupByLibrary.simpleMessage("Geschwindigkeit"),
        "start": MessageLookupByLibrary.simpleMessage("Startpunkt"),
        "startLocationWithoutParticipating":
            MessageLookupByLibrary.simpleMessage("Tracking ohne Teilnahme"),
        "startLocationWithoutParticipatingInfo":
            MessageLookupByLibrary.simpleMessage(
                "Bitte Aufmerksam lesen.\nDies startet die Standortdarstellung auf der Karte ohne Teilnahme an der BladeNight und überträgt zur Berechnung der Zeiten deinen Standort auf den Server. Deine Freunde im Zug werden Dir angezeigt. Die Zeit zum Zuganfang /-ende von deinem Standort werden berechnet. Weiterhin, werden deine Geschwindigkeit und Trackingdaten aufgezeichnet die du speichern kannst. Bitte diese Funktion nicht verwenden, wenn du an der BladeNight teilnimmst. Der Modus muss manuell beendet werden. \nSoll dies gestartet werden?"),
        "startParticipationTracking": MessageLookupByLibrary.simpleMessage(
            "Teilnahme an BladeNight starten"),
        "startPoint": MessageLookupByLibrary.simpleMessage(
            "Startpunkt\nDeutsches Verkehrsmuseum\nSchwanthalerhöhe München"),
        "startPointTitle": MessageLookupByLibrary.simpleMessage("Startpunkt"),
        "startTime": MessageLookupByLibrary.simpleMessage("Startzeit"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "status_active": MessageLookupByLibrary.simpleMessage("Aktiv"),
        "status_inactive": MessageLookupByLibrary.simpleMessage("Inaktiv"),
        "status_obsolete": MessageLookupByLibrary.simpleMessage("Veraltet"),
        "status_pending": MessageLookupByLibrary.simpleMessage("Ausstehend"),
        "stopLocationTracking":
            MessageLookupByLibrary.simpleMessage("Stoppe Standort wirklich?"),
        "stopLocationWithoutParticipating":
            MessageLookupByLibrary.simpleMessage(
                "Stoppe Position ohne Teilnahme"),
        "stopParticipationTracking":
            MessageLookupByLibrary.simpleMessage("Stoppe Teilnahme/ Tracking"),
        "stopTrackingTimeOut": m9,
        "submit": MessageLookupByLibrary.simpleMessage("Senden"),
        "symbols": MessageLookupByLibrary.simpleMessage("Symbole"),
        "tail": MessageLookupByLibrary.simpleMessage("Zugende"),
        "tellcode": m10,
        "thanksForParticipating":
            MessageLookupByLibrary.simpleMessage("Danke fürs Teilnehmen."),
        "timeIntl": m11,
        "timeOutDurationExceedTitle": MessageLookupByLibrary.simpleMessage(
            "Zeitüberschreitung Dauer der BladeNight"),
        "timeStamp": MessageLookupByLibrary.simpleMessage("Stand von"),
        "timeToFinish":
            MessageLookupByLibrary.simpleMessage("Dauer bis zum Ziel (ca.)"),
        "timeToFriend":
            MessageLookupByLibrary.simpleMessage("Dauer zum Freund (ca.)"),
        "timeToHead":
            MessageLookupByLibrary.simpleMessage("Dauer zum Zugkopf (ca.)"),
        "timeToMe": MessageLookupByLibrary.simpleMessage("Dauer von mir (ca.)"),
        "timeToTail":
            MessageLookupByLibrary.simpleMessage("Dauer zum Zugende (ca)."),
        "today": MessageLookupByLibrary.simpleMessage("Heute"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("Morgen"),
        "trackers": MessageLookupByLibrary.simpleMessage("Tracker"),
        "tracking": MessageLookupByLibrary.simpleMessage("Daten vorhanden"),
        "trackingRestarted":
            MessageLookupByLibrary.simpleMessage("Tracking wieder gestartet"),
        "train": MessageLookupByLibrary.simpleMessage("Skater-Zug"),
        "trainlength": MessageLookupByLibrary.simpleMessage("Zuglänge"),
        "tryOpenAppSettings": MessageLookupByLibrary.simpleMessage(
            "Dies kann nur in den Systemeinstellungen geändert werden! Versuche Systemeinstellungen zu öffnen?"),
        "understand": MessageLookupByLibrary.simpleMessage("Verstanden"),
        "unknown": MessageLookupByLibrary.simpleMessage("unbekannt"),
        "unknownerror": MessageLookupByLibrary.simpleMessage("unbek. Fehler"),
        "userSpeed":
            MessageLookupByLibrary.simpleMessage("Meine GPS-Geschwindigkeit."),
        "validatefriend":
            MessageLookupByLibrary.simpleMessage("Freund:in verknüpfen"),
        "version": MessageLookupByLibrary.simpleMessage("Version:"),
        "visibleOnMap":
            MessageLookupByLibrary.simpleMessage("Auf Karte angezeigt."),
        "waiting": MessageLookupByLibrary.simpleMessage("Wartend..."),
        "waittime": MessageLookupByLibrary.simpleMessage("Wartezeit"),
        "wasCanceledPleaseCheck": MessageLookupByLibrary.simpleMessage(
            "wurde leider abgesagt! Bitte prüfe dies auf https://bladenight-muenchen.de"),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "yesterday": MessageLookupByLibrary.simpleMessage("war gestern")
      };
}
