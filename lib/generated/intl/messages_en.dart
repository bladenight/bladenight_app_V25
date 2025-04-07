// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(bladeguardRegisterlink, bladeguardPrivacyLink) =>
      "<h2>Requirements and rules:</h2><ul><li>You are at least 16 years old.</li><li>You are comfortable with inline skates and can brake.</li><li>You know the rules of the road </li><li>You are helpful, friendly and a team player </li><li>You read our Bladeguard-training module before your first trip and answers the questions.</li></ul><p>There are no costs to you as a Bladeguard. You can unsubscribe at any time. <h3>Here you can go to <a href=\"${bladeguardRegisterlink}\">Online registration</a> and <a href=\"${bladeguardPrivacyLink}\">Data protection</a></p></h3>";

  static String m1(date) => "${date}";

  static String m2(date, time) => "${date} at ${time}";

  static String m3(date, time) => "${date} ${time}";

  static String m4(date, time) => "${date} ${time}Uhr";

  static String m5(name) => "Delete linking with ${name} forever";

  static String m6(name) => "Edit ${name} colors and name";

  static String m7(timeout) =>
      "Location sharing after ${timeout} min of BladeNight automatic stopped. (Press long on ▶️ to deactivate automatic location sharing stop)";

  static String m8(code) =>
      "Alternative can your friend scan the barcode below or manually enter the code ${code} in his app";

  static String m9(bladeguardPrivacyLink) =>
      "We need support from volunteers. As a Bladeguard you actively support BladeNight. The <a href=\"${bladeguardPrivacyLink}\">Munich BladeNight data protection regulations</a></p> apply";

  static String m10(name) => "invite ${name}";

  static String m11(linkDescription, link) =>
      "You clicked \n${linkDescription} (${link}) and you will be redirected to your device internet browser. Please switch back to this app when finished. The app continues to run in the background.";

  static String m12(deviceName) =>
      "<h2>Important information!</h2><ul><li>Your friend must use the same type of phone. Apple to Android does not work. In this case, use the code pairing.</li><li> Your friend must be within a maximum distance of 2 m from you!</li><li>Please open the Friends tab for your friend in the BladeNight! app.</li><li>Select Plus at the top right<span class=\"icon\">plus</span></li><li>Select Add friend next to you</li><li>Now with this device <b><em>${deviceName}</em></b> Pair.</li><li>Alternatively, you can scan your friend\'s barcode with the camera or use the connection with the Add friend with code option </li></ul>You can enter your transmitted name change in the text field. This is only for transferring via direct connection.";

  static String m13(deviceName, code) =>
      "<h2>Important information!</h2><ul><li>Your friend must use the same type of phone. Apple to Android does not work. In this case, use the code pairing.</li><li> Your friend must be within a maximum distance of 2 m from you!</li><li>Please open the Friends tab for your friend in the BladeNight! app.</li><li>Select Plus at the top right<span class=\"icon\">plus</span></li><li>Choose to accept a friend next to you</li><li>Now with this device <b><em>${deviceName}</em></b> pair.</li><li>Alternatively, your friend can scan the barcode with the camera or connect you with <br>code <b>${code}</b></li></ul>You can change your submitted name in the text field. This is only for transfer via direct connection / scan.";

  static String m14(distInMeter) =>
      "You have to be close to the starting point, but you are at least ${distInMeter} m away. If you are late, inform your team leader, please!";

  static String m15(timeout) =>
      "No Event active since more than ${timeout} min. - Location sharing stopped automatically.";

  static String m16(
    requestId,
    bnaLink,
    myName,
    playStoreLink,
    iosAppStoreLink,
  ) =>
      "Hi, this is my invitation to share your skating position in BladeNight App, and find me. If you like this, get the BladeNight app from AppStore end enter the code: ${requestId} in Friends after pressing + add friend by code.\nWhen the BladeNight App is installed use following link: ${bnaLink} on your mobile. \nHave fun and we will find together.\nThe BladeNight-App is available on Playstore \n${playStoreLink} and on Apple App Store \n${iosAppStoreLink}";

  static String m17(timeout) =>
      "Event timed out (${timeout} min). Don\'t forget to stop location sharing.";

  static String m18(name, requestid) =>
      "Please tell \'${name}\' this code \n\n${requestid}\nHe/she/it has to confirm this in his/her/it \'BladeNight-App\'.\nThe Code is only 60 minutes valid!\nPlease update with ↻ button the status manually.";

  static String m19(time) => "${time}";

  static String m20(level) =>
      "Tracking stopped due to low battery ${level}%. To avoid turn off Autostop in settings";

  static String m21(level) =>
      "Display on activated by app settings - Warning, battery low ${level} %.";

  static String m22(date) => "${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "OneSignalId": MessageLookupByLibrary.simpleMessage("Push-Message-Id"),
    "about_appinfo": MessageLookupByLibrary.simpleMessage(
      "The app is provided free of charge by the publisher exclusively for the Munich BladeNight and Skatemunich e.V. and its sponsors.\nThe app offers all BladeNight participants the following functions:\n\t-Overview of upcoming and past dates\n- Display of the routes on the map\n- Live display of the train during BladeNight\n- Live display of your own position on the route and within the train\n- Add friends and follow them live",
    ),
    "about_appprivacy": MessageLookupByLibrary.simpleMessage(
      "This app uses a unique ID that is saved locally when the app is first started.\nThis ID is used on the server to pair friends and share the position. This is only transferred between your own app and server. \nThe app version number and phone manufacturer (Apple or Android) are also transmitted to check correct communication.\nThe ID is stored on the server with the linked friends.\nDeleting and reinstalling the app deletes the ID and the friends must be relinked \nThe data will not be passed on to third parties or used in any other way.\nYour location data will be used during the event to calculate and display the start and end of the train on the route and to calculate the distance to friends and to the destination.\nNo personal data is collected. The names of friends are only stored locally in the app.\nThe use of the app, email function, Bladeguard functions and website https://bladenight-muenchen.de is subject to the data protection regulations of Skatemunich e.V.\n These can be found at https:/ /bladenight-muenchen.de/datenschutzerklaerung can be viewed. The personal data is collected and processed exclusively for the purpose of organizing the Munich BladeNight. If you have any questions, please use the contact form,",
    ),
    "about_bnapp": MessageLookupByLibrary.simpleMessage("About BladeNight App"),
    "about_crashlytics": MessageLookupByLibrary.simpleMessage(
      "To improve the stability and reliability of this app, we rely on anonymized crash reports. For this we use \"Firebase Crashlytics\", a service of Google Ireland Ltd., Google Building Gordon House, Barrow Street, Dublin 4, Ireland.\nIn the event of a crash, anonymous information is sent to the Google servers in the USA (status of the app at the time of the crash, installation UUID, crash trace, cell phone manufacturer and operating system, last log messages). This information does not contain any personal data.\n\nCrash reports are only sent with your express consent. When using iOS apps, you can give consent in the app\'s settings or after a crash. With Android apps, when setting up the mobile device, you have the option of generally agreeing to the transmission of crash notifications to Google and the app developer.\n\nThe legal basis for data transmission is Article 6 (1) (a) GDPR.\n\nYou can revoke your consent at any time by deactivating the \"Crash reports\" function in the settings of the iOS apps (in the magazine apps the entry is in the \"Communication\" menu item).\n\nWith the Android apps, the deactivation is basically done in the Android settings.To do this, open the Settings app, select \"Google\" and there in the three-point menu at the top right the menu item \"Usage & Diagnostics\". Here you can deactivate the sending of the corresponding data. For more information, see your Google Account Help.\n\nFurther information on data protection can be found in the Firebase Crashlytics data protection information at https://firebase.google.com/support/privacy and https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies",
    ),
    "about_feedback": MessageLookupByLibrary.simpleMessage(
      "Your feedback is welcome.\nSend us an email:\nservice@skatemunich.de",
    ),
    "about_h_androidapplicationflutter": MessageLookupByLibrary.simpleMessage(
      "BladeNight-App iOS/Android (2022)",
    ),
    "about_h_androidapplicationflutter_23":
        MessageLookupByLibrary.simpleMessage(
          "BladeNight-App iOS/Android (2023)",
        ),
    "about_h_androidapplicationv1": MessageLookupByLibrary.simpleMessage(
      "Android App V1 (2013)",
    ),
    "about_h_androidapplicationv2": MessageLookupByLibrary.simpleMessage(
      "Android App V2 (2014-2022)",
    ),
    "about_h_androidapplicationv3": MessageLookupByLibrary.simpleMessage(
      "Android App V3 (2023)",
    ),
    "about_h_bnapp": MessageLookupByLibrary.simpleMessage(
      "What is the application for",
    ),
    "about_h_crashlytics": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics privacy",
    ),
    "about_h_feedback": MessageLookupByLibrary.simpleMessage(
      "Feedback about BladeNight",
    ),
    "about_h_homepage": MessageLookupByLibrary.simpleMessage("Homepage"),
    "about_h_impressum": MessageLookupByLibrary.simpleMessage("Imprint"),
    "about_h_licences": MessageLookupByLibrary.simpleMessage("Licence"),
    "about_h_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
      "OneSignal privacy",
    ),
    "about_h_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Open Street Map Privacy",
    ),
    "about_h_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
    "about_h_serverapp": MessageLookupByLibrary.simpleMessage(
      "Server application",
    ),
    "about_h_version": MessageLookupByLibrary.simpleMessage("Version:"),
    "about_impressum": MessageLookupByLibrary.simpleMessage(
      "Operator and organizer of Münchener BladeNight is:\n\nSportverein SkateMunich! e.V.\nOberföhringer Straße 230\n81925 München\n\nVereinsregister: VR 200139\nRegistergericht: Amtsgericht München\n\nRepresented by:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail: service@skatemunich.de",
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
      "We use OneSignal, a mobile marketing platform, for our website. Service provider is the American company OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\n\nOneSignal also processes data in the USA, among other places. We would like to point out that, according to the European Court of Justice, there is currently no adequate level of protection for data transfer to the USA. This can be associated with various risks for the legality and security of data processing.\n\nOneSignal uses standard contractual clauses approved by the EU Commission (= Art. 46. Para. 2 and 3 GDPR). These clauses oblige OneSignal to comply with the EU data protection level when processing relevant data outside of the EU. These clauses are based on an implementation decision of the EU Commission. You can find the decision and the clauses here: https://germany.representation.ec.europa.eu/index_de.\n\nTo learn more about the data processed using OneSignal, see the Privacy Policy at https://onesignal.com/privacy.\n\nAll texts are copyrighted.\n\nSource: Created with the Privacy Generator by AdSimple",
    ),
    "about_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Data we receive automatically\n\nThe OSMF operates a number of services for the OpenStreetMap community, examples are the openstreetmap.org website, the \"Standard\" style online map, the OSM API and the nominatim search facility.\n\nWhen you visit an OSMF website, access any of the services via a browser or via applications that utilize the provided APIs, records of that use are produced, we collect information about your browser or application and your interaction with our website, including (a) IP address, (b) browser and device type, (c) operating system, (d) referring web page, (e) the date and time of page visits, and (f) the pages accessed on our websites.\n\nFurther we may operate user interaction tracking software that will generate additional records of user activity, for example Piwik.\n\nServices that use Geo-DNS or similar mechanisms to distribute load to geographically distributed servers will potentially generate a record of your location at a large scale (for example the OSMF tile cache network determines the country you are likely to be located in and directs your requests to an appropriate server).\n\nThese records are used or can be used in the following ways:\n\nin support of the operation of the services from a technical, security and planning point of view.\nas anonymised, summarised data for research and other purposes. Such data may be offered publicly via https://planet.openstreetmap.org or other channels and used by 3rd parties.\nto improve the OpenStreetMap dataset. For example by analysing nominatim queries for missing addresses and postcodes and providing such data to the OSM community.\nThe data collected on the systems will be accessible by the system administrators and the appropriate OSMF working groups, for example the Data Working Group. No personal information or information that is linked to an individual will be released to third parties, except as required by law.\n\nIP addresses stored by Piwik are shortened to two bytes and detailed usage information is retained for 180 days.\n\nGiven the temporary nature of this storage, it is generally not feasible for us to provide access to IP addresses or the logs associated with them.\n\nThe above mentioned data is processed on a legitimate interest basis (see GDPR article 6.1f ).",
    ),
    "actualInformations": MessageLookupByLibrary.simpleMessage(
      "Actual information",
    ),
    "addEvent": MessageLookupByLibrary.simpleMessage("Add Event"),
    "addFriendWithCodeHeader": MessageLookupByLibrary.simpleMessage(
      "Here you can generate a code to create a relationship with your friend",
    ),
    "addNearBy": MessageLookupByLibrary.simpleMessage("Add friend nearby"),
    "addNewFriendHeader": MessageLookupByLibrary.simpleMessage(
      "If your friend has generated a code, you can finish the relationship with him",
    ),
    "addfriendwithcode": MessageLookupByLibrary.simpleMessage(
      "Add friend with Code",
    ),
    "addnewfriend": MessageLookupByLibrary.simpleMessage("Add new  friend."),
    "admin": MessageLookupByLibrary.simpleMessage("Administrator"),
    "aheadOfMe": MessageLookupByLibrary.simpleMessage("ahead of me"),
    "alignDirectionAndPositionOnUpdate": MessageLookupByLibrary.simpleMessage(
      "Align map on direction and position",
    ),
    "alignDirectionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Align map on direction update only",
    ),
    "alignNever": MessageLookupByLibrary.simpleMessage("No map align"),
    "alignPositionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Align map on my position update only",
    ),
    "allowHeadless": MessageLookupByLibrary.simpleMessage(
      "Background update activ",
    ),
    "allowHeadlessHeader": MessageLookupByLibrary.simpleMessage(
      "Test implementation, since MIUI Xiaomi cell phones kill the apps through aggressive memory management and they no longer work. If the app is in the background or killed, the location is still transmitted (BETA).",
    ),
    "allowWakeLock": MessageLookupByLibrary.simpleMessage(
      "Leave app waked up?",
    ),
    "allowWakeLockHeader": MessageLookupByLibrary.simpleMessage(
      "Display keeps on while the app is open and location sharing is active. Disables at 30% battery level. (Higher battery consumption)",
    ),
    "alternativeLocationProvider": MessageLookupByLibrary.simpleMessage(
      "Use alternative driver",
    ),
    "alternativeLocationProviderTitle": MessageLookupByLibrary.simpleMessage(
      "Use alternative location driver in case of problems with GPS data",
    ),
    "alwaysPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Location permission always denied in System.!",
    ),
    "alwaysPermantlyDenied": MessageLookupByLibrary.simpleMessage(
      "Location permission for always seems permanently denied!",
    ),
    "anonymous": MessageLookupByLibrary.simpleMessage("Anonymous"),
    "appId": MessageLookupByLibrary.simpleMessage("App-Id"),
    "appIdTitle": MessageLookupByLibrary.simpleMessage(
      "Unique application identification string",
    ),
    "appInfo": MessageLookupByLibrary.simpleMessage("App info"),
    "appInitialisationError": MessageLookupByLibrary.simpleMessage(
      "App initialisation failed",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("BladeNight Munich"),
    "appOutDated": MessageLookupByLibrary.simpleMessage(
      "App is outdated!\nPlease update in Appstore.",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "appsupport": MessageLookupByLibrary.simpleMessage("Application support"),
    "apptrackingtransparancy": MessageLookupByLibrary.simpleMessage(
      "We care about your privacy and data security.\nTo help us improve the BladeNight experience, we transfer your location to our server. This information includes a unique ID created when you first start the app to enable friends to be assigned. This data is never passed on to third parties or used for advertising purposes.",
    ),
    "at": MessageLookupByLibrary.simpleMessage("on"),
    "autoStartTracking": MessageLookupByLibrary.simpleMessage(
      "Location sharing started automatically. To disable behaviour go to settings and switch Auto-Start/Stop location sharing off",
    ),
    "autoStartTrackingInfo": MessageLookupByLibrary.simpleMessage(
      "Start location sharing automatically",
    ),
    "autoStartTrackingInfoTitle": MessageLookupByLibrary.simpleMessage(
      "When starting BladeNight, it is possible to start location sharing automatically if the app is open. As soon as the app is closed or the background activity is not enabled, location sharing is not activated. Should the location sharing function start automatically when the app is open?",
    ),
    "autoStartTrackingTitle": MessageLookupByLibrary.simpleMessage(
      "Location sharing started automatically ...",
    ),
    "autoStopTracking": MessageLookupByLibrary.simpleMessage(
      "Info - please read - Stop automatic on finish",
    ),
    "automatedStopInfo": MessageLookupByLibrary.simpleMessage(
      "On long press at ▶️ automatic location sharing stop will activated. This means, as long the app is active and reaching the finish, location sharing will stopped automatically.\nRepeat long press at ▶️,⏸︎,⏹︎ ︎ switches to manual stop and location sharing with auto stop.",
    ),
    "automatedStopSettingText": MessageLookupByLibrary.simpleMessage(
      "Auto-Stop location sharing",
    ),
    "automatedStopSettingTitle": MessageLookupByLibrary.simpleMessage(
      "Stop location sharing automatically dependent on event",
    ),
    "becomeBladeguard": MessageLookupByLibrary.simpleMessage(
      "Become a Bladeguard",
    ),
    "behindMe": MessageLookupByLibrary.simpleMessage("behind me"),
    "bgNotificationText": MessageLookupByLibrary.simpleMessage(
      "Background location update is active. Thank you for participating.",
    ),
    "bgNotificationTitle": MessageLookupByLibrary.simpleMessage(
      "BladeNight background location sharing",
    ),
    "bgTeam": MessageLookupByLibrary.simpleMessage("Bladeguard team"),
    "bgTodayIsRegistered": MessageLookupByLibrary.simpleMessage(
      "You\'re registered as Bladeguard today!",
    ),
    "bgTodayNotParticipation": MessageLookupByLibrary.simpleMessage(
      "Unfortunately I cannot participate as a Bladeguard today",
    ),
    "bgTodayNotRegistered": MessageLookupByLibrary.simpleMessage(
      "Please login as Bladeguard today!",
    ),
    "bgTodayTapToRegister": MessageLookupByLibrary.simpleMessage(
      "Login as a Bladeguard today!",
    ),
    "bgTodayTapToUnRegister": MessageLookupByLibrary.simpleMessage(
      "Unregister as a Bladeguard today!",
    ),
    "bgUpdatePhone": MessageLookupByLibrary.simpleMessage("Update data"),
    "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
    "bladeGuard": MessageLookupByLibrary.simpleMessage("Bladeguard"),
    "bladeGuardSettings": MessageLookupByLibrary.simpleMessage(
      "Bladeguard settings",
    ),
    "bladeGuardSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Open Bladeguard settings page",
    ),
    "bladeguardAtStartPointTitle": MessageLookupByLibrary.simpleMessage(
      "BladeNight!-App - registered onsite",
    ),
    "bladeguardInfo": m0,
    "bladenight": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "bladenightUpdate": MessageLookupByLibrary.simpleMessage(
      "BladeNight Update",
    ),
    "bladenightViewerTracking": MessageLookupByLibrary.simpleMessage(
      "Viewermode with GPS",
    ),
    "bladenighttracking": MessageLookupByLibrary.simpleMessage(
      "Viewermode, Participant push ▶ please",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "canceled": MessageLookupByLibrary.simpleMessage("Canceled 😞"),
    "change": MessageLookupByLibrary.simpleMessage("Change it."),
    "changeDarkColor": MessageLookupByLibrary.simpleMessage(
      "Change dark mode color",
    ),
    "changeLightColor": MessageLookupByLibrary.simpleMessage(
      "Change light mode color",
    ),
    "changeMeColor": MessageLookupByLibrary.simpleMessage("Change me color"),
    "changetoalways": MessageLookupByLibrary.simpleMessage(
      "Change it to \'Allow all time\'",
    ),
    "checkBgRegistration": MessageLookupByLibrary.simpleMessage(
      "Check if you registered as Bladeguard",
    ),
    "checkNearbyCounterSide": MessageLookupByLibrary.simpleMessage(
      "Please select your friends device to get App-friends",
    ),
    "chooseDeviceToLink": MessageLookupByLibrary.simpleMessage(
      "Please select your friend\'s device to pair !",
    ),
    "clearLogsQuestion": MessageLookupByLibrary.simpleMessage(
      "Clear logs really?",
    ),
    "clearLogsTitle": MessageLookupByLibrary.simpleMessage(
      "Logdata will be deleted permanently!",
    ),
    "clearMessages": MessageLookupByLibrary.simpleMessage(
      "Clear all messages really?",
    ),
    "clearMessagesTitle": MessageLookupByLibrary.simpleMessage(
      "Clear messages",
    ),
    "closeApp": MessageLookupByLibrary.simpleMessage("Close app really?"),
    "codeExpired": MessageLookupByLibrary.simpleMessage(
      "Code too old! Please delete entry and re-invite friend!",
    ),
    "codecontainsonlydigits": MessageLookupByLibrary.simpleMessage(
      "Error, code contains only numbers",
    ),
    "collectionStop": MessageLookupByLibrary.simpleMessage(
      "Procession collection stop",
    ),
    "confirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting..."),
    "copiedtoclipboard": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy code"),
    "couldNotOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "Could not open application settings!",
    ),
    "dataCouldBeOutdated": MessageLookupByLibrary.simpleMessage(
      "Data could be outdated.",
    ),
    "dateIntl": m1,
    "dateTimeDayIntl": m2,
    "dateTimeIntl": m3,
    "dateTimeSecIntl": m4,
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteEvent": MessageLookupByLibrary.simpleMessage("Delete Event"),
    "deleteFriendHeader": m5,
    "deleteMessage": MessageLookupByLibrary.simpleMessage("Delete Message"),
    "deletefriend": MessageLookupByLibrary.simpleMessage("Remove friend"),
    "deny": MessageLookupByLibrary.simpleMessage("Deny"),
    "devicesAlreadyConnected": MessageLookupByLibrary.simpleMessage(
      "Devices are already connected",
    ),
    "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Not connected"),
    "distance": MessageLookupByLibrary.simpleMessage("distance"),
    "distanceDriven": MessageLookupByLibrary.simpleMessage("Distance moved"),
    "distanceDrivenOdo": MessageLookupByLibrary.simpleMessage(
      "GPS total driven",
    ),
    "distanceToFinish": MessageLookupByLibrary.simpleMessage(
      "Distance to finish",
    ),
    "distanceToFriend": MessageLookupByLibrary.simpleMessage(
      "Distance to friend",
    ),
    "distanceToHead": MessageLookupByLibrary.simpleMessage("Distance to head"),
    "distanceToMe": MessageLookupByLibrary.simpleMessage("Distance to me"),
    "distanceToTail": MessageLookupByLibrary.simpleMessage("Distance to tail"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "editEvent": MessageLookupByLibrary.simpleMessage("Edit Event"),
    "editFriendHeader": m6,
    "editfriend": MessageLookupByLibrary.simpleMessage("Edit friend"),
    "enableAlwaysLocationGeofenceText": MessageLookupByLibrary.simpleMessage(
      "For automatic on-site login, the location release should be set to always. Should the system settings be opened?",
    ),
    "enableAlwaysLocationInfotext": MessageLookupByLibrary.simpleMessage(
      "To use BladeNight-App also in the background (Share location with friends and increase procession accuracy) without screen on, should location settings changed to \'Allow all time\'.",
    ),
    "enableOnesignalPushMessage": MessageLookupByLibrary.simpleMessage(
      "Push message active",
    ),
    "enableOnesignalPushMessageTitle": MessageLookupByLibrary.simpleMessage(
      "Enable Onesignal Push Notifications. Herewith general information can be received via push notification e.g. if the bladenight takes place. Recommended setting is \'On\'",
    ),
    "enter6digitcode": MessageLookupByLibrary.simpleMessage(
      "You must enter a 6-digit-code",
    ),
    "enterBgPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter Bladeguard security password",
    ),
    "enterBirthday": MessageLookupByLibrary.simpleMessage("Your Birthday"),
    "enterEmail": MessageLookupByLibrary.simpleMessage("Enter email"),
    "enterPassword": MessageLookupByLibrary.simpleMessage("Enter password"),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter your mobile phone Number",
    ),
    "entercode": MessageLookupByLibrary.simpleMessage("Code: "),
    "enterfriendname": MessageLookupByLibrary.simpleMessage(
      "Enter your friends name",
    ),
    "entername": MessageLookupByLibrary.simpleMessage("Enter Name"),
    "eventNotStarted": MessageLookupByLibrary.simpleMessage(
      "Event not started",
    ),
    "events": MessageLookupByLibrary.simpleMessage("Events"),
    "export": MessageLookupByLibrary.simpleMessage("Export"),
    "exportLogData": MessageLookupByLibrary.simpleMessage(
      "Send logger data for support oder feature purposes",
    ),
    "exportUserTracking": MessageLookupByLibrary.simpleMessage(
      "Export user locations (tracking)",
    ),
    "exportUserTrackingHeader": MessageLookupByLibrary.simpleMessage(
      "Export recorded location data (visible track on map) as GPX",
    ),
    "exportWarning": MessageLookupByLibrary.simpleMessage(
      "Danger! This will back up all friends and the ID from the device. This may contain sensitive information such as names.",
    ),
    "exportWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Export friends und ID.",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("Failed!"),
    "failedAddNearbyTryCode": MessageLookupByLibrary.simpleMessage(
      "Please try to establish the connection with a code. Ask your friend for the code displayed in their \'Friends\' overview. You can only connect to the same friend once.",
    ),
    "finish": MessageLookupByLibrary.simpleMessage("Finish"),
    "finishForceStopEventOverTitle": MessageLookupByLibrary.simpleMessage(
      "Location sharing stopped - BladeNight finished",
    ),
    "finishForceStopTimeoutTitle": MessageLookupByLibrary.simpleMessage(
      "Location sharing stopped - Timeout",
    ),
    "finishReachedStopedTracking": MessageLookupByLibrary.simpleMessage(
      "Finish reached - Location sharing stopped.",
    ),
    "finishReachedTitle": MessageLookupByLibrary.simpleMessage(
      "Finish reached",
    ),
    "finishReachedtargetReachedPleaseStopTracking":
        MessageLookupByLibrary.simpleMessage(
          "Finish reached - Please stop Location sharing.",
        ),
    "finishStopTrackingEventOver": MessageLookupByLibrary.simpleMessage(
      "Automatic location sharing stopped, because this BladeNight event is finished. (Press long on ▶️ to deactivate automatic location sharing stop)",
    ),
    "finishStopTrackingTimeout": m7,
    "finished": MessageLookupByLibrary.simpleMessage("Finished"),
    "fireBaseCrashlytics": MessageLookupByLibrary.simpleMessage(
      "Crashlytics on/off",
    ),
    "fireBaseCrashlyticsHeader": MessageLookupByLibrary.simpleMessage(
      "To improve the app, crash events will be send to Crashlytics. This can be suppressed here.",
    ),
    "fitnessPermissionInfoText": MessageLookupByLibrary.simpleMessage(
      "Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location sharing when your device is detected as stationary. Therefore please activate this function. This will be requested in the next steps.",
    ),
    "fitnessPermissionInfoTextTitle": MessageLookupByLibrary.simpleMessage(
      "Fitness Activity",
    ),
    "fitnessPermissionSettingsText": MessageLookupByLibrary.simpleMessage(
      "Access to motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location sharing when your device is detected as stationary. Therefore please activate this function.",
    ),
    "fitnessPermissionSwitchSettingsText": MessageLookupByLibrary.simpleMessage(
      "Motion sensor enabled",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password"),
    "forward": MessageLookupByLibrary.simpleMessage("Forward"),
    "friend": MessageLookupByLibrary.simpleMessage("Friend"),
    "friendIs": MessageLookupByLibrary.simpleMessage("Friend is"),
    "friendScanQrCode": m8,
    "friends": MessageLookupByLibrary.simpleMessage("Friends"),
    "friendswillmissyou": MessageLookupByLibrary.simpleMessage(
      "Please support the exact presentation of BladeNight skater procession.\nYour friends will miss you!",
    ),
    "from": MessageLookupByLibrary.simpleMessage("by"),
    "geoFencing": MessageLookupByLibrary.simpleMessage("Allow geofencing"),
    "geoFencingTitle": MessageLookupByLibrary.simpleMessage(
      "Bladeguard on site – allow via geofencing. If you are within the radius of the starting point, you will automatically be logged in as BladeGuard digital (Beta)",
    ),
    "getwebdata": MessageLookupByLibrary.simpleMessage(
      "Loading data from server ...",
    ),
    "head": MessageLookupByLibrary.simpleMessage("Head"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "iAmBladeGuard": MessageLookupByLibrary.simpleMessage(
      "I am already a Bladeguard",
    ),
    "iAmBladeGuardTitle": m9,
    "iam": MessageLookupByLibrary.simpleMessage("I am"),
    "ignoreBatteriesOptimisation": MessageLookupByLibrary.simpleMessage(
      "Note - some manufacturers switch off the apps due to unfavorable battery optimization or close the app. If so, please try disabling battery optimization for the app. Set to No restrictions.",
    ),
    "ignoreBatteriesOptimisationTitle": MessageLookupByLibrary.simpleMessage(
      "Change Battery Optimizations",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importWarning": MessageLookupByLibrary.simpleMessage(
      "Attention this overwrites all friends and the ID. Export data beforehand! Be careful, delete the app on the device from which it was exported!",
    ),
    "importWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Import friends and ID.",
    ),
    "inprogress": MessageLookupByLibrary.simpleMessage(
      "not implemented. We are working ...",
    ),
    "internalerror_invalidcode": MessageLookupByLibrary.simpleMessage(
      "Invalid Code",
    ),
    "internalerror_seemslinked": MessageLookupByLibrary.simpleMessage(
      "Error - Is friend linked?",
    ),
    "invalidEMail": MessageLookupByLibrary.simpleMessage("Email not found"),
    "invalidLoginData": MessageLookupByLibrary.simpleMessage(
      "Email not found or wrong birthday",
    ),
    "invalidcode": MessageLookupByLibrary.simpleMessage("invalid code"),
    "invitebyname": m10,
    "invitenewfriend": MessageLookupByLibrary.simpleMessage("Invite friend"),
    "isIgnoring": MessageLookupByLibrary.simpleMessage("Is ignored"),
    "ist": MessageLookupByLibrary.simpleMessage("is"),
    "isuseractive": MessageLookupByLibrary.simpleMessage("Show in map"),
    "lastseen": MessageLookupByLibrary.simpleMessage("Last seen"),
    "lastupdate": MessageLookupByLibrary.simpleMessage("Last update"),
    "later": MessageLookupByLibrary.simpleMessage("Later"),
    "lead": MessageLookupByLibrary.simpleMessage("Procession start/end"),
    "leadspec": MessageLookupByLibrary.simpleMessage("Procession + Special"),
    "leaveAppWarning": m11,
    "leaveAppWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Open an external browser?",
    ),
    "leavewheninuse": MessageLookupByLibrary.simpleMessage("Leave settings"),
    "length": MessageLookupByLibrary.simpleMessage("Length"),
    "linkAsBrowserDevice": m12,
    "linkNearBy": MessageLookupByLibrary.simpleMessage("Accept friend nearby"),
    "linkOnOtherDevice": m13,
    "linkingFailed": MessageLookupByLibrary.simpleMessage("Linking failed"),
    "linkingSuccessful": MessageLookupByLibrary.simpleMessage(
      "Linking successful",
    ),
    "liveMapInBrowser": MessageLookupByLibrary.simpleMessage(
      "Follow BladeNight procession without app",
    ),
    "liveMapInBrowserInfoHeader": MessageLookupByLibrary.simpleMessage(
      "Live map in browser",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading ..."),
    "locationServiceOff": MessageLookupByLibrary.simpleMessage(
      "Location is turned off in settings. Location sharing not possible. Press Play ▶️ or go to OS-Settings.",
    ),
    "locationServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Location sharing was started and is active.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("login"),
    "loginThreeHoursBefore": MessageLookupByLibrary.simpleMessage(
      "You can sign up as a Bladeguard for tonight’s BladeNight when you are already registered as a Bladeguard, you are near the starting point, and it’s less than 3 hours before the start.",
    ),
    "manufacturer": MessageLookupByLibrary.simpleMessage("Manufacturer"),
    "map": MessageLookupByLibrary.simpleMessage("Map"),
    "mapAlign": MessageLookupByLibrary.simpleMessage("Map alignment"),
    "mapFollow": MessageLookupByLibrary.simpleMessage("Following on map"),
    "mapFollowLocation": MessageLookupByLibrary.simpleMessage(
      "Map follows my position",
    ),
    "mapFollowStopped": MessageLookupByLibrary.simpleMessage(
      "Map follows me stopped!",
    ),
    "mapFollowTrain": MessageLookupByLibrary.simpleMessage(
      "Map follows procession head position.",
    ),
    "mapFollowTrainStopped": MessageLookupByLibrary.simpleMessage(
      "Map follows procession head stopped.",
    ),
    "mapToStartNoFollowing": MessageLookupByLibrary.simpleMessage(
      "Move map to start, no following",
    ),
    "markMeAsHead": MessageLookupByLibrary.simpleMessage(
      "Mark me as head of procession",
    ),
    "markMeAsTail": MessageLookupByLibrary.simpleMessage(
      "Mark me as tail of procession",
    ),
    "me": MessageLookupByLibrary.simpleMessage("Me"),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "metersOnRoute": MessageLookupByLibrary.simpleMessage("Driven route"),
    "missingName": MessageLookupByLibrary.simpleMessage(
      "Field must contain at least 1 character",
    ),
    "model": MessageLookupByLibrary.simpleMessage("Model"),
    "mustNearbyStartingPoint": m14,
    "mustentername": MessageLookupByLibrary.simpleMessage(
      "You must enter a name!",
    ),
    "myName": MessageLookupByLibrary.simpleMessage("My name is"),
    "myNameHeader": MessageLookupByLibrary.simpleMessage(
      "The specified name is transferred to the 2nd device when you connect to your friend. The name is only saved locally and is used for simplified linking via the local connection.",
    ),
    "mySpeed": MessageLookupByLibrary.simpleMessage("My speed on track"),
    "nameexists": MessageLookupByLibrary.simpleMessage("Sorry, name exists"),
    "networkerror": MessageLookupByLibrary.simpleMessage(
      "Network error! No data!",
    ),
    "never": MessageLookupByLibrary.simpleMessage("never"),
    "newGPSDatareceived": MessageLookupByLibrary.simpleMessage(
      "New GPS data received",
    ),
    "nextEvent": MessageLookupByLibrary.simpleMessage("Next BladeNight"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noBackgroundlocationLeaveAppOpen": MessageLookupByLibrary.simpleMessage(
      "Location \'When in use\' is selected. Warning, there is no background update enabled. Your position data to show exact Bladnight train and share your position with your friends is only possible when the app is open in foreground. Please confirm it or change your settings to \'Allow all time\'.\nFurthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location sharing when your device is detected as stationary. Therefore please activate this function.",
    ),
    "noBackgroundlocationTitle": MessageLookupByLibrary.simpleMessage(
      "No background update possible.",
    ),
    "noChoiceNoAction": MessageLookupByLibrary.simpleMessage(
      "No choice, no action",
    ),
    "noEvent": MessageLookupByLibrary.simpleMessage("Nothing planned"),
    "noEventPlanned": MessageLookupByLibrary.simpleMessage(
      "There are currently no further events planned",
    ),
    "noEventStarted": MessageLookupByLibrary.simpleMessage("No Event"),
    "noEventStartedAutoStop": MessageLookupByLibrary.simpleMessage(
      "No Event - Autostop",
    ),
    "noEventTimeOut": m15,
    "noGpsAllowed": MessageLookupByLibrary.simpleMessage("GPS not active"),
    "noLocationAvailable": MessageLookupByLibrary.simpleMessage(
      "No location known",
    ),
    "noLocationPermissionGrantedAlertAndroid":
        MessageLookupByLibrary.simpleMessage(
          "Please check location-permissions in Settings.",
        ),
    "noLocationPermissionGrantedAlertTitle":
        MessageLookupByLibrary.simpleMessage("Info no location permissions"),
    "noLocationPermissionGrantedAlertiOS": MessageLookupByLibrary.simpleMessage(
      "Please check location-permissions in iOS Settings. Look at Privacy - Location - BladnightApp. Set it to always or when in use!",
    ),
    "noLocationPermitted": MessageLookupByLibrary.simpleMessage(
      "No location permission, please check device settings",
    ),
    "noNearbyService": MessageLookupByLibrary.simpleMessage(
      "Nearby service not activated",
    ),
    "noSelfRelationAllowed": MessageLookupByLibrary.simpleMessage(
      "Relationship with self is not allowed",
    ),
    "noValidPendingRelationShip": MessageLookupByLibrary.simpleMessage(
      "Not a valid pending relationship id",
    ),
    "nodatareceived": MessageLookupByLibrary.simpleMessage(
      "No Data received !",
    ),
    "nogps": MessageLookupByLibrary.simpleMessage("No GPS"),
    "nogpsenabled": MessageLookupByLibrary.simpleMessage(
      "Sorry, no GPS in device found or denied. Please check your privacy and location settings.",
    ),
    "notAvailable": MessageLookupByLibrary.simpleMessage("not available"),
    "notKnownOnServer": MessageLookupByLibrary.simpleMessage(
      "Obsolete! Delete it!",
    ),
    "notOnRoute": MessageLookupByLibrary.simpleMessage("Not on route!"),
    "notVisibleOnMap": MessageLookupByLibrary.simpleMessage(
      "Not visible on map!",
    ),
    "note_bladenightCanceled": MessageLookupByLibrary.simpleMessage(
      "The BladeNight was canceled.",
    ),
    "note_bladenightStartInFiveMinutesStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "Next BladeNight will start in 5 minutes. Don\'t forget to turn location sharing on !",
        ),
    "note_bladenightStartInSixHoursStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "Next BladeNight will start in 6 hours.",
        ),
    "note_statuschanged": MessageLookupByLibrary.simpleMessage(
      "BladeNight Status was changed - Please check in app",
    ),
    "notification": MessageLookupByLibrary.simpleMessage("Notification"),
    "notracking": MessageLookupByLibrary.simpleMessage("No location sharing!"),
    "now": MessageLookupByLibrary.simpleMessage("Now"),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on": MessageLookupByLibrary.simpleMessage("at"),
    "onRoute": MessageLookupByLibrary.simpleMessage("on route"),
    "oneSignalId": MessageLookupByLibrary.simpleMessage("OneSignal-Id: "),
    "oneSignalIdTitle": MessageLookupByLibrary.simpleMessage(
      "This is the assigned Id for receiving push messages. Let us know the ID if you have problems receiving push messages.",
    ),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "onlyReducedLocationAccuracyText": MessageLookupByLibrary.simpleMessage(
      "Only approximate location is shared. This may influence the tracking of your position in procession",
    ),
    "onlyReducedLocationAccuracyTitle": MessageLookupByLibrary.simpleMessage(
      "Only approximate location",
    ),
    "onlyTracking": MessageLookupByLibrary.simpleMessage(
      "Location record only active",
    ),
    "onlyWhenInUseEnabled": MessageLookupByLibrary.simpleMessage(
      "Location only \'Allow only while using the app\' set.",
    ),
    "onlyWhileInUse": MessageLookupByLibrary.simpleMessage(
      "GPS WhileInUse - app works only in foreground. Please change Operating Systems settings",
    ),
    "openOperatingSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Open operating system settings",
    ),
    "openStreetMap": MessageLookupByLibrary.simpleMessage(
      "load Openstreetmap  / App restart necessary",
    ),
    "openStreetMapText": MessageLookupByLibrary.simpleMessage(
      "Use Openstreetmap",
    ),
    "own": MessageLookupByLibrary.simpleMessage("Own"),
    "participant": MessageLookupByLibrary.simpleMessage("Participant"),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Mobile"),
    "pickcolor": MessageLookupByLibrary.simpleMessage("Pick a color."),
    "polyLinesAmount": MessageLookupByLibrary.simpleMessage(
      "To increase rendering speed on slow devices you can increase/decrease the amount of drawn polylines (routepoints) on map before simplifying.",
    ),
    "polyLinesAmountHeader": MessageLookupByLibrary.simpleMessage("Amount"),
    "position": MessageLookupByLibrary.simpleMessage("Position"),
    "positiveInFront": MessageLookupByLibrary.simpleMessage(
      "Positive if in front, negative if behind me.",
    ),
    "proceed": MessageLookupByLibrary.simpleMessage("Proceed"),
    "prominentdisclosuretrackingprealertandroidFromAndroid_V11":
        MessageLookupByLibrary.simpleMessage(
          "The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step. You should select \'While using the App\'. Later we will ask you again, prefered is \'Allow all time\'. When you select \'When in use\' you must let open the BladeNight on screen in forground, to share your location. If you deny locationaccess, only the BladeNight procession can be watched without location sharing.  So you can use other Apps in foreground.Furthermore, access to the motion activity detection (physical activity) is desirable. This increases battery efficiency by intelligently turning off location sharing when your device is detected as stationary. Therefore please activate this function.\nThe request is parted in 2 Steps.\nPlease support the accuracy of the train. Thank you so much.",
        ),
    "prominentdisclosuretrackingprealertandroidToAndroid_V10x":
        MessageLookupByLibrary.simpleMessage(
          "The BladeNight application needs your location data to display the BladeNight procession and to share your position with your friends, while using the app. Please accept the location permission in the next step.You should select \'While using the App\'. If you deny locationaccess, only the BladeNight skater procession can be watched without location sharing. Please support the accuracy of the train",
        ),
    "pushMessageParticipateAsBladeGuard": MessageLookupByLibrary.simpleMessage(
      "Participate push req.",
    ),
    "pushMessageParticipateAsBladeGuardTitle":
        MessageLookupByLibrary.simpleMessage(
          "Bladeguard-participate via push-message?",
        ),
    "pushMessageSkateMunichInfos": MessageLookupByLibrary.simpleMessage(
      "Get Skatemunich Infos",
    ),
    "pushMessageSkateMunichInfosTitle": MessageLookupByLibrary.simpleMessage(
      "Receive SkateMunich infos via push message about events?",
    ),
    "qrcoderouteinfoheader": MessageLookupByLibrary.simpleMessage(
      "QRCode to show event info without app in browser",
    ),
    "readMessage": MessageLookupByLibrary.simpleMessage("Read"),
    "receiveBladeGuardInfos": MessageLookupByLibrary.simpleMessage(
      "Receive Bladeguard Infos",
    ),
    "received": MessageLookupByLibrary.simpleMessage("received"),
    "refresh": MessageLookupByLibrary.simpleMessage("Update"),
    "refreshHeader": MessageLookupByLibrary.simpleMessage("Update data"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registeredAs": MessageLookupByLibrary.simpleMessage("Registered as:"),
    "reload": MessageLookupByLibrary.simpleMessage("Reload"),
    "reltime": MessageLookupByLibrary.simpleMessage("rel. timediff."),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "requestAlwaysPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Location always permissions",
    ),
    "requestLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Information why location sharing would be necessary.",
    ),
    "requestOffSite": MessageLookupByLibrary.simpleMessage(
      "You really want to unregister as a Bladeguard today. We need everyone. Think again.",
    ),
    "requestOffSiteTitle": MessageLookupByLibrary.simpleMessage(
      "No Bladeguard today?",
    ),
    "resetInSettings": MessageLookupByLibrary.simpleMessage(
      "Reset in settings-page",
    ),
    "resetLongPress": MessageLookupByLibrary.simpleMessage(
      "Press gauge long to reset the ODO meter",
    ),
    "resetOdoMeter": MessageLookupByLibrary.simpleMessage(
      "Reset ODO meter to 0 and clear driven route?",
    ),
    "resetOdoMeterTitle": MessageLookupByLibrary.simpleMessage(
      "ODO meter reset and driven route",
    ),
    "resetTrackPointsStore": MessageLookupByLibrary.simpleMessage("Clear all"),
    "resetTrackPointsStoreTitle": MessageLookupByLibrary.simpleMessage(
      "Clear location-store for all tracked events.",
    ),
    "restartRequired": MessageLookupByLibrary.simpleMessage(
      "Restart required! Please close app and reopen !!!",
    ),
    "route": MessageLookupByLibrary.simpleMessage("Route"),
    "routeoverview": MessageLookupByLibrary.simpleMessage("Route overview"),
    "running": MessageLookupByLibrary.simpleMessage("We are on route"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "scrollMapTo": MessageLookupByLibrary.simpleMessage("Scroll map to ..."),
    "searchNearby": MessageLookupByLibrary.simpleMessage(
      "Searching nearby devices",
    ),
    "seemsoffline": MessageLookupByLibrary.simpleMessage(
      " Waiting for internet connection ...",
    ),
    "selectDate": MessageLookupByLibrary.simpleMessage("Select event date"),
    "selectTrackingType": MessageLookupByLibrary.simpleMessage(
      "Select tracking type",
    ),
    "sendData30sec": MessageLookupByLibrary.simpleMessage(
      "Request sent - change need about 30 secs.",
    ),
    "sendMail": MessageLookupByLibrary.simpleMessage("Send email to support"),
    "sendlink": MessageLookupByLibrary.simpleMessage("Send link"),
    "sendlinkdescription": m16,
    "sendlinksubject": MessageLookupByLibrary.simpleMessage(
      "Send link to BladeNight-App. You can see each other.",
    ),
    "serverConnected": MessageLookupByLibrary.simpleMessage("Server connected"),
    "serverNotReachable": MessageLookupByLibrary.simpleMessage(
      "Connecting to server ...",
    ),
    "serverVersion": MessageLookupByLibrary.simpleMessage("Server version"),
    "sessionConnectionError": MessageLookupByLibrary.simpleMessage(
      "Error negotiate session connection",
    ),
    "setClearLogs": MessageLookupByLibrary.simpleMessage("Clear log data"),
    "setDarkMode": MessageLookupByLibrary.simpleMessage("Activate Dark Mode"),
    "setDarkModeTitle": MessageLookupByLibrary.simpleMessage(
      "Switch between light- and dark-mode independent of OS-setting.",
    ),
    "setExportLogSupport": MessageLookupByLibrary.simpleMessage(
      "Export Log data to support",
    ),
    "setIconSize": MessageLookupByLibrary.simpleMessage("Icon size: "),
    "setIconSizeTitle": MessageLookupByLibrary.simpleMessage(
      "Set size of me, friend and procession icons on the map",
    ),
    "setInsertImportDataset": MessageLookupByLibrary.simpleMessage(
      "Insert dataset incl. bna:",
    ),
    "setLogData": MessageLookupByLibrary.simpleMessage("Data logger"),
    "setLogLevel": MessageLookupByLibrary.simpleMessage("Set log level"),
    "setMeColor": MessageLookupByLibrary.simpleMessage("Own Color on Map"),
    "setOpenSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Open Operatingsystem settings",
    ),
    "setPrimaryColor": MessageLookupByLibrary.simpleMessage(
      "Set primary (light) color (default yellow)",
    ),
    "setPrimaryDarkColor": MessageLookupByLibrary.simpleMessage(
      "Set primary Dark-mode color (default yellow)",
    ),
    "setRoute": MessageLookupByLibrary.simpleMessage("Set Route"),
    "setStartImport": MessageLookupByLibrary.simpleMessage(
      "Start import Id und friends",
    ),
    "setState": MessageLookupByLibrary.simpleMessage("Set Status"),
    "setSystem": MessageLookupByLibrary.simpleMessage("System"),
    "setTeam": MessageLookupByLibrary.simpleMessage("Choose your team!"),
    "setcolor": MessageLookupByLibrary.simpleMessage("Change color"),
    "setexportDataHeader": MessageLookupByLibrary.simpleMessage("Export"),
    "setexportIdAndFriends": MessageLookupByLibrary.simpleMessage(
      "Export Id and friends",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "showCompass": MessageLookupByLibrary.simpleMessage("Show compass"),
    "showCompassTitle": MessageLookupByLibrary.simpleMessage(
      "Show compass on map",
    ),
    "showFullProcession": MessageLookupByLibrary.simpleMessage(
      "Show procession participants",
    ),
    "showFullProcessionTitle": MessageLookupByLibrary.simpleMessage(
      "Show procession participants (limited to 100 in procession) on map. Works only when your location is shared.",
    ),
    "showLogData": MessageLookupByLibrary.simpleMessage("Show log data"),
    "showOwnColoredTrack": MessageLookupByLibrary.simpleMessage(
      "Colorize my track",
    ),
    "showOwnTrack": MessageLookupByLibrary.simpleMessage(
      "Your own journey can be recorded and displayed. The coloured route also shows the speed, but depending on the device, this can lead to jerking when zooming etc.",
    ),
    "showOwnTrackSwitchTitle": MessageLookupByLibrary.simpleMessage(
      "Show track points",
    ),
    "showProcession": MessageLookupByLibrary.simpleMessage(
      "Showing actual procession of Münchener BladeNight",
    ),
    "showWeblinkToRoute": MessageLookupByLibrary.simpleMessage(
      "Show weblink to route",
    ),
    "showonly": MessageLookupByLibrary.simpleMessage("Show only"),
    "since": MessageLookupByLibrary.simpleMessage("since"),
    "someSettingsNotAvailableBecauseOffline": MessageLookupByLibrary.simpleMessage(
      "Some settings are not available because there is no internet connection",
    ),
    "spec": MessageLookupByLibrary.simpleMessage("Special"),
    "specialfunction": MessageLookupByLibrary.simpleMessage(
      "Special functions - change only when you know what you do!",
    ),
    "speed": MessageLookupByLibrary.simpleMessage("Speed"),
    "sponsors": MessageLookupByLibrary.simpleMessage("Our sponsors"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Start location without participating",
    ),
    "startLocationWithoutParticipatingInfo": MessageLookupByLibrary.simpleMessage(
      "Please read carefully.\nThis starts the location display on the map without participating in the train and transfers your location to the server to calculate the times. Your friends on the train will be displayed. The time to the beginning / end of the train from your location will be calculated. Furthermore, your speed and location data will be recorded which you can save. Please do not use this function if you participate in the BladeNight. The mode must be ended manually.\nDo you want to start this?",
    ),
    "startParticipation": MessageLookupByLibrary.simpleMessage(
      "Start participation",
    ),
    "startParticipationHeader": MessageLookupByLibrary.simpleMessage(
      "You are participating on the BladeNight today and would like to support the presentation of the procession and share your location with friends. Start location sharing?",
    ),
    "startParticipationShort": MessageLookupByLibrary.simpleMessage(
      "Start participation",
    ),
    "startParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Start participation",
    ),
    "startPoint": MessageLookupByLibrary.simpleMessage(
      "Start:\nMünchen - Bavariapark",
    ),
    "startPointTitle": MessageLookupByLibrary.simpleMessage(
      "Where is the start?",
    ),
    "startTime": MessageLookupByLibrary.simpleMessage("Start time"),
    "startTrackingOnly": MessageLookupByLibrary.simpleMessage(
      "Start route recording",
    ),
    "startTrackingOnlyTitle": MessageLookupByLibrary.simpleMessage(
      "Start location recording without sending data to server.",
    ),
    "startsIn": MessageLookupByLibrary.simpleMessage("Starts in"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "status_active": MessageLookupByLibrary.simpleMessage("active"),
    "status_inactive": MessageLookupByLibrary.simpleMessage("inactive"),
    "status_obsolete": MessageLookupByLibrary.simpleMessage("obsolete"),
    "status_pending": MessageLookupByLibrary.simpleMessage("pending"),
    "stopLocationTracking": MessageLookupByLibrary.simpleMessage(
      "Stop location sharing?",
    ),
    "stopLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Stop location sharing without participating",
    ),
    "stopParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Stop participation location sharing",
    ),
    "stopTrackingTimeOut": m17,
    "submit": MessageLookupByLibrary.simpleMessage("Senden"),
    "symbols": MessageLookupByLibrary.simpleMessage("Symbols"),
    "tail": MessageLookupByLibrary.simpleMessage("Tail"),
    "tellcode": m18,
    "thanksForParticipating": MessageLookupByLibrary.simpleMessage(
      "Thank you for participating.",
    ),
    "timeIntl": m19,
    "timeOutDurationExceedTitle": MessageLookupByLibrary.simpleMessage(
      "Timeout - duration of BladeNight exceed",
    ),
    "timeStamp": MessageLookupByLibrary.simpleMessage("Timestamp"),
    "timeToFinish": MessageLookupByLibrary.simpleMessage("to finish (est.)"),
    "timeToFriend": MessageLookupByLibrary.simpleMessage("Time to friend"),
    "timeToHead": MessageLookupByLibrary.simpleMessage("Time to head (est.)"),
    "timeToMe": MessageLookupByLibrary.simpleMessage("Time to me (est.)"),
    "timeToTail": MessageLookupByLibrary.simpleMessage("Time to tail (est.)"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todayNo": MessageLookupByLibrary.simpleMessage("No today"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
    "trackPointsExporting": MessageLookupByLibrary.simpleMessage(
      "The following route points will be exported: ",
    ),
    "trackers": MessageLookupByLibrary.simpleMessage("Tracker"),
    "tracking": MessageLookupByLibrary.simpleMessage("data ok"),
    "trackingPoints": MessageLookupByLibrary.simpleMessage(
      "Recorded route points",
    ),
    "trackingRestarted": MessageLookupByLibrary.simpleMessage(
      "Location sharing restartet",
    ),
    "trackingStoppedLowBat": m20,
    "train": MessageLookupByLibrary.simpleMessage("Train"),
    "trainlength": MessageLookupByLibrary.simpleMessage("Trainlength"),
    "tryOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "This can only be changed in the system settings! Try opening system settings?",
    ),
    "understand": MessageLookupByLibrary.simpleMessage("Understood"),
    "unknown": MessageLookupByLibrary.simpleMessage("unknown"),
    "unknownerror": MessageLookupByLibrary.simpleMessage("unknown error"),
    "unreadMessage": MessageLookupByLibrary.simpleMessage("Unread"),
    "updatePhone": MessageLookupByLibrary.simpleMessage("Update Phone"),
    "updating": MessageLookupByLibrary.simpleMessage("Updating data"),
    "userSpeed": MessageLookupByLibrary.simpleMessage("This is my GPS-speed."),
    "validatefriend": MessageLookupByLibrary.simpleMessage("Validate friend"),
    "version": MessageLookupByLibrary.simpleMessage("Version:"),
    "visibleOnMap": MessageLookupByLibrary.simpleMessage("Shown on map."),
    "waiting": MessageLookupByLibrary.simpleMessage("Waiting..."),
    "waittime": MessageLookupByLibrary.simpleMessage("Waiting"),
    "wakelockDisabled": MessageLookupByLibrary.simpleMessage(
      "Display switches off",
    ),
    "wakelockEnabled": MessageLookupByLibrary.simpleMessage(
      "Display remains an",
    ),
    "wakelockWarnBattery": m21,
    "warning": MessageLookupByLibrary.simpleMessage("Warning!"),
    "wasCanceledPleaseCheck": MessageLookupByLibrary.simpleMessage(
      "is canceled! Please check this on https://bladenight-muenchen.de",
    ),
    "weekdayIntl": m22,
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yesterday": MessageLookupByLibrary.simpleMessage("was yesterday"),
  };
}
