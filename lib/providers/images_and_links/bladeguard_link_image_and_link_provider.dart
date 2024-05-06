import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'bladeguard_link_image_and_link_provider.g.dart';

String bladeguardImageAndLinkKey = 'bladeguardIalKey';
ImageAndLink _defaultBladeguard = ImageAndLink(
    'https://bladenight.app/skatemunich.png',
    'https://bladenight-muenchen.de/blade-guards/#anmelden',
    'Bladeguard',
    'bladeguardLink');

@riverpod
class BladeguardImageAndLink extends _$BladeguardImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: bladeguardImageAndLinkKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.settingsHiveBox
        .get(bladeguardImageAndLinkKey, defaultValue: _defaultBladeguard);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(bladeguardImageAndLinkKey, imageAndLink);
    //state = imageAndLink;
  }
}
