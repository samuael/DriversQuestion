import 'package:drivers_question/states/userdata_state.dart';
import "package:flutter/material.dart";
import "package:drivers_question/libs.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserData ud = UserData.getInstance();
  ud.initTheme();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  Future.delayed(
    Duration(milliseconds: 2000),
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserDataState(ud)),
          ChangeNotifierProvider(create: (_) => ThemeState()),
        ],
        child: MainApp(),
      ),
    ),
  );
}

// MainApp class
class MainApp extends StatelessWidget {
  int themeIndex = 0;

  UserData Userdata = UserData.getInstance();
  @override
  Widget build(BuildContext context) {
    themeIndex = UserData.getInstance().themeIndex;
    final materialApp = getNewMaterialApp(context);
    return materialApp;
  }
}

Widget getNewMaterialApp(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Drivers Question',
    theme: context.watch<ThemeState>().theme,
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
}
