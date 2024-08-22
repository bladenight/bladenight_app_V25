import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BladeGuardWebRegisterPage extends StatefulWidget {
  const BladeGuardWebRegisterPage({super.key});

  @override
  State<BladeGuardWebRegisterPage> createState() =>
      _BladeGuardWebRegisterPage();
}

class _BladeGuardWebRegisterPage extends State<BladeGuardWebRegisterPage>
    with WidgetsBindingObserver {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
        Uri.parse('https://bladenight-muenchen.de/blade-guards/#anmeldung'));

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
    return CupertinoPageScaffold(
      child: WebViewWidget(controller: controller),
    );
  }
}
