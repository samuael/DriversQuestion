import 'package:flutter/material.dart';
import '../libs.dart';

void showThemeChange(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return SelectTheme();
    },
  );
}
