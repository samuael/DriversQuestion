import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ThemeState a class with a ChangeNotifier provider state management class
class ThemeState with ChangeNotifier {
  int themeIndex = 0;
  ThemeData theme;
  ThemeState() {
    this.theme = themeDatas[themeIndex];
  }
  static final List<ThemeData> themeDatas = List<ThemeData>.from([
    ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    ),
    ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.white,
        ),
      ),
      canvasColor: Colors.black26,
    ),
    ThemeData(
      primarySwatch: Colors.brown,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.white,
        ),
      ),
      canvasColor: Colors.black26,
    ),
    ThemeData(
      primarySwatch: Colors.teal,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    ),
    ThemeData(
      primarySwatch: Colors.orange,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    )
  ]);

  // setThemeIndex method to set the theme Index and the theme Value
  void setThemeIndex(int index) {
    this.themeIndex = index;
    this.theme = themeDatas[this.themeIndex];
    notifyListeners();
  }
}
