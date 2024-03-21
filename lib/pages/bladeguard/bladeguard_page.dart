import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../app_settings/globals.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../pages/widgets/no_connection_warning.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';
import '../widgets/birthday_date_picker.dart';
import '../widgets/data_widget_left_right.dart';
import '../widgets/email_widget.dart';
import '../widgets/phone_number.dart';
import 'bladeguard_on_site_page.dart';
//import 'widgets/show_message_dialog.dart';

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
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Icon(CupertinoIcons.back),
            ),
            largeTitle: Text(Localize.of(context).bladeGuard),
            trailing: (networkConnected.connectivityStatus ==
                    ConnectivityStatus.online)
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () async {
                      var _ = await ref.refresh(fetchOnSiteStateProvider(
                              HiveSettingsDB.bladeguardSHA512Hash)
                          .future);
                    },
                    child: isBladeguard
                        ? const Icon(CupertinoIcons.refresh)
                        : Container(),
                  )
                : const Icon(Icons.offline_bolt_outlined),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              if (!isBladeguard) return;
              var _ = await ref.refresh(
                  fetchOnSiteStateProvider(HiveSettingsDB.bladeguardSHA512Hash)
                      .future);
            },
          ),
          const SliverToBoxAdapter(
            child: FractionallySizedBox(
                widthFactor: 0.9, child: ConnectionWarning()),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
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
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        return Future(false as FutureOr<bool> Function());
                      }
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
                      if (!isBladeguard)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: HtmlWidget(
                              textStyle: TextStyle(
                                  fontSize: MediaQuery.textScalerOf(context)
                                      .scale(14),
                                  color: CupertinoTheme.of(context)
                                      .primaryColor), onTapUrl: (url) async {
                            var uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              return Future(false as FutureOr<bool> Function());
                            }
                            return Future(true as FutureOr<bool> Function());
                          },
                              Localize.of(context).bladeguardInfo(
                                  bladeguardRegisterLink,
                                  bladeguardPrivacyLink)),
                        ),
                      //--------- Register
                      if (!isBladeguard)
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
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    if (!context.mounted) return;
                                    showToast(
                                        message: Localize.of(context).failed);
                                  }
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
                      //---------
                      if (isBladeguard) ...[
                        const EmailTextField(),
                        const BirthdayDatePicker(),
                        const PhoneTextField(),
                      ],
                      if (networkConnected.connectivityStatus ==
                              ConnectivityStatus.online &&
                          !bladeguardSettingsVisible &&
                          isBladeguard &&
                          ref.watch(isValidBladeGuardEmailProvider))
                        CupertinoButton(
                            child:
                                Text(Localize.of(context).checkBgRegistration),
                            onPressed: () async {
                              await checkOrUpdateBladeGuardData();
                            }),
                      if (!kIsWeb)
                        Column(
                          children: [
                            if (HiveSettingsDB.isBladeGuard &&
                                (bladeguardSettingsVisible ||
                                    HiveSettingsDB.bgLeaderSettingVisible ||
                                    Globals.adminPass != null))
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: DataLeftRightContent(
                                  descriptionLeft: HiveSettingsDB.bgTeam,
                                  descriptionRight: '',
                                  rightWidget: CupertinoButton(
                                      child: Text(Localize.of(context).update),
                                      onPressed: () async {
                                        setState(() {});
                                        await checkOrUpdateBladeGuardData();
                                      }),
                                ),
                              )
                          ],
                        ),
                      if (!kIsWeb &&
                          HiveSettingsDB.isBladeGuard &&
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
                              ),
                            ),
                          ],
                        ),
                      if (!kIsWeb &&
                          HiveSettingsDB.isBladeGuard &&
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
                      const SizedBox(
                        height: 15,
                      ),
                      if (!kIsWeb && HiveSettingsDB.bgLeaderSettingVisible ||
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
                      if (!kIsWeb && HiveSettingsDB.bgLeaderSettingVisible ||
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
                if (Globals.adminPass != null)
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
                                  HiveSettingsDB.setwantSeeFullOfProcession(
                                      val);
                                });
                              },
                              value: HiveSettingsDB.wantSeeFullOfProcession),
                        ),
                      ),
                    ],
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
        final res = await ref.read(checkBladeguardMailProvider(
                HiveSettingsDB.bladeguardSHA512Hash,
                HiveSettingsDB.bladeguardBirthday,
                HiveSettingsDB.bladeguardPhone)
            .future);
        if (res.result != null && res.result != '') {
          ref.read(bladeguardSettingsVisibleProvider.notifier).setValue(true);
          HiveSettingsDB.setBgTeam(res.result!);
        } else {
          ref.read(bladeguardSettingsVisibleProvider.notifier).setValue(false);
          showToast(
              message: '${Localize.current.failed} ${res.errorDescription}');

          setState(() {});
        }
      } catch (ex) {
        BnLog.error(
            text: ex.toString(),
            methodName: 'checkOrUpdateBladeGuardData',
            className: toString());
      }
    }
  }
}
