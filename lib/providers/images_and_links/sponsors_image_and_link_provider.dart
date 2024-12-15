import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'sponsors_image_and_link_provider.g.dart';

String sponsorsImageAndLinkKey = 'sponsorsIalDbKey';
ImageAndLink _defaultSponsors = ImageAndLink(
    '',
    '',
    '{ "spo": ['
        '{'
        '"rem": "Skatemunich", '
        '"img": "skatemunich_logo.png",'
        '"des": "Skatemunich e.V. Sportverein", '
        '"ilk": "https://bladenight.app/images/logos/skatemunich.png",'
        '"url": "https://skatemunich.de", '
        '"idx": 0'
        '}]}',
    'sponsors');

@riverpod
class SponsorsImageAndLink extends _$SponsorsImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: sponsorsImageAndLinkKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.settingsHiveBox
        .get(sponsorsImageAndLinkKey, defaultValue: _defaultSponsors);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox.put(sponsorsImageAndLinkKey, imageAndLink);
    //state = imageAndLink;
  }
}
