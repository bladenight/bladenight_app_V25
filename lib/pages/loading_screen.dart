import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
import '../providers/active_event_provider.dart';
import '../providers/get_images_and_links_provider.dart';
import 'home_info/logo_animate.dart';
import 'home_screen.dart';

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

    await ref.read(activeEventProvider.notifier).refresh(forceUpdate: true);
    ref.invalidate(updateImagesAndLinksProvider);
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
              Image.asset(
                'assets/images/2025_Bladenight_Logo_Skm.jpg',
                width: MediaQuery.sizeOf(context).width * 0.9,
              ),
              Text(statusText),
              LogoAnimate(),
            ],
          );
        }
      },
    );
  }
}
