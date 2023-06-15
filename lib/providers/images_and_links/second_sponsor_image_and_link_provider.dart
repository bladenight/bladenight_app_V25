
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String secondSponsorImageAndLinkKey ='secondSponsorImageAndLinkKey';
String _secondSponsorImageAndLinkPrefJson='{"key":"secondLogo","image":"https://bladenight.app/skatemunich.png","link":""}';

class SecondSponsorImageAndLink extends StateNotifier<ImageAndLink> {
  SecondSponsorImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(pref?.getString(secondSponsorImageAndLinkKey)?.toString() ?? _secondSponsorImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider = StateNotifierProvider<SecondSponsorImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () =>  null,
        );
    return  SecondSponsorImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(secondSponsorImageAndLinkKey,MapperContainer.globals.toJson(imageAndLink));
  }
}