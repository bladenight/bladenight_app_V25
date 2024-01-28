import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/url_launch_helper.dart';

class QRCreatePage extends StatefulWidget {
  const QRCreatePage(
      {super.key,
      required this.qrcodetext,
      required this.headertext,
      required this.infotext});

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
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    color: CupertinoTheme.of(context).primaryColor,
                    width: MediaQuery.of(context).size.width / 3,
                    height: 7,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24),
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  data: widget.qrcodetext,
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24),
                child: FittedBox(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
