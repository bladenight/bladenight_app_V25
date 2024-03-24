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

  /// `Push-Message-Id`
  String get OneSignalId {
    return Intl.message(
      'Push-Message-Id',
      name: 'OneSignalId',
      desc: '',
      args: [],
    );
  }

  /// `The app is provided free of charge by the publisher exclusively for the Munich BladeNight and Skatemunich e.V. and its sponsors.\nThe app offers all BladeNight participants the following functions:\n\t-Overview of upcoming and past dates\n- Display of the routes on the map\n- Live display of the train during BladeNight\n- Live display of your own position on the route and within the train\n- Add friends and follow them live`
  String get about_appinfo {
    return Intl.message(
      'The app is provided free of charge by the publisher exclusively for the Munich BladeNight and Skatemunich e.V. and its sponsors.\nThe app offers all BladeNight participants the following functions:\n\t-Overview of upcoming and past dates\n- Display of the routes on the map\n- Live display of the train during BladeNight\n- Live display of your own position on the route and within the train\n- Add friends and follow them live',
      name: 'about_appinfo',
      desc: '',
      args: [],
    );
  }

  /// `This app uses a unique ID that is saved locally when the app is first started.\nThis ID is used on the server to link friends and share the position. This is only transferred between your own app and server. \nThe app version number and phone manufacturer (Apple or Android) are also transmitted to check correct communication.\nThe ID is stored on the server with the linked friends.\nDeleting and reinstalling the app deletes the ID and the friends must be relinked \nThe data will not be passed on to third parties or used in any other way.\nYour location data will be used during the event to calculate and display the start and end of the train on the route and to calculate the distance to friends and to the destination.\nNo personal data is collected. The names of friends are only stored locally in the app.\nThe use of the app, email function, Bladeguard functions and website https://bladenight-muenchen.de is subject to the data protection regulations of Skatemunich e.V.\n These can be found at https:/ /bladenight-muenchen.de/datenschutzerklaerung can be viewed. The personal data is collected and processed exclusively for the purpose of organizing the Munich BladeNight. If you have any questions, please use the contact form,`
  String get about_appprivacy {
    return Intl.message(
      'This app uses a unique ID that is saved locally when the app is first started.\nThis ID is used on the server to link friends and share the position. This is only transferred between your own app and server. \nThe app version number and phone manufacturer (Apple or Android) are also transmitted to check correct communication.\nThe ID is stored on the server with the linked friends.\nDeleting and reinstalling the app deletes the ID and the friends must be relinked \nThe data will not be passed on to third parties or used in any other way.\nYour location data will be used during the event to calculate and display the start and end of the train on the route and to calculate the distance to friends and to the destination.\nNo personal data is collected. The names of friends are only stored locally in the app.\nThe use of the app, email function, Bladeguard functions and website https://bladenight-muenchen.de is subject to the data protection regulations of Skatemunich e.V.\n These can be found at https:/ /bladenight-muenchen.de/datenschutzerklaerung can be viewed. The personal data is collected and processed exclusively for the purpose of organizing the Munich BladeNight. If you have any questions, please use the contact form,',
      name: 'about_appprivacy',
      desc: '',
      args: [],
    );
  }

  /// `About BladeNight App`
  String get about_bnapp {
    return Intl.message(
      'About BladeNight App',
      name: 'about_bnapp',
      desc: '',
      args: [],
    );
  }

  /// `To improve the stability and reliability of this app, we rely on anonymized crash reports. For this we use "Firebase Crashlytics", a service of Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIn the event of a crash, anonymous information is sent to the Google servers in the USA (status of the app at the time of the crash, installation UUID, crash trace, cell phone manufacturer and operating system, last log messages). This information does not contain any personal data.\n\nCrash reports are only sent with your express consent. When using iOS apps, you can give consent in the app's settings or after a crash. With Android apps, when setting up the mobile device, you have the option of generally agreeing to the transmission of crash notifications to Google and the app developer.\n\nThe legal basis for data transmission is Article 6 (1) (a) GDPR.\n\nYou can revoke your consent at any time by deactivating the "Crash reports" function in the settings of the iOS apps (in the magazine apps the entry is in the "Communication" menu item).\n\nWith the Android apps, the deactivation is basically done in the Android settings.To do this, open the Settings app, select "Google" and there in the three-point menu at the top right the menu item "Usage & Diagnostics". Here you can deactivate the sending of the corresponding data. For more information, see your Google Account Help.\n\nFurther information on data protection can be found in the Firebase Crashlytics data protection information at https://firebase.google.com/support/privacy and https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies`
  String get about_crashlytics {
    return Intl.message(
      'To improve the stability and reliability of this app, we rely on anonymized crash reports. For this we use "Firebase Crashlytics", a service of Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIn the event of a crash, anonymous information is sent to the Google servers in the USA (status of the app at the time of the crash, installation UUID, crash trace, cell phone manufacturer and operating system, last log messages). This information does not contain any personal data.\n\nCrash reports are only sent with your express consent. When using iOS apps, you can give consent in the app\'s settings or after a crash. With Android apps, when setting up the mobile device, you have the option of generally agreeing to the transmission of crash notifications to Google and the app developer.\n\nThe legal basis for data transmission is Article 6 (1) (a) GDPR.\n\nYou can revoke your consent at any time by deactivating the "Crash reports" function in the settings of the iOS apps (in the magazine apps the entry is in the "Communication" menu item).\n\nWith the Android apps, the deactivation is basically done in the Android settings.To do this, open the Settings app, select "Google" and there in the three-point menu at the top right the menu item "Usage & Diagnostics". Here you can deactivate the sending of the corresponding data. For more information, see your Google Account Help.\n\nFurther information on data protection can be found in the Firebase Crashlytics data protection information at https://firebase.google.com/support/privacy and https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies',
      name: 'about_crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback is welcome.\nSend us an email:\nservice@skatemunich.de`
  String get about_feedback {
    return Intl.message(
      'Your feedback is welcome.\nSend us an email:\nservice@skatemunich.de',
      name: 'about_feedback',
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

  /// `BladeNight-App iOS/Android (2023)`
  String get about_h_androidapplicationflutter_23 {
    return Intl.message(
      'BladeNight-App iOS/Android (2023)',
      name: 'about_h_androidapplicationflutter_23',
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

  /// `What is the application for`
  String get about_h_bnapp {
    return Intl.message(
      'What is the application for',
      name: 'about_h_bnapp',
      desc: '',
      args: [],
    );
  }

  /// `Firebase Crashlytics privacy`
  String get about_h_crashlytics {
    return Intl.message(
      'Firebase Crashlytics privacy',
      name: 'about_h_crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `Feedback about BladeNight`
  String get about_h_feedback {
    return Intl.message(
      'Feedback about BladeNight',
      name: 'about_h_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Homepage`
  String get about_h_homepage {
    return Intl.message(
      'Homepage',
      name: 'about_h_homepage',
      desc: '',
      args: [],
    );
  }

  /// `Imprint`
  String get about_h_impressum {
    return Intl.message(
      'Imprint',
      name: 'about_h_impressum',
      desc: '',
      args: [],
    );
  }

  /// `Licence`
  String get about_h_licences {
    return Intl.message(
      'Licence',
      name: 'about_h_licences',
      desc: '',
      args: [],
    );
  }

  /// `OneSignal privacy`
  String get about_h_oneSignalPrivacy {
    return Intl.message(
      'OneSignal privacy',
      name: 'about_h_oneSignalPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Open Street Map Privacy`
  String get about_h_open_street_map {
    return Intl.message(
      'Open Street Map Privacy',
      name: 'about_h_open_street_map',
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

  /// `Server application`
  String get about_h_serverapp {
    return Intl.message(
      'Server application',
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

  /// `Operator and organizer of Münchener BladeNight is:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nRepresented by:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de`
  String get about_impressum {
    return Intl.message(
      'Operator and organizer of Münchener BladeNight is:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nRepresented by:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de',
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

  /// `Lars Huth`
  String get about_lars {
    return Intl.message(
      'Lars Huth',
      name: 'about_lars',
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

  /// `We use OneSignal, a mobile marketing platform, for our website. Service provider is the American company OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal also processes data in the USA, among other places. We would like to point out that, according to the European Court of Justice, there is currently no adequate level of protection for data transfer to the USA. This can be associated with various risks for the legality and security of data processing.\n\nOneSignal uses standard contractual clauses approved by the EU Commission (= Art. 46. Para. 2 and 3 GDPR). These clauses oblige OneSignal to comply with the EU data protection level when processing relevant data outside of the EU. These clauses are based on an implementation decision of the EU Commission. You can find the decision and the clauses here: https://germany.representation.ec.europa.eu/index_de.\n\nTo learn more about the data processed using OneSignal, see the Privacy Policy at https://onesignal.com/privacy.\n\nAll texts are copyrighted.\n\nSource: Created with the Privacy Generator by AdSimple`
  String get about_oneSignalPrivacy {
    return Intl.message(
      'We use OneSignal, a mobile marketing platform, for our website. Service provider is the American company OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal also processes data in the USA, among other places. We would like to point out that, according to the European Court of Justice, there is currently no adequate level of protection for data transfer to the USA. This can be associated with various risks for the legality and security of data processing.\n\nOneSignal uses standard contractual clauses approved by the EU Commission (= Art. 46. Para. 2 and 3 GDPR). These clauses oblige OneSignal to comply with the EU data protection level when processing relevant data outside of the EU. These clauses are based on an implementation decision of the EU Commission. You can find the decision and the clauses here: https://germany.representation.ec.europa.eu/index_de.\n\nTo learn more about the data processed using OneSignal, see the Privacy Policy at https://onesignal.com/privacy.\n\nAll texts are copyrighted.\n\nSource: Created with the Privacy Generator by AdSimple',
      name: 'about_oneSignalPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Data we receive automatically\n\nThe OSMF operates a number of services for the OpenStreetMap community, examples are the openstreetmap.org website, the "Standard" style online map, the OSM API and the nominatim search facility.\n\nWhen you visit an OSMF website, access any of the services via a browser or via applications that utilize the provided APIs, records of that use are produced, we collect information about your browser or application and your interaction with our website, including (a) IP address, (b) browser and device type, (c) operating system, (d) referring web page, (e) the date and time of page visits, and (f) the pages accessed on our websites.\n\nFurther we may operate user interaction tracking software that will generate additional records of user activity, for example Piwik.\n\nServices that use Geo-DNS or similar mechanisms to distribute load to geographically distributed servers will potentially generate a record of your location at a large scale (for example the OSMF tile cache network determines the country you are likely to be located in and directs your requests to an appropriate server).\n\nThese records are used or can be used in the following ways:\n\nin support of the operation of the services from a technical, security and planning point of view.\nas anonymised, summarised data for research and other purposes. Such data may be offered publicly via https://planet.openstreetmap.org or other channels and used by 3rd parties.\nto improve the OpenStreetMap dataset. For example by analysing nominatim queries for missing addresses and postcodes and providing such data to the OSM community.\nThe data collected on the systems will be accessible by the system administrators and the appropriate OSMF working groups, for example the Data Working Group. No personal information or information that is linked to an individual will be released to third parties, except as required by law.\n\nIP addresses stored by Piwik are shortened to two bytes and detailed usage information is retained for 180 days.\n\nGiven the temporary nature of this storage, it is generally not feasible for us to provide access to IP addresses or the logs associated with them.\n\nThe above mentioned data is processed on a legitimate interest basis (see GDPR article 6.1f ).`
  String get about_open_street_map {
    return Intl.message(
      'Data we receive automatically\n\nThe OSMF operates a number of services for the OpenStreetMap community, examples are the openstreetmap.org website, the "Standard" style online map, the OSM API and the nominatim search facility.\n\nWhen you visit an OSMF website, access any of the services via a browser or via applications that utilize the provided APIs, records of that use are produced, we collect information about your browser or application and your interaction with our website, including (a) IP address, (b) browser and device type, (c) operating system, (d) referring web page, (e) the date and time of page visits, and (f) the pages accessed on our websites.\n\nFurther we may operate user interaction tracking software that will generate additional records of user activity, for example Piwik.\n\nServices that use Geo-DNS or similar mechanisms to distribute load to geographically distributed servers will potentially generate a record of your location at a large scale (for example the OSMF tile cache network determines the country you are likely to be located in and directs your requests to an appropriate server).\n\nThese records are used or can be used in the following ways:\n\nin support of the operation of the services from a technical, security and planning point of view.\nas anonymised, summarised data for research and other purposes. Such data may be offered publicly via https://planet.openstreetmap.org or other channels and used by 3rd parties.\nto improve the OpenStreetMap dataset. For example by analysing nominatim queries for missing addresses and postcodes and providing such data to the OSM community.\nThe data collected on the systems will be accessible by the system administrators and the appropriate OSMF working groups, for example the Data Working Group. No personal information or information that is linked to an individual will be released to third parties, except as required by law.\n\nIP addresses stored by Piwik are shortened to two bytes and detailed usage information is retained for 180 days.\n\nGiven the temporary nature of this storage, it is generally not feasible for us to provide access to IP addresses or the logs associated with them.\n\nThe above mentioned data is processed on a legitimate interest basis (see GDPR article 6.1f ).',
      name: 'about_open_street_map',
      desc: '',
      args: [],
    );
  }

  /// `Actual informations`
  String get actualInformations {
    return Intl.message(
      'Actual informations',
      name: 'actualInformations',
      desc: '',
      args: [],
    );
  }

  /// `Add friend nearby`
  String get addNearBy {
    return Intl.message(
      'Add friend nearby',
      name: 'addNearBy',
      desc: '',
      args: [],
    );
  }

  /// `Add friend with Code`
  String get addfriendwithcode {
    return Intl.message(
      'Add friend with Code',
      name: 'addfriendwithcode',
      desc: '',
      args: [],
    );
  }

  /// `Add new  friend.`
  String get addnewfriend {
    return Intl.message(
      'Add new  friend.',
      name: 'addnewfriend',
      desc: '',
      args: [],
    );
  }

  /// `ahead of me`
  String get aheadOfMe {
    return Intl.message(
      'ahead of me',
      name: 'aheadOfMe',
      desc: '',
      args: [],
    );
  }

  /// `Align map on direction and position`
  String get alignDirectionAndPositionOnUpdate {
    return Intl.message(
      'Align map on direction and position',
      name: 'alignDirectionAndPositionOnUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Align map on direction update only`
  String get alignDirectionOnUpdateOnly {
    return Intl.message(
      'Align map on direction update only',
      name: 'alignDirectionOnUpdateOnly',
      desc: '',
      args: [],
    );
  }

  /// `No map align`
  String get alignNever {
    return Intl.message(
      'No map align',
      name: 'alignNever',
      desc: '',
      args: [],
    );
  }

  /// `Align map on my position update only`
  String get alignPositionOnUpdateOnly {
    return Intl.message(
      'Align map on my position update only',
      name: 'alignPositionOnUpdateOnly',
      desc: '',
      args: [],
    );
  }

  /// `Background update activ`
  String get allowHeadless {
    return Intl.message(
      'Background update activ',
      name: 'allowHeadless',
      desc: '',
      args: [],
    );
  }

  /// `Test implementation, since MIUI Xiaomi cell phones kill the apps through aggressive memory management and they no longer work. If the app is in the background or killed, the location is still transmitted (BETA).`
  String get allowHeadlessHeader {
    return Intl.message(
      'Test implementation, since MIUI Xiaomi cell phones kill the apps through aggressive memory management and they no longer work. If the app is in the background or killed, the location is still transmitted (BETA).',
      name: 'allowHeadlessHeader',
      desc: '',
      args: [],
    );
  }

  /// `Leave app waked up?`
  String get allowWakeLock {
    return Intl.message(
      'Leave app waked up?',
      name: 'allowWakeLock',
      desc: '',
      args: [],
    );
  }

  /// `App stays on while the app is open and tracking is active. Disables at 20% battery level. Leave switched on.`
  String get allowWakeLockHeader {
    return Intl.message(
      'App stays on while the app is open and tracking is active. Disables at 20% battery level. Leave switched on.',
      name: 'allowWakeLockHeader',
      desc: '',
      args: [],
    );
  }

  /// `Use alternative driver`
  String get alternativeLocationProvider {
    return Intl.message(
      'Use alternative driver',
      name: 'alternativeLocationProvider',
      desc: '',
      args: [],
    );
  }

  /// `Use alternative location driver in case of problems with GPS data`
  String get alternativeLocationProviderTitle {
    return Intl.message(
      'Use alternative location driver in case of problems with GPS data',
      name: 'alternativeLocationProviderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Location permission always denied in System.!`
  String get alwaysPermanentlyDenied {
    return Intl.message(
      'Location permission always denied in System.!',
      name: 'alwaysPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permission for always seems permanently denied!`
  String get alwaysPermantlyDenied {
    return Intl.message(
      'Location permission for always seems permanently denied!',
      name: 'alwaysPermantlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get anonymous {
    return Intl.message(
      'Anonymous',
      name: 'anonymous',
      desc: '',
      args: [],
    );
  }

  /// `App-Id`
  String get appId {
    return Intl.message(
      'App-Id',
      name: 'appId',
      desc: '',
      args: [],
    );
  }

  /// `Unique application identification string`
  String get appIdTitle {
    return Intl.message(
      'Unique application identification string',
      name: 'appIdTitle',
      desc: '',
      args: [],
    );
  }

  /// `App is outdated!\nPlease update in Appstore.`
  String get appOutDated {
    return Intl.message(
      'App is outdated!\nPlease update in Appstore.',
      name: 'appOutDated',
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

  /// `Application support`
  String get appsupport {
    return Intl.message(
      'Application support',
      name: 'appsupport',
      desc: '',
      args: [],
    );
  }

  /// `We care about your privacy and data security.\nTo help us improve the BladeNight experience, we transfer your location to our server. This information includes a unique ID created when you first start the app to enable friends to be assigned. This data is never passed on to third parties or used for advertising purposes.`
  String get apptrackingtransparancy {
    return Intl.message(
      'We care about your privacy and data security.\nTo help us improve the BladeNight experience, we transfer your location to our server. This information includes a unique ID created when you first start the app to enable friends to be assigned. This data is never passed on to third parties or used for advertising purposes.',
      name: 'apptrackingtransparancy',
      desc: '',
      args: [],
    );
  }

  /// `at`
  String get at {
    return Intl.message(
      'at',
      name: 'at',
      desc: '',
      args: [],
    );
  }

  /// `Info - please read - Stop automatic on finish`
  String get autoStopTracking {
    return Intl.message(
      'Info - please read - Stop automatic on finish',
      name: 'autoStopTracking',
      desc: '',
      args: [],
    );
  }

  /// `On long press at ▶️ automatic tracking stop will activated. This means, as long the app is active and tracking on reaching finish BladeNight the tracking stops automatic.\nRepeat long press at ▶️,⏸︎,⏹︎ ︎ switches to manual stop and locationsharing with autostop.`
  String get automatedStopInfo {
    return Intl.message(
      'On long press at ▶️ automatic tracking stop will activated. This means, as long the app is active and tracking on reaching finish BladeNight the tracking stops automatic.\nRepeat long press at ▶️,⏸︎,⏹︎ ︎ switches to manual stop and locationsharing with autostop.',
      name: 'automatedStopInfo',
      desc: '',
      args: [],
    );
  }

  /// `Become a Bladeguard`
  String get becomeBladeguard {
    return Intl.message(
      'Become a Bladeguard',
      name: 'becomeBladeguard',
      desc: '',
      args: [],
    );
  }

  /// `behind me`
  String get behindMe {
    return Intl.message(
      'behind me',
      name: 'behindMe',
      desc: '',
      args: [],
    );
  }

  /// `Background location update is active. Thank you for participating.`
  String get bgNotificationText {
    return Intl.message(
      'Background location update is active. Thank you for participating.',
      name: 'bgNotificationText',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight background tracking`
  String get bgNotificationTitle {
    return Intl.message(
      'BladeNight background tracking',
      name: 'bgNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard team`
  String get bgTeam {
    return Intl.message(
      'Bladeguard team',
      name: 'bgTeam',
      desc: '',
      args: [],
    );
  }

  /// `You're not on site today?`
  String get bgTodayNotOnSite {
    return Intl.message(
      'You\'re not on site today?',
      name: 'bgTodayNotOnSite',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately I cannot participate as a Bladeguard today`
  String get bgTodayNotParticipation {
    return Intl.message(
      'Unfortunately I cannot participate as a Bladeguard today',
      name: 'bgTodayNotParticipation',
      desc: '',
      args: [],
    );
  }

  /// `Are you on site today as a bladeguard?`
  String get bgTodayOnSite {
    return Intl.message(
      'Are you on site today as a bladeguard?',
      name: 'bgTodayOnSite',
      desc: '',
      args: [],
    );
  }

  /// `Please log in as Bladeguard today!`
  String get bgTodayRegister {
    return Intl.message(
      'Please log in as Bladeguard today!',
      name: 'bgTodayRegister',
      desc: '',
      args: [],
    );
  }

  /// `Update Phone.`
  String get bgUpdatePhone {
    return Intl.message(
      'Update Phone.',
      name: 'bgUpdatePhone',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
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

  /// `Bladeguard settings`
  String get bladeGuardSettings {
    return Intl.message(
      'Bladeguard settings',
      name: 'bladeGuardSettings',
      desc: '',
      args: [],
    );
  }

  /// `Open Bladeguard settings page`
  String get bladeGuardSettingsTitle {
    return Intl.message(
      'Open Bladeguard settings page',
      name: 'bladeGuardSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `<h2>Requirements and rules:</h2><ul><li>You are at least 16 years old.</li><li>You are comfortable with inline skates and can brake.</li ><li>You know the rules of the road </li><li>You are helpful, friendly and a team player </li><li>You take part in our free training before your first trip.</li></ul ><p>There are no costs to you as a Bladeguard. You can unsubscribe at any time. <h3>Here you can go to <a href="{bladeguardRegisterlink}">Online registration</a> and <a href="{ bladeguardPrivacyLink}">Data protection</a></p></h3>`
  String bladeguardInfo(
      Object bladeguardRegisterlink, Object bladeguardPrivacyLink) {
    return Intl.message(
      '<h2>Requirements and rules:</h2><ul><li>You are at least 16 years old.</li><li>You are comfortable with inline skates and can brake.</li ><li>You know the rules of the road </li><li>You are helpful, friendly and a team player </li><li>You take part in our free training before your first trip.</li></ul ><p>There are no costs to you as a Bladeguard. You can unsubscribe at any time. <h3>Here you can go to <a href="$bladeguardRegisterlink">Online registration</a> and <a href="$bladeguardPrivacyLink">Data protection</a></p></h3>',
      name: 'bladeguardInfo',
      desc: '',
      args: [bladeguardRegisterlink, bladeguardPrivacyLink],
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

  /// `BladeNight Update`
  String get bladenightUpdate {
    return Intl.message(
      'BladeNight Update',
      name: 'bladenightUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Viewermode with GPS`
  String get bladenightViewerTracking {
    return Intl.message(
      'Viewermode with GPS',
      name: 'bladenightViewerTracking',
      desc: '',
      args: [],
    );
  }

  /// `Viewermode, Participant push ▶ please`
  String get bladenighttracking {
    return Intl.message(
      'Viewermode, Participant push ▶ please',
      name: 'bladenighttracking',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Canceled 😞`
  String get canceled {
    return Intl.message(
      'Canceled 😞',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Change it.`
  String get change {
    return Intl.message(
      'Change it.',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change it to 'Allow all time'`
  String get changetoalways {
    return Intl.message(
      'Change it to \'Allow all time\'',
      name: 'changetoalways',
      desc: '',
      args: [],
    );
  }

  /// `Check if you registered as Bladeguard`
  String get checkBgRegistration {
    return Intl.message(
      'Check if you registered as Bladeguard',
      name: 'checkBgRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Please select your friend's device to link !`
  String get chooseDeviceToLink {
    return Intl.message(
      'Please select your friend\'s device to link !',
      name: 'chooseDeviceToLink',
      desc: '',
      args: [],
    );
  }

  /// `Clear logs really?`
  String get clearLogsQuestion {
    return Intl.message(
      'Clear logs really?',
      name: 'clearLogsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Logdata will be deleted permanently!`
  String get clearLogsTitle {
    return Intl.message(
      'Logdata will be deleted permanently!',
      name: 'clearLogsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Clear all messages really?`
  String get clearMessages {
    return Intl.message(
      'Clear all messages really?',
      name: 'clearMessages',
      desc: '',
      args: [],
    );
  }

  /// `Clear messages`
  String get clearMessagesTitle {
    return Intl.message(
      'Clear messages',
      name: 'clearMessagesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Close app really?`
  String get closeApp {
    return Intl.message(
      'Close app really?',
      name: 'closeApp',
      desc: '',
      args: [],
    );
  }

  /// `Code too old! Please delete entry and re-invite friend!`
  String get codeExpired {
    return Intl.message(
      'Code too old! Please delete entry and re-invite friend!',
      name: 'codeExpired',
      desc: '',
      args: [],
    );
  }

  /// `Error, code contains only numbers`
  String get codecontainsonlydigits {
    return Intl.message(
      'Error, code contains only numbers',
      name: 'codecontainsonlydigits',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed 😃`
  String get confirmed {
    return Intl.message(
      'Confirmed 😃',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedtoclipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedtoclipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copy code`
  String get copy {
    return Intl.message(
      'Copy code',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Could not open application settings!`
  String get couldNotOpenAppSettings {
    return Intl.message(
      'Could not open application settings!',
      name: 'couldNotOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Data could be outdated.`
  String get dataCouldBeOutdated {
    return Intl.message(
      'Data could be outdated.',
      name: 'dataCouldBeOutdated',
      desc: '',
      args: [],
    );
  }

  /// `{date}`
  String dateIntl(DateTime date) {
    final DateFormat dateDateFormat =
        DateFormat('dd.MM.yyyy', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      '$dateString',
      name: 'dateIntl',
      desc: '',
      args: [dateString],
    );
  }

  /// `{date} at {time}`
  String dateTimeDayIntl(DateTime date, DateTime time) {
    final DateFormat dateDateFormat =
        DateFormat('E d.MMM y', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$dateString at $timeString',
      name: 'dateTimeDayIntl',
      desc: '',
      args: [dateString, timeString],
    );
  }

  /// `{date} {time}`
  String dateTimeIntl(DateTime date, DateTime time) {
    final DateFormat dateDateFormat =
        DateFormat('d.M.y', Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$dateString $timeString',
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

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Message`
  String get deleteMessage {
    return Intl.message(
      'Delete Message',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get deletefriend {
    return Intl.message(
      'Remove friend',
      name: 'deletefriend',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get deny {
    return Intl.message(
      'Deny',
      name: 'deny',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Not connected`
  String get disconnected {
    return Intl.message(
      'Not connected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `distance`
  String get distance {
    return Intl.message(
      'distance',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Distance moved`
  String get distanceDriven {
    return Intl.message(
      'Distance moved',
      name: 'distanceDriven',
      desc: '',
      args: [],
    );
  }

  /// `GPS total driven`
  String get distanceDrivenOdo {
    return Intl.message(
      'GPS total driven',
      name: 'distanceDrivenOdo',
      desc: '',
      args: [],
    );
  }

  /// `Distance to finish`
  String get distanceToFinish {
    return Intl.message(
      'Distance to finish',
      name: 'distanceToFinish',
      desc: '',
      args: [],
    );
  }

  /// `Distance to friend`
  String get distanceToFriend {
    return Intl.message(
      'Distance to friend',
      name: 'distanceToFriend',
      desc: '',
      args: [],
    );
  }

  /// `Distance to head`
  String get distanceToHead {
    return Intl.message(
      'Distance to head',
      name: 'distanceToHead',
      desc: '',
      args: [],
    );
  }

  /// `Distance to me`
  String get distanceToMe {
    return Intl.message(
      'Distance to me',
      name: 'distanceToMe',
      desc: '',
      args: [],
    );
  }

  /// `Distance to tail`
  String get distanceToTail {
    return Intl.message(
      'Distance to tail',
      name: 'distanceToTail',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Edit friend`
  String get editfriend {
    return Intl.message(
      'Edit friend',
      name: 'editfriend',
      desc: '',
      args: [],
    );
  }

  /// `To use BladeNight-App also in the background (Share location with friends and increase procession accuracy) without screen on, should location settings changed to 'Allow all time'.`
  String get enableAlwaysLocationInfotext {
    return Intl.message(
      'To use BladeNight-App also in the background (Share location with friends and increase procession accuracy) without screen on, should location settings changed to \'Allow all time\'.',
      name: 'enableAlwaysLocationInfotext',
      desc: '',
      args: [],
    );
  }

  /// `Push message active`
  String get enableOnesignalPushMessage {
    return Intl.message(
      'Push message active',
      name: 'enableOnesignalPushMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enable Onesignal Push Notifications. Herewith general information can be received via push notification e.g. if the bladenight takes place. Recommended setting is 'On'`
  String get enableOnesignalPushMessageTitle {
    return Intl.message(
      'Enable Onesignal Push Notifications. Herewith general information can be received via push notification e.g. if the bladenight takes place. Recommended setting is \'On\'',
      name: 'enableOnesignalPushMessageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You must enter a 6-digit-code`
  String get enter6digitcode {
    return Intl.message(
      'You must enter a 6-digit-code',
      name: 'enter6digitcode',
      desc: '',
      args: [],
    );
  }

  /// `Your Birthday`
  String get enterBirthday {
    return Intl.message(
      'Your Birthday',
      name: 'enterBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile phone Number`
  String get enterPhoneNumber {
    return Intl.message(
      'Please enter your mobile phone Number',
      name: 'enterPhoneNumber',
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

  /// `Enter your friends name`
  String get enterfriendname {
    return Intl.message(
      'Enter your friends name',
      name: 'enterfriendname',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get entername {
    return Intl.message(
      'Enter Name',
      name: 'entername',
      desc: '',
      args: [],
    );
  }

  /// `Event not started`
  String get eventNotStarted {
    return Intl.message(
      'Event not started',
      name: 'eventNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Send logger data for support oder feature purposes`
  String get exportLogData {
    return Intl.message(
      'Send logger data for support oder feature purposes',
      name: 'exportLogData',
      desc: '',
      args: [],
    );
  }

  /// `Export user tracking`
  String get exportUserTracking {
    return Intl.message(
      'Export user tracking',
      name: 'exportUserTracking',
      desc: '',
      args: [],
    );
  }

  /// `Export recorded location data (visible track on map) as GPX`
  String get exportUserTrackingHeader {
    return Intl.message(
      'Export recorded location data (visible track on map) as GPX',
      name: 'exportUserTrackingHeader',
      desc: '',
      args: [],
    );
  }

  /// `Danger! This will back up all friends and the ID from the device. This may contain sensitive information such as names.`
  String get exportWarning {
    return Intl.message(
      'Danger! This will back up all friends and the ID from the device. This may contain sensitive information such as names.',
      name: 'exportWarning',
      desc: '',
      args: [],
    );
  }

  /// `Export friends und ID.`
  String get exportWarningTitle {
    return Intl.message(
      'Export friends und ID.',
      name: 'exportWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed!`
  String get failed {
    return Intl.message(
      'Failed!',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Please try to establish the connection with a code. Ask your friend for the code displayed in their 'Friends' overview. You can only connect to the same friend once.`
  String get failedAddNearbyTryCode {
    return Intl.message(
      'Please try to establish the connection with a code. Ask your friend for the code displayed in their \'Friends\' overview. You can only connect to the same friend once.',
      name: 'failedAddNearbyTryCode',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Tracking stopped - BladeNight finished`
  String get finishForceStopEventOverTitle {
    return Intl.message(
      'Tracking stopped - BladeNight finished',
      name: 'finishForceStopEventOverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tracking stopped - Timeout`
  String get finishForceStopTimeoutTitle {
    return Intl.message(
      'Tracking stopped - Timeout',
      name: 'finishForceStopTimeoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Finish reached - location tracking stopped.`
  String get finishReachedStopedTracking {
    return Intl.message(
      'Finish reached - location tracking stopped.',
      name: 'finishReachedStopedTracking',
      desc: '',
      args: [],
    );
  }

  /// `Finish reached`
  String get finishReachedTitle {
    return Intl.message(
      'Finish reached',
      name: 'finishReachedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Finish reached - Please stop location tracking.`
  String get finishReachedtargetReachedPleaseStopTracking {
    return Intl.message(
      'Finish reached - Please stop location tracking.',
      name: 'finishReachedtargetReachedPleaseStopTracking',
      desc: '',
      args: [],
    );
  }

  /// `Automatic tracking stop, because this BladeNight event is finished. (Press long on ▶️ to deactivate Automatic tracking stop)`
  String get finishStopTrackingEventOver {
    return Intl.message(
      'Automatic tracking stop, because this BladeNight event is finished. (Press long on ▶️ to deactivate Automatic tracking stop)',
      name: 'finishStopTrackingEventOver',
      desc: '',
      args: [],
    );
  }

  /// `Location tracking after {timeout} min of BladeNight automatic stopped. (Press long on ▶️ to deactivate Automatic tracking stop)`
  String finishStopTrackingTimeout(Object timeout) {
    return Intl.message(
      'Location tracking after $timeout min of BladeNight automatic stopped. (Press long on ▶️ to deactivate Automatic tracking stop)',
      name: 'finishStopTrackingTimeout',
      desc: '',
      args: [timeout],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Crashlytics on/off`
  String get fireBaseCrashlytics {
    return Intl.message(
      'Crashlytics on/off',
      name: 'fireBaseCrashlytics',
      desc: '',
      args: [],
    );
  }

  /// `To improve the app, crash events will be send to Crashlytics. This can be suppressed here.`
  String get fireBaseCrashlyticsHeader {
    return Intl.message(
      'To improve the app, crash events will be send to Crashlytics. This can be suppressed here.',
      name: 'fireBaseCrashlyticsHeader',
      desc: '',
      args: [],
    );
  }

  /// `Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function. This will be requested in the next steps.`
  String get fitnessPermissionInfoText {
    return Intl.message(
      'Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function. This will be requested in the next steps.',
      name: 'fitnessPermissionInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Fitness Activity`
  String get fitnessPermissionInfoTextTitle {
    return Intl.message(
      'Fitness Activity',
      name: 'fitnessPermissionInfoTextTitle',
      desc: '',
      args: [],
    );
  }

  /// `Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function. (Default inactive)`
  String get fitnessPermissionSettingsText {
    return Intl.message(
      'Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function. (Default inactive)',
      name: 'fitnessPermissionSettingsText',
      desc: '',
      args: [],
    );
  }

  /// `Fitness Activity disabled`
  String get fitnessPermissionSwitchSettingsText {
    return Intl.message(
      'Fitness Activity disabled',
      name: 'fitnessPermissionSwitchSettingsText',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get forward {
    return Intl.message(
      'Forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend {
    return Intl.message(
      'Friend',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `Friend is`
  String get friendIs {
    return Intl.message(
      'Friend is',
      name: 'friendIs',
      desc: '',
      args: [],
    );
  }

  /// `Alternative can your friend scan the barcode below or manually enter the code {code} in his app`
  String friendScanQrCode(Object code) {
    return Intl.message(
      'Alternative can your friend scan the barcode below or manually enter the code $code in his app',
      name: 'friendScanQrCode',
      desc: '',
      args: [code],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Please support the exact presentation of BladeNight skater train.\nYour friends will miss you!`
  String get friendswillmissyou {
    return Intl.message(
      'Please support the exact presentation of BladeNight skater train.\nYour friends will miss you!',
      name: 'friendswillmissyou',
      desc: '',
      args: [],
    );
  }

  /// `by`
  String get from {
    return Intl.message(
      'by',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Loading data from server ...`
  String get getwebdata {
    return Intl.message(
      'Loading data from server ...',
      name: 'getwebdata',
      desc: '',
      args: [],
    );
  }

  /// `Head`
  String get head {
    return Intl.message(
      'Head',
      name: 'head',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `I am already a Bladeguard`
  String get iAmBladeGuard {
    return Intl.message(
      'I am already a Bladeguard',
      name: 'iAmBladeGuard',
      desc: '',
      args: [],
    );
  }

  /// `We need support from volunteers. As a Bladeguard you actively support Bladenight. The <a href="{bladeguardPrivacyLink}">Munich BladeNight data protection regulations</a></p> apply`
  String iAmBladeGuardTitle(Object bladeguardPrivacyLink) {
    return Intl.message(
      'We need support from volunteers. As a Bladeguard you actively support Bladenight. The <a href="$bladeguardPrivacyLink">Munich BladeNight data protection regulations</a></p> apply',
      name: 'iAmBladeGuardTitle',
      desc: '',
      args: [bladeguardPrivacyLink],
    );
  }

  /// `I am`
  String get iam {
    return Intl.message(
      'I am',
      name: 'iam',
      desc: '',
      args: [],
    );
  }

  /// `Note - some manufacturers switch off the apps due to unfavorable battery optimization or close the app. If so, please try disabling battery optimization for the app. Set to No restrictions.`
  String get ignoreBatteriesOptimisation {
    return Intl.message(
      'Note - some manufacturers switch off the apps due to unfavorable battery optimization or close the app. If so, please try disabling battery optimization for the app. Set to No restrictions.',
      name: 'ignoreBatteriesOptimisation',
      desc: '',
      args: [],
    );
  }

  /// `Change Battery Optimizations`
  String get ignoreBatteriesOptimisationTitle {
    return Intl.message(
      'Change Battery Optimizations',
      name: 'ignoreBatteriesOptimisationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Attention this overwrites all friends and the ID. Export data beforehand! Be careful, delete the app on the device from which it was exported!`
  String get importWarning {
    return Intl.message(
      'Attention this overwrites all friends and the ID. Export data beforehand! Be careful, delete the app on the device from which it was exported!',
      name: 'importWarning',
      desc: '',
      args: [],
    );
  }

  /// `Import friends and ID.`
  String get importWarningTitle {
    return Intl.message(
      'Import friends and ID.',
      name: 'importWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `not implemented. We are working ...`
  String get inprogress {
    return Intl.message(
      'not implemented. We are working ...',
      name: 'inprogress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Code`
  String get internalerror_invalidcode {
    return Intl.message(
      'Invalid Code',
      name: 'internalerror_invalidcode',
      desc: '',
      args: [],
    );
  }

  /// `Error - Is friend linked?`
  String get internalerror_seemslinked {
    return Intl.message(
      'Error - Is friend linked?',
      name: 'internalerror_seemslinked',
      desc: '',
      args: [],
    );
  }

  /// `Email not found`
  String get invalidEMail {
    return Intl.message(
      'Email not found',
      name: 'invalidEMail',
      desc: '',
      args: [],
    );
  }

  /// `Email not found or wrong birthday`
  String get invalidLoginData {
    return Intl.message(
      'Email not found or wrong birthday',
      name: 'invalidLoginData',
      desc: '',
      args: [],
    );
  }

  /// `invalid code`
  String get invalidcode {
    return Intl.message(
      'invalid code',
      name: 'invalidcode',
      desc: '',
      args: [],
    );
  }

  /// `invite {name}`
  String invitebyname(Object name) {
    return Intl.message(
      'invite $name',
      name: 'invitebyname',
      desc: 'Invite {name}',
      args: [name],
    );
  }

  /// `Invite friend`
  String get invitenewfriend {
    return Intl.message(
      'Invite friend',
      name: 'invitenewfriend',
      desc: '',
      args: [],
    );
  }

  /// `Is ignored`
  String get isIgnoring {
    return Intl.message(
      'Is ignored',
      name: 'isIgnoring',
      desc: '',
      args: [],
    );
  }

  /// `is`
  String get ist {
    return Intl.message(
      'is',
      name: 'ist',
      desc: '',
      args: [],
    );
  }

  /// `Show in map`
  String get isuseractive {
    return Intl.message(
      'Show in map',
      name: 'isuseractive',
      desc: '',
      args: [],
    );
  }

  /// `Last seen`
  String get lastseen {
    return Intl.message(
      'Last seen',
      name: 'lastseen',
      desc: '',
      args: [],
    );
  }

  /// `Last update`
  String get lastupdate {
    return Intl.message(
      'Last update',
      name: 'lastupdate',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Leave settings`
  String get leavewheninuse {
    return Intl.message(
      'Leave settings',
      name: 'leavewheninuse',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get length {
    return Intl.message(
      'Length',
      name: 'length',
      desc: '',
      args: [],
    );
  }

  /// `Accept friend nearby`
  String get linkNearBy {
    return Intl.message(
      'Accept friend nearby',
      name: 'linkNearBy',
      desc: '',
      args: [],
    );
  }

  /// `<h2>Important information</h2><ul><li>Your friend must have same mobile type. Apple to Android doesn't work. Use Code pairing instead.</li><li>Your friend must be within a maximum of 2 m of you!</li><li>Please open the Friends tab for your friend in the Bladenight app.</li><li>Select Plus at the top right<span class= "icon">plus</span></li><li>Choose to accept a friend next to you</li><li>Now with this device <b><em>{deviceName}</em></b> Pair.</li></ul>You can change your submitted name in the text field. This is only for transferring via direct connection / scan.`
  String linkOnOtherDevice(Object deviceName) {
    return Intl.message(
      '<h2>Important information</h2><ul><li>Your friend must have same mobile type. Apple to Android doesn\'t work. Use Code pairing instead.</li><li>Your friend must be within a maximum of 2 m of you!</li><li>Please open the Friends tab for your friend in the Bladenight app.</li><li>Select Plus at the top right<span class= "icon">plus</span></li><li>Choose to accept a friend next to you</li><li>Now with this device <b><em>$deviceName</em></b> Pair.</li></ul>You can change your submitted name in the text field. This is only for transferring via direct connection / scan.',
      name: 'linkOnOtherDevice',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Linking failed`
  String get linkingFailed {
    return Intl.message(
      'Linking failed',
      name: 'linkingFailed',
      desc: '',
      args: [],
    );
  }

  /// `Linking successful`
  String get linkingSuccessful {
    return Intl.message(
      'Linking successful',
      name: 'linkingSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Follow BladeNight procession without app`
  String get liveMapInBrowser {
    return Intl.message(
      'Follow BladeNight procession without app',
      name: 'liveMapInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Live map in browser`
  String get liveMapInBrowserInfoHeader {
    return Intl.message(
      'Live map in browser',
      name: 'liveMapInBrowserInfoHeader',
      desc: '',
      args: [],
    );
  }

  /// `Loading ...`
  String get loading {
    return Intl.message(
      'Loading ...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Location is turned off in settings. Tracking not possible. Press Play ▶️ or go to OS-Settings.`
  String get locationServiceOff {
    return Intl.message(
      'Location is turned off in settings. Tracking not possible. Press Play ▶️ or go to OS-Settings.',
      name: 'locationServiceOff',
      desc: '',
      args: [],
    );
  }

  /// `Location sharing was started and is active.`
  String get locationServiceRunning {
    return Intl.message(
      'Location sharing was started and is active.',
      name: 'locationServiceRunning',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Map follows my position`
  String get mapFollowLocation {
    return Intl.message(
      'Map follows my position',
      name: 'mapFollowLocation',
      desc: '',
      args: [],
    );
  }

  /// `Map follows me stopped!`
  String get mapFollowStopped {
    return Intl.message(
      'Map follows me stopped!',
      name: 'mapFollowStopped',
      desc: '',
      args: [],
    );
  }

  /// `Map follows procession head position.`
  String get mapFollowTrain {
    return Intl.message(
      'Map follows procession head position.',
      name: 'mapFollowTrain',
      desc: '',
      args: [],
    );
  }

  /// `Map follows procession head stopped.`
  String get mapFollowTrainStopped {
    return Intl.message(
      'Map follows procession head stopped.',
      name: 'mapFollowTrainStopped',
      desc: '',
      args: [],
    );
  }

  /// `Move map to start, no following`
  String get mapToStartNoFollowing {
    return Intl.message(
      'Move map to start, no following',
      name: 'mapToStartNoFollowing',
      desc: '',
      args: [],
    );
  }

  /// `Mark me as head of procession`
  String get markMeAsHead {
    return Intl.message(
      'Mark me as head of procession',
      name: 'markMeAsHead',
      desc: '',
      args: [],
    );
  }

  /// `Mark me as tail of procession`
  String get markMeAsTail {
    return Intl.message(
      'Mark me as tail of procession',
      name: 'markMeAsTail',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get me {
    return Intl.message(
      'Me',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message(
      'Messages',
      name: 'messages',
      desc: '',
      args: [],
    );
  }

  /// `Driven route`
  String get metersOnRoute {
    return Intl.message(
      'Driven route',
      name: 'metersOnRoute',
      desc: '',
      args: [],
    );
  }

  /// `Field must contain at least 1 character`
  String get missingName {
    return Intl.message(
      'Field must contain at least 1 character',
      name: 'missingName',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get model {
    return Intl.message(
      'Model',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  /// `You must enter a name!`
  String get mustentername {
    return Intl.message(
      'You must enter a name!',
      name: 'mustentername',
      desc: '',
      args: [],
    );
  }

  /// `My name is`
  String get myName {
    return Intl.message(
      'My name is',
      name: 'myName',
      desc: '',
      args: [],
    );
  }

  /// `The specified name is transferred to the 2nd device when you connect to your friend. The name is only saved locally and is used for simplified linking via the local connection.`
  String get myNameHeader {
    return Intl.message(
      'The specified name is transferred to the 2nd device when you connect to your friend. The name is only saved locally and is used for simplified linking via the local connection.',
      name: 'myNameHeader',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, name exists`
  String get nameexists {
    return Intl.message(
      'Sorry, name exists',
      name: 'nameexists',
      desc: '',
      args: [],
    );
  }

  /// `Network error! No data!`
  String get networkerror {
    return Intl.message(
      'Network error! No data!',
      name: 'networkerror',
      desc: '',
      args: [],
    );
  }

  /// `never`
  String get never {
    return Intl.message(
      'never',
      name: 'never',
      desc: '',
      args: [],
    );
  }

  /// `New GPS data received`
  String get newGPSDatareceived {
    return Intl.message(
      'New GPS data received',
      name: 'newGPSDatareceived',
      desc: '',
      args: [],
    );
  }

  /// `Next BladeNight`
  String get nextEvent {
    return Intl.message(
      'Next BladeNight',
      name: 'nextEvent',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Location 'When in use' is selected. Warning, there is no background update enabled. Your position data to show exact Bladnight train and share your position with your friends is only possible when the app is open in foreground. Please confirm it or change your settings to 'Allow all time'.\nFurthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function.`
  String get noBackgroundlocationLeaveAppOpen {
    return Intl.message(
      'Location \'When in use\' is selected. Warning, there is no background update enabled. Your position data to show exact Bladnight train and share your position with your friends is only possible when the app is open in foreground. Please confirm it or change your settings to \'Allow all time\'.\nFurthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function.',
      name: 'noBackgroundlocationLeaveAppOpen',
      desc: '',
      args: [],
    );
  }

  /// `No background update possible.`
  String get noBackgroundlocationTitle {
    return Intl.message(
      'No background update possible.',
      name: 'noBackgroundlocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `No choice, no action`
  String get noChoiceNoAction {
    return Intl.message(
      'No choice, no action',
      name: 'noChoiceNoAction',
      desc: '',
      args: [],
    );
  }

  /// `Nothing planned`
  String get noEvent {
    return Intl.message(
      'Nothing planned',
      name: 'noEvent',
      desc: '',
      args: [],
    );
  }

  /// `No Event planned`
  String get noEventPlanned {
    return Intl.message(
      'No Event planned',
      name: 'noEventPlanned',
      desc: '',
      args: [],
    );
  }

  /// `No Event`
  String get noEventStarted {
    return Intl.message(
      'No Event',
      name: 'noEventStarted',
      desc: '',
      args: [],
    );
  }

  /// `No Event - Autostop`
  String get noEventStartedAutoStop {
    return Intl.message(
      'No Event - Autostop',
      name: 'noEventStartedAutoStop',
      desc: '',
      args: [],
    );
  }

  /// `No Event active since more than {timeout} min. - Tracking stopped automatically.`
  String noEventTimeOut(Object timeout) {
    return Intl.message(
      'No Event active since more than $timeout min. - Tracking stopped automatically.',
      name: 'noEventTimeOut',
      desc: '',
      args: [timeout],
    );
  }

  /// `GPS not active`
  String get noGpsAllowed {
    return Intl.message(
      'GPS not active',
      name: 'noGpsAllowed',
      desc: '',
      args: [],
    );
  }

  /// `No location known`
  String get noLocationAvailable {
    return Intl.message(
      'No location known',
      name: 'noLocationAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Please check location-permissions in Settings.`
  String get noLocationPermissionGrantedAlertAndroid {
    return Intl.message(
      'Please check location-permissions in Settings.',
      name: 'noLocationPermissionGrantedAlertAndroid',
      desc: '',
      args: [],
    );
  }

  /// `Info location permissions`
  String get noLocationPermissionGrantedAlertTitle {
    return Intl.message(
      'Info location permissions',
      name: 'noLocationPermissionGrantedAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please check location-permissions in iOS Settings. Look at Privacy - Location - BladnightApp. Set it to always or when in use!`
  String get noLocationPermissionGrantedAlertiOS {
    return Intl.message(
      'Please check location-permissions in iOS Settings. Look at Privacy - Location - BladnightApp. Set it to always or when in use!',
      name: 'noLocationPermissionGrantedAlertiOS',
      desc: '',
      args: [],
    );
  }

  /// `No location permission, please check device settings`
  String get noLocationPermitted {
    return Intl.message(
      'No location permission, please check device settings',
      name: 'noLocationPermitted',
      desc: '',
      args: [],
    );
  }

  /// `No Data received !`
  String get nodatareceived {
    return Intl.message(
      'No Data received !',
      name: 'nodatareceived',
      desc: '',
      args: [],
    );
  }

  /// `No GPS`
  String get nogps {
    return Intl.message(
      'No GPS',
      name: 'nogps',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, no GPS in device found or denied. Please check your privacy and location settings.`
  String get nogpsenabled {
    return Intl.message(
      'Sorry, no GPS in device found or denied. Please check your privacy and location settings.',
      name: 'nogpsenabled',
      desc: '',
      args: [],
    );
  }

  /// `not available`
  String get notAvailable {
    return Intl.message(
      'not available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Obsolete! Delete it!`
  String get notKnownOnServer {
    return Intl.message(
      'Obsolete! Delete it!',
      name: 'notKnownOnServer',
      desc: '',
      args: [],
    );
  }

  /// `Not on route!`
  String get notOnRoute {
    return Intl.message(
      'Not on route!',
      name: 'notOnRoute',
      desc: '',
      args: [],
    );
  }

  /// `Not visible on map!`
  String get notVisibleOnMap {
    return Intl.message(
      'Not visible on map!',
      name: 'notVisibleOnMap',
      desc: '',
      args: [],
    );
  }

  /// `The BladeNight was canceled.`
  String get note_bladenightCanceled {
    return Intl.message(
      'The BladeNight was canceled.',
      name: 'note_bladenightCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Next BladeNight will start in 5 minutes. Don't forget to turn tracking on !`
  String get note_bladenightStartInFiveMinutesStartTracking {
    return Intl.message(
      'Next BladeNight will start in 5 minutes. Don\'t forget to turn tracking on !',
      name: 'note_bladenightStartInFiveMinutesStartTracking',
      desc: '',
      args: [],
    );
  }

  /// `Next BladeNight will start in 6 hours.`
  String get note_bladenightStartInSixHoursStartTracking {
    return Intl.message(
      'Next BladeNight will start in 6 hours.',
      name: 'note_bladenightStartInSixHoursStartTracking',
      desc: '',
      args: [],
    );
  }

  /// `BladeNight Status was changed - Please check in app`
  String get note_statuschanged {
    return Intl.message(
      'BladeNight Status was changed - Please check in app',
      name: 'note_statuschanged',
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

  /// `No tracking!`
  String get notracking {
    return Intl.message(
      'No tracking!',
      name: 'notracking',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
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

  /// `at`
  String get on {
    return Intl.message(
      'at',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `on route`
  String get onRoute {
    return Intl.message(
      'on route',
      name: 'onRoute',
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

  /// `This is the assigned Id for receiving push messages. Let us know the ID if you have problems receiving push messages.`
  String get oneSignalIdTitle {
    return Intl.message(
      'This is the assigned Id for receiving push messages. Let us know the ID if you have problems receiving push messages.',
      name: 'oneSignalIdTitle',
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

  /// `Location only 'Allow only while using the app' set.`
  String get onlyWhenInUseEnabled {
    return Intl.message(
      'Location only \'Allow only while using the app\' set.',
      name: 'onlyWhenInUseEnabled',
      desc: '',
      args: [],
    );
  }

  /// `GPS WhileInUse - app works only in foreground. Please change Operating Systems settings`
  String get onlyWhileInUse {
    return Intl.message(
      'GPS WhileInUse - app works only in foreground. Please change Operating Systems settings',
      name: 'onlyWhileInUse',
      desc: '',
      args: [],
    );
  }

  /// `Open operating system settings`
  String get openOperatingSystemSettings {
    return Intl.message(
      'Open operating system settings',
      name: 'openOperatingSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `load Openstreetmap  / App restart necessary`
  String get openStreetMap {
    return Intl.message(
      'load Openstreetmap  / App restart necessary',
      name: 'openStreetMap',
      desc: '',
      args: [],
    );
  }

  /// `Use Openstreetmap`
  String get openStreetMapText {
    return Intl.message(
      'Use Openstreetmap',
      name: 'openStreetMapText',
      desc: '',
      args: [],
    );
  }

  /// `Own`
  String get own {
    return Intl.message(
      'Own',
      name: 'own',
      desc: '',
      args: [],
    );
  }

  /// `Participant`
  String get participant {
    return Intl.message(
      'Participant',
      name: 'participant',
      desc: '',
      args: [],
    );
  }

  /// `Pending ⏰`
  String get pending {
    return Intl.message(
      'Pending ⏰',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get phoneNumber {
    return Intl.message(
      'Mobile',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Pick a color.`
  String get pickcolor {
    return Intl.message(
      'Pick a color.',
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

  /// `Positive if in front, negative if behind me.`
  String get positiveInFront {
    return Intl.message(
      'Positive if in front, negative if behind me.',
      name: 'positiveInFront',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step. You should select 'While using the App'. Later we will ask you again, prefered is 'Allow all time'. When you select 'When in use' you must let open the BladeNight on screen in forground, to share your location. If you deny locationaccess, only the BladeNight procession can be watched without location sharing.  So you can use other Apps in foreground.Furthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function.\nThe request is parted in 2 Steps.\nPlease support the accuracy of the train. Thank you so much.`
  String get prominentdisclosuretrackingprealertandroidFromAndroid_V11 {
    return Intl.message(
      'The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step. You should select \'While using the App\'. Later we will ask you again, prefered is \'Allow all time\'. When you select \'When in use\' you must let open the BladeNight on screen in forground, to share your location. If you deny locationaccess, only the BladeNight procession can be watched without location sharing.  So you can use other Apps in foreground.Furthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location tracking when your device is detected as stationary. Therefore please activate this function.\nThe request is parted in 2 Steps.\nPlease support the accuracy of the train. Thank you so much.',
      name: 'prominentdisclosuretrackingprealertandroidFromAndroid_V11',
      desc: '',
      args: [],
    );
  }

  /// `The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step.You should select 'While using the App'. If you deny locationaccess, only the BladeNight skater train can be watched without location sharing. Please support the accuracy of the train`
  String get prominentdisclosuretrackingprealertandroidToAndroid_V10x {
    return Intl.message(
      'The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step.You should select \'While using the App\'. If you deny locationaccess, only the BladeNight skater train can be watched without location sharing. Please support the accuracy of the train',
      name: 'prominentdisclosuretrackingprealertandroidToAndroid_V10x',
      desc: '',
      args: [],
    );
  }

  /// `Participate push req.`
  String get pushMessageParticipateAsBladeGuard {
    return Intl.message(
      'Participate push req.',
      name: 'pushMessageParticipateAsBladeGuard',
      desc: '',
      args: [],
    );
  }

  /// `Bladeguard-participate via push-message?`
  String get pushMessageParticipateAsBladeGuardTitle {
    return Intl.message(
      'Bladeguard-participate via push-message?',
      name: 'pushMessageParticipateAsBladeGuardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Skatemunich Infos`
  String get pushMessageSkateMunichInfos {
    return Intl.message(
      'Get Skatemunich Infos',
      name: 'pushMessageSkateMunichInfos',
      desc: '',
      args: [],
    );
  }

  /// `Receive SkateMunich infos via push message about events?`
  String get pushMessageSkateMunichInfosTitle {
    return Intl.message(
      'Receive SkateMunich infos via push message about events?',
      name: 'pushMessageSkateMunichInfosTitle',
      desc: '',
      args: [],
    );
  }

  /// `QRCode to show event info without app in browser`
  String get qrcoderouteinfoheader {
    return Intl.message(
      'QRCode to show event info without app in browser',
      name: 'qrcoderouteinfoheader',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get readMessage {
    return Intl.message(
      'Read',
      name: 'readMessage',
      desc: '',
      args: [],
    );
  }

  /// `Receive Bladeguard Infos`
  String get receiveBladeGuardInfos {
    return Intl.message(
      'Receive Bladeguard Infos',
      name: 'receiveBladeGuardInfos',
      desc: '',
      args: [],
    );
  }

  /// `received`
  String get received {
    return Intl.message(
      'received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get reload {
    return Intl.message(
      'Reload',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `rel. timediff.`
  String get reltime {
    return Intl.message(
      'rel. timediff.',
      name: 'reltime',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Location always permissions`
  String get requestAlwaysPermissionTitle {
    return Intl.message(
      'Location always permissions',
      name: 'requestAlwaysPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Information why location sharing would be necessary.`
  String get requestLocationPermissionTitle {
    return Intl.message(
      'Information why location sharing would be necessary.',
      name: 'requestLocationPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `You really want to deregister as a Bladeguard today. We need everyone. Think again.`
  String get requestOffSite {
    return Intl.message(
      'You really want to deregister as a Bladeguard today. We need everyone. Think again.',
      name: 'requestOffSite',
      desc: '',
      args: [],
    );
  }

  /// `No Bladeguard today?`
  String get requestOffSiteTitle {
    return Intl.message(
      'No Bladeguard today?',
      name: 'requestOffSiteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reset in settings-page`
  String get resetInSettings {
    return Intl.message(
      'Reset in settings-page',
      name: 'resetInSettings',
      desc: '',
      args: [],
    );
  }

  /// `Press gauge long to reset the ODO meter`
  String get resetLongPress {
    return Intl.message(
      'Press gauge long to reset the ODO meter',
      name: 'resetLongPress',
      desc: '',
      args: [],
    );
  }

  /// `Reset ODO meter to 0 and clear driven route?`
  String get resetOdoMeter {
    return Intl.message(
      'Reset ODO meter to 0 and clear driven route?',
      name: 'resetOdoMeter',
      desc: '',
      args: [],
    );
  }

  /// `ODO meter reset and driven route`
  String get resetOdoMeterTitle {
    return Intl.message(
      'ODO meter reset and driven route',
      name: 'resetOdoMeterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Restart required! Please close app and reopen !!!`
  String get restartRequired {
    return Intl.message(
      'Restart required! Please close app and reopen !!!',
      name: 'restartRequired',
      desc: '',
      args: [],
    );
  }

  /// `Route`
  String get route {
    return Intl.message(
      'Route',
      name: 'route',
      desc: '',
      args: [],
    );
  }

  /// `Route overview`
  String get routeoverview {
    return Intl.message(
      'Route overview',
      name: 'routeoverview',
      desc: '',
      args: [],
    );
  }

  /// `We are on route ⏳`
  String get running {
    return Intl.message(
      'We are on route ⏳',
      name: 'running',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Scroll map to ...`
  String get scrollMapTo {
    return Intl.message(
      'Scroll map to ...',
      name: 'scrollMapTo',
      desc: '',
      args: [],
    );
  }

  /// ` Waiting for internet connection ...`
  String get seemsoffline {
    return Intl.message(
      ' Waiting for internet connection ...',
      name: 'seemsoffline',
      desc: '',
      args: [],
    );
  }

  /// `Request sent - change need about 30 secs.`
  String get sendData30sec {
    return Intl.message(
      'Request sent - change need about 30 secs.',
      name: 'sendData30sec',
      desc: '',
      args: [],
    );
  }

  /// `Send link`
  String get sendlink {
    return Intl.message(
      'Send link',
      name: 'sendlink',
      desc: '',
      args: [],
    );
  }

  /// `Hi, this is my invitation to share your skating position in BladeNight App, and find me. If you like this, get the BladeNight app from AppStore end enter the code: {requestid} in Friends after pressing + add friend by code.\nWhen the BladeNight App is installed use following link: bna://bladenight.app?addFriend&code={requestid} on your mobile. \nHave fun and we will find together.\nThe BladeNight-App is available on Playstore \n{playStoreLink} and on Apple App Store \n{iosAppStoreLink}`
  String sendlinkdescription(
      Object requestid, Object playStoreLink, Object iosAppStoreLink) {
    return Intl.message(
      'Hi, this is my invitation to share your skating position in BladeNight App, and find me. If you like this, get the BladeNight app from AppStore end enter the code: $requestid in Friends after pressing + add friend by code.\nWhen the BladeNight App is installed use following link: bna://bladenight.app?addFriend&code=$requestid on your mobile. \nHave fun and we will find together.\nThe BladeNight-App is available on Playstore \n$playStoreLink and on Apple App Store \n$iosAppStoreLink',
      name: 'sendlinkdescription',
      desc: 'Please send code {requestid} to your friend',
      args: [requestid, playStoreLink, iosAppStoreLink],
    );
  }

  /// `Send link to BladeNight-App. You can see each other.`
  String get sendlinksubject {
    return Intl.message(
      'Send link to BladeNight-App. You can see each other.',
      name: 'sendlinksubject',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for server connection ....`
  String get serverNotReachable {
    return Intl.message(
      'Waiting for server connection ....',
      name: 'serverNotReachable',
      desc: '',
      args: [],
    );
  }

  /// `Error negotiate session connection`
  String get sessionConnectionError {
    return Intl.message(
      'Error negotiate session connection',
      name: 'sessionConnectionError',
      desc: '',
      args: [],
    );
  }

  /// `Clear log data`
  String get setClearLogs {
    return Intl.message(
      'Clear log data',
      name: 'setClearLogs',
      desc: '',
      args: [],
    );
  }

  /// `Activate Dark Mode`
  String get setDarkMode {
    return Intl.message(
      'Activate Dark Mode',
      name: 'setDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Switch between light- and dark-mode independent of OS-setting.`
  String get setDarkModeTitle {
    return Intl.message(
      'Switch between light- and dark-mode independent of OS-setting.',
      name: 'setDarkModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Export Log data (Support) it@huth.app`
  String get setExportLogSupport {
    return Intl.message(
      'Export Log data (Support) it@huth.app',
      name: 'setExportLogSupport',
      desc: '',
      args: [],
    );
  }

  /// `Icon size: `
  String get setIconSize {
    return Intl.message(
      'Icon size: ',
      name: 'setIconSize',
      desc: '',
      args: [],
    );
  }

  /// `Set size of me, friend and procession icons on the map`
  String get setIconSizeTitle {
    return Intl.message(
      'Set size of me, friend and procession icons on the map',
      name: 'setIconSizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Insert dataset incl. bna:`
  String get setInsertImportDataset {
    return Intl.message(
      'Insert dataset incl. bna:',
      name: 'setInsertImportDataset',
      desc: '',
      args: [],
    );
  }

  /// `Data logger`
  String get setLogData {
    return Intl.message(
      'Data logger',
      name: 'setLogData',
      desc: '',
      args: [],
    );
  }

  /// `Own Color on Map`
  String get setMeColor {
    return Intl.message(
      'Own Color on Map',
      name: 'setMeColor',
      desc: '',
      args: [],
    );
  }

  /// `Open Operatingsystem settings`
  String get setOpenSystemSettings {
    return Intl.message(
      'Open Operatingsystem settings',
      name: 'setOpenSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Set primary (light) color (default yellow)`
  String get setPrimaryColor {
    return Intl.message(
      'Set primary (light) color (default yellow)',
      name: 'setPrimaryColor',
      desc: '',
      args: [],
    );
  }

  /// `Set primary Dark-mode color (default yellow)`
  String get setPrimaryDarkColor {
    return Intl.message(
      'Set primary Dark-mode color (default yellow)',
      name: 'setPrimaryDarkColor',
      desc: '',
      args: [],
    );
  }

  /// `Set Route`
  String get setRoute {
    return Intl.message(
      'Set Route',
      name: 'setRoute',
      desc: '',
      args: [],
    );
  }

  /// `Start import Id und friends`
  String get setStartImport {
    return Intl.message(
      'Start import Id und friends',
      name: 'setStartImport',
      desc: '',
      args: [],
    );
  }

  /// `Set Status`
  String get setState {
    return Intl.message(
      'Set Status',
      name: 'setState',
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

  /// `Choose your team!`
  String get setTeam {
    return Intl.message(
      'Choose your team!',
      name: 'setTeam',
      desc: '',
      args: [],
    );
  }

  /// `Change color`
  String get setcolor {
    return Intl.message(
      'Change color',
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

  /// `Export Id and friends`
  String get setexportIdAndFriends {
    return Intl.message(
      'Export Id and friends',
      name: 'setexportIdAndFriends',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Show procession participants`
  String get showFullProcession {
    return Intl.message(
      'Show procession participants',
      name: 'showFullProcession',
      desc: '',
      args: [],
    );
  }

  /// `Show procession participants (limited to 100 in procession) on map. Works only if self-tracking.`
  String get showFullProcessionTitle {
    return Intl.message(
      'Show procession participants (limited to 100 in procession) on map. Works only if self-tracking.',
      name: 'showFullProcessionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show own track in map`
  String get showOwnTrack {
    return Intl.message(
      'Show own track in map',
      name: 'showOwnTrack',
      desc: '',
      args: [],
    );
  }

  /// `Showing actual procession of Münchener BladeNight`
  String get showProcession {
    return Intl.message(
      'Showing actual procession of Münchener BladeNight',
      name: 'showProcession',
      desc: '',
      args: [],
    );
  }

  /// `Show weblink to route`
  String get showWeblinkToRoute {
    return Intl.message(
      'Show weblink to route',
      name: 'showWeblinkToRoute',
      desc: '',
      args: [],
    );
  }

  /// `Show only`
  String get showonly {
    return Intl.message(
      'Show only',
      name: 'showonly',
      desc: '',
      args: [],
    );
  }

  /// `since`
  String get since {
    return Intl.message(
      'since',
      name: 'since',
      desc: '',
      args: [],
    );
  }

  /// `Some settings are not available because there is no internet connection`
  String get someSettingsNotAvailableBecauseOffline {
    return Intl.message(
      'Some settings are not available because there is no internet connection',
      name: 'someSettingsNotAvailableBecauseOffline',
      desc: '',
      args: [],
    );
  }

  /// `Special functions - change only when you know what you do!`
  String get specialfunction {
    return Intl.message(
      'Special functions - change only when you know what you do!',
      name: 'specialfunction',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get speed {
    return Intl.message(
      'Speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Start location without participating`
  String get startLocationWithoutParticipating {
    return Intl.message(
      'Start location without participating',
      name: 'startLocationWithoutParticipating',
      desc: '',
      args: [],
    );
  }

  /// `Please read carefully.\nThis starts the location display on the map without participating in the train and transfers your location to the server to calculate the times. Your friends on the train will be displayed. The time to the beginning / end of the train from your location will be calculated. Furthermore, your speed and tracking data will be recorded which you can save. Please do not use this function if you participate in the BladeNight. The mode must be ended manually.\nDo you want to start this?`
  String get startLocationWithoutParticipatingInfo {
    return Intl.message(
      'Please read carefully.\nThis starts the location display on the map without participating in the train and transfers your location to the server to calculate the times. Your friends on the train will be displayed. The time to the beginning / end of the train from your location will be calculated. Furthermore, your speed and tracking data will be recorded which you can save. Please do not use this function if you participate in the BladeNight. The mode must be ended manually.\nDo you want to start this?',
      name: 'startLocationWithoutParticipatingInfo',
      desc: '',
      args: [],
    );
  }

  /// `Start participation`
  String get startParticipationTracking {
    return Intl.message(
      'Start participation',
      name: 'startParticipationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Start point\nDeutsches Verkehrsmuseum\nSchwanthalerhöhe Munich`
  String get startPoint {
    return Intl.message(
      'Start point\nDeutsches Verkehrsmuseum\nSchwanthalerhöhe Munich',
      name: 'startPoint',
      desc: '',
      args: [],
    );
  }

  /// `Where is the start?`
  String get startPointTitle {
    return Intl.message(
      'Where is the start?',
      name: 'startPointTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get startTime {
    return Intl.message(
      'Start time',
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

  /// `active`
  String get status_active {
    return Intl.message(
      'active',
      name: 'status_active',
      desc: '',
      args: [],
    );
  }

  /// `inactive`
  String get status_inactive {
    return Intl.message(
      'inactive',
      name: 'status_inactive',
      desc: '',
      args: [],
    );
  }

  /// `obsolete`
  String get status_obsolete {
    return Intl.message(
      'obsolete',
      name: 'status_obsolete',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get status_pending {
    return Intl.message(
      'pending',
      name: 'status_pending',
      desc: '',
      args: [],
    );
  }

  /// `Stop location sharing?`
  String get stopLocationTracking {
    return Intl.message(
      'Stop location sharing?',
      name: 'stopLocationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Stop location without participating`
  String get stopLocationWithoutParticipating {
    return Intl.message(
      'Stop location without participating',
      name: 'stopLocationWithoutParticipating',
      desc: '',
      args: [],
    );
  }

  /// `Stop participation tracking`
  String get stopParticipationTracking {
    return Intl.message(
      'Stop participation tracking',
      name: 'stopParticipationTracking',
      desc: '',
      args: [],
    );
  }

  /// `Event timed out ({timeout} min). Don't forget to stop tracking.`
  String stopTrackingTimeOut(Object timeout) {
    return Intl.message(
      'Event timed out ($timeout min). Don\'t forget to stop tracking.',
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

  /// `Symbols`
  String get symbols {
    return Intl.message(
      'Symbols',
      name: 'symbols',
      desc: '',
      args: [],
    );
  }

  /// `Tail`
  String get tail {
    return Intl.message(
      'Tail',
      name: 'tail',
      desc: '',
      args: [],
    );
  }

  /// `Please tell '{name}' this code \n\n{requestid}\nHe/she/it has to confirm this in his/her/it 'BladeNight-App'.\nThe Code is only 60 minutes valid!\nPlease update with ↻ button the status manually.`
  String tellcode(Object name, Object requestid) {
    return Intl.message(
      'Please tell \'$name\' this code \n\n$requestid\nHe/she/it has to confirm this in his/her/it \'BladeNight-App\'.\nThe Code is only 60 minutes valid!\nPlease update with ↻ button the status manually.',
      name: 'tellcode',
      desc: 'transfer code to friend',
      args: [name, requestid],
    );
  }

  /// `Thank you for participating.`
  String get thanksForParticipating {
    return Intl.message(
      'Thank you for participating.',
      name: 'thanksForParticipating',
      desc: '',
      args: [],
    );
  }

  /// `{time}`
  String timeIntl(DateTime time) {
    final DateFormat timeDateFormat = DateFormat.Hm(Intl.getCurrentLocale());
    final String timeString = timeDateFormat.format(time);

    return Intl.message(
      '$timeString',
      name: 'timeIntl',
      desc: '',
      args: [timeString],
    );
  }

  /// `Timeout - duration of BladeNight exceed`
  String get timeOutDurationExceedTitle {
    return Intl.message(
      'Timeout - duration of BladeNight exceed',
      name: 'timeOutDurationExceedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp`
  String get timeStamp {
    return Intl.message(
      'Timestamp',
      name: 'timeStamp',
      desc: '',
      args: [],
    );
  }

  /// `to finish (est.)`
  String get timeToFinish {
    return Intl.message(
      'to finish (est.)',
      name: 'timeToFinish',
      desc: '',
      args: [],
    );
  }

  /// `Time to friend`
  String get timeToFriend {
    return Intl.message(
      'Time to friend',
      name: 'timeToFriend',
      desc: '',
      args: [],
    );
  }

  /// `Time to head`
  String get timeToHead {
    return Intl.message(
      'Time to head',
      name: 'timeToHead',
      desc: '',
      args: [],
    );
  }

  /// `Time to me`
  String get timeToMe {
    return Intl.message(
      'Time to me',
      name: 'timeToMe',
      desc: '',
      args: [],
    );
  }

  /// `Time to tail`
  String get timeToTail {
    return Intl.message(
      'Time to tail',
      name: 'timeToTail',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `No today`
  String get todayNo {
    return Intl.message(
      'No today',
      name: 'todayNo',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `The following route points will be exported: `
  String get trackPointsExporting {
    return Intl.message(
      'The following route points will be exported: ',
      name: 'trackPointsExporting',
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

  /// `data ok`
  String get tracking {
    return Intl.message(
      'data ok',
      name: 'tracking',
      desc: '',
      args: [],
    );
  }

  /// `Recorded route points`
  String get trackingPoints {
    return Intl.message(
      'Recorded route points',
      name: 'trackingPoints',
      desc: '',
      args: [],
    );
  }

  /// `Tracking restartet`
  String get trackingRestarted {
    return Intl.message(
      'Tracking restartet',
      name: 'trackingRestarted',
      desc: '',
      args: [],
    );
  }

  /// `Train`
  String get train {
    return Intl.message(
      'Train',
      name: 'train',
      desc: '',
      args: [],
    );
  }

  /// `Trainlength`
  String get trainlength {
    return Intl.message(
      'Trainlength',
      name: 'trainlength',
      desc: '',
      args: [],
    );
  }

  /// `This can only be changed in the system settings! Try opening system settings?`
  String get tryOpenAppSettings {
    return Intl.message(
      'This can only be changed in the system settings! Try opening system settings?',
      name: 'tryOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Understood`
  String get understand {
    return Intl.message(
      'Understood',
      name: 'understand',
      desc: '',
      args: [],
    );
  }

  /// `unknown`
  String get unknown {
    return Intl.message(
      'unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `unknown error`
  String get unknownerror {
    return Intl.message(
      'unknown error',
      name: 'unknownerror',
      desc: '',
      args: [],
    );
  }

  /// `Unread`
  String get unreadMessage {
    return Intl.message(
      'Unread',
      name: 'unreadMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update Phone`
  String get updatePhone {
    return Intl.message(
      'Update Phone',
      name: 'updatePhone',
      desc: '',
      args: [],
    );
  }

  /// `This is my GPS-speed.`
  String get userSpeed {
    return Intl.message(
      'This is my GPS-speed.',
      name: 'userSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Validate friend`
  String get validatefriend {
    return Intl.message(
      'Validate friend',
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

  /// `Shown on map.`
  String get visibleOnMap {
    return Intl.message(
      'Shown on map.',
      name: 'visibleOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Waiting...`
  String get waiting {
    return Intl.message(
      'Waiting...',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `Waittime`
  String get waittime {
    return Intl.message(
      'Waittime',
      name: 'waittime',
      desc: '',
      args: [],
    );
  }

  /// `is canceled! Please check this on https://bladenight-muenchen.de`
  String get wasCanceledPleaseCheck {
    return Intl.message(
      'is canceled! Please check this on https://bladenight-muenchen.de',
      name: 'wasCanceledPleaseCheck',
      desc: '',
      args: [],
    );
  }

  /// `{date}`
  String weekdayIntl(DateTime date) {
    final DateFormat dateDateFormat = DateFormat.EEEE(Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      '$dateString',
      name: 'weekdayIntl',
      desc: '',
      args: [dateString],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `was yesterday`
  String get yesterday {
    return Intl.message(
      'was yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Localize> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
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
