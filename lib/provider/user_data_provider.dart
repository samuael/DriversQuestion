import 'package:DriversMobile/handlers/sharedPreference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//
class UserDataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  UserData _userdata;
  UserData get userdata => _userdata;

  void setUserData(UserData userd) {
    this._userdata = userd;
    notifyListeners();
  }
}
