import 'dart:core';

import 'package:hive_flutter/adapters.dart';

import '../../app_settings/app_constants.dart';
import '../../app_settings/server_connections.dart';
import '../../models/image_and_link.dart';

class ServerConfigDb {
  static final ImageAndLink _restApiLinkIal = ImageAndLink('',
      defaultBladenightRestApiServerLink, defaultApiCryptoPass, 'restApiLink');

  static final ServerConfigDb instance = ServerConfigDb._();

  ServerConfigDb._();

  static const String restApiLinkKey = 'restApiUrlIalKey';

  static get serverConfigBox {
    return _appServerConfigBox;
  }

  static get _appServerConfigBox {
    return Hive.box(hiveBoxServerConfigDBName);
  }

  static ImageAndLink get restApiLinkConfig {
    return _appServerConfigBox.get(restApiLinkKey,
        defaultValue: _restApiLinkIal);
  }

  static void setRestApiLinkConfig(ImageAndLink imageAndLink) {
    _appServerConfigBox.put(restApiLinkKey, imageAndLink);
  }

  static String get _restApiLink {
    if (restApiLinkConfig.link != null) {
      return restApiLinkConfig.link!;
    }
    return defaultBladenightRestApiServerLink;
  }

  static String get restApiLinkBg {
    return '$_restApiLink/bg';
  }

  static String get restApiLinkMsg {
    return '$_restApiLink/msg';
  }

  static String get restApiLinkPassword {
    if (restApiLinkConfig.text != null) {
      return restApiLinkConfig.text!;
    }
    return defaultApiCryptoPass;
  }
}
