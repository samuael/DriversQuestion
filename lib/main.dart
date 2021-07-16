import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'libs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserData ud = UserData.getInstance();
  ud.initTheme();
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  Future.delayed(
    Duration(milliseconds: 2000),
    () => runApp(
      MultiProvider(
        providers: [
          Provider<Questions>(create: (_) => Questions()),
          Provider<ActiveQuestion>(create: (_) => ActiveQuestion()),
          Provider<ThemeProvider>(create: (_) => ThemeProvider()),
          Provider<UserDataProvider>(create: (_) => UserDataProvider(ud)),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  int themeIndex = 0;
  // themeProvider
  ThemeProvider themeProvider;

  UserData Userdata = UserData.getInstance();
  @override
  Widget build(BuildContext context) {
    // UserData.getInstance().initialize();
    themeIndex = UserData.getInstance().themeIndex;
    return Consumer<UserDataProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drivers Question',
          theme: ThemeProvider.themes[themeProvider.themeIndex],
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
      },
    );
    //  )) },
    // );
  }
}
