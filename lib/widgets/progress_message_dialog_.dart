import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

class ProgressMessageDialog {
  static String message;
  static ProgressDialog dialog;

  static Future<void> show(BuildContext context, message) async {
    dialog = ProgressDialog(context,
        type: ProgressDialogType.Download,
        isDismissible: true,
        showLogs: false);
    dialog.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOutCubic,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600));
    dialog.show();
    Future.delayed(Duration(seconds: 1), () {
      dialog.hide();
    });
  }
}
