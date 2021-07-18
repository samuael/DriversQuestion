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
          ChangeNotifierProvider<Questions>(
            create: (_) => Questions(),
            lazy: false,
          ),
          ChangeNotifierProvider<ActiveQuestion>(
            create: (_) => ActiveQuestion(),
            lazy: false,
          ),
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
            lazy: false,
          ),
          ChangeNotifierProvider<UserDataProvider>(
            create: (_) => UserDataProvider(ud),
            lazy: false,
          ),
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

  @override
  Widget build(BuildContext context) {
    UserData.getInstance();
    // UserData.getInstance().initialize();
    themeIndex = UserData.getInstance().themeIndex;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drivers Question',
      theme: context.watch<ThemeProvider>().theTheme,
      initialRoute: "/",
      routes: {
        "/": (BuildContext contaex1) {
          return SplashApp();
        },
        RegistrationScreen.RouteName: (BuildContext contaex2) {
          return RegistrationScreen(
            key: UniqueKey(),
          );
        },
        CategoryScreen.RouteName: (BuildContext contaex3) {
          return CategoryScreen.getInstance();
        },
        SettingsScreen.RouteName: (BuildContext contaex4) {
          return SettingsScreen.GetInstance();
        },
        QuestionScreen.RouteName: (BuildContext contaex5) {
          return QuestionScreen.getInstance();
        },
        ResultScreen.RouteName: (BuildContext contaex6) {
          return ResultScreen.getInstance();
        },
        AboutScreen.RouteName: (BuildContext contaex7) {
          return AboutScreen();
        }
      },
    );
    //   },
    // );
    //  )) },
    // );
  }
}
