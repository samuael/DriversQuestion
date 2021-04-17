import 'package:drivers_question/handlers/sharedPreference.dart';
import 'package:flutter/material.dart';

class UserDataState with ChangeNotifier {
  UserData state;
  bool visibleResultBar = false;

  // filtering information will be placed here

  // -----    Filtering Datatypes --------
  // Icon Related Questions
  // Theory Related QUestion
  // All
  // -- This all are to be represented by an emumerator and will be used by the database to filter Questions while fetching

  // UserDataState ...
  UserDataState(UserData udata) {
    this.state = udata;
  }
  // setUserData ...
  setUserData(UserData userd) {
    this.state = userd;
    notifyListeners();
  }

  // setLanguage a method to set the language in the UserData instance
  void setLanguage(String lang) {
    this.state.Lang = lang;
    notifyListeners();
  }

  // setCategory ...
  setCategory(int categoryID) {
    this.state.category = categoryID;
    notifyListeners();
  }

  // setGroup ...
  setGroup(int groupID) {
    this.state.group = groupID;
    notifyListeners();
  }

  // setLang  ...
  setLang(String lang) {
    this.state.Lang = lang;
    notifyListeners();
  }

  // setUsername ...
  setUsername(String username) {
    this.state.Username = username;
    notifyListeners();
  }

  // setThemeIndex ...
  setThemeIndex(int themeIndex) {
    this.state.themeIndex = themeIndex;
    notifyListeners();
  }

  setVisibleResultBar(bool resultBar) {
    this.visibleResultBar = resultBar;
    notifyListeners();
  }
}
