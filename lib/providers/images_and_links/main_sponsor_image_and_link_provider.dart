import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String mainSponsorImageAndLinkKey = 'mainSponsorImageAndLinkKey';
String _mainSponsorImageAndLinkPrefJson =
    '{"key":"mainSponsorLogo","image":"https://bladenight.app/main_sponsor.png","link":"","text":"t"}';

class MainSponsorImageAndLink extends StateNotifier<ImageAndLink> {
  MainSponsorImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(mainSponsorImageAndLinkKey)?.toString() ??
                _mainSponsorImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<MainSponsorImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return MainSponsorImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(mainSponsorImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
