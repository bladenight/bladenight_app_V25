import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String liveMapImageAndLinkKey = 'liveMapKey';
String _liveMapImageAndLinkPrefJson =
    '{"key":"liveMapLink","image":"","link":"https://bladenight-muenchen.de/bladenight-live-karte/","text":"Live Karte"}';

class LiveMapImageAndLink extends StateNotifier<ImageAndLink> {
  LiveMapImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(liveMapImageAndLinkKey)?.toString() ??
                _liveMapImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<LiveMapImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return LiveMapImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    var prefval = pref!.getString(liveMapImageAndLinkKey);
    if (prefval != null) {
      var oldval = MapperContainer.globals.fromJson<ImageAndLink>(prefval);
      if (oldval.hashCode == imageAndLink.hashCode) return;
    }
    state = imageAndLink;
    pref!.setString(liveMapImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
