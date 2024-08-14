import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../app_settings/globals.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../helpers/url_launch_helper.dart';
import '../../pages/widgets/no_connection_warning.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';
import '../admin/widgets/admin_password_dialog.dart';
import '../widgets/birthday_date_picker.dart';
import '../widgets/data_widget_left_right.dart';
import '../widgets/data_widget_left_right_text.dart';
import '../widgets/email_widget.dart';
import '../widgets/phone_number.dart';
import '../widgets/send_mail.dart';
import '../widgets/settings_invisible_offline.dart';
import 'bg_pin_dialog.dart';
import 'bladeguard_on_site_page.dart';

class BladeGuardPage extends ConsumerStatefulWidget {
  const BladeGuardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BladeGuardPage();
}

class _BladeGuardPage extends ConsumerState with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    var isBladeguard = ref.watch(userIsBladeguardProvider);
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    var networkConnected = ref.watch(networkAwareProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(Localize.of(context).bladeGuard),
            trailing: Align(
              alignment: Alignment.centerRight,
              child: (networkConnected.connectivityStatus ==
                      ConnectivityStatus.online)
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () async {
                        var _ = ref.refresh(bgIsOnSiteProvider);
                      },
                      child: isBladeguard
                          ? const Icon(CupertinoIcons.refresh)
                          : const SizedBox(), //Container hides gesture from back button
                    )
                  : const Icon(Icons.offline_bolt_outlined),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              if (!isBladeguard) return;
              var _ = await ref.refresh(bgIsOnSiteProvider.future);
            },
          ),
          const SliverToBoxAdapter(
            child: FractionallySizedBox(
                widthFactor: 0.9, child: ConnectionWarning()),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SettingsInvisibleOfflineWidget(),
                const BladeGuardOnsite(),
                if (networkConnected.connectivityStatus ==
                    ConnectivityStatus.online)
                  CupertinoFormSection(
                    header: HtmlWidget(
                        textStyle: TextStyle(
                            fontSize:
                                MediaQuery.textScalerOf(context).scale(14),
                            color: CupertinoTheme.of(context).primaryColor),
                        onTapUrl: (url) async {
                      var uri = Uri.parse(url);
                      Launch.launchUrlFromUri(uri);
                      return Future(true as FutureOr<bool> Function());
                    },
                        Localize.of(context)
                            .iAmBladeGuardTitle(bladeguardPrivacyLink)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: DataLeftRightContent(
                          descriptionLeft: Localize.of(context).iAmBladeGuard,
                          descriptionRight: '',
                          rightWidget: CupertinoSwitch(
                            onChanged: (val) {
                              ref
                                  .read(userIsBladeguardProvider.notifier)
                                  .setValue(val);
                            },
                            value: isBladeguard,
                          ),
                        ),
                      ),
                      if (!isBladeguard) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: HtmlWidget(
                              textStyle: TextStyle(
                                  fontSize: MediaQuery.textScalerOf(context)
                                      .scale(14),
                                  color: CupertinoTheme.of(context)
                                      .primaryColor), onTapUrl: (url) async {
                            Launch.launchUrlFromString(url);
                            return Future(true as FutureOr<bool> Function());
                          },
                              Localize.of(context).bladeguardInfo(
                                  bladeguardRegisterLink,
                                  bladeguardPrivacyLink)),
                        ),
                        //--------- Register

                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: CupertinoButton(
                                onPressed: () async {
                                  var uri = Uri.parse(bladeguardRegisterLink);
                                  Launch.launchUrlFromUri(uri);
                                },
                                color: Colors.lightGreen,
                                child: Text(Localize.of(context).register),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: CupertinoButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: Colors.redAccent,
                                child: Text(Localize.of(context).later),
                              ),
                            ),
                          ],
                        ),
                      ],
                      //---------
                      if (isBladeguard) ...[
                        if (!bladeguardSettingsVisible) ...[
                          const EmailTextField(),
                          const BirthdayDatePicker(),
                        ],
                        if (bladeguardSettingsVisible)
                          Text(HiveSettingsDB.bladeguardEmail),
                        const PhoneTextField(),
                        if (networkConnected.connectivityStatus ==
                                ConnectivityStatus.online &&
                            !bladeguardSettingsVisible &&
                            ref.watch(isValidBladeGuardEmailProvider))
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: CupertinoButton(
                                  color: Colors.yellowAccent,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      Localize.of(context).checkBgRegistration,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await checkOrUpdateBladeGuardData();
                                  }),
                            ),
                          ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const SendMailWidget(),
                        ),
                      ],
                      if (!kIsWeb)
                        Column(
                          children: [
                            if (HiveSettingsDB.isBladeGuard &&
                                ref.watch(isValidBladeGuardEmailProvider) &&
                                bladeguardSettingsVisible)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: DataLeftWidgetRightTextContent(
                                  descriptionRight: HiveSettingsDB.bgTeam,
                                  leftWidget: CupertinoButton(
                                      child: Text(
                                          Localize.of(context).bgUpdatePhone),
                                      onPressed: () async {
                                        await checkOrUpdateBladeGuardData();
                                        setState(() {});
                                      }),
                                ),
                              )
                          ],
                        ),
                      if (!kIsWeb &&
                          HiveSettingsDB.isBladeGuard &&
                          HiveSettingsDB.bgSettingVisible) ...[
                        CupertinoFormSection(
                          header: Text(Localize.of(context).geoFencingTitle),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DataLeftRightContent(
                                descriptionLeft:
                                    Localize.of(context).geoFencing,
                                rightWidget: CupertinoSwitch(
                                  onChanged: (val) async {
                                    await HiveSettingsDB
                                        .setSetOnsiteGeoFencingActiveAsync(val);
                                    await LocationProvider.instance
                                        .startStopGeoFencing();
                                    setState(() {});
                                  },
                                  value: HiveSettingsDB.onsiteGeoFencingActive,
                                ),
                                descriptionRight: '',
                              ),
                            ),
                          ],
                        ),
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
                                rightWidget: CupertinoSwitch(
                                  onChanged: (val) async {
                                    setState(() {
                                      HiveSettingsDB
                                          .setOneSignalRegisterBladeGuardPush(
                                              val);
                                    });
                                    await OnesignalHandler
                                        .registerPushAsBladeGuard(
                                            val, HiveSettingsDB.bgTeam);
                                  },
                                  value: HiveSettingsDB
                                      .oneSignalRegisterBladeGuardPush,
                                ),
                                descriptionRight: '',
                              ),
                            ),
                          ],
                        ),
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
                                    HiveSettingsDB.setRcvSkatemunichInfos(val);
                                    OnesignalHandler.registerSkateMunichInfo(
                                        val);
                                  },
                                  value: HiveSettingsDB.rcvSkatemunichInfos,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!kIsWeb &&
                          (HiveSettingsDB.bgLeaderSettingVisible ||
                              Globals.adminPass != null ||
                              HiveSettingsDB.bgIsAdmin))
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
                                        HiveSettingsDB.setIsSpecialTail(false);
                                      }
                                    });
                                  },
                                  value: HiveSettingsDB.isHeadOfProcession,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (!kIsWeb &&
                          (HiveSettingsDB.bgLeaderSettingVisible ||
                              Globals.adminPass != null ||
                              HiveSettingsDB.bgIsAdmin))
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
                                        HiveSettingsDB.setIsSpecialHead(false);
                                      }
                                    });
                                  },
                                  value: HiveSettingsDB.isTailOfProcession,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                if (!kIsWeb &&
                    (Globals.adminPass != null ||
                        HiveSettingsDB.hasSpecialRights ||
                        HiveSettingsDB.bgIsAdmin))
                  CupertinoFormSection(
                    header: Text(Localize.of(context).showFullProcessionTitle),
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
                                  HiveSettingsDB.setWantSeeFullOfProcession(
                                      val);
                                });
                              },
                              value: HiveSettingsDB.wantSeeFullOfProcession),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (!kIsWeb && HiveSettingsDB.bgIsAdmin)
                  CupertinoFormSection(
                    header: const Text('Server-Admin'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CupertinoButton(
                            child: const Text('Öffne Serveradmin'),
                            onPressed: () async {
                              await AdminPasswordDialog.show(context);
                            }),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
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

  checkOrUpdateBladeGuardData() async {
    if (HiveSettingsDB.bladeguardSHA512Hash != '') {
      try {
        String? role;
        final res = await ref.read(checkBladeguardMailProvider(
          HiveSettingsDB.bladeguardEmail,
          HiveSettingsDB.bladeguardBirthday,
          HiveSettingsDB.bladeguardPhone,
          HiveSettingsDB.bladeguardPin,
        ).future);
        if (res.result != null && res.result!.length > 5) {
          //check PIN
          var resultMap = jsonDecode(res.result!);
          if (resultMap is Map) {
            if (resultMap.keys.contains('pinReq') &&
                resultMap['pinReq'] == true) {
              if (mounted) {
                var pinRes = await PinDialog.show(context);
                if (pinRes == null) return;
                final resPin = await ref.read(checkBladeguardMailProvider(
                  HiveSettingsDB.bladeguardEmail,
                  HiveSettingsDB.bladeguardBirthday,
                  HiveSettingsDB.bladeguardPhone,
                  pinRes,
                ).future);
                if (resPin.result != null) {
                  //check PIN
                  var resPinMap = jsonDecode(resPin.result!);
                  if (resPinMap is Map &&
                      resPinMap.keys.contains('pin') &&
                      resPinMap['pin'] == true) {
                    role = '';
                    HiveSettingsDB.setBladeguardPin(pinRes);
                    if (resPinMap.keys.contains('role')) {
                      role = resPinMap['role'];
                    }
                    _setBladeguardRole(role);
                    var translatedRole = _translateRole(role);
                    HiveSettingsDB.setBgTeam(
                        '${resPinMap['team']} $translatedRole');
                    ref
                        .read(bladeguardSettingsVisibleProvider.notifier)
                        .setValue(true);
                    await _activatePush();
                    if (mounted) {
                      showToast(message: Localize.of(context).ok);
                    }
                    ref.invalidate(bgIsOnSiteProvider);
                    setState(() {});
                    return;
                  }
                } else {
                  ref
                      .read(bladeguardSettingsVisibleProvider.notifier)
                      .setValue(false);
                  showToast(message: Localize.current.failed);
                  ref.invalidate(bgIsOnSiteProvider);
                  setState(() {});
                  return;
                }
              }
            }
            if (resultMap.keys.contains('team')) {
              String? role;
              if (resultMap.keys.contains('role')) {
                role = resultMap['role'];
              }
              var translatedRole = _translateRole(role);
              _setBladeguardRole(role);
              HiveSettingsDB.setBgTeam('${resultMap['team']} $translatedRole');

              ref
                  .read(bladeguardSettingsVisibleProvider.notifier)
                  .setValue(true);
              ref.invalidate(bgIsOnSiteProvider);
              await _activatePush();
            }
          }
        } else {
          ref.read(bladeguardSettingsVisibleProvider.notifier).setValue(false);
          showToast(
              message: '${Localize.current.failed} ${res.errorDescription}');
        }
        setState(() {});
      } catch (ex) {
        BnLog.error(
            text: ex.toString(),
            methodName: 'checkOrUpdateBladeGuardData',
            className: toString());
      }
    }
  }

  String _translateRole(String? role) {
    if (role == null) return '';
    if (role == 'spec') return '(${Localize.current.spec})';
    if (role == 'lead') return '(${Localize.current.lead})';
    if (role == 'leadspec') return '(${Localize.current.leadspec})';
    if (role == 'admin') return '(${Localize.current.admin})';
    return '';
  }

  _activatePush() async {
    HiveSettingsDB.setOneSignalRegisterBladeGuardPush(true);
    await OnesignalHandler.registerPushAsBladeGuard(
        true, HiveSettingsDB.bgTeam);
  }

  _setBladeguardRole(String? role) {
    if (role == null) return;
    if (role.toLowerCase() == 'spec') {
      HiveSettingsDB.setBgLeaderSettingVisible(false);
      HiveSettingsDB.setHasSpecialRightsPrefs(true);
    } else if (role.toLowerCase() == 'lead') {
      HiveSettingsDB.setBgLeaderSettingVisible(true);
      HiveSettingsDB.setHasSpecialRightsPrefs(false);
    } else if (role.toLowerCase() == 'leadspec') {
      HiveSettingsDB.setBgLeaderSettingVisible(true);
      HiveSettingsDB.setHasSpecialRightsPrefs(true);
    } else {
      HiveSettingsDB.setBgLeaderSettingVisible(false);
      HiveSettingsDB.setHasSpecialRightsPrefs(false);
    }
    if (role.toLowerCase() == ('admin')) {
      HiveSettingsDB.setBgIsAdmin(true);
      HiveSettingsDB.setBgLeaderSettingVisible(true);
      HiveSettingsDB.setHasSpecialRightsPrefs(true);
    } else {
      HiveSettingsDB.setBgIsAdmin(false);
    }
  }
}
