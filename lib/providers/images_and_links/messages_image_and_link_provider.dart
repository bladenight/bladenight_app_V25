import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String bnMessageImageAndLinkKey = 'bnMessageKey';
String _bnMessageImageAndLinkPrefJson =
    '{"key":"bnMessage","image":"","link":"https://bladenight.app/messages/","text":""}';

class BnMessageImageAndLink extends StateNotifier<ImageAndLink> {
  BnMessageImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(bnMessageImageAndLinkKey)?.toString() ??
                _bnMessageImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<BnMessageImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return BnMessageImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(bnMessageImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
