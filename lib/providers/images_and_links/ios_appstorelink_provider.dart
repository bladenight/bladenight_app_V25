import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'ios_appstorelink_provider.g.dart';

String iosIalKey = 'iosAppStoreIalKey';
ImageAndLink _defaultIosIal = ImageAndLink('', 'https://apps.apple.com/de/app/bladenight-vorab/id1629988473', 'BladenightApp iOS', 'iOSAppStoreLink');


@riverpod
class IosAppstoreImageAndLink extends _$IosAppstoreImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: iosIalKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.settingsHiveBox
        .get(iosIalKey, defaultValue: _defaultIosIal);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(iosIalKey, imageAndLink);
    //state = imageAndLink;
  }
}

