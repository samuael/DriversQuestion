import "package:flutter/material.dart";
import "./screens/SplashScreen.dart";
import "./widgets/navigation_drawer.dart";
import "./screens/Registration.dart";
import "./screens/Categories.dart";
import "./handlers/sharedPreference.dart";
import 'package:flutter/services.dart';
import './screens/SettingsScreen.dart';
import './screens/QuestionScreen.dart';
import './screens/ResultScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Select Category',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
          return CategoryScreen();
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
        QuestionScreen.RouteName: (BuildContext context) {
          return QuestionScreen.getInstance();
        }
      },
    );
  }
}
