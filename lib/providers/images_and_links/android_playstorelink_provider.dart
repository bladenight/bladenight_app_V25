import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'android_playstorelink_provider.g.dart';

String androidIalKey = 'androidPlayStoreIalKey';
ImageAndLink _defaultAndroidIal = ImageAndLink(
    '', playStoreLink, 'BladenightPlay Android', 'androidPlayStoreLink');

@riverpod
class AndroidPlaystoreImageAndLink extends _$AndroidPlaystoreImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: androidIalKey)
        .listen((event) => state = event.value);
    return  HiveSettingsDB.settingsHiveBox
        .get(androidIalKey, defaultValue: _defaultAndroidIal);

  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox.put(androidIalKey, imageAndLink);
    //state = imageAndLink;
  }
}
