import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/url_launch_helper.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../widgets/grip_bar.dart';

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
      required String infoText}) async {
    return context.pushNamed(AppRoute.qrCreatePage.name, pathParameters: {
      qrCodeText: qrCodeText,
      headerText: headerText,
      infoText: infoText
    });
  }

  @override
  QRCreatePageState createState() => QRCreatePageState();
}

class QRCreatePageState extends State<QRCreatePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const GripBar(),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  Launch.launchUrlFromString(widget.qrCodeText);
                },
                child: Padding(
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
              ),
              const SizedBox(height: 5),
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
