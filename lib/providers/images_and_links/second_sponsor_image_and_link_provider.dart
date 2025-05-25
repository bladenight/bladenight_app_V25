import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'second_sponsor_image_and_link_provider.g.dart';

String secondSponsorImageAndLinkKey = 'secondSponsorIalKey';
ImageAndLink _defaultSecondSponsor = ImageAndLink(
    'https://bladenight.app/skatemunich.png', '', '', 'secondLogo');

@riverpod
class SecondSponsorImageAndLink extends _$SecondSponsorImageAndLink {
  @override
  ImageAndLink build() {
    var listener = HiveSettingsDB.settingsHiveBox
        .watch(key: secondSponsorImageAndLinkKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.settingsHiveBox
        .get(secondSponsorImageAndLinkKey, defaultValue: _defaultSecondSponsor);
  }

  void setValue(ImageAndLink imageAndLink) {
    var oldVal =
        HiveSettingsDB.settingsHiveBox.get(secondSponsorImageAndLinkKey);
    if (oldVal != imageAndLink) {
      HiveSettingsDB.settingsHiveBox
          .put(secondSponsorImageAndLinkKey, imageAndLink);
    }
  }
}
