import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(
    {required String message, Color? textColor, Color? backgroundColor}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor ?? CupertinoColors.systemYellow,
      textColor: textColor ?? CupertinoColors.black);
}
