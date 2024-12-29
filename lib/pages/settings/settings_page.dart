import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wakelock/wakelock.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../../providers/settings/server_pwd_provider.dart';
import '../widgets/common_widgets/tinted_cupertino_button.dart';
import '../widgets/tracking_export_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:universal_io/io.dart';

import '../../generated/l10n.dart';
import '../../helpers/background_location_helper.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/notification/toast_notification.dart';
import '../widgets/app_id_widget.dart';
import '../widgets/data_widget_left_right.dart';
import '../../providers/is_tracking_provider.dart';
import '../../providers/map/map_settings_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../wamp/wamp_v2.dart';
import '../widgets/one_signal_id_widget.dart';
import '../widgets/settings_invisible_offline.dart';
import 'color_settings_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  var inputText = '';
  bool _openInvisibleSettings = false;
  bool _exportLogInProgress = false;
  bool _showPushProgressIndicator = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var networkConnected = ref.watch(networkAwareProvider);
    var adminPass = ref.watch(serverPwdSetProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            ResponsiveBreakpoints.of(context).orientation ==
                    Orientation.portrait
                ? CupertinoSliverNavigationBar(
                    largeTitle: Text(Localize.of(context).settings),
                    backgroundColor:
                        CupertinoTheme.of(context).barBackgroundColor,
                  )
                : SliverToBoxAdapter(
                    child: CupertinoNavigationBar(
                      middle: Text(Localize.of(context).settings),
                    ),
                  ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CupertinoFormSection(
                      header:
                          Text(Localize.of(context).bladeGuardSettingsTitle),
                      children: <Widget>[
                        SizedTintedCupertinoButton(
                          child: Text(Localize.of(context).bladeGuardSettings),
                          onPressed: () => {
                            context.pushNamed(AppRoute.bladeguard.name),
                          },
                          onLongPress: () => {
                            adminPass
                                ? context.pushNamed(AppRoute.adminPage.name,
                                    queryParameters: {
                                        'password':
                                            HiveSettingsDB.serverPassword
                                      })
                                : context.pushNamed(AppRoute.bladeguard.name)
                          },
                        ),
                      ]),
                  const TrackingExportWidget(),
                  const ColorSettingsWidget(),
                  CupertinoFormSection(
                      header:
                          Text(Localize.of(context).automatedStopSettingTitle),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).automatedStopSettingText,
                            descriptionRight: '',
                            rightWidget: CupertinoSwitch(
                              activeTrackColor:
                                  CupertinoTheme.of(context).primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  ref
                                      .read(autoStopTrackingProvider.notifier)
                                      .setValue(val);
                                });
                              },
                              value: ref.watch(autoStopTrackingProvider),
                            ),
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header:
                          Text(Localize.of(context).autoStartTrackingInfoTitle),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).autoStartTrackingInfo,
                            descriptionRight: '',
                            rightWidget: CupertinoSwitch(
                              activeTrackColor:
                                  CupertinoTheme.of(context).primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  ref
                                      .read(autoStartTrackingProvider.notifier)
                                      .setValue(val);
                                });
                              },
                              value: ref.watch(autoStartTrackingProvider),
                            ),
                          ),
                        ),
                      ]),
                  CupertinoFormSection(
                      header: Text(Localize.of(context).showOwnTrack),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).showOwnTrackSwitchTitle,
                            descriptionRight: '',
                            rightWidget: CupertinoSwitch(
                              activeTrackColor:
                                  CupertinoTheme.of(context).primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  ref
                                      .read(showOwnTrackProvider.notifier)
                                      .setValue(val);
                                });
                              },
                              value: ref.watch(showOwnTrackProvider),
                            ),
                          ),
                        ),
                        if (ref.watch(showOwnTrackProvider))
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DataLeftRightContent(
                              descriptionLeft:
                                  Localize.of(context).showOwnColoredTrack,
                              descriptionRight: '',
                              rightWidget: CupertinoSwitch(
                                activeTrackColor:
                                    CupertinoTheme.of(context).primaryColor,
                                onChanged: (val) {
                                  setState(() {
                                    ref
                                        .read(showOwnColoredTrackProvider
                                            .notifier)
                                        .setValue(val);
                                  });
                                },
                                value: ref.watch(showOwnColoredTrackProvider),
                              ),
                            ),
                          ),
                      ]),
                  if (!kIsWeb)
                    CupertinoFormSection(
                        header: Text(Localize.of(context).showCompassTitle),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DataLeftRightContent(
                              descriptionLeft: Localize.of(context).showCompass,
                              descriptionRight: '',
                              rightWidget: CupertinoSwitch(
                                activeTrackColor:
                                    CupertinoTheme.of(context).primaryColor,
                                onChanged: (val) {
                                  setState(() {
                                    ref
                                        .read(showCompassProvider.notifier)
                                        .setValue(val);
                                  });
                                },
                                value: ref.watch(showCompassProvider),
                              ),
                            ),
                          ),
                        ]),
                  const SettingsInvisibleOfflineWidget(),
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
                        if ((networkConnected.connectivityStatus ==
                                    ConnectivityStatus.wampConnected ||
                                networkConnected.connectivityStatus ==
                                    ConnectivityStatus.wampNotConnected) &&
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
                                          activeTrackColor:
                                              CupertinoTheme.of(context)
                                                  .primaryColor,
                                          onChanged: (val) async {
                                            await HiveSettingsDB
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
                        if (HiveSettingsDB.pushNotificationsEnabled)
                          const OneSignalIdWidget(),
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
                                    activeTrackColor:
                                        CupertinoTheme.of(context).primaryColor,
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
                        CupertinoFormSection(
                            header: Text(Localize.of(context)
                                .fitnessPermissionSettingsText),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft: Localize.of(context)
                                      .fitnessPermissionSwitchSettingsText,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    activeTrackColor:
                                        CupertinoTheme.of(context).primaryColor,
                                    onChanged: (val) {
                                      HiveSettingsDB
                                          .setIsMotionDetectionDisabled(!val);
                                      bg.BackgroundGeolocation.setConfig(
                                          bg.Config(
                                              disableMotionActivityUpdates:
                                                  !val));
                                      setState(() {});
                                    },
                                    value: !HiveSettingsDB
                                        .isMotionDetectionDisabled,
                                  ),
                                ),
                              ),
                            ]),
                        CupertinoFormSection(
                            header:
                                Text(Localize.of(context).allowWakeLockHeader),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: DataLeftRightContent(
                                  descriptionLeft:
                                      Localize.of(context).allowWakeLock,
                                  descriptionRight: '',
                                  rightWidget: CupertinoSwitch(
                                    activeTrackColor:
                                        CupertinoTheme.of(context).primaryColor,
                                    onChanged: (val) {
                                      HiveSettingsDB.setWakeLockEnabled(val);
                                      Wakelock.toggle(enable: val);
                                      setState(() {});
                                    },
                                    value: HiveSettingsDB.wakeLockEnabled,
                                  ),
                                ),
                              ),
                            ]),
                        if (Platform.isAndroid)
                          CupertinoFormSection(
                              header: Text(Localize.of(context)
                                  .ignoreBatteriesOptimisation),
                              children: <Widget>[
                                SizedTintedCupertinoButton(
                                    child: Text(Localize.of(context)
                                        .ignoreBatteriesOptimisationTitle),
                                    onPressed: () async =>
                                        await BackgroundGeolocationHelper
                                            .openBatteriesSettings(context)),
                              ]),
                        if (!kIsWeb)
                          CupertinoFormSection(
                              header: Text(Localize.of(context).setSystem),
                              children: <Widget>[
                                SizedTintedCupertinoButton(
                                    child: Text(Localize.of(context)
                                        .openOperatingSystemSettings),
                                    onPressed: () => openAppSettings()),
                              ]),
                        CupertinoFormSection(
                          header: Text(Localize.of(context).exportLogData),
                          children: <Widget>[
                            _exportLogInProgress
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    child: SizedTintedCupertinoButton(
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
                                  ),
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
                                    SizedTintedCupertinoButton(
                                        child: Text(
                                            'Loglevel ${BnLog.getActiveLogLevel().name}'),
                                        onPressed: () async {
                                          await BnLog.showLogLevelDialog(
                                              context);
                                          setState(() {});
                                        }),
                                    SizedTintedCupertinoButton(
                                        child: Text(
                                            Localize.of(context).setClearLogs),
                                        onPressed: () async {
                                          await QuickAlert.show(
                                              context: context,
                                              showCancelBtn: true,
                                              type: QuickAlertType.warning,
                                              title: Localize
                                                  .current.clearLogsTitle,
                                              text: Localize
                                                  .current.clearLogsQuestion,
                                              confirmBtnText:
                                                  Localize.current.yes,
                                              cancelBtnText:
                                                  Localize.current.cancel,
                                              onConfirmBtnTap: () async {
                                                context.pop();
                                                await BnLog.clearLogs();
                                                await bg.Logger.destroyLog();
                                                showToast(
                                                    message: Localize
                                                        .current.finished);
                                                if (!context.mounted) return;
                                              });
                                        }),
                                  ]),
                              if (!HiveSettingsDB
                                      .useAlternativeLocationProvider &&
                                  HiveSettingsDB.flogLogLevel.value < 3000)
                                CupertinoFormSection(
                                    header: const Text('Geolocation Log'),
                                    children: <Widget>[
                                      SizedTintedCupertinoButton(
                                          child: Text(Localize.of(context)
                                              .setExportLogSupport),
                                          onPressed: () =>
                                              exportBgLocationLogs()),
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

                              const SizedBox(
                                height: 15,
                              ),

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
                                            WampV2().closeAndReconnect();
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
                                    SizedTintedCupertinoButton(
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
                                    opacity: inputText.length > 10 ? 1.0 : 0.2,
                                    duration: const Duration(milliseconds: 500),
                                    // The green box must be a child of the AnimatedOpacity widget.
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: SizedTintedCupertinoButton(
                                        child: Text(Localize.of(context)
                                            .setStartImport),
                                        onPressed: () {
                                          inputText.length > 10
                                              ? importData(context, inputText)
                                              : null;
                                        },
                                      ),
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
