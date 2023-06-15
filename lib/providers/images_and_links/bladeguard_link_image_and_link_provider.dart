import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String bladeguardLinkImageAndLinkKey = 'bladeguardLinkKey';
String _bladeguardLinkImageAndLinkPrefJson =
    '{"key":"bladeguardLink","image":"","link":"https://bladenight-muenchen.de/blade-guards/#anmelden","text":"Bladeguard"}';

class BladeguardLinkImageAndLink extends StateNotifier<ImageAndLink> {
  BladeguardLinkImageAndLink(this.pref)
      : super(ImageAndLinkMapper.fromJson(
            pref?.getString(bladeguardLinkImageAndLinkKey)?.toString() ??
                _bladeguardLinkImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<BladeguardLinkImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return BladeguardLinkImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(bladeguardLinkImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
