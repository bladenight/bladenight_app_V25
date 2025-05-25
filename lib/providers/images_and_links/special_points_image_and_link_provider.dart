import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'special_points_image_and_link_provider.g.dart';

String specialPointsImageAndLinkKey = 'specialPointsIalDbKey';
ImageAndLink _defaultSpecialPoints = ImageAndLink(
    '',
    '',
    '{"spp":['
        '{"lat":48.098390,"lon":11.508354,"url":"https://bladenight.app/images/skatemunich_child_orange_circle.png","des":"Sammelstopp"},' //Süd Höglwörther
        '{"lat":48.12308,"lon":11.56730,"url":"https://bladenight.app/images/skatemunich_child_orange_circle.png","des":"Sammelstopp"},' //Ost Wittelsbacher
        '{"lat":48.15726,"lon":11.58417,"url":"https://bladenight.app/images/skatemunich_child_orange_circle.png","des":"Sammelstopp"}' //Nord Leopold
        ']'
        '}',
    'specialPoints');

@riverpod
class SpecialPointsImageAndLink extends _$SpecialPointsImageAndLink {
  @override
  ImageAndLink build() {
    var listener = HiveSettingsDB.settingsHiveBox
        .watch(key: specialPointsImageAndLinkKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.settingsHiveBox
        .get(specialPointsImageAndLinkKey, defaultValue: _defaultSpecialPoints);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(specialPointsImageAndLinkKey, imageAndLink);
    //state = imageAndLink;
  }
}
