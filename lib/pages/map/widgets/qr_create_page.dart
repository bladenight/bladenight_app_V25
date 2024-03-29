import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/url_launch_helper.dart';

class QRCreatePage extends StatefulWidget {
  const QRCreatePage(
      {super.key,
      required this.qrCodeText,
      required this.headerText,
      required this.infoText});

  final String headerText;
  final String infoText;
  final String qrCodeText;

  static Future<dynamic> show(
      {required BuildContext context,
      required String qrCodeText,
      required String headerText,
      required String infotext}) async {
    return Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => QRCreatePage(
        qrCodeText: qrCodeText,
        headerText: headerText,
        infoText: infotext,
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
                  data: widget.qrCodeText,
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24),
                child: FittedBox(
                  child: GestureDetector(
                    onTap: () async {
                      Launch.launchUrlFromString(widget.qrCodeText);
                    },
                    child: Text(widget.infoText,
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
