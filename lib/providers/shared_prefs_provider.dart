import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../models/color_mapper.dart';

final sharedPrefs = FutureProvider<SharedPreferences>((_) async {
  return await SharedPreferences.getInstance()
      // ignore: invalid_return_type_for_catch_error
      .catchError((error) => print(error));
});

const String meColorKey = 'meColorSetting';

class MeColor extends StateNotifier<Color> {
  MeColor(this.pref)
      : super(pref?.getString(meColorKey)?.toColor() ?? meDefaultColor);

  final SharedPreferences? pref;

  static final provider = StateNotifierProvider<MeColor, Color>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return MeColor(pref);
  });

  void setColor(Color color) {
    state = color;
    pref!.setString(meColorKey, color.toHexString());
  }
}

const String themePrimaryColorKey = 'primaryColorSetting';

///Set foreground color for texts and map track in app
class ThemePrimaryColor extends StateNotifier<Color> {
  ThemePrimaryColor(this.pref)
      : super(pref?.getString(themePrimaryColorKey)?.toColor() ??
            systemPrimaryDefaultColor);

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<ThemePrimaryColor, Color>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return ThemePrimaryColor(pref);
  });

  void setColor(Color color) {
    state = color;
    pref!.setString(themePrimaryColorKey, color.toHexString());
  }
}

const String themePrimaryDarkColorKey = 'primaryColorDarkSetting';

///Set foreground color in dark mode for texts and map track in app
class ThemePrimaryDarkColor extends StateNotifier<Color> {
  ThemePrimaryDarkColor(this.pref)
      : super(pref?.getString(themePrimaryDarkColorKey)?.toColor() ??
            systemPrimaryDarkDefaultColor);

  final SharedPreferences? pref;

  static final provider =
      StateNotifierProvider<ThemePrimaryDarkColor, Color>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return ThemePrimaryDarkColor(pref);
  });

  void setColor(Color color) {
    state = color;
    pref!.setString(themePrimaryDarkColorKey, color.toHexString());
  }
}

const String showOwnTrackKey = 'showOwnTrackSetting';

///Show own tracklayer on map during tracking
class ShowOwnTrack extends StateNotifier<bool> {
  ShowOwnTrack(this.pref) : super(pref?.getBool(showOwnTrackKey) ?? true);

  final SharedPreferences? pref;

  static final provider = StateNotifierProvider<ShowOwnTrack, bool>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return ShowOwnTrack(pref);
  });

  void setValue(bool value) {
    state = value;
    pref!.setBool(showOwnTrackKey, value);
  }
}

///Set as Head of procession
class IsHeadOfProcession extends ChangeNotifier {
  bool isSpecialHead = HiveSettingsDB.isSpecialHead;

  void setValue(bool value) async {
    HiveSettingsDB.setwantSeeFullOfProcession(value);
    isSpecialHead = value;
    notifyListeners();
  }
}

///Set as Head of procession
class IsTailOfProcession extends ChangeNotifier {
  bool isSpecialTail = HiveSettingsDB.isSpecialTail;

  void setValue(bool value) async {
    HiveSettingsDB.setwantSeeFullOfProcession(value);
    isSpecialTail = value;
    notifyListeners();
  }
}

///Set as Head of procession
class WantSeeFullOfProcession extends ChangeNotifier {
  bool wantSeeFullOfProcession = HiveSettingsDB.wantSeeFullOfProcession;

  void setValue(bool value) async {
    HiveSettingsDB.setwantSeeFullOfProcession(value);
    wantSeeFullOfProcession = value;
    notifyListeners();
  }
}
