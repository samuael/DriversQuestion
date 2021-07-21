import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class SelectedCategoryProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int selectedIndex = 0;

  int setIndex(int index) {
    this.selectedIndex = index;
    notifyListeners();
  }
}
