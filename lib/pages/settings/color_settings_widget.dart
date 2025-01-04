import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/app_constants.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../providers/settings/dark_color_provider.dart';
import '../../providers/settings/light_color_provider.dart';
import '../../providers/settings/me_color_provider.dart';
import '../widgets/common_widgets/data_widget_left_right.dart';

class ColorSettingsWidget extends ConsumerStatefulWidget {
  const ColorSettingsWidget({super.key});

  @override
  ConsumerState<ColorSettingsWidget> createState() => _ColorSettingsState();
}

class _ColorSettingsState extends ConsumerState<ColorSettingsWidget> {
  var _iconSize = HiveSettingsDB.iconSizeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoFormSection(
            header: Text(Localize.of(context).setMeColor),
            children: <Widget>[
              CupertinoListTile(
                title: GestureDetector(
                  onTap: () async {
                    final Color colorBeforeDialog = ref.read(meColorProvider);
                    var res =
                        await showColorPickerDialog(context, colorBeforeDialog);
                    ref
                        .read(themePrimaryDarkColorProvider.notifier)
                        .setColor(res);
                  },
                  child: Text(Localize.of(context).changeMeColor),
                ),
                trailing: ColorIndicator(
                  width: 20,
                  height: 20,
                  borderRadius: 22,
                  color: ref.watch(meColorProvider),
                  onSelectFocus: false,
                  onSelect: () async {
                    final Color colorBeforeDialog = ref.read(meColorProvider);
                    var res =
                        await showColorPickerDialog(context, colorBeforeDialog);
                    ref.read(meColorProvider.notifier).setColor(res);
                  },
                ),
              ),
            ]),
        CupertinoFormSection(
            header: Text(Localize.of(context).changeLightColor),
            children: <Widget>[
              CupertinoListTile(
                title: GestureDetector(
                  onTap: () async {
                    final Color colorBeforeDialog =
                        ref.read(themePrimaryLightColorProvider);
                    var res =
                        await showColorPickerDialog(context, colorBeforeDialog);
                    ref
                        .read(themePrimaryLightColorProvider.notifier)
                        .setColor(res);
                  },
                  child: Text(Localize.of(context).changeLightColor),
                ),
                trailing: ColorIndicator(
                  width: 20,
                  height: 20,
                  borderRadius: 22,
                  color: ref.watch(themePrimaryLightColorProvider),
                  onSelectFocus: false,
                  onSelect: () async {
                    final Color colorBeforeDialog =
                        ref.read(themePrimaryLightColorProvider);
                    var res =
                        await showColorPickerDialog(context, colorBeforeDialog);
                    ref
                        .read(themePrimaryLightColorProvider.notifier)
                        .setColor(res);
                    if (!context.mounted) return;
                    CupertinoAdaptiveTheme.of(context).setTheme(
                        light: CupertinoThemeData(
                            brightness: Brightness.light,
                            primaryColor: res,
                            primaryContrastingColor:
                                res.withValues(alpha: primaryContrastingAlpha)),
                        dark: CupertinoThemeData(
                          brightness: Brightness.dark,
                          primaryColor: ref.read(themePrimaryDarkColorProvider),
                          primaryContrastingColor: ref
                              .read(themePrimaryDarkColorProvider)
                              .withValues(alpha: primaryContrastingAlpha),
                        ));
                  },
                ),
              ),
            ]),
        CupertinoFormSection(
            header: Text(Localize.of(context).setPrimaryDarkColor),
            children: [
              CupertinoListTile(
                title: Text(Localize.of(context).changeDarkColor),
                trailing: ColorIndicator(
                  width: 20,
                  height: 20,
                  borderRadius: 22,
                  color: ref.watch(themePrimaryDarkColorProvider),
                  onSelectFocus: false,
                  onSelect: () async {
                    final Color colorBeforeDialog = ref.read(meColorProvider);
                    var res =
                        await showColorPickerDialog(context, colorBeforeDialog);
                    ref
                        .read(themePrimaryDarkColorProvider.notifier)
                        .setColor(res);
                    if (!context.mounted) return;
                    CupertinoAdaptiveTheme.of(context).setTheme(
                        light: CupertinoThemeData(
                            brightness: Brightness.light,
                            primaryColor:
                                ref.read(themePrimaryLightColorProvider),
                            primaryContrastingColor: ref
                                .read(themePrimaryLightColorProvider)
                                .withValues(alpha: primaryContrastingAlpha)),
                        dark: CupertinoThemeData(
                          brightness: Brightness.dark,
                          primaryColor: res,
                          primaryContrastingColor:
                              res.withValues(alpha: primaryContrastingAlpha),
                        ));
                  },
                ),
              ),
            ]),
        CupertinoFormSection(
            header: Text(Localize.of(context).setIconSizeTitle),
            children: <Widget>[
              Text(
                  '${Localize.of(context).setIconSize} ${_iconSize.toStringAsFixed(0)} px'),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CupertinoSlider(
                  key: const Key('sliderIconSize'),
                  value: _iconSize,
                  divisions: 100,
                  min: 15.0,
                  max: 60,
                  activeColor: ref.watch(meColorProvider),
                  thumbColor: ref.watch(meColorProvider),
                  onChanged: (double value) {
                    setState(() {
                      _iconSize = value;
                    });
                  },
                  onChangeEnd: ((val) => HiveSettingsDB.setIconSizeValue(val)),
                ),
                const SizedBox(width: 10),
                Center(
                  child: Icon(CupertinoIcons.circle_filled,
                      size: _iconSize, color: ref.watch(meColorProvider)),
                ),
              ]),
            ]),
        CupertinoFormSection(
            header: Text(Localize.of(context).setDarkModeTitle),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DataLeftRightContent(
                  descriptionLeft: Localize.of(context).setDarkMode,
                  descriptionRight: '',
                  rightWidget: CupertinoSwitch(
                    activeTrackColor: CupertinoTheme.of(context).primaryColor,
                    onChanged: (val) async {
                      if (val) {
                        setState(() {
                          HiveSettingsDB.setAdaptiveThemeMode(
                              AdaptiveThemeMode.dark);
                        });
                        CupertinoAdaptiveTheme.of(context).setDark();
                      } else {
                        setState(() {
                          HiveSettingsDB.setAdaptiveThemeMode(
                              AdaptiveThemeMode.light);
                        });
                        CupertinoAdaptiveTheme.of(context).setLight();
                      }
                    },
                    value: HiveSettingsDB.adaptiveThemeMode ==
                        AdaptiveThemeMode.dark,
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
