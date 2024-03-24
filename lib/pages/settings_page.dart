import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';
import 'package:wakelock/wakelock.dart';

import '../generated/l10n.dart';
import '../helpers/background_location_helper.dart';
import '../helpers/export_import_data_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../helpers/notification/toast_notification.dart';
import '../pages/widgets/app_id_widget.dart';
import '../pages/widgets/data_widget_left_right.dart';
import '../providers/location_provider.dart';
import '../providers/map/map_settings_provider.dart';
import '../providers/settings/me_color_provider.dart';
import '../providers/network_connection_provider.dart';
import '../providers/settings/dark_color_provider.dart';
import '../providers/settings/light_color_provider.dart';
import '../wamp/wamp_v2.dart';
import 'bladeguard/bladeguard_page.dart';
import 'widgets/one_signal_id_widget.dart';
import 'widgets/settings_invisible_offline.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
    });
  }

  var inputText = '';
  var _iconSize = HiveSettingsDB.iconSizeValue;
  bool _openInvisibleSettings = false;
  bool _exportLogInProgress = false;
  bool _exportTrackingInProgress = false;
  bool _showPushProgressIndicator = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var networkConnected = context.watch(networkAwareProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(Localize.of(context).settings),
              backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CupertinoFormSection(
                      header:
                          Text(Localize.of(context).bladeGuardSettingsTitle),
                      children: <Widget>[
                        CupertinoButton(
                          child: Text(Localize.of(context).bladeGuardSettings),
                          onPressed: () => {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const BladeGuardPage(),
                              ),
                            )
                          },
                        ),
                      ]),
                  //const VersionWidget(),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setMeColor),
                      children: <Widget>[
                        CupertinoListTile(
                          title: GestureDetector(
                            onTap: () async {
                              final Color colorBeforeDialog =
                                  ref.read(meColorProvider);
                              var res = await showColorPickerDialog(
                                  context, colorBeforeDialog);
                              ref
                                  .read(themePrimaryDarkColorProvider.notifier)
                                  .setColor(res);
                            },
                            child: Text(Localize.of(context).setcolor),
                          ),
                          trailing: ColorIndicator(
                            width: 20,
                            height: 20,
                            borderRadius: 22,
                            color: ref.watch(meColorProvider),
                            onSelectFocus: false,
                            onSelect: () async {
                              final Color colorBeforeDialog =
                                  ref.read(meColorProvider);
                              var res = await showColorPickerDialog(
                                  context, colorBeforeDialog);
                              ref.read(meColorProvider.notifier).setColor(res);
                            },
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setPrimaryColor),
                      children: <Widget>[
                        CupertinoListTile(
                          title: GestureDetector(
                            onTap: () async {
                              final Color colorBeforeDialog =
                                  ref.read(themePrimaryLightColorProvider);
                              var res = await showColorPickerDialog(
                                  context, colorBeforeDialog);
                              ref
                                  .read(themePrimaryLightColorProvider.notifier)
                                  .setColor(res);
                            },
                            child: Text(Localize.of(context).setcolor),
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
                              var res = await showColorPickerDialog(
                                  context, colorBeforeDialog);
                              ref
                                  .read(themePrimaryLightColorProvider.notifier)
                                  .setColor(res);
                              if (!context.mounted) return;
                              CupertinoAdaptiveTheme.of(context).setTheme(
                                  light: CupertinoThemeData(
                                      brightness: Brightness.light,
                                      primaryColor: res),
                                  dark: CupertinoThemeData(
                                    brightness: Brightness.dark,
                                    primaryColor: context
                                        .read(themePrimaryDarkColorProvider),
                                  ));
                            },
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setPrimaryDarkColor),
                      children: [
                        CupertinoListTile(
                          title: Text(Localize.of(context).setcolor),
                          trailing: ColorIndicator(
                            width: 20,
                            height: 20,
                            borderRadius: 22,
                            color: ref.watch(themePrimaryDarkColorProvider),
                            onSelectFocus: false,
                            onSelect: () async {
                              final Color colorBeforeDialog =
                                  ref.read(meColorProvider);
                              var res = await showColorPickerDialog(
                                  context, colorBeforeDialog);
                              ref
                                  .read(themePrimaryDarkColorProvider.notifier)
                                  .setColor(res);
                              if (!context.mounted) return;
                              CupertinoAdaptiveTheme.of(context).setTheme(
                                  light: CupertinoThemeData(
                                      brightness: Brightness.light,
                                      primaryColor: context.read(
                                          themePrimaryLightColorProvider)),
                                  dark: CupertinoThemeData(
                                    brightness: Brightness.dark,
                                    primaryColor: res,
                                  ));
                            },
                          ),
                        ),
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
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setIconSizeTitle),
                      children: <Widget>[
                        Text(
                            '${Localize.of(context).setIconSize} ${_iconSize.toStringAsFixed(0)} px'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSlider(
                                key: const Key('sliderIconSize'),
                                value: _iconSize,
                                divisions: 100,
                                min: 15.0,
                                max: 60,
                                activeColor: context.watch(meColorProvider),
                                thumbColor: context.watch(meColorProvider),
                                onChanged: (double value) {
                                  setState(() {
                                    _iconSize = value;
                                  });
                                },
                                onChangeEnd: ((val) =>
                                    HiveSettingsDB.setIconSizeValue(val)),
                              ),
                              const SizedBox(width: 10),
                              Center(
                                child: Icon(CupertinoIcons.circle_filled,
                                    size: _iconSize,
                                    color: context.watch(meColorProvider)),
                              ),
                            ]),
                      ]),

                  if (!kIsWeb)
                    CupertinoFormSection(
                        header: Text(Localize.of(context).showOwnTrack),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DataLeftRightContent(
                              descriptionLeft:
                                  Localize.of(context).showOwnTrack,
                              descriptionRight: '',
                              rightWidget: CupertinoSwitch(
                                onChanged: (val) {
                                  setState(() {
                                    context
                                        .read(showOwnTrackProvider.notifier)
                                        .setValue(val);
                                  });
                                },
                                value: context.watch(showOwnTrackProvider),
                              ),
                            ),
                          ),
                        ]),
                  if (!kIsWeb)
                    CupertinoFormSection(
                      header:
                          Text(Localize.of(context).exportUserTrackingHeader),
                      children: <Widget>[
                        CupertinoButton(
                            child: _exportTrackingInProgress
                                ? const CircularProgressIndicator()
                                : Text(Localize.of(context).exportUserTracking),
                            onPressed: () async {
                              if (_exportTrackingInProgress) return;
                              setState(() {
                                _exportTrackingInProgress = true;
                              });
                              await compute(
                                exportUserTracking,
                                LocationProvider.instance.userTrackingPoints,
                              ).then(
                                  (value) => shareExportedTrackingData(value));
                              _exportTrackingInProgress = false;

                              setState(() {});
                            }),
                      ],
                    ),
                  if (!kIsWeb)
                    CupertinoFormSection(
                        header: Text(Localize.of(context).resetOdoMeter),
                        children: <Widget>[
                          CupertinoButton(
                            child:
                                Text(Localize.of(context).resetOdoMeterTitle),
                            onPressed: () async {
                              await LocationProvider.instance
                                  .resetTrackPoints();
                              setState(() {});
                            },
                          ),
                        ]),
                  settingsInvisibleOfflineWidget(context),

                  if (!kIsWeb)
                    const SizedBox(
                      height: 15,
                    ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (kIsWeb) return;
                      setState(() {
                        _openInvisibleSettings = !_openInvisibleSettings;
                      });
                    },
                    onLongPress: () {
                      if (kIsWeb) return;
                      setState(() {
                        _openInvisibleSettings = !_openInvisibleSettings;
                      });
                    },
                    child: Column(
                      children: [
                        const AppIdWidget(),
                        const OneSignalIdWidget(),
                        if (networkConnected.connectivityStatus ==
                                ConnectivityStatus.online &&
                            !kIsWeb)
                          CupertinoFormSection(
                            header: Text(Localize.of(context)
                                .enableOnesignalPushMessageTitle),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context)
                                      .enableOnesignalPushMessage,
                                  descriptionRight: '',
                                  rightWidget: _showPushProgressIndicator
                                      ? const CircularProgressIndicator()
                                      : CupertinoSwitch(
                                          onChanged: (val) async {
                                            HiveSettingsDB
                                                .setPushNotificationsEnabled(
                                                    val);
                                            setState(() {
                                              _showPushProgressIndicator = true;
                                            });
                                            await OnesignalHandler
                                                    .setOneSignalChannels()
                                                .timeout(
                                                    const Duration(seconds: 20))
                                                .catchError((error) {
                                              BnLog.error(
                                                  text:
                                                      'error deactivating Push');
                                            });
                                            _showPushProgressIndicator = false;
                                            setState(() {});
                                          },
                                          value: HiveSettingsDB
                                              .pushNotificationsEnabled,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        if (!kIsWeb)
                          CupertinoFormSection(
                            header: Text(
                                Localize.of(context).fireBaseCrashlyticsHeader),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft:
                                      Localize.of(context).fireBaseCrashlytics,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    onChanged: (val) async {
                                      HiveSettingsDB.setChrashlyticsEnabled(
                                          val);
                                      setState(() {});
                                    },
                                    value: HiveSettingsDB.chrashlyticsEnabled,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!kIsWeb)
                          CupertinoFormSection(
                              header: Text(Localize.of(context).setSystem),
                              children: <Widget>[
                                CupertinoButton(
                                    child: Text(Localize.of(context)
                                        .openOperatingSystemSettings),
                                    onPressed: () => openAppSettings()),
                              ]),
                        if (Platform.isAndroid)
                          CupertinoFormSection(
                              header: Text(Localize.of(context)
                                  .ignoreBatteriesOptimisation),
                              children: <Widget>[
                                CupertinoButton(
                                    child: Text(Localize.of(context)
                                        .ignoreBatteriesOptimisationTitle),
                                    onPressed: () async =>
                                        await BackgroundGeolocationHelper
                                            .openBatteriesSettings()),
                              ]),
                        const SizedBox(height: 5),
                        CupertinoFormSection(
                          header: Text(Localize.of(context).exportLogData),
                          children: <Widget>[
                            _exportLogInProgress
                                ? const CircularProgressIndicator()
                                : CupertinoButton(
                                    child: Text(Localize.of(context)
                                        .setExportLogSupport),
                                    onPressed: () async {
                                      if (_exportLogInProgress) return;
                                      setState(() {
                                        _exportLogInProgress = true;
                                      });
                                      await exportLogs();
                                      setState(() {
                                        _exportLogInProgress = false;
                                      });
                                    }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _openInvisibleSettings,
                          child: Column(
                            children: [
                              CupertinoFormSection(
                                  header: Text(Localize.of(context).setLogData),
                                  children: <Widget>[
                                    CupertinoButton(
                                        child: Text(
                                            'Loglevel ${BnLog.getActiveLogLevel().name}'),
                                        onPressed: () async {
                                          await BnLog.showLogLevelDialog(
                                              context);
                                          setState(() {});
                                        }),
                                    CupertinoButton(
                                        child: Text(
                                            Localize.of(context).setClearLogs),
                                        onPressed: () async {
                                          final clickedButton =
                                              await FlutterPlatformAlert.showCustomAlert(
                                                  windowTitle: Localize
                                                      .current.clearLogsTitle,
                                                  text: Localize.current
                                                      .clearLogsQuestion,
                                                  positiveButtonTitle:
                                                      Localize.current.yes,
                                                  neutralButtonTitle:
                                                      Localize.current.cancel,
                                                  windowPosition:
                                                      AlertWindowPosition
                                                          .screenCenter,
                                                  options:
                                                      FlutterPlatformAlertOption(
                                                          preferMessageBoxOnWindows:
                                                              true,
                                                          showAsLinksOnWindows:
                                                              true));
                                          if (clickedButton ==
                                              CustomButton.positiveButton) {
                                            BnLog.clearLogs();
                                            showToast(
                                                message:
                                                    Localize.current.finished);
                                          }
                                        }),
                                  ]),
                              if (HiveSettingsDB
                                      .useAlternativeLocationProvider ==
                                  false)
                                CupertinoFormSection(
                                    header: const Text('Geolocation Log'),
                                    children: <Widget>[
                                      CupertinoButton(
                                          child: Text(Localize.of(context)
                                              .setExportLogSupport),
                                          onPressed: () =>
                                              exportBgLocationLogs()),
                                      CupertinoButton(
                                          child: Text(Localize.of(context)
                                              .setClearLogs),
                                          onPressed: () async {
                                            final clickedButton =
                                                await FlutterPlatformAlert.showCustomAlert(
                                                    windowTitle: Localize
                                                        .current.clearLogsTitle,
                                                    text: Localize.current
                                                        .clearLogsQuestion,
                                                    positiveButtonTitle:
                                                        Localize.current.yes,
                                                    neutralButtonTitle:
                                                        Localize.current.cancel,
                                                    windowPosition:
                                                        AlertWindowPosition
                                                            .screenCenter,
                                                    options: FlutterPlatformAlertOption(
                                                        preferMessageBoxOnWindows:
                                                            true,
                                                        showAsLinksOnWindows:
                                                            true));
                                            if (clickedButton ==
                                                CustomButton.positiveButton) {
                                              bg.Logger.destroyLog();
                                              showToast(
                                                  message: Localize
                                                      .current.finished);
                                            }
                                          }),
                                    ]),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Localize.of(context).specialfunction,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        backgroundColor:
                                            CupertinoColors.activeOrange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              CupertinoFormSection(
                                  header: Text(
                                      Localize.of(context).allowWakeLockHeader),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DataLeftRightContent(
                                        descriptionLeft:
                                            Localize.of(context).allowWakeLock,
                                        descriptionRight: '',
                                        rightWidget: CupertinoSwitch(
                                          onChanged: (val) {
                                            HiveSettingsDB.setWakeLockEnabled(
                                                val);
                                            Wakelock.toggle(enable: val);
                                            setState(() {});
                                          },
                                          value: HiveSettingsDB.wakeLockEnabled,
                                        ),
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 15,
                              ),
                              CupertinoFormSection(
                                  header: Text(Localize.of(context)
                                      .fitnessPermissionSettingsText),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DataLeftRightContent(
                                        descriptionLeft: Localize.of(context)
                                            .fitnessPermissionSwitchSettingsText,
                                        descriptionRight: '',
                                        rightWidget: CupertinoSwitch(
                                          onChanged: (val) {
                                            HiveSettingsDB
                                                .setIsMotionDetectionDisabled(
                                                    val);
                                            bg.BackgroundGeolocation.setConfig(
                                                bg.Config(
                                                    disableMotionActivityUpdates:
                                                        val));
                                            setState(() {});
                                          },
                                          value: HiveSettingsDB
                                              .isMotionDetectionDisabled,
                                        ),
                                      ),
                                    ),
                                  ]),
                              //if (Platform.isAndroid)
                              CupertinoFormSection(
                                  header: Text(Localize.of(context)
                                      .alternativeLocationProviderTitle),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DataLeftRightContent(
                                        descriptionLeft: Localize.of(context)
                                            .alternativeLocationProvider,
                                        descriptionRight: '',
                                        rightWidget: CupertinoSwitch(
                                          onChanged: (val) {
                                            HiveSettingsDB
                                                .setUseAlternativeLocationProvider(
                                                    val);
                                            setState(() {});
                                          },
                                          value: HiveSettingsDB
                                              .useAlternativeLocationProvider,
                                        ),
                                      ),
                                    ),
                                  ]),
                              CupertinoFormSection(
                                  header:
                                      Text(Localize.of(context).openStreetMap),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DataLeftRightContent(
                                        descriptionLeft: Localize.of(context)
                                            .openStreetMapText,
                                        descriptionRight: '',
                                        rightWidget: CupertinoSwitch(
                                          onChanged: (val) {
                                            MapSettings.setOpenStreetMapEnabled(
                                                val);
                                            setState(() {});
                                          },
                                          value:
                                              MapSettings.openStreetMapEnabled,
                                        ),
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              CupertinoFormSection(
                                  header: const Text('Testing only'),
                                  children: <Widget>[
                                    const Text('Server'),
                                    CupertinoTextFormFieldRow(
                                      placeholder: 'server address',
                                      showCursor: true,
                                      initialValue:
                                          HiveSettingsDB.customServerAddress,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        HiveSettingsDB.setCustomServerAddress(
                                            value);
                                      },
                                      onSaved: (inputText) =>
                                          HiveSettingsDB.setCustomServerAddress(
                                              inputText),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DataLeftRightContent(
                                        descriptionLeft: 'Custom Server',
                                        descriptionRight: '',
                                        rightWidget: CupertinoSwitch(
                                          onChanged: (val) {
                                            WampV2.instance.closeAndReconnect();
                                            HiveSettingsDB.setUseCustomServer(
                                                val);
                                            setState(() {});
                                          },
                                          value: HiveSettingsDB.useCustomServer,
                                        ),
                                      ),
                                    ),
                                  ]),
                              CupertinoFormSection(
                                  header: Text(
                                      Localize.of(context).setexportDataHeader),
                                  children: <Widget>[
                                    CupertinoButton(
                                        child: Text(Localize.of(context)
                                            .setexportIdAndFriends),
                                        onPressed: () => exportData(context)),
                                  ]),
                              CupertinoFormSection(
                                header: Text(Localize.current.import),
                                children: <Widget>[
                                  CupertinoTextFormFieldRow(
                                    controller: _textController,
                                    placeholder: Localize.of(context)
                                        .setInsertImportDataset,
                                    autocorrect: false,
                                    prefix: inputText.length > 10
                                        ? const Icon(Icons.save)
                                        : null,
                                    maxLines: 4,
                                    onChanged: (value) {
                                      setState(() {
                                        inputText = value;
                                      });
                                    },
                                    onFieldSubmitted: (value) {
                                      importData(value);
                                    },
                                  ),
                                  AnimatedOpacity(
                                    // If the widget is visible, animate to 0.0 (invisible).
                                    // If the widget is hidden, animate to 1.0 (fully visible).
                                    opacity: inputText.length > 10 ? 1.0 : 0.2,
                                    duration: const Duration(milliseconds: 500),
                                    // The green box must be a child of the AnimatedOpacity widget.
                                    child: CupertinoButton(
                                      child: Text(
                                          Localize.of(context).setStartImport),
                                      onPressed: () {
                                        inputText.length > 10
                                            ? importData(inputText)
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
