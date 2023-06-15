import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/url_launch_helper.dart';

class QRCreatePage extends StatefulWidget {
  const QRCreatePage(
      {Key? key,
      required this.qrcodetext,
      required this.headertext,
      required this.infotext})
      : super(key: key);
  final String headertext;
  final String infotext;
  final String qrcodetext;

  static Future<dynamic> show(
      {required BuildContext context,
      required String qrcodetext,
      required String headertext,
      required String infotext}) async {
    return Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => QRCreatePage(
        qrcodetext: qrcodetext,
        headertext: headertext,
        infotext: infotext,
      ),
    ));
  }

  @override
  QRCreatePageState createState() => QRCreatePageState();
}

class QRCreatePageState extends State<QRCreatePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(Localize.of(context).qrcoderouteinfoheader),
          backgroundColor:
              CupertinoTheme.of(context).barBackgroundColor.withOpacity(1),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  data: widget.qrcodetext,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),
                FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      Launch.launchUrlFromString(widget.qrcodetext);
                    },
                    child: Text(widget.infotext,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
