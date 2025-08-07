import 'dart:io' show HttpClient;

import 'package:universal_io/io.dart' hide HttpClient;


class MyHttpOverrides extends HttpOverrides {
  MyHttpOverrides();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final SecurityContext context1 = SecurityContext();
    /*context.usePrivateKeyBytes(data.buffer.asUint8List(),
        password: certificatePassword //* input certificate passphrase */"
        );*/
    return super.createHttpClient(context1)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
