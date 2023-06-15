import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../models/image_and_link.dart';
import '../shared_prefs_provider.dart';

String startPointImageAndLinkKey = 'startPointKey';
String _startPointImageAndLinkPrefJson =
    '{"key":"startPoint","image":"","link":"","text":"Schwanthalerhöhe\\nMünchen\\n(Deutsches Verkehrsmuseum)"}';

class StartPointImageAndLink extends StateNotifier<ImageAndLink> {
  StartPointImageAndLink(this.pref)
      : super(MapperContainer.globals.fromJson(
            pref?.getString(startPointImageAndLinkKey)?.toString() ??
                _startPointImageAndLinkPrefJson));

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<StartPointImageAndLink, ImageAndLink>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return StartPointImageAndLink(pref);
  });

  void setValue(ImageAndLink imageAndLink) {
    state = imageAndLink;
    pref!.setString(startPointImageAndLinkKey, MapperContainer.globals.toJson(imageAndLink));
  }
}
