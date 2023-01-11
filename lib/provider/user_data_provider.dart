import '../../libs.dart';
import 'package:flutter/foundation.dart';

// UserDataProvider ...
class UserDataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  UserData _userdata;
  UserData get userdata => _userdata;

  UserDataProvider(this._userdata);

  void setUserData(UserData userd) {
    this._userdata = userd;
    notifyListeners();
  }

  Future<void> setThemeIndex(int index) async {
    await this._userdata.SetThmeIndex(index);
    this._userdata.initialize();
    notifyListeners();
  }

  int get themeIndex {
    return this._userdata.themeIndex;
  }

  String get username {
    return this._userdata.Username;
  }

  Future<String> setUsername(String username) async {
    String val = await this._userdata.SetUsername(username);
    notifyListeners();
    return val;
  }

  String get language {
    return this._userdata.Lang;
  }

  void setLanguage(String lang) {
    this._userdata.SetLanguage(lang);
    this._userdata.Lang = lang;
    notifyListeners();
  }

  int get category {
    return this._userdata.category;
  }

  void setCategory(int category) {
    this._userdata.SetCategory(category);
    notifyListeners();
  }
}
