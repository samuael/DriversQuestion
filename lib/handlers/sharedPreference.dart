import "package:shared_preferences/shared_preferences.dart";

class UserData {
  static const String PASSWORD = "shambel1122";

  String Lang;
  String Username;
  int category;
  int group;
  static UserData userdata;
  Future<String> GetUsername() async {
    final pref = await SharedPreferences.getInstance();
    this.Username = pref.getString("username");
    if (this.Username == null || this.Username == "") {
      return "";
    }
    return this.Username;
  }

  Future<String> SetUsername(String username) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("username", username);
    return username;
  }

  void initialize() {
    GetUsername();
    GetCategory();
    GetLanguage();
    GetGroup();
  }

  Future<void> resetUsername() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("username", "");
  }

  Future<void> SetLanguage(String lang) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("lang", lang);
    return lang;
  }

  Future<String> GetLanguage() async {
    final pref = await SharedPreferences.getInstance();
    this.Lang = pref.getString("lang");
    if (this.Lang == null || this.Lang == "") {
      return "";
    }
    return this.Lang;
  }

  Future<int> SetCategory(int category) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("category", category).then((val) {
      if (val) {
        return category;
      }
      return -1;
    });
  }

  Future<int> GetCategory() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getInt("category");
    return value;
  }

  Future<int> SetGroup(int group) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("group", category).then((val) {
      if (val) {
        return category;
      }
      return -1;
    });
  }

  Future<int> GetGroup() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getInt("group");
    return value;
  }

  static UserData getInstance() {
    if (userdata == null) {
      userdata = UserData();
    }
    return userdata;
  }
}
