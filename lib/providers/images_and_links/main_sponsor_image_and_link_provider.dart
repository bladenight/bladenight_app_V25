import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'main_sponsor_image_and_link_provider.g.dart';

String mainSponsorImageAndLinkKey = 'mainSponsorIalKey';
ImageAndLink _defaultLiveMapImageAndLinkKey = ImageAndLink(
    'https://bladenight.app/main_sponsor.png', '', '', 'mainSponsorLogo');

@riverpod
class MainSponsorImageAndLink extends _$MainSponsorImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: mainSponsorImageAndLinkKey)
        .listen((event) => state =
            event.value);
    return HiveSettingsDB.settingsHiveBox.get(mainSponsorImageAndLinkKey,
        defaultValue: _defaultLiveMapImageAndLinkKey);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox.put(mainSponsorImageAndLinkKey,imageAndLink);
    //state = imageAndLink;
  }
}
