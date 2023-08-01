import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:f_logs/f_logs.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';
import 'package:wakelock/wakelock.dart';

import '../app_settings/globals.dart';
import '../generated/l10n.dart';
import '../helpers/background_location_helper.dart';
import '../helpers/export_import_data_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger_helper.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../helpers/notification/toast_notification.dart';
import '../pages/widgets/app_id_widget.dart';
import '../pages/widgets/data_widget_left_right.dart';
import '../pages/widgets/fast_custom_color_picker.dart';
import '../pages/widgets/password_input.dart';
import '../providers/location_provider.dart';
import '../providers/network_connection_provider.dart';
import '../providers/shared_prefs_provider.dart';
import '../wamp/wamp_v2.dart';
import 'widgets/one_signal_id_widget.dart';
import 'widgets/settings_invisible_offline.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var inputText = '';
  var _iconSize = HiveSettingsDB.iconSizeValue;
  bool _openInvisibleSettings = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var networkConnected = context.watch(networkAwareProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(Localize.of(context).settings),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //const VersionWidget(),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setMeColor),
                      children: <Widget>[
                        FittedBox(
                          child: FastCustomColorPicker(
                            selectedColor: context.watch(MeColor.provider),
                            onColorSelected: (color) {
                              setState(() {
                                context
                                    .read(MeColor.provider.notifier)
                                    .setColor(color);
                              });
                            },
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setPrimaryColor),
                      children: <Widget>[
                        FittedBox(
                          child: FastCustomColorPicker(
                            selectedColor:
                                context.watch(ThemePrimaryColor.provider),
                            onColorSelected: (color) {
                              setState(() {
                                context
                                    .read(ThemePrimaryColor.provider.notifier)
                                    .setColor(color);
                              });
                              CupertinoAdaptiveTheme.of(context).setTheme(
                                light: CupertinoThemeData(
                                    brightness: Brightness.light,
                                    primaryColor: color),
                                dark: CupertinoThemeData(
                                  brightness: Brightness.dark,
                                  primaryColor: context
                                      .read(ThemePrimaryDarkColor.provider),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).setPrimaryDarkColor),
                      children: <Widget>[
                        FittedBox(
                          child: FastCustomColorPicker(
                            selectedColor:
                                context.watch(ThemePrimaryDarkColor.provider),
                            onColorSelected: (color) {
                              setState(() {
                                context
                                    .read(
                                        ThemePrimaryDarkColor.provider.notifier)
                                    .setColor(color);
                              });
                              CupertinoAdaptiveTheme.of(context).setTheme(
                                light: CupertinoThemeData(
                                  brightness: Brightness.light,
                                  primaryColor:
                                      context.read(ThemePrimaryColor.provider),
                                ),
                                dark: CupertinoThemeData(
                                  brightness: Brightness.dark,
                                  primaryColor: color,
                                ),
                              );
                            },
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
                                activeColor: context.watch(MeColor.provider),
                                thumbColor: context.watch(MeColor.provider),
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
                                    color: context.watch(MeColor.provider)),
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
                                        .read(ShowOwnTrack.provider.notifier)
                                        .setValue(val);
                                  });
                                },
                                value: context.watch(ShowOwnTrack.provider),
                              ),
                            ),
                          ),
                        ]),
                  settingsInvisibleOfflineWidget(context),
                  if (networkConnected.connectivityStatus ==
                      ConnectivityStatus.online)
                    CupertinoFormSection(
                      header: Text(
                          Localize.of(context).enableOnesignalPushMessageTitle),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).enableOnesignalPushMessage,
                            descriptionRight: '',
                            rightWidget: CupertinoSwitch(
                              onChanged: (val) async {
                                HiveSettingsDB.setPushNotificationsEnabled(val);
                                await OnesignalHandler.instance
                                    .initPushNotifications();
                                setState(() {});
                              },
                              value: HiveSettingsDB.pushNotificationsEnabled,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (networkConnected.connectivityStatus ==
                          ConnectivityStatus.online &&
                      HiveSettingsDB.pushNotificationsEnabled)
                    Column(
                      children: [
                        const OneSignalIdWidget(),
                        CupertinoFormSection(
                          header: Text(Localize.of(context).iAmBladeGuardTitle),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DataLeftRightContent(
                                descriptionLeft:
                                    Localize.of(context).iAmBladeGuard,
                                descriptionRight: '',
                                rightWidget: CupertinoSwitch(
                                  onChanged: (val) async {
                                    if (val == false) {
                                      //switch off and unregister
                                      HiveSettingsDB.setBgSettingVisible(false);
                                      HiveSettingsDB.setBgLeaderSettingVisible(
                                          false);
                                      HiveSettingsDB.setIsBladeGuard(false);
                                      HiveSettingsDB.setBladeGuardClick(false);
                                      OnesignalHandler.registerPushAsBladeGuard(
                                          false, 0);
                                      setState(() {});
                                      return;
                                    }
                                    var codeResult =
                                        await InputPasswordDialog.show(context);
                                    if (!codeResult) return;
                                    HiveSettingsDB.setIsBladeGuard(val);
                                    HiveSettingsDB.setBladeGuardClick(val);
                                    int teamId = 0;
                                    if (mounted) {
                                      teamId = await showTeamIdDialog(
                                              context, HiveSettingsDB.teamId) ??
                                          0;
                                      HiveSettingsDB.setTeamId(teamId);
                                    }
                                    setState(() {});
                                    OnesignalHandler.registerPushAsBladeGuard(
                                        val, teamId);
                                  },
                                  value: HiveSettingsDB.isBladeGuard,
                                ),
                              ),
                            ),
                            if (HiveSettingsDB.isBladeGuard &&
                                (HiveSettingsDB.bgSettingVisible ||
                                    HiveSettingsDB.bgLeaderSettingVisible ||
                                    Globals.adminPass != null))
                              CupertinoButton(
                                  child: Text(
                                      '${Localize.of(context).bgTeam} ${HiveSettingsDB.teamId}'),
                                  onPressed: () async {
                                    var teamId = await showTeamIdDialog(
                                        context, HiveSettingsDB.teamId);
                                    if (teamId == null) return;
                                    HiveSettingsDB.setTeamId(teamId);
                                    setState(() {});
                                    await OnesignalHandler
                                        .registerPushAsBladeGuard(
                                            HiveSettingsDB.bladeGuardClick,
                                            teamId);
                                  }),
                          ],
                        ),
                        if (HiveSettingsDB.isBladeGuard &&
                            (HiveSettingsDB.bgSettingVisible ||
                                HiveSettingsDB.bgLeaderSettingVisible ||
                                Globals.adminPass != null))
                          CupertinoFormSection(
                            header: Text(Localize.of(context)
                                .pushMessageParticipateAsBladeGuardTitle),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context)
                                      .pushMessageParticipateAsBladeGuard,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    onChanged: (val) async {
                                      setState(() {
                                        HiveSettingsDB.setBladeGuardClick(val);
                                      });
                                      await OnesignalHandler
                                          .registerPushAsBladeGuard(
                                              val, HiveSettingsDB.teamId);
                                    },
                                    value: HiveSettingsDB.bladeGuardClick,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (HiveSettingsDB.isBladeGuard &&
                            (HiveSettingsDB.bgSettingVisible ||
                                HiveSettingsDB.bgLeaderSettingVisible ||
                                Globals.adminPass != null))
                          CupertinoFormSection(
                            header: Text(Localize.of(context)
                                .pushMessageSkateMunichInfosTitle),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context)
                                      .pushMessageSkateMunichInfos,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    onChanged: (val) async {
                                      setState(() {
                                        HiveSettingsDB.setRcvSkatemunichInfos(
                                            val);
                                      });
                                      HiveSettingsDB.setRcvSkatemunichInfos(
                                          val);
                                      OnesignalHandler.registerSkateMunichInfo(
                                          val);
                                    },
                                    value: HiveSettingsDB.rcvSkatemunichInfos,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (HiveSettingsDB.bgLeaderSettingVisible ||
                            Globals.adminPass != null)
                          CupertinoFormSection(
                            header: Text(Localize.of(context).markMeAsHead),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context).head,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    onChanged: (val) {
                                      setState(() {
                                        HiveSettingsDB.setIsSpecialHead(val);
                                        if (val) {
                                          HiveSettingsDB.setIsSpecialTail(
                                              false);
                                        }
                                      });
                                    },
                                    value: HiveSettingsDB.isSpecialHead,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (HiveSettingsDB.bgLeaderSettingVisible ||
                            Globals.adminPass != null)
                          CupertinoFormSection(
                            header: Text(Localize.of(context).markMeAsTail),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context).tail,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    onChanged: (val) {
                                      setState(() {
                                        HiveSettingsDB.setIsSpecialTail(val);
                                        if (val) {
                                          HiveSettingsDB.setIsSpecialHead(
                                              false);
                                        }
                                      });
                                    },
                                    value: HiveSettingsDB.isSpecialTail,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  if (Globals.adminPass != null)
                    CupertinoFormSection(
                      header:
                          Text(Localize.of(context).showFullProcessionTitle),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).showFullProcession,
                            descriptionRight: '',
                            rightWidget: CupertinoSwitch(
                                onChanged: (val) {
                                  setState(() {
                                    HiveSettingsDB.setwantSeeFullOfProcession(
                                        val);
                                  });
                                },
                                value: HiveSettingsDB.wantSeeFullOfProcession),
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
                        header: Text(
                            Localize.of(context).ignoreBatteriesOptimisation),
                        children: <Widget>[
                          CupertinoButton(
                              child: Text(Localize.of(context)
                                  .ignoreBatteriesOptimisationTitle),
                              onPressed: () async =>
                                  await BackgroundGeolocationHelper
                                      .openBatteriesSettings()),
                        ]),
                  if (!kIsWeb)
                    const SizedBox(
                      height: 15,
                    ),
                  if (!kIsWeb)
                  CupertinoFormSection(
                      header: Text(Localize.of(context)
                          .exportUserTrackingHeader),
                      children: <Widget>[
                        CupertinoButton(
                            child: Text(Localize.of(context)
                                .exportUserTracking),
                            onPressed: () => exportUserTracking(
                                LocationProvider.instance
                                    .userTrackingPoints)),
                      ]),
                  if (!kIsWeb)
                    CupertinoFormSection(
                        header: Text(Localize.of(context).resetOdoMeter),
                        children: <Widget>[
                          CupertinoButton(

                              child: Text(Localize.of(context).resetOdoMeterTitle),
                              onPressed: () async =>
                                  await BackgroundGeolocationHelper
                                      .resetOdoMeter(context)),
                        ]),
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
                          const SizedBox(height: 5),
                          Visibility(
                            visible: _openInvisibleSettings,
                            child: Column(
                              children: [
                                CupertinoFormSection(
                                    header:
                                        Text(Localize.of(context).setLogData),
                                    children: <Widget>[
                                      CupertinoButton(
                                          child: Text(
                                              'Loglevel ${LoggerHelper().getActiveLogLevel().name}'),
                                          onPressed: () async {
                                            await LoggerHelper()
                                                .showLogLevelDialog(context);
                                            setState(() {});
                                          }),
                                      CupertinoButton(
                                          child: Text(Localize.of(context)
                                              .setExportLogSupport),
                                          onPressed: () => exportLogs()),
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
                                              if (!kIsWeb) FLog.clearLogs();
                                              showToast(
                                                  message: Localize
                                                      .current.finished);
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
                                                      windowTitle:
                                                          Localize.current
                                                              .clearLogsTitle,
                                                      text: Localize.current
                                                          .clearLogsQuestion,
                                                      positiveButtonTitle:
                                                          Localize.current.yes,
                                                      neutralButtonTitle:
                                                          Localize
                                                              .current.cancel,
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
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Center(
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
                                CupertinoFormSection(
                                    header: Text(Localize.of(context)
                                        .allowWakeLockHeader),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: DataLeftRightContent(
                                          descriptionLeft: Localize.of(context)
                                              .allowWakeLock,
                                          descriptionRight: '',
                                          rightWidget: CupertinoSwitch(
                                            onChanged: (val) {
                                              HiveSettingsDB.setWakeLockEnabled(
                                                  val);
                                              Wakelock.toggle(enable: val);
                                              setState(() {});
                                            },
                                            value:
                                                HiveSettingsDB.wakeLockEnabled,
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
                                              bg.BackgroundGeolocation
                                                  .setConfig(bg.Config(
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
                                            descriptionLeft: Localize.of(
                                                    context)
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
                                    header: Text(
                                        Localize.of(context).openStreetMap),
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
                                              HiveSettingsDB
                                                  .setOpenStreetMapEnabled(val);
                                              setState(() {});
                                            },
                                            value: HiveSettingsDB
                                                .openStreetMapEnabled,
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
                                        onSaved: (inputText) => HiveSettingsDB
                                            .setCustomServerAddress(inputText),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: DataLeftRightContent(
                                          descriptionLeft: 'Custom Server',
                                          descriptionRight: '',
                                          rightWidget: CupertinoSwitch(
                                            onChanged: (val) {
                                              Wamp_V2.instance
                                                  .closeAndReconnect();
                                              HiveSettingsDB.setUseCustomServer(
                                                  val);
                                              setState(() {});
                                            },
                                            value:
                                                HiveSettingsDB.useCustomServer,
                                          ),
                                        ),
                                      ),
                                    ]),
                                CupertinoFormSection(
                                    header: Text(Localize.of(context)
                                        .setexportDataHeader),
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
                                        importData(context, value);
                                      },
                                    ),
                                    AnimatedOpacity(
                                      // If the widget is visible, animate to 0.0 (invisible).
                                      // If the widget is hidden, animate to 1.0 (fully visible).
                                      opacity:
                                          inputText.length > 10 ? 1.0 : 0.2,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      // The green box must be a child of the AnimatedOpacity widget.
                                      child: CupertinoButton(
                                        child: Text(Localize.of(context)
                                            .setStartImport),
                                        onPressed: () {
                                          inputText.length > 10
                                              ? importData(context, inputText)
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
                      )),
                ],
              )),
        ),
      ),
    );
  }

  Future<int?> showTeamIdDialog(BuildContext context, int? current) {
    int selected = current ?? 0;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(Localize.of(context).setTeam),
          content: SizedBox(
            height: 100,
            child: Builder(builder: (context) {
              //ref not working here in Alert
              var teams = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
              return CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selected),
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      selected = value;
                    });
                  },
                  itemExtent: 50,
                  children: [
                    for (var i in teams) Center(child: Text(i.toString()))
                  ]);
            }),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                Navigator.of(context).pop(selected);
              },
            ),
          ],
        );
      },
    );
  }
}
