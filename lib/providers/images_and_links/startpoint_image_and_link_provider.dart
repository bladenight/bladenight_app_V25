import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'startpoint_image_and_link_provider.g.dart';

String startpointImageAndLinkKey = 'startpointIalKey';
ImageAndLink _defaultStartpoint = ImageAndLink(
    'https://bladenight.app/skatemunich.png',
    '',
    'Schwanthalerhöhe\\nMünchen\\n(Deutsches Verkehrsmuseum)',
    'startPoint');

@riverpod
class StartpointImageAndLink extends _$StartpointImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: startpointImageAndLinkKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.settingsHiveBox
        .get(startpointImageAndLinkKey, defaultValue: _defaultStartpoint);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(startpointImageAndLinkKey, (imageAndLink));
    //state = imageAndLink;
  }
}
