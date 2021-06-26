import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//
class ThemeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static List<ThemeData> themes = [
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
    ),
  ];

  ThemeData theTheme;
  int themeIndex = 0;
  ThemeData get theme => theTheme;

  void setTheme(int index) {
    this.theTheme = themes[index];
    notifyListeners();
  }
}
