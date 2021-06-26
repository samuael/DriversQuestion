import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'libs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserData ud = UserData.getInstance();
  ud.initTheme();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  Future.delayed(
    Duration(milliseconds: 2000),
    () => runApp(MainApp()),
  );
}

class MainApp extends StatelessWidget {
  int themeIndex = 0;
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

  UserData Userdata = UserData.getInstance();

  @override
  Widget build(BuildContext context) {
    // UserData.getInstance().initialize();
    themeIndex = UserData.getInstance().themeIndex;
    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Select Category',
      theme: themeDatas[themeIndex],
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) {
          return SplashApp();
        },
        RegistrationScreen.RouteName: (BuildContext context) {
          return RegistrationScreen(
            key: UniqueKey(),
          );
        },
        CategoryScreen.RouteName: (BuildContext context) {
          return CategoryScreen.getInstance();
        },
        SettingsScreen.RouteName: (BuildContext context) {
          return SettingsScreen.GetInstance();
        },
        QuestionScreen.RouteName: (BuildContext context) {
          return QuestionScreen.getInstance();
        },
        ResultScreen.RouteName: (BuildContext context) {
          return ResultScreen.getInstance();
        },
        AboutScreen.RouteName: (BuildContext context) {
          return AboutScreen();
        }
      },
    );
    return materialApp;
  }
}
