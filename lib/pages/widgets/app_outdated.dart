//This file contains part of shimmer_effect package with following licence
/*
Copyright (c) 2023 Deepak Kumar
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/url_launch_helper.dart';
import '../../providers/app_outdated_provider.dart';
import 'alert_animated_widget.dart';

class AppOutdated extends ConsumerStatefulWidget {
  const AppOutdated({super.key});

  @override
  ConsumerState<AppOutdated> createState() => _AppOutdatedState();
}

class _AppOutdatedState extends ConsumerState<AppOutdated>
    with SingleTickerProviderStateMixin {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    var pr = ref.watch(appOutdatedProvider);
    if (kDebugMode) {
      pr = true;
    }
    if (!pr) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            Launch.launchUrlFromString(playStoreLink,
                mode: LaunchMode.platformDefault);
          }
          if (Platform.isIOS) {
            Launch.launchUrlFromString(iOSAppStoreLink,
                mode: LaunchMode.platformDefault);
          }
        },
        child: AlertAnimated(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    Localize.of(context).appOutDated,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
