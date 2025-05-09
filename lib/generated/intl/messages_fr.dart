// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(batteryLevel) =>
      "Le suivi s\'est interrompu en raison d\'un faible niveau de batterie ${batteryLevel} %";

  static String m1(bladeguardRegisterlink, bladeguardPrivacyLink) =>
      "<h2>Exigences et règles :</h2><ul><li>Vous avez au moins 16 ans.</li><li>Vous êtes à l\'aise avec les rollers en ligne et savez freiner.</li ><li>Vous connaissez le code de la route </li><li>Vous êtes serviable, sympathique et avez l\'esprit d\'équipe </li><li>Vous participez à notre formation gratuite avant votre premier voyage.</li> </ul ><p>En tant que Bladeguard, il n\'y a aucun frais pour vous. Vous pouvez vous désinscrire à tout moment. <h3>Ici, vous pouvez accéder à <a href=\"${bladeguardRegisterlink}\">Inscription en ligne</a> et <a href=\"${bladeguardPrivacyLink}\">Protection des données</a></p></h3>";

  static String m2(date) => "${date}";

  static String m3(date, time) => "${date} à ${time}";

  static String m4(date, time) => "${date} ${time}";

  static String m5(date, time) => "${date} à ${time} ${date} ${time}Uhr";

  static String m6(name) =>
      "Supprimer le lien avec ${name}. Pas de restauration possible";

  static String m7(name) => "Modifier le nom et la couleur de ${name}";

  static String m8(timeout) =>
      "Le suivi de l\'emplacement après ${timeout} min de BladeNight s\'est arrêté automatiquement. (Appuyez longuement sur ▶️ pour désactiver l\'arrêt automatique du suivi)";

  static String m9(code) =>
      "Votre ami peut-il également scanner le code-barres ci-dessous ou saisir manuellement le code ${code} dans son application";

  static String m10(bladeguardPrivacyLink) =>
      "Nous avons besoin du soutien de bénévoles. En tant que Bladeguard, vous soutenez activement BladeNight. Les <a href=\"${bladeguardPrivacyLink}\">Règlements de Munich BladeNight sur la protection des données</a></p> s\'appliquent";

  static String m11(name) => "inviter ${name}";

  static String m12(linkDescription, link) =>
      "Vous êtes prêt à utiliser votre navigateur Internet. Bien que cette application soit disponible, lorsque vous êtes prêt à le faire. L\'application est disponible dans l\'arrière-plan plus loin. \n\n${linkDescription} (${link})";

  static String m13(deviceName) =>
      "<h2>Information importante !</h2><ul><li>Votre ami doit utiliser le même type de téléphone. Apple vers Android ne fonctionne pas. Dans ce cas, utilisez le couplage de codes.</li><li> Votre ami doit se trouver à une distance maximale de 2 m de vous !</li><li>Veuillez ouvrir l\'onglet Amis de votre ami dans l\'application BladeNight.</li><li>Sélectionnez Plus ! en haut à droite<span class=\"icon\">plus</span></li><li>Sélectionnez Ajouter un ami à côté de vous</li><li>Maintenant avec cet appareil <b><em>${deviceName} </em></b> Associer.</li><li>Vous pouvez également scanner le code-barres de votre ami avec l\'appareil photo ou utiliser la connexion avec l\'option Ajouter un ami avec code </li></ul>Vous pouvez entrer votre changement de nom transmis dans le champ de texte. Ceci est uniquement pour le transfert via une connexion directe.";

  static String m14(deviceName, code) =>
      "<h2>Information importante !</h2><ul><li>Votre ami doit utiliser le même type de téléphone. Apple vers Android ne fonctionne pas. Dans ce cas, utilisez le couplage de codes.</li><li> Votre ami doit se trouver à une distance maximale de 2 m de vous !</li><li>Veuillez ouvrir l\'onglet Amis de votre ami dans l\'application BladeNight.</li><li>Sélectionnez Plus ! en haut à droite<span class=\"icon\">plus</span></li><li>Choisissez d\'accepter un ami à côté de vous</li><li>Maintenant avec cet appareil <b><em>${deviceName}</em></b> paire.</li><li>Alternativement, votre ami peut scanner le code-barres avec l\'appareil photo ou vous connecter avec le <br>code <b>${code}</b>< /li></ul>Vous pouvez modifier votre nom soumis dans le champ de texte. Ceci est uniquement pour le transfert via connexion directe/scan.";

  static String m15(distInMeter) =>
      "Il faut que dans le voisinage des points de démarrage, il y ait moins de min. ${distInMeter} m entfernt. Vous avez le temps de vous informer de votre équipe.";

  static String m16(timeout) =>
      "Aucun événement n\'est actif depuis plus de ${timeout} min - le suivi s\'est arrêté automatiquement";

  static String m17(friendName, myName, code) =>
      "Votre ami (${friendName}) peut également prendre une photo de ce code-barres et ajouter le nom ${myName} et ${code} à BladeNightApp si l\'application est installée.";

  static String m18(
    requestId,
    bnaLink,
    myName,
    playStoreLink,
    iosAppStoreLink,
  ) =>
      "Hi, this is my invitation to share your skating position in BladeNight App, and find me. Si vous aimez cela, obtenez l\'application BladeNight sur l\'AppStore et entrez le code : ${requestId} dans Amis après avoir appuyé sur + ajouter un ami par code.\nLorsque l\'application BladeNight est installée, utilisez le lien suivant: ${bnaLink} sur votre mobile. \nAmusez-vous et nous trouverons ensemble.\nL\'application BladeNight est disponible sur Playstore \n${playStoreLink} et sur Apple App Store \n${iosAppStoreLink}";

  static String m19(timeout) =>
      "L\'événement s\'est terminé (${timeout} min). N\'oubliez pas d\'arrêter le suivi";

  static String m20(name, requestid) =>
      "Veuillez indiquer ce code à \'${name}\' \n${requestid}\nIl/elle doit le confirmer dans son \'BladeNight-App\'.\nLe code n\'est valable que 60 minutes ! \nVeuillez mettre à jour le statut manuellement avec le bouton ↻.";

  static String m21(time) => "${time}";

  static String m22(level) =>
      "Le suivi s\'est arrêté en raison d\'une batterie faible ${level}%. Pour éviter cela, désactivez l\'arrêt automatique dans les paramètres";

  static String m23(level) =>
      "Affichage activé par les paramètres de l\'application - Avertissement, batterie faible ${level} %";

  static String m24(date) => "${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "OneSignalId": MessageLookupByLibrary.simpleMessage("Push-Message-Id"),
    "about_appinfo": MessageLookupByLibrary.simpleMessage(
      "L\'application est fournie gratuitement par l\'éditeur exclusivement pour Munich BladeNight et Skatemunich e.V. et ses sponsors.\nL\'application offre à tous les participants de BladeNight les fonctions suivantes :\n\t-Aperçu des dates à venir et passées\n- Affichage des itinéraires sur la carte\n- Affichage en direct du train pendant BladeNight\n- Affichage en direct de votre propre position sur l\'itinéraire et dans le train\n- Ajoutez des amis et suivez-les en direct",
    ),
    "about_appprivacy": MessageLookupByLibrary.simpleMessage(
      "Cette application utilise un identifiant unique qui est enregistré localement lors du premier démarrage de l\'application.\nCet identifiant est utilisé sur le serveur pour lier des amis et partager la position. Il est uniquement transféré entre votre propre application et votre serveur. \nLe numéro de version de l\'application et le fabricant du téléphone (Apple ou Android) sont également transmis pour vérifier la bonne communication.\nL\'ID est stocké sur le serveur avec les amis liés.\nLa suppression et la réinstallation de l\'application supprime l\'ID et les amis doivent être à nouveau liés. \nLe les données ne seront pas transmises à des tiers ni utilisées de quelque autre manière.\nVos données de localisation seront utilisées pendant l\'événement pour calculer et afficher le début et la fin du train sur l\'itinéraire et pour calculer la distance par rapport aux amis et au destination.\nAucune donnée personnelle n\'est collectée. Les noms des amis ne sont stockés que localement dans l\'application.\nL\'utilisation de l\'application, de la fonction e-mail, des fonctions Bladeguard et du site Web https://bladenight-muenchen.de est soumise à la protection des données. règlements de Skatemunich e.V.\n Ceux-ci peuvent être consultés sur https://bladenight-muenchen.de/datenschutzerklaerung. Les données personnelles sont collectées et traitées exclusivement dans le but d\'organiser la Munich BladeNight. Si vous avez des questions, veuillez utiliser le formulaire de contact,",
    ),
    "about_bnapp": MessageLookupByLibrary.simpleMessage(
      "A propos de l\'application BladeNight",
    ),
    "about_crashlytics": MessageLookupByLibrary.simpleMessage(
      "Pour améliorer la stabilité et la fiabilité de cette application, nous nous appuyons sur des rapports de crash anonymes. Pour ce faire, nous utilisons Firebase Crashlytics, un service de Google Ireland Ltd, Google Building Gordon House, Barrow Street, Dublin 4, Irlande. En cas de panne, des informations anonymes sont envoyées aux serveurs de Google aux États-Unis (état de l\'application au moment de la panne, UUID d\'installation, trace de la panne, fabricant du téléphone portable et système d\'exploitation, derniers messages du journal). Ces informations ne contiennent aucune donnée personnelle. Les rapports de crash ne sont envoyés qu\'avec votre consentement explicite. Lorsque vous utilisez des applications iOS, vous pouvez donner votre consentement dans les paramètres de l\'application ou après un crash. Pour les applications Android, lors de la configuration de l\'appareil mobile, vous avez la possibilité de donner votre accord général à la transmission des notifications de crash à Google et au développeur de l\'application.\nLa base juridique de la transmission des données est l\'article 6, paragraphe 1, point a), du règlement GDPR.\nVous pouvez révoquer votre consentement à tout moment en désactivant la fonction rapports de crash dans les paramètres des applications iOS (dans les applications magazines, l\'entrée se trouve dans l\'élément de menu \'Communication\'). Pour ce faire, ouvrez l\'application Paramètres, sélectionnez \'Google\' et, dans le menu à trois points en haut à droite, l\'élément de menu \'Utilisation & Diagnostics\'. Vous pouvez y désactiver l\'envoi des données correspondantes. Pour plus d\'informations, consultez l\'aide de votre compte Google.\nPlus d\'informations sur la protection des données sont disponibles dans les informations sur la protection des données de Firebase Crashlytics à l\'adresse https://firebase.google.com/support/privacy et https://docs.fabric.io/apple/fabric/data-privacy.html#data-collection-policies",
    ),
    "about_feedback": MessageLookupByLibrary.simpleMessage(
      "Vos commentaires sont les bienvenus.\nEnvoyez-nous un courriel:\nnservice@skatemunich.de",
    ),
    "about_h_androidapplicationflutter": MessageLookupByLibrary.simpleMessage(
      "BladeNight-App iOS/Android (2022)",
    ),
    "about_h_androidapplicationflutter_23":
        MessageLookupByLibrary.simpleMessage(
          "BladeNight-App iOS/Android (2023-2025)",
        ),
    "about_h_androidapplicationv1": MessageLookupByLibrary.simpleMessage(
      "Application Android V1 (2013)",
    ),
    "about_h_androidapplicationv2": MessageLookupByLibrary.simpleMessage(
      "Android App V2 (2014-2022)",
    ),
    "about_h_androidapplicationv3": MessageLookupByLibrary.simpleMessage(
      "Android App V3 (2023-2025)",
    ),
    "about_h_bnapp": MessageLookupByLibrary.simpleMessage(
      "À quoi sert l\'application",
    ),
    "about_h_crashlytics": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics privacy",
    ),
    "about_h_feedback": MessageLookupByLibrary.simpleMessage(
      "Retour d\'information à propos de BladeNight",
    ),
    "about_h_homepage": MessageLookupByLibrary.simpleMessage("Page d\'accueil"),
    "about_h_impressum": MessageLookupByLibrary.simpleMessage(
      "Mentions légales",
    ),
    "about_h_licences": MessageLookupByLibrary.simpleMessage("Licence"),
    "about_h_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
      "OneSignal privacy",
    ),
    "about_h_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Open Street Map Privacy",
    ),
    "about_h_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
    "about_h_serverapp": MessageLookupByLibrary.simpleMessage(
      "Application serveur",
    ),
    "about_h_version": MessageLookupByLibrary.simpleMessage("Version :"),
    "about_impressum": MessageLookupByLibrary.simpleMessage(
      "L\'opérateur et l\'organisateur de la Münchener BladeNight est:\nSportverein SkateMunich ! e.V.\nOberföhringer Straße 230\n81925 München\nVereinsregister : VR 200139 \nRegistergericht : Amtsgericht München\n\nReprésenté par:\nChristian Reith, Rudolf Sedlmayr\n\nE-Mail : service@skatemunich.de",
    ),
    "about_kilianlars": MessageLookupByLibrary.simpleMessage(
      "Kilian Schulte, Lars Huth",
    ),
    "about_lars": MessageLookupByLibrary.simpleMessage("Lars Huth"),
    "about_licences": MessageLookupByLibrary.simpleMessage(
      "GNU General Public License v3.0",
    ),
    "about_olivier": MessageLookupByLibrary.simpleMessage("Olivier Croquette"),
    "about_olivierandbenjamin": MessageLookupByLibrary.simpleMessage(
      "Benjamin Uekermann, Olivier Croquette",
    ),
    "about_oneSignalPrivacy": MessageLookupByLibrary.simpleMessage(
      "Nous utilisons OneSignal, une plateforme de marketing mobile, pour notre site web. Le prestataire de services est la société américaine OneSignal, 2850 S Delaware St #201, San Mateo, CA 94403, USA.\nOneSignal traite également des données aux États-Unis, entre autres. Nous tenons à souligner que, selon la Cour européenne de justice, il n\'existe actuellement aucun niveau de protection adéquat pour le transfert de données vers les États-Unis. Ceci peut être associé à divers risques pour la légalité et la sécurité du traitement des données. OneSignal utilise des clauses contractuelles standard approuvées par la Commission européenne (= Art. 46. Para. 2 et 3 GDPR). Ces clauses obligent OneSignal à se conformer au niveau de protection des données de l\'UE lorsqu\'il traite des données pertinentes en dehors de l\'UE. Ces clauses sont basées sur une décision de mise en œuvre de la Commission européenne. Vous pouvez trouver la décision et les clauses ici : https://germany.representation.ec.europa.eu/index_de. Pour en savoir plus sur les données traitées par OneSignal, consultez la politique de confidentialité à l\'adresse https://onesignal.com/privacy. Tous les textes sont protégés par des droits d\'auteur. Source : Créé avec le générateur de confidentialité par AdSimple",
    ),
    "about_open_street_map": MessageLookupByLibrary.simpleMessage(
      "Données que nous recevons automatiquement L\'OSMF gère un certain nombre de services pour la communauté OpenStreetMap, par exemple le site web openstreetmap.org, la carte en ligne de style \'Standard\', l\'API OSM et l\'outil de recherche nominatim.\nLorsque vous visitez un site web OSMF, accédez à l\'un des services via un navigateur ou via des applications qui utilisent les API fournies, des enregistrements de cette utilisation sont produits, nous collectons des informations sur votre navigateur ou application et votre interaction avec notre site web, y compris (a) l\'adresse IP, (b) le type de navigateur et d\'appareil, (c) le système d\'exploitation, (d) la page web de référence, (e) la date et l\'heure des visites de pages, et (f) les pages consultées sur nos sites web.\nLes services qui utilisent le Geo-DNS ou des mécanismes similaires pour répartir la charge sur des serveurs géographiquement distribués généreront potentiellement un enregistrement de votre localisation à grande échelle (par exemple, le réseau de cache de tuiles OSMF détermine le pays dans lequel vous êtes susceptible d\'être situé et dirige vos requêtes vers un serveur approprié). \nCes données sont utilisées ou peuvent être utilisées de la manière suivante : pour soutenir le fonctionnement des services d\'un point de vue technique, de sécurité et de planification, en tant que données anonymes et résumées à des fins de recherche et autres. Ces données peuvent être proposées publiquement via https://planet.openstreetmap.org ou d\'autres canaux et utilisées par des tiers.\npour améliorer le jeu de données OpenStreetMap. Par exemple, en analysant les requêtes nominatives pour les adresses et les codes postaux manquants et en fournissant ces données à la communauté OSM. Les données collectées sur les systèmes seront accessibles par les administrateurs du système et les groupes de travail OSMF appropriés, par exemple le groupe de travail sur les données. Aucune information personnelle ou liée à un individu ne sera divulguée à des tiers, sauf si la loi l\'exige.\nLes adresses IP stockées par Piwik sont raccourcies à deux octets et les informations d\'utilisation détaillées sont conservées pendant 180 jours.\nCompte tenu de la nature temporaire de ce stockage, il n\'est généralement pas possible pour nous de fournir un accès aux adresses IP ou aux journaux qui y sont associés.\nLes données mentionnées ci-dessus sont traitées sur la base de l\'intérêt légitime (voir GDPR article 6.1f ).",
    ),
    "actualInformations": MessageLookupByLibrary.simpleMessage(
      "Informations actuelles",
    ),
    "addEvent": MessageLookupByLibrary.simpleMessage("Ajouter un événement"),
    "addFriendWithCodeHeader": MessageLookupByLibrary.simpleMessage(
      "Ici vous pouvez générer un code pour créer une relation avec votre ami",
    ),
    "addNearBy": MessageLookupByLibrary.simpleMessage(
      "Ajouter un ami à proximité",
    ),
    "addNewFriendHeader": MessageLookupByLibrary.simpleMessage(
      "Si votre ami a généré un code, vous pouvez mettre fin à la relation avec lui",
    ),
    "addfriendwithcode": MessageLookupByLibrary.simpleMessage(
      "Ajouter un ami avec un code",
    ),
    "addnewfriend": MessageLookupByLibrary.simpleMessage(
      "Ajouter un nouvel ami",
    ),
    "admin": MessageLookupByLibrary.simpleMessage("Administrateur"),
    "aheadOfMe": MessageLookupByLibrary.simpleMessage("en avance sur moi"),
    "alignDirectionAndPositionOnUpdate": MessageLookupByLibrary.simpleMessage(
      "Cartes de gestion des positions et des ressources",
    ),
    "alignDirectionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Cartes de gestion des ressources financières",
    ),
    "alignNever": MessageLookupByLibrary.simpleMessage(
      "Aucune orientation de la carte,",
    ),
    "alignPositionOnUpdateOnly": MessageLookupByLibrary.simpleMessage(
      "Cartes de sélection des positions",
    ),
    "allowHeadless": MessageLookupByLibrary.simpleMessage(
      "Mise à jour de l\'arrière-plan active",
    ),
    "allowHeadlessHeader": MessageLookupByLibrary.simpleMessage(
      "Test d\'implémentation, puisque les téléphones portables MIUI Xiaomi tuent les applications par une gestion agressive de la mémoire et qu\'elles ne fonctionnent plus. Si l\'application est en arrière-plan ou tuée, la localisation est toujours transmise (BETA).",
    ),
    "allowWakeLock": MessageLookupByLibrary.simpleMessage(
      "Laisser l\'application éveillée?",
    ),
    "allowWakeLockHeader": MessageLookupByLibrary.simpleMessage(
      "L\'application reste activée tant qu\'elle est ouverte et que le suivi est actif. Se désactive lorsque le niveau de la batterie atteint 30 %. Laisser allumé",
    ),
    "alternativeLocationProvider": MessageLookupByLibrary.simpleMessage(
      "Use alternative driver",
    ),
    "alternativeLocationProviderTitle": MessageLookupByLibrary.simpleMessage(
      "Utiliser un autre fournisseur de localisation en cas de problèmes avec les données GPS",
    ),
    "alwaysPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Permission de localisation toujours refusée dans le système !",
    ),
    "alwaysPermantlyDenied": MessageLookupByLibrary.simpleMessage(
      "L\'autorisation de localisation pour toujours semble refusée en permanence !",
    ),
    "anonymous": MessageLookupByLibrary.simpleMessage("Anonyme"),
    "appId": MessageLookupByLibrary.simpleMessage("App-Id"),
    "appIdTitle": MessageLookupByLibrary.simpleMessage(
      "Chaîne d\'identification unique de l\'application",
    ),
    "appInfo": MessageLookupByLibrary.simpleMessage("App Info"),
    "appInitialisationError": MessageLookupByLibrary.simpleMessage(
      "L\'initialisation de l\'application a échoué",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("BladeNight Munich"),
    "appOutDated": MessageLookupByLibrary.simpleMessage(
      "L\'application est obsolète !\nVeuillez la mettre à jour dans l\'Appstore.",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "appsupport": MessageLookupByLibrary.simpleMessage(
      "Support de l\'application",
    ),
    "apptrackingtransparancy": MessageLookupByLibrary.simpleMessage(
      "Nous nous soucions de votre vie privée et de la sécurité de vos données.nPour nous aider à améliorer l\'expérience BladeNight, nous transférons votre position sur notre serveur. Ces informations comprennent un identifiant unique créé lorsque vous démarrez l\'application pour permettre l\'attribution d\'amis. Ces données ne sont jamais transmises à des tiers ni utilisées à des fins publicitaires.",
    ),
    "at": MessageLookupByLibrary.simpleMessage("at"),
    "autoStartTracking": MessageLookupByLibrary.simpleMessage(
      "Le partage de position a démarré automatiquement. Pour désactiver le comportement, accédez aux paramètres et désactivez le partage de position Auto-Start/Stop",
    ),
    "autoStartTrackingInfo": MessageLookupByLibrary.simpleMessage(
      "Démarrer automatiquement le partage de position",
    ),
    "autoStartTrackingInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Lors du démarrage de BladeNight, il est possible de démarrer automatiquement le partage de position si l\'application est ouverte. Dès que l\'application est fermée ou que l\'activité en arrière-plan n\'est pas activée, le partage de position n\'est pas activé. Si la fonction de partage de position démarre automatiquement lorsque l\'application est ouverte ?",
    ),
    "autoStartTrackingTitle": MessageLookupByLibrary.simpleMessage(
      "Le partage de position a démarré automatiquement...",
    ),
    "autoStopTracking": MessageLookupByLibrary.simpleMessage(
      "Info - à lire - Arrêt automatique à l\'arrivée",
    ),
    "autoStopTrackingDueLowBattery": m0,
    "automatedStopInfo": MessageLookupByLibrary.simpleMessage(
      "En cas d\'appui long sur ▶️, l\'arrêt automatique du suivi sera activé. Cela signifie que tant que l\'application est active et que le suivi s\'arrête à la fin de BladeNight, le suivi s\'arrête automatiquement.\nRépétez un appui long sur ▶️,⏸︎,⏹︎ ︎ pour passer à l\'arrêt manuel et au partage de la localisation avec l\'arrêt automatique.",
    ),
    "automatedStopSettingText": MessageLookupByLibrary.simpleMessage(
      "Arrêter automatiquement le partage de position",
    ),
    "automatedStopSettingTitle": MessageLookupByLibrary.simpleMessage(
      "Arrêter automatiquement le partage de position en fonction de l\'événement",
    ),
    "becomeBladeguard": MessageLookupByLibrary.simpleMessage(
      "Devenir un Bladeguard",
    ),
    "behindMe": MessageLookupByLibrary.simpleMessage("derrière moi"),
    "bgNotificationText": MessageLookupByLibrary.simpleMessage(
      "La mise à jour de la position en arrière-plan est active. Merci de votre participation",
    ),
    "bgNotificationTitle": MessageLookupByLibrary.simpleMessage(
      "Suivi de l\'arrière-plan de BladeNight",
    ),
    "bgTeam": MessageLookupByLibrary.simpleMessage("L\'équipe des Bladeguard"),
    "bgTodayIsRegistered": MessageLookupByLibrary.simpleMessage(
      "Vous n\'êtes pas sur place aujourd\'hui ?",
    ),
    "bgTodayNotParticipation": MessageLookupByLibrary.simpleMessage(
      "Malheureusement, je ne peux pas participer en tant que Bladeguard aujourd\'hui",
    ),
    "bgTodayNotRegistered": MessageLookupByLibrary.simpleMessage(
      "Veuillez vous connecter en tant que Bladeguard aujourd\'hui!",
    ),
    "bgTodayTapToRegister": MessageLookupByLibrary.simpleMessage(
      "Etes-vous sur place aujourd\'hui en tant que protège-lame!",
    ),
    "bgTodayTapToUnRegister": MessageLookupByLibrary.simpleMessage(
      "Désinscrivez-vous en tant que Bladeguard aujourd\'hui !",
    ),
    "bgUpdatePhone": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
    "bladeGuard": MessageLookupByLibrary.simpleMessage("Bladeguard"),
    "bladeGuardSettings": MessageLookupByLibrary.simpleMessage(
      "Paramètres du Bladeguard",
    ),
    "bladeGuardSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Ouvrir la page des paramètres de Bladeguard",
    ),
    "bladeguardAtStartPointTitle": MessageLookupByLibrary.simpleMessage(
      "BladenightApp - Pour votre enregistrement",
    ),
    "bladeguardInfo": m1,
    "bladenight": MessageLookupByLibrary.simpleMessage("BladeNight"),
    "bladenightInfoTitleApp": MessageLookupByLibrary.simpleMessage(
      "Bladenight et informations sur",
    ),
    "bladenightInfoTitleWeb": MessageLookupByLibrary.simpleMessage(
      "WebApp et informations sur",
    ),
    "bladenightUpdate": MessageLookupByLibrary.simpleMessage(
      "BladeNight mise à jour",
    ),
    "bladenightViewerTracking": MessageLookupByLibrary.simpleMessage(
      "Mode visualisation avec GPS",
    ),
    "bladenighttracking": MessageLookupByLibrary.simpleMessage(
      "Mode visualisation, poussée du participant ▶ s\'il vous plaît",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "canceled": MessageLookupByLibrary.simpleMessage("😞 Annulé 😞"),
    "change": MessageLookupByLibrary.simpleMessage("Le modifier."),
    "changeDarkColor": MessageLookupByLibrary.simpleMessage(
      "Changer la couleur du mode sombre",
    ),
    "changeLightColor": MessageLookupByLibrary.simpleMessage(
      "Changer la couleur du mode d\'éclairage",
    ),
    "changeMeColor": MessageLookupByLibrary.simpleMessage(
      "Change-moi de couleur",
    ),
    "changetoalways": MessageLookupByLibrary.simpleMessage(
      "Changer pour \'Autoriser tout le temps\'",
    ),
    "checkBgRegistration": MessageLookupByLibrary.simpleMessage(
      "Vérifiez si vous êtes enregistré en tant que Bladeguard",
    ),
    "checkNearbyCounterSide": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner l\'appareil de vos amis pour obtenir des amis sur l\'application",
    ),
    "chooseDeviceToLink": MessageLookupByLibrary.simpleMessage(
      "Veuillez choisir l\'appareil à coupler !",
    ),
    "clearLogsQuestion": MessageLookupByLibrary.simpleMessage(
      "Clear logs really ?",
    ),
    "clearLogsTitle": MessageLookupByLibrary.simpleMessage(
      "Les données de logs seront supprimées de manière permanente !",
    ),
    "clearMessages": MessageLookupByLibrary.simpleMessage(
      "Effacer tous les messages, vraiment ?",
    ),
    "clearMessagesTitle": MessageLookupByLibrary.simpleMessage(
      "Effacer les messages",
    ),
    "closeApp": MessageLookupByLibrary.simpleMessage("Close app really ?"),
    "codeExpired": MessageLookupByLibrary.simpleMessage(
      "Code trop ancien ! Veuillez supprimer l\'entrée et réinviter un ami !",
    ),
    "codecontainsonlydigits": MessageLookupByLibrary.simpleMessage(
      "Erreur, le code ne contient que des chiffres",
    ),
    "collectionStop": MessageLookupByLibrary.simpleMessage(
      "Arrêt de collecte du cortège",
    ),
    "confirmed": MessageLookupByLibrary.simpleMessage("Confirmé"),
    "connected": MessageLookupByLibrary.simpleMessage("Connecté"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecter..."),
    "copiedtoclipboard": MessageLookupByLibrary.simpleMessage(
      "Copié dans le presse-papiers",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copier le code"),
    "couldNotOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'ouvrir les paramètres de l\'application !",
    ),
    "dataCouldBeOutdated": MessageLookupByLibrary.simpleMessage(
      "Les données pourraient être obsolètes",
    ),
    "dateIntl": m2,
    "dateTimeDayIntl": m3,
    "dateTimeIntl": m4,
    "dateTimeSecIntl": m5,
    "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "deleteEvent": MessageLookupByLibrary.simpleMessage(
      "Supprimer l\'événement",
    ),
    "deleteFriendHeader": m6,
    "deleteMessage": MessageLookupByLibrary.simpleMessage(
      "Supprimer le message",
    ),
    "deletefriend": MessageLookupByLibrary.simpleMessage("Supprimer un ami"),
    "deny": MessageLookupByLibrary.simpleMessage("Refuser"),
    "devicesAlreadyConnected": MessageLookupByLibrary.simpleMessage(
      "Les appareils sont déjà connectés",
    ),
    "disconnect": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "disconnected": MessageLookupByLibrary.simpleMessage("non connecté"),
    "distance": MessageLookupByLibrary.simpleMessage("distance"),
    "distanceDriven": MessageLookupByLibrary.simpleMessage(
      "Distance parcourue",
    ),
    "distanceDrivenOdo": MessageLookupByLibrary.simpleMessage(
      "GPS total driven",
    ),
    "distanceToFinish": MessageLookupByLibrary.simpleMessage(
      "Distance jusqu\'à l\'arrivée",
    ),
    "distanceToFriend": MessageLookupByLibrary.simpleMessage(
      "Distance par rapport à l\'ami",
    ),
    "distanceToHead": MessageLookupByLibrary.simpleMessage(
      "Distance à la tête",
    ),
    "distanceToMe": MessageLookupByLibrary.simpleMessage(
      "Distance par rapport à moi",
    ),
    "distanceToTail": MessageLookupByLibrary.simpleMessage(
      "Distance jusqu\'à la queue",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Terminé"),
    "editEvent": MessageLookupByLibrary.simpleMessage("Editer un événement"),
    "editFriendHeader": m7,
    "editfriend": MessageLookupByLibrary.simpleMessage("Modifier l\'ami"),
    "enableAlwaysLocationGeofenceText": MessageLookupByLibrary.simpleMessage(
      "Pour la connexion automatique sur place, le partage de site devrait être réglé sur toujours. Faut-il ouvrir les paramètres système ?",
    ),
    "enableAlwaysLocationInfotext": MessageLookupByLibrary.simpleMessage(
      "Pour utiliser BladeNight-App également en arrière-plan (partager la position avec des amis et augmenter la précision des processions) sans que l\'écran soit allumé, les paramètres de localisation doivent être réglés sur Autoriser tout le temps",
    ),
    "enableOnesignalPushMessage": MessageLookupByLibrary.simpleMessage(
      "Message push actif",
    ),
    "enableOnesignalPushMessageTitle": MessageLookupByLibrary.simpleMessage(
      "Activer les notifications push d\'Onesignal. Ici, des informations générales peuvent être reçues par notification push, par exemple si la nuit blanche a lieu. Le réglage recommandé est \'On\'",
    ),
    "enter6digitcode": MessageLookupByLibrary.simpleMessage(
      "Vous devez entrer un code à 6 chiffres",
    ),
    "enterBgPassword": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir le mot de passe de sécurité Bladeguard",
    ),
    "enterBirthday": MessageLookupByLibrary.simpleMessage("Your Birthday"),
    "enterEmail": MessageLookupByLibrary.simpleMessage(
      "Saisir l\'adresse électronique",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Entrer le mot de passe",
    ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter your mobile phone Number",
    ),
    "entercode": MessageLookupByLibrary.simpleMessage("Code : "),
    "enterfriendname": MessageLookupByLibrary.simpleMessage(
      "Entrez le nom de votre ami",
    ),
    "entername": MessageLookupByLibrary.simpleMessage(
      "Entrez le nom de votre ami",
    ),
    "eventNotStarted": MessageLookupByLibrary.simpleMessage(
      "Événement non démarré",
    ),
    "eventOn": MessageLookupByLibrary.simpleMessage("Événement sur"),
    "events": MessageLookupByLibrary.simpleMessage("Événements"),
    "export": MessageLookupByLibrary.simpleMessage("Exporter"),
    "exportLogData": MessageLookupByLibrary.simpleMessage(
      "Envoi des données de l\'enregistreur à des fins d\'assistance ou de fonctionnalité",
    ),
    "exportUserTracking": MessageLookupByLibrary.simpleMessage(
      "Exporter le suivi des utilisateurs",
    ),
    "exportUserTrackingHeader": MessageLookupByLibrary.simpleMessage(
      "Exportation des données de localisation enregistrées (trace visible sur la carte) au format GPX",
    ),
    "exportWarning": MessageLookupByLibrary.simpleMessage(
      "Danger ! Cette opération permet de sauvegarder tous les amis et l\'identifiant de l\'appareil. Cela peut contenir des informations sensibles telles que des noms.",
    ),
    "exportWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Exporter des amis et des identifiants.",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("Échec!"),
    "failedAddNearbyTryCode": MessageLookupByLibrary.simpleMessage(
      "Veuillez essayer d\'établir la connexion avec un code. Demandez à votre ami le code affiché dans sa liste d\'amis. Vous ne pouvez vous connecter qu\'une seule fois avec le même ami.",
    ),
    "finish": MessageLookupByLibrary.simpleMessage("finir"),
    "finishForceStopEventOverTitle": MessageLookupByLibrary.simpleMessage(
      "Tracking stopped - BladeNight finished",
    ),
    "finishForceStopTimeoutTitle": MessageLookupByLibrary.simpleMessage(
      "Tracking stopped - Timeout",
    ),
    "finishReachedStopedTracking": MessageLookupByLibrary.simpleMessage(
      "Finish reached - location tracking stopped",
    ),
    "finishReachedTitle": MessageLookupByLibrary.simpleMessage(
      "Finish reached",
    ),
    "finishReachedtargetReachedPleaseStopTracking":
        MessageLookupByLibrary.simpleMessage(
          "Finish reached - Please stop location tracking",
        ),
    "finishStopTrackingEventOver": MessageLookupByLibrary.simpleMessage(
      "Arrêt automatique du suivi : Arrêt automatique du suivi, car cet événement BladeNight est terminé. (Appuyez longuement sur ▶️ pour désactiver l\'arrêt automatique du suivi)",
    ),
    "finishStopTrackingTimeout": m8,
    "finished": MessageLookupByLibrary.simpleMessage("Fini"),
    "fireBaseCrashlytics": MessageLookupByLibrary.simpleMessage(
      "Crashlytics activé/désactivé",
    ),
    "fireBaseCrashlyticsHeader": MessageLookupByLibrary.simpleMessage(
      "Pour améliorer l\'application, les événements de crash seront envoyés à Crashlytics. Cela peut être supprimé ici.",
    ),
    "fitnessPermissionInfoText": MessageLookupByLibrary.simpleMessage(
      "L\'accès à la détection de l\'activité de mouvement (activité physique) est souhaitable. Cela augmente l\'efficacité de la batterie en désactivant intelligemment le suivi de la localisation lorsque votre appareil est détecté comme étant stationnaire. Veuillez donc activer cette fonction. Elle sera demandée dans les étapes suivantes.",
    ),
    "fitnessPermissionInfoTextTitle": MessageLookupByLibrary.simpleMessage(
      "Activité physique",
    ),
    "fitnessPermissionSettingsText": MessageLookupByLibrary.simpleMessage(
      "L\'accès à la détection de l\'activité de mouvement (activité physique) est souhaitable. Cela augmente l\'efficacité de la batterie en désactivant intelligemment le suivi de l\'emplacement lorsque votre appareil est détecté comme étant stationnaire. Veuillez donc activer cette fonction.",
    ),
    "fitnessPermissionSwitchSettingsText": MessageLookupByLibrary.simpleMessage(
      "Activité de remise en forme activée",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Mot de passe oublié",
    ),
    "forward": MessageLookupByLibrary.simpleMessage("Forward"),
    "friend": MessageLookupByLibrary.simpleMessage("Ami"),
    "friendIs": MessageLookupByLibrary.simpleMessage("L\'ami est"),
    "friendScanQrCode": m9,
    "friends": MessageLookupByLibrary.simpleMessage("Amis"),
    "friendswillmissyou": MessageLookupByLibrary.simpleMessage(
      "Veuillez soutenir la présentation exacte de BladeNight skater procession.\nVous manquerez à vos amis !",
    ),
    "from": MessageLookupByLibrary.simpleMessage("by"),
    "geoFencing": MessageLookupByLibrary.simpleMessage(
      "autoriser le géofencing",
    ),
    "geoFencingTitle": MessageLookupByLibrary.simpleMessage(
      "Bladeguard sur site – autorisé via geofencing. Si vous vous trouvez dans le rayon du point de départ, vous serez automatiquement connecté en tant que BladeGuard digital (Beta)",
    ),
    "getwebdata": MessageLookupByLibrary.simpleMessage(
      "Chargement des données depuis le serveur ...",
    ),
    "head": MessageLookupByLibrary.simpleMessage("Tête"),
    "home": MessageLookupByLibrary.simpleMessage("Accueil"),
    "iAmBladeGuard": MessageLookupByLibrary.simpleMessage(
      "Je suis déjà un Bladeguard",
    ),
    "iAmBladeGuardTitle": m10,
    "iam": MessageLookupByLibrary.simpleMessage("Je suis"),
    "ignoreBatteriesOptimisation": MessageLookupByLibrary.simpleMessage(
      "Note - certains fabricants désactivent les applications en raison d\'une optimisation défavorable de la batterie ou ferment l\'application. Si c\'est le cas, essayez de désactiver l\'optimisation de la batterie pour l\'application. Régler sur Aucune restriction",
    ),
    "ignoreBatteriesOptimisationTitle": MessageLookupByLibrary.simpleMessage(
      "Modifier les optimisations de la batterie",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Importation"),
    "importWarning": MessageLookupByLibrary.simpleMessage(
      "Attention, cela écrase tous les amis et l\'ID. Exportez les données au préalable ! Attention, supprimez l\'application sur l\'appareil à partir duquel elle a été exportée !",
    ),
    "importWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Importer les amis et l\'ID",
    ),
    "inprogress": MessageLookupByLibrary.simpleMessage(
      "non implémenté. Nous y travaillons...",
    ),
    "internalerror_invalidcode": MessageLookupByLibrary.simpleMessage(
      "Code invalide",
    ),
    "internalerror_seemslinked": MessageLookupByLibrary.simpleMessage(
      "Erreur - Un ami est lié?",
    ),
    "invalidEMail": MessageLookupByLibrary.simpleMessage("Mail not found"),
    "invalidLoginData": MessageLookupByLibrary.simpleMessage(
      "Email not found or wrong birthday",
    ),
    "invalidcode": MessageLookupByLibrary.simpleMessage("Code invalide"),
    "invitebyname": m11,
    "invitenewfriend": MessageLookupByLibrary.simpleMessage("Inviter un ami"),
    "isIgnoring": MessageLookupByLibrary.simpleMessage("Est ignoré"),
    "ist": MessageLookupByLibrary.simpleMessage("is"),
    "isuseractive": MessageLookupByLibrary.simpleMessage(
      "Afficher sur la carte",
    ),
    "lastseen": MessageLookupByLibrary.simpleMessage("Dernière observation"),
    "lastupdate": MessageLookupByLibrary.simpleMessage("Dernière mise à jour"),
    "lead": MessageLookupByLibrary.simpleMessage("Procession Start / Fin"),
    "leadspec": MessageLookupByLibrary.simpleMessage("Zug+Spécial"),
    "leaveAppWarning": m12,
    "leaveAppWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Le navigateur externe est-il activé ?",
    ),
    "leavewheninuse": MessageLookupByLibrary.simpleMessage(
      "Laisser les paramètres",
    ),
    "length": MessageLookupByLibrary.simpleMessage("Longueur"),
    "linkAsBrowserDevice": m13,
    "linkNearBy": MessageLookupByLibrary.simpleMessage(
      "Accepter un ami à proximité",
    ),
    "linkOnOtherDevice": m14,
    "linkingFailed": MessageLookupByLibrary.simpleMessage("Échec du couplage"),
    "linkingSuccessful": MessageLookupByLibrary.simpleMessage(
      "Couplage réussi",
    ),
    "liveMapInBrowser": MessageLookupByLibrary.simpleMessage(
      "Suivre le procession de Bladnight sans application",
    ),
    "liveMapInBrowserInfoHeader": MessageLookupByLibrary.simpleMessage(
      "Carte en direct dans le navigateur",
    ),
    "loading": MessageLookupByLibrary.simpleMessage(
      "Données de chargement ...",
    ),
    "locationServiceOff": MessageLookupByLibrary.simpleMessage(
      "La localisation est désactivée dans les paramètres. Le suivi n\'est pas possible. Appuyez sur Play ▶️ ou allez dans OS-Paramètres.",
    ),
    "locationServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Le partage de localisation a été démarré et est actif",
    ),
    "login": MessageLookupByLibrary.simpleMessage("login"),
    "loginThreeHoursBefore": MessageLookupByLibrary.simpleMessage(
      "Vous pouvez vous présenter sur place 3 heures avant le départ ! Vous devez être à proximité du point de départ !",
    ),
    "manufacturer": MessageLookupByLibrary.simpleMessage("Fabricant"),
    "map": MessageLookupByLibrary.simpleMessage("Carte"),
    "mapAlign": MessageLookupByLibrary.simpleMessage("Alignement de la carte"),
    "mapFollow": MessageLookupByLibrary.simpleMessage("Suivi sur la carte"),
    "mapFollowLocation": MessageLookupByLibrary.simpleMessage(
      "La carte suit ma position",
    ),
    "mapFollowStopped": MessageLookupByLibrary.simpleMessage(
      "La carte me suit arrêtée!",
    ),
    "mapFollowTrain": MessageLookupByLibrary.simpleMessage(
      "La carte suit la position de la tête du procession",
    ),
    "mapFollowTrainStopped": MessageLookupByLibrary.simpleMessage(
      "La carte suit la tête du procession à l\'arrêt",
    ),
    "mapToStartNoFollowing": MessageLookupByLibrary.simpleMessage(
      "Déplacer la carte au début, pas de suite",
    ),
    "markMeAsHead": MessageLookupByLibrary.simpleMessage(
      "Marquez-moi comme tête de cortège",
    ),
    "markMeAsTail": MessageLookupByLibrary.simpleMessage(
      "Marquez-moi comme queue de cortège",
    ),
    "me": MessageLookupByLibrary.simpleMessage("moi"),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "metersOnRoute": MessageLookupByLibrary.simpleMessage("Itinéraire conduit"),
    "missingName": MessageLookupByLibrary.simpleMessage(
      "Le champ doit contenir au moins 1 caractère",
    ),
    "model": MessageLookupByLibrary.simpleMessage("Modèle"),
    "mustNearbyStartingPoint": m15,
    "mustentername": MessageLookupByLibrary.simpleMessage(
      "Vous devez entrer un nom !",
    ),
    "myName": MessageLookupByLibrary.simpleMessage("Mon nom est"),
    "myNameHeader": MessageLookupByLibrary.simpleMessage(
      "Le nom spécifié est transféré au deuxième appareil lorsque vous vous connectez à votre ami. Le nom n\'est sauvegardé que localement et est utilisé pour simplifier la liaison via la connexion locale.",
    ),
    "mySpeed": MessageLookupByLibrary.simpleMessage("Ma vitesse sur piste"),
    "nameexists": MessageLookupByLibrary.simpleMessage("Désolé, le nom existe"),
    "networkerror": MessageLookupByLibrary.simpleMessage(
      "Erreur Internet! Pas de données!",
    ),
    "never": MessageLookupByLibrary.simpleMessage("jamais"),
    "newGPSDatareceived": MessageLookupByLibrary.simpleMessage(
      "Nouvelles données GPS reçues",
    ),
    "nextEvent": MessageLookupByLibrary.simpleMessage(
      "Prochaine nuit des lames",
    ),
    "no": MessageLookupByLibrary.simpleMessage("Non"),
    "noBackgroundlocationLeaveAppOpen": MessageLookupByLibrary.simpleMessage(
      "L\'emplacement \'En cours d\'utilisation\' est sélectionné. Attention, aucune mise à jour en arrière-plan n\'est activée. Vos données de position pour montrer le procession Bladnight exact et partager votre position avec vos amis n\'est possible que lorsque l\'application est ouverte au premier plan. Veuillez le confirmer ou modifier vos paramètres en Autoriser tout le temps.nEn outre, l\'accès à la détection de l\'activité de mouvement (activité physique) est souhaitable. Cette fonction augmente l\'efficacité de la batterie en désactivant intelligemment le suivi de l\'emplacement lorsque votre appareil est détecté comme étant stationnaire. Veuillez donc activer cette fonction.",
    ),
    "noBackgroundlocationTitle": MessageLookupByLibrary.simpleMessage(
      "Pas de mise à jour possible en arrière-plan",
    ),
    "noChoiceNoAction": MessageLookupByLibrary.simpleMessage(
      "Pas de choix, pas d\'action",
    ),
    "noEvent": MessageLookupByLibrary.simpleMessage("Rien de prévu"),
    "noEventPlanned": MessageLookupByLibrary.simpleMessage(
      "Aucun événement prévu",
    ),
    "noEventStarted": MessageLookupByLibrary.simpleMessage("Pas d\'événement"),
    "noEventStartedAutoStop": MessageLookupByLibrary.simpleMessage(
      "No Event - Autostop",
    ),
    "noEventTimeOut": m16,
    "noGpsAllowed": MessageLookupByLibrary.simpleMessage("GPS non actif"),
    "noLocationAvailable": MessageLookupByLibrary.simpleMessage(
      "Pas de localisation connue",
    ),
    "noLocationPermissionGrantedAlertAndroid": MessageLookupByLibrary.simpleMessage(
      "Veuillez vérifier les autorisations de localisation dans les paramètres",
    ),
    "noLocationPermissionGrantedAlertTitle":
        MessageLookupByLibrary.simpleMessage("Info no location permissions"),
    "noLocationPermissionGrantedAlertiOS": MessageLookupByLibrary.simpleMessage(
      "Veuillez vérifier les autorisations de localisation dans les paramètres d\'iOS. Regardez dans Confidentialité - Localisation - BladnightApp. Réglez-la sur toujours ou lorsqu\'elle est utilisée !",
    ),
    "noLocationPermitted": MessageLookupByLibrary.simpleMessage(
      "No location permission, please check device settings",
    ),
    "noNearbyService": MessageLookupByLibrary.simpleMessage(
      "Service à proximité non activé",
    ),
    "noSelfRelationAllowed": MessageLookupByLibrary.simpleMessage(
      "La relation avec soi-même n\'est pas autorisée",
    ),
    "noValidPendingRelationShip": MessageLookupByLibrary.simpleMessage(
      "Pas d\'identifiant de relation en attente valide",
    ),
    "nodatareceived": MessageLookupByLibrary.simpleMessage(
      "No Data received !",
    ),
    "nogps": MessageLookupByLibrary.simpleMessage("Pas de GPS"),
    "nogpsenabled": MessageLookupByLibrary.simpleMessage(
      "Désolé, aucun GPS dans l\'appareil n\'a été trouvé ou refusé.",
    ),
    "notAvailable": MessageLookupByLibrary.simpleMessage("non disponible"),
    "notKnownOnServer": MessageLookupByLibrary.simpleMessage(
      "Obsolète ! Supprimez-le !",
    ),
    "notOnRoute": MessageLookupByLibrary.simpleMessage("Pas sur la route!"),
    "notVisibleOnMap": MessageLookupByLibrary.simpleMessage(
      "Non visible sur la carte !",
    ),
    "note_bladenightCanceled": MessageLookupByLibrary.simpleMessage(
      "La BladeNight a été annulée",
    ),
    "note_bladenightStartInFiveMinutesStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "La prochaine BladeNight commencera dans 5 minutes. N\'oubliez pas d\'activer le suivi !",
        ),
    "note_bladenightStartInSixHoursStartTracking":
        MessageLookupByLibrary.simpleMessage(
          "La prochaine nuit blanche commencera dans 6 heures",
        ),
    "note_statuschanged": MessageLookupByLibrary.simpleMessage(
      "Le statut de la BladeNight a été modifié - Veuillez vérifier dans l\'application",
    ),
    "notification": MessageLookupByLibrary.simpleMessage("Notification"),
    "notracking": MessageLookupByLibrary.simpleMessage("Pas de suivi !"),
    "now": MessageLookupByLibrary.simpleMessage("maintenant"),
    "offline": MessageLookupByLibrary.simpleMessage("Hors ligne"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on": MessageLookupByLibrary.simpleMessage("sur le site"),
    "onRoute": MessageLookupByLibrary.simpleMessage("sur la route"),
    "oneSignalId": MessageLookupByLibrary.simpleMessage("OneSignal-Id : "),
    "oneSignalIdTitle": MessageLookupByLibrary.simpleMessage(
      "Il s\'agit de l\'identifiant attribué pour la réception des messages push. Communiquez-nous cet identifiant si vous avez des problèmes pour recevoir des messages push.",
    ),
    "online": MessageLookupByLibrary.simpleMessage("en ligne"),
    "onlyReducedLocationAccuracyText": MessageLookupByLibrary.simpleMessage(
      "Seule une position approximative est communiquée. Cela peut influencer le suivi de votre position dans le cortège.",
    ),
    "onlyReducedLocationAccuracyTitle": MessageLookupByLibrary.simpleMessage(
      "Emplacement approximatif seulement",
    ),
    "onlyTracking": MessageLookupByLibrary.simpleMessage(
      "Enregistrement de localisation uniquement actif!",
    ),
    "onlyWhenInUseEnabled": MessageLookupByLibrary.simpleMessage(
      "Localisation uniquement \"Autoriser uniquement lors de l\'utilisation de l\'application\".",
    ),
    "onlyWhileInUse": MessageLookupByLibrary.simpleMessage(
      "GPS Pendant l\'utilisation - l\'application ne fonctionne qu\'au premier plan. Veuillez modifier les paramètres du système d\'exploitation",
    ),
    "openOperatingSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Ouvrir les paramètres du système d\'exploitation",
    ),
    "openStreetMap": MessageLookupByLibrary.simpleMessage(
      "Charger Openstreetmap / Redémarrage de l\'application nécessaire",
    ),
    "openStreetMapText": MessageLookupByLibrary.simpleMessage(
      "Utiliser Openstreetmap",
    ),
    "own": MessageLookupByLibrary.simpleMessage("Propre"),
    "participant": MessageLookupByLibrary.simpleMessage("Participant"),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Mobile"),
    "pickcolor": MessageLookupByLibrary.simpleMessage("Choisissez une couleur"),
    "polyLinesAmount": MessageLookupByLibrary.simpleMessage(
      "Pour augmenter la vitesse de rendu sur les appareils lents, vous pouvez augmenter/diminuer la quantité de polylignes dessinées (points d\'itinéraire) sur la carte avant de simplifier.",
    ),
    "polyLinesAmountHeader": MessageLookupByLibrary.simpleMessage("Nombre"),
    "polyLinesTolerance": MessageLookupByLibrary.simpleMessage(
      "To increase rendering speed on slow devices you can increase/decrease the tolerance of drawn polylines (routepoints) on map.",
    ),
    "polyLinesToleranceHeader": MessageLookupByLibrary.simpleMessage(
      "tolerance",
    ),
    "position": MessageLookupByLibrary.simpleMessage("Position"),
    "positiveInFront": MessageLookupByLibrary.simpleMessage(
      "Positif si je suis devant, négatif si je suis derrière",
    ),
    "proceed": MessageLookupByLibrary.simpleMessage("Proceed"),
    "prominentdisclosuretrackingprealertandroidFromAndroid_V11":
        MessageLookupByLibrary.simpleMessage(
          "L\'application BladeNight a besoin de vos données de localisation pour afficher le cortège BladeNight et pour partager votre position avec vos amis, lors de l\'utilisation de l\'application. Veuillez accepter l\'autorisation de localisation à l\'étape suivante. Vous devez sélectionner \'Lors de l\'utilisation de l\'application\'. Plus tard, nous vous le redemanderons, l\'option préférée étant \'Autoriser tout le temps\'. Lorsque vous sélectionnez \'Lors de l\'utilisation\', vous devez laisser s\'ouvrir l\'écran BladeNight au sol, pour partager votre position. Si vous refusez l\'accès à l\'emplacement, seul le défilé BladeNight peut être regardé sans partage de l\'emplacement.  En outre, l\'accès à la détection de l\'activité de mouvement (activité physique) est souhaitable. Cette fonction augmente l\'efficacité de la batterie en désactivant intelligemment le suivi de la localisation lorsque votre appareil est détecté comme étant stationnaire. Veuillez donc activer cette fonction.\nLa demande est divisée en 2 étapes.\nVeuillez soutenir l\'exactitude du procession. Merci beaucoup",
        ),
    "prominentdisclosuretrackingprealertandroidToAndroid_V10x":
        MessageLookupByLibrary.simpleMessage(
          "L\'application BladeNight a besoin de vos données de localisation pour afficher le cortège BladeNight et partager votre position avec vos amis, lorsque vous utilisez l\'application. Veuillez accepter l\'autorisation de localisation à l\'étape suivante. Vous devez sélectionner \'Lors de l\'utilisation de l\'application\'. Si vous refusez l\'accès à la localisation, seul le procession de patineurs de BladeNight pourra être regardé sans partage de position. Veuillez soutenir l\'exactitude du procession",
        ),
    "pushMessageParticipateAsBladeGuard": MessageLookupByLibrary.simpleMessage(
      "Participate push req.",
    ),
    "pushMessageParticipateAsBladeGuardTitle":
        MessageLookupByLibrary.simpleMessage(
          "Bladeguard-participer par message push ?",
        ),
    "pushMessageSkateMunichInfos": MessageLookupByLibrary.simpleMessage(
      "Recevoir des informations sur SkateMunich",
    ),
    "pushMessageSkateMunichInfosTitle": MessageLookupByLibrary.simpleMessage(
      "Recevoir des informations sur les événements de SkateMunich par message push?",
    ),
    "qrcoderouteinfoheader": MessageLookupByLibrary.simpleMessage(
      "QRCode pour afficher des informations sur les événements sans application dans le navigateur",
    ),
    "readMessage": MessageLookupByLibrary.simpleMessage("Message lu"),
    "receiveBladeGuardInfos": MessageLookupByLibrary.simpleMessage(
      "Reçu Bladeguard Infos",
    ),
    "received": MessageLookupByLibrary.simpleMessage("reçu"),
    "refresh": MessageLookupByLibrary.simpleMessage("Actualiser"),
    "refreshHeader": MessageLookupByLibrary.simpleMessage(
      "Actualiser les données",
    ),
    "register": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
    "registeredAs": MessageLookupByLibrary.simpleMessage(
      "Enregistré en tant que:",
    ),
    "reload": MessageLookupByLibrary.simpleMessage("Recharger"),
    "reltime": MessageLookupByLibrary.simpleMessage("rel. timediff."),
    "remove": MessageLookupByLibrary.simpleMessage("Retirer"),
    "requestAlwaysPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Location always permissions",
    ),
    "requestLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Information sur les raisons pour lesquelles le partage de la localisation serait nécessaire",
    ),
    "requestOffSite": MessageLookupByLibrary.simpleMessage(
      "Vous voulez vraiment vous désinscrire en tant que Bladeguard aujourd\'hui. Nous avons besoin de tout le monde. Détrompez-vous.",
    ),
    "requestOffSiteTitle": MessageLookupByLibrary.simpleMessage(
      "Pas de Bladeguard aujourd\'hui ?",
    ),
    "resetInSettings": MessageLookupByLibrary.simpleMessage(
      "Reset in Paramètres",
    ),
    "resetLongPress": MessageLookupByLibrary.simpleMessage(
      "Appuyer longuement sur la jauge pour réinitialiser le compteur ODO",
    ),
    "resetOdoMeter": MessageLookupByLibrary.simpleMessage(
      "Remettre le compteur ODO à 0 et effacer l\'itinéraire conduit?",
    ),
    "resetOdoMeterTitle": MessageLookupByLibrary.simpleMessage(
      "Remise à zéro du compteur ODO et route conduite",
    ),
    "resetTrackPointsStore": MessageLookupByLibrary.simpleMessage("Clear all"),
    "resetTrackPointsStoreTitle": MessageLookupByLibrary.simpleMessage(
      "Effacez location-store pour tous les événements suivis.",
    ),
    "restartRequired": MessageLookupByLibrary.simpleMessage(
      "Redémarrage requis ! Veuillez fermer l\'application et la rouvrir !!!",
    ),
    "route": MessageLookupByLibrary.simpleMessage("Parcours"),
    "routeoverview": MessageLookupByLibrary.simpleMessage(
      "Aperçu de l\'itinéraire",
    ),
    "running": MessageLookupByLibrary.simpleMessage("Nous sommes en route"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "scanCodeForFriend": m17,
    "scrollMapTo": MessageLookupByLibrary.simpleMessage(
      "Faire défiler la carte pour ...",
    ),
    "searchNearby": MessageLookupByLibrary.simpleMessage(
      "Recherche d\'appareils à proximité",
    ),
    "seemsoffline": MessageLookupByLibrary.simpleMessage(
      "Attente de la connexion internet ...",
    ),
    "selectDate": MessageLookupByLibrary.simpleMessage("Sélectionner une date"),
    "selectTrackingType": MessageLookupByLibrary.simpleMessage(
      "Sélectionner le type de suivi",
    ),
    "sendData30sec": MessageLookupByLibrary.simpleMessage(
      "Demande envoyée - le changement prend environ 30 secondes.",
    ),
    "sendMail": MessageLookupByLibrary.simpleMessage(
      "Envoyer un email (E-Mail support)",
    ),
    "sendlink": MessageLookupByLibrary.simpleMessage("Envoyer un lien"),
    "sendlinkdescription": m18,
    "sendlinksubject": MessageLookupByLibrary.simpleMessage(
      "Envoyer un lien à BladeNight-App. Vous pouvez vous voir",
    ),
    "serverConnected": MessageLookupByLibrary.simpleMessage("Serveur connecté"),
    "serverNotReachable": MessageLookupByLibrary.simpleMessage(
      "Connecting to server ...",
    ),
    "serverVersion": MessageLookupByLibrary.simpleMessage("Serverversion"),
    "sessionConnectionError": MessageLookupByLibrary.simpleMessage(
      "Erreur de négociation de la connexion à la session",
    ),
    "setClearLogs": MessageLookupByLibrary.simpleMessage(
      "Efface les données du journal",
    ),
    "setDarkMode": MessageLookupByLibrary.simpleMessage(
      "Activer le mode sombre",
    ),
    "setDarkModeTitle": MessageLookupByLibrary.simpleMessage(
      "Basculer entre le mode clair et le mode sombre indépendamment du réglage du système d\'exploitation",
    ),
    "setExportLogSupport": MessageLookupByLibrary.simpleMessage(
      "Exporter les données du journal",
    ),
    "setIconSize": MessageLookupByLibrary.simpleMessage("Taille de l\'icône"),
    "setIconSizeTitle": MessageLookupByLibrary.simpleMessage(
      "Définir la taille des icônes \'moi\', \'ami\' et \'cortège\' sur la carte",
    ),
    "setInsertImportDataset": MessageLookupByLibrary.simpleMessage(
      "Insert dataset incl. bna :",
    ),
    "setLogData": MessageLookupByLibrary.simpleMessage(
      "Enregistreur de données",
    ),
    "setLogLevel": MessageLookupByLibrary.simpleMessage(
      "Définir le niveau de journalisation",
    ),
    "setMeColor": MessageLookupByLibrary.simpleMessage(
      "Propre couleur sur la carte",
    ),
    "setOpenSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Paramètres du système d\'exploitation ouvert",
    ),
    "setPrimaryColor": MessageLookupByLibrary.simpleMessage(
      "Définir la couleur primaire (claire) (jaune par défaut)",
    ),
    "setPrimaryDarkColor": MessageLookupByLibrary.simpleMessage(
      "Définir la couleur primaire en mode sombre (jaune par défaut)",
    ),
    "setRoute": MessageLookupByLibrary.simpleMessage("Définir l\'itinéraire"),
    "setStartImport": MessageLookupByLibrary.simpleMessage(
      "Démarrer l\'importation Id und friends",
    ),
    "setState": MessageLookupByLibrary.simpleMessage("Set Status"),
    "setSystem": MessageLookupByLibrary.simpleMessage("System"),
    "setTeam": MessageLookupByLibrary.simpleMessage(
      "Choisissez votre équipe !",
    ),
    "setcolor": MessageLookupByLibrary.simpleMessage("Changer de couleur"),
    "setexportDataHeader": MessageLookupByLibrary.simpleMessage("Exporter"),
    "setexportIdAndFriends": MessageLookupByLibrary.simpleMessage(
      "Exporter l\'identifiant et les amis",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "showCompass": MessageLookupByLibrary.simpleMessage("Afficher la boussole"),
    "showCompassTitle": MessageLookupByLibrary.simpleMessage(
      "Afficher la boussole sur la carte",
    ),
    "showFullProcession": MessageLookupByLibrary.simpleMessage(
      "Afficher les participants à la procession",
    ),
    "showFullProcessionTitle": MessageLookupByLibrary.simpleMessage(
      "Afficher les participants au cortège (limité à 100 dans le cortège) sur la carte. Ne fonctionne qu\'en cas d\'autopistage",
    ),
    "showLogData": MessageLookupByLibrary.simpleMessage(
      "Afficher les données de journal",
    ),
    "showOwnColoredTrack": MessageLookupByLibrary.simpleMessage(
      "Coloriser ma trace",
    ),
    "showOwnTrack": MessageLookupByLibrary.simpleMessage(
      "Afficher sa propre ligne de parcours. Il est possible d\'enregistrer et d\'afficher son propre parcours. L\'itinéraire coloré montre également la vitesse, mais selon l\'appareil, il peut y avoir des saccades lors du zoom, etc",
    ),
    "showOwnTrackSwitchTitle": MessageLookupByLibrary.simpleMessage(
      "Afficher les points de piste",
    ),
    "showProcession": MessageLookupByLibrary.simpleMessage(
      "Showing actual procession of Münchener BladeNight",
    ),
    "showWeblinkToRoute": MessageLookupByLibrary.simpleMessage(
      "Afficher le lien web vers l\'itinéraire",
    ),
    "showonly": MessageLookupByLibrary.simpleMessage("Show only"),
    "since": MessageLookupByLibrary.simpleMessage("depuis"),
    "someSettingsNotAvailableBecauseOffline": MessageLookupByLibrary.simpleMessage(
      "Certains paramètres ne sont pas disponibles car il n\'y a pas de connexion internet",
    ),
    "spec": MessageLookupByLibrary.simpleMessage("Spécial"),
    "specialfunction": MessageLookupByLibrary.simpleMessage(
      "Fonctions spéciales - ne changez que si vous savez ce que vous faites !",
    ),
    "speed": MessageLookupByLibrary.simpleMessage("vitesse"),
    "sponsors": MessageLookupByLibrary.simpleMessage("Nos sponsors"),
    "start": MessageLookupByLibrary.simpleMessage("Commence le"),
    "startLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Lieu de départ sans participation",
    ),
    "startLocationWithoutParticipatingInfo": MessageLookupByLibrary.simpleMessage(
      "Veuillez lire attentivement.\nCeci démarre l\'affichage de la position sur la carte sans participer au procession et transfère votre position au serveur pour calculer les temps. Vos amis dans le procession seront affichés. La durée du trajet entre le début et la fin du procession à partir de votre position sera calculée. En outre, votre vitesse et vos données de suivi seront enregistrées et vous pourrez les sauvegarder. N\'utilisez pas cette fonction si vous participez à la BladeNight. Le mode doit être arrêté manuellement.\nVous voulez démarrer ceci ?",
    ),
    "startNoParticipationShort": MessageLookupByLibrary.simpleMessage(
      "Montrez votre position",
    ),
    "startParticipation": MessageLookupByLibrary.simpleMessage(
      "Démarrer la participation",
    ),
    "startParticipationHeader": MessageLookupByLibrary.simpleMessage(
      "Tu participes aujourd\'hui à la BladeNight et tu souhaites soutenir la représentation du train et partager ton emplacement avec tes amis. Démarrer le partage de site ?",
    ),
    "startParticipationShort": MessageLookupByLibrary.simpleMessage(
      "Début de la participation",
    ),
    "startParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Démarrer la participation",
    ),
    "startPoint": MessageLookupByLibrary.simpleMessage(
      "Point de départ: München - Bavariapark",
    ),
    "startPointTitle": MessageLookupByLibrary.simpleMessage(
      "Où se situe le point de départ?",
    ),
    "startTime": MessageLookupByLibrary.simpleMessage("Heure de début"),
    "startTrackingOnly": MessageLookupByLibrary.simpleMessage(
      "Démarrer le journal de trajet",
    ),
    "startTrackingOnlyTitle": MessageLookupByLibrary.simpleMessage(
      "Démarre le journal de trajet sans envoyer de données au serveur",
    ),
    "startsIn": MessageLookupByLibrary.simpleMessage("Commence en"),
    "status": MessageLookupByLibrary.simpleMessage("Statut"),
    "status_active": MessageLookupByLibrary.simpleMessage("actif"),
    "status_inactive": MessageLookupByLibrary.simpleMessage("inactif"),
    "status_obsolete": MessageLookupByLibrary.simpleMessage("obsolète"),
    "status_pending": MessageLookupByLibrary.simpleMessage("en attente"),
    "stopLocationTracking": MessageLookupByLibrary.simpleMessage(
      "Stop location sharing ?",
    ),
    "stopLocationWithoutParticipating": MessageLookupByLibrary.simpleMessage(
      "Arrêter la localisation sans participer",
    ),
    "stopParticipationTracking": MessageLookupByLibrary.simpleMessage(
      "Arrêter le suivi de la participation",
    ),
    "stopTrackingTimeOut": m19,
    "submit": MessageLookupByLibrary.simpleMessage("Senden"),
    "symbols": MessageLookupByLibrary.simpleMessage("Symboles"),
    "tail": MessageLookupByLibrary.simpleMessage("Fin du procession"),
    "tellcode": m20,
    "thanksForParticipating": MessageLookupByLibrary.simpleMessage(
      "Merci d\'avoir participé",
    ),
    "timeIntl": m21,
    "timeOutDurationExceedTitle": MessageLookupByLibrary.simpleMessage(
      "Timeout - duration of BladeNight exceed",
    ),
    "timeStamp": MessageLookupByLibrary.simpleMessage("Timestamp"),
    "timeToFinish": MessageLookupByLibrary.simpleMessage("to finish (est.)"),
    "timeToFriend": MessageLookupByLibrary.simpleMessage("Le temps de amis"),
    "timeToHead": MessageLookupByLibrary.simpleMessage(
      "Le temps de procession Début",
    ),
    "timeToMe": MessageLookupByLibrary.simpleMessage("Le temps de moi"),
    "timeToTail": MessageLookupByLibrary.simpleMessage(
      "Le temps de fin du procession",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Aujourd\'hui"),
    "todayNo": MessageLookupByLibrary.simpleMessage("Non aujourd\'hui"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Demain"),
    "trackPointsExporting": MessageLookupByLibrary.simpleMessage(
      "Les points d\'itinéraire suivants seront exportés : ",
    ),
    "trackers": MessageLookupByLibrary.simpleMessage("Traceur"),
    "tracking": MessageLookupByLibrary.simpleMessage("data ok"),
    "trackingPoints": MessageLookupByLibrary.simpleMessage(
      "Points d\'itinéraire enregistrés",
    ),
    "trackingRestarted": MessageLookupByLibrary.simpleMessage(
      "Suivi du redémarrage",
    ),
    "trackingStoppedLowBat": m22,
    "train": MessageLookupByLibrary.simpleMessage("procession"),
    "trainlength": MessageLookupByLibrary.simpleMessage(
      "longueur du procession",
    ),
    "tryOpenAppSettings": MessageLookupByLibrary.simpleMessage(
      "Essayez d\'ouvrir les paramètres du système?",
    ),
    "understand": MessageLookupByLibrary.simpleMessage("Compris"),
    "unknown": MessageLookupByLibrary.simpleMessage("inconnu"),
    "unknownerror": MessageLookupByLibrary.simpleMessage("erreur inconnue"),
    "unreadMessage": MessageLookupByLibrary.simpleMessage("Message non lu"),
    "updating": MessageLookupByLibrary.simpleMessage("Mise à jour des données"),
    "userSpeed": MessageLookupByLibrary.simpleMessage("C\'est ma vitesse GPS"),
    "validatefriend": MessageLookupByLibrary.simpleMessage("Valider l\'ami"),
    "version": MessageLookupByLibrary.simpleMessage("Version:"),
    "visibleOnMap": MessageLookupByLibrary.simpleMessage("Montré sur la carte"),
    "waiting": MessageLookupByLibrary.simpleMessage("En attente..."),
    "waittime": MessageLookupByLibrary.simpleMessage("Temps d\'attente"),
    "wakelockDisabled": MessageLookupByLibrary.simpleMessage(
      "L\'écran s\'éteint",
    ),
    "wakelockEnabled": MessageLookupByLibrary.simpleMessage(
      "L\'écran reste allumé",
    ),
    "wakelockWarnBattery": m23,
    "warning": MessageLookupByLibrary.simpleMessage("Avertissement!"),
    "wasCanceledPleaseCheck": MessageLookupByLibrary.simpleMessage(
      "Est annulé ! Veuillez le vérifier sur https://bladenight-muenchen.de",
    ),
    "weekdayIntl": m24,
    "yes": MessageLookupByLibrary.simpleMessage("Oui"),
    "yesterday": MessageLookupByLibrary.simpleMessage("était hier"),
  };
}
