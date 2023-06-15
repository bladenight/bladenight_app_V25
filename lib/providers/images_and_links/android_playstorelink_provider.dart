import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String androidLinkImageAndLinkKey = 'androidLinkKey';
String _androidLinkImageAndLinkPrefJson =
    '{"key":"androidPlayStoreLink","image":"","link":"https://play.google.com/store/apps/details?id=de.bladenight.bladenight_app_flutter","text":"BladenightApp Android"}';

class AndroidAppStoreImageAndLink extends StateNotifier<ImageAndLink> {
  AndroidAppStoreImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(androidLinkImageAndLinkKey)?.toString() ??
                _androidLinkImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<AndroidAppStoreImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return AndroidAppStoreImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(androidLinkImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
