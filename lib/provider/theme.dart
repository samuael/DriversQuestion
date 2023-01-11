import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "../../libs.dart";

const MaterialColor myRed = MaterialColor(
  0xffC70039,
  <int, Color>{
    50: Color(0xffC70039),
    100: Color(0xffC70039),
    200: Color(0xffC70039),
    300: Color(0xffC70039),
    400: Color(0xffC70039),
    500: Color(0xffC70039),
    600: Color(0xffC70039),
    700: Color(0xffC70039),
    800: Color(0xffC70039),
    900: Color(0xffC70039),
  },
);

class ThemeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static List<ThemeData> themes = [
    ThemeData(
      primarySwatch: myRed, //Color(0xffC70039),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    ),
    ThemeData(
      primarySwatch: myRed,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white70,
    ),
    ThemeData(
      primarySwatch: Colors.brown,
      // backgroundColor: Colors.white24,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.brown,
        ),
      ),
      canvasColor: Colors.white70,
    ),
    ThemeData(
      primarySwatch: Colors.teal,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    ),
    ThemeData(
      primarySwatch: Colors.orange,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
      ),
      canvasColor: Colors.white,
    ),
  ];
  UserData userdata;
  ThemeProvider.withUserData({UserData userdata}) {
    this.themeIndex = userdata.themeIndex;
    this.theTheme = themes[this.themeIndex];
    this.userdata = userdata;
  }

  ThemeProvider() {
    this.userdata = UserData.getInstance();
    this.userdata.initialize();
    this.themeIndex = this.userdata.themeIndex;
  }

  ThemeData theTheme;
  int themeIndex = 0;
  ThemeData get theme => theTheme;

  void setTheme(int index) async {
    this.themeIndex = index;
    this.theTheme = themes[this.themeIndex];
    await this.userdata.SetThmeIndex(this.themeIndex);
    notifyListeners();
  }
}
