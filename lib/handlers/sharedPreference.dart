import "package:shared_preferences/shared_preferences.dart";

class UserData {
  static const String PASSWORD = "shambel1122";

  String Lang="amh";
  String Username;
  int category;
  int group;
  int themeIndex =0;


  static UserData userdata;

  Future<int > GetThemeIndex() async {
    final pref = await SharedPreferences.getInstance();
    this.themeIndex = pref.getInt("theme");
    if(this.themeIndex==null ){
      this.themeIndex=0;
    }
    return this.themeIndex;
  }

  Future<int> SetThmeIndex(int themeIndex) async {
    final pref = await SharedPreferences.getInstance();
    bool success =false;
    pref.setInt( "theme" , themeIndex ).then((val ){
      this.themeIndex= themeIndex;
      success = val ;
    });
    if(success){
      return this.themeIndex;
    }
    return 0;
  }

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
    GetThemeIndex();
    GetUsername();
    GetCategory();
    GetLanguage();
    GetGroup();

  }
  Future<void> initTheme() async {
    await GetThemeIndex();
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
    this.category = value;
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
    this.group = value;
    return value;
  }

  static UserData getInstance() {
    if (userdata == null) {
      userdata = UserData();
    }
    return userdata;
  }
}
