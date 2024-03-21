import 'package:dart_mappable/dart_mappable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'live_map_image_and_link_provider.g.dart';

String liveMapImageAndLinkKey = 'liveMapIalKey';
ImageAndLink _defaultLiveMap = ImageAndLink('', 'https://bladenight-muenchen.de/bladenight-live-karte/', 'Live Karte', 'liveMapLink');

@riverpod
class LiveMapImageAndLink extends _$LiveMapImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: liveMapImageAndLinkKey)
        .listen((event) => state =
        MapperContainer.globals.fromJson<ImageAndLink>(event.value));
    return HiveSettingsDB.settingsHiveBox.get(liveMapImageAndLinkKey,
        defaultValue: _defaultLiveMap);
  }

  void setValue(ImageAndLink imageAndLink) {
    var storedVal = HiveSettingsDB.settingsHiveBox.get(liveMapImageAndLinkKey);
    if (storedVal != null) {
      if (storedVal.hashCode == imageAndLink.hashCode) return;
    }

    HiveSettingsDB.settingsHiveBox.put(liveMapImageAndLinkKey,
        MapperContainer.globals.toJson(imageAndLink));
    //state = imageAndLink;
  }
}

