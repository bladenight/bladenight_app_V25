import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String iosLinkImageAndLinkKey = 'iosLinkKey';
String _iosLinkImageAndLinkPrefJson =
    '{"key":"iOSAppStoreLink","image":"","link":"https://apps.apple.com/de/app/bladenight-vorab/id1629988473","text":"BladenightApp iOS"}';

class IosAppStoreImageAndLink extends StateNotifier<ImageAndLink> {
  IosAppStoreImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(iosLinkImageAndLinkKey)?.toString() ??
                _iosLinkImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<IosAppStoreImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return IosAppStoreImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(iosLinkImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
