import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/app_server_config_db.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'rest_api_link_provider.g.dart';

@riverpod
class RestApiLink extends _$RestApiLink {
  @override
  ImageAndLink build() {
    var listener = ServerConfigDb.serverConfigBox
        .watch(key: ServerConfigDb.restApiLinkKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return ServerConfigDb.restApiLinkConfig;
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(ServerConfigDb.restApiLinkKey, imageAndLink);
    //state = imageAndLink;
  }
}
