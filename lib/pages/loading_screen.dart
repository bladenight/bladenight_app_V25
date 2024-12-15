import 'dart:async';
import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import '../helpers/export_import_data_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../helpers/watch_communication_helper.dart';
import '../providers/active_event_provider.dart';
import '../providers/get_images_and_links_provider.dart';
import '../providers/location_provider.dart';
import '../wamp/wamp_v2.dart';
import 'bladeguard/bladeguard_page.dart';
import 'events/events_page.dart';
import 'friends/friends_page.dart';
import 'home_info/logo_animate.dart';
import 'home_info/home_page.dart';
import 'home_screen.dart';
import 'map/map_page.dart';
import 'settings/settings_page.dart';
import 'widgets/data_loading_indicator.dart';
import 'widgets/intro_slider.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/loadingScreen';

  const LoadingScreen({super.key, int tabIndex = 0});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with WidgetsBindingObserver {
  //added deep links bna.bladenight.app

  bool _isInitialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //call on first start
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> initSystem() async {
    setState(() {
      statusText = 'Prüfe Netzwerk';
    });
    try {
      /*if (await WampV2()
          .internetConnChecker
          .hasInternetAccess
          .timeout(Duration(seconds: 5))) ;*/
    } catch (e) {
      setState(() {
        statusText = 'Kein Internet!';
      });
      await Future.delayed(Duration(seconds: 1));
      return true;
    }

    setState(() {
      statusText = 'Initialisiere Eventdaten';
    });

    ref.invalidate(updateImagesAndLinksProvider);
    await ref.read(activeEventProvider.notifier).refresh(forceUpdate: true);
    setState(() {
      statusText = Localize.of(context).finished;
    });

    return true;
  }

  var statusText = '';

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) return HomeScreen();
    return FutureBuilder<bool>(
      future: initSystem(), // Future.delayed(Duration(seconds: 1), () => true),
      builder: (context, snapshot) {
        if (snapshot.hasData || _isInitialized) {
          _isInitialized = true;
          /* Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => HomeScreen(),
              ));*/
          return HomeScreen();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(statusText),
              LogoAnimate(),
            ],
          );
        }
      },
    );
  }
}
