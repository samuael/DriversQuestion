import '../libs.dart';
import 'package:flutter/scheduler.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

Future<void> runMainApp(BuildContext context) async {
  final UserData userdata = UserData.getInstance();
  int groupID = 0;
  int categoryID = 0;
  await userdata.GetCategory().then((group) {
    categoryID = group;
  });

  await userdata.GetGroup().then((group) {
    groupID = group;
  });
  await userdata.initialize();

  categoryID = userdata.category;
  groupID = userdata.group;
  userdata.GetUsername().then((username) {
    if (username == "") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RegistrationScreen.RouteName, (_) {
        return false;
      }, arguments: {
        // 'username': username,
        "locald": userdata,
      });
    } else if ((categoryID != null &&
            groupID != null &&
            groupID > 0 &&
            categoryID > 0) &&
        (categoryID > 0 && groupID > 0)) {
      gotoQuestions(categoryID, groupID, context);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(CategoryScreen.RouteName,
          (_) {
        return false;
      }, arguments: {
        'username': username,
        "locald": userdata,
      });
    }
  });
  // CategoryScreen(   ),
}

Future<void> gotoQuestions(
    int categoryID, int groupID, BuildContext context) async {
  Group groupo;
  Category category;
  final databaseManager = DatabaseManager.getInstance();
  category = DatabaseManager.categories[categoryID - 1];
  print("Group ID In Splash Screen IS L $groupID");
  await databaseManager.GetGroupByID(groupID).then((group) {
    groupo = group;
  });
  final userdata = UserData.getInstance();
  userdata.initialize();
  if (groupo == null) {
    Navigator.of(context).pushNamedAndRemoveUntil(CategoryScreen.RouteName,
        (_) {
      return false;
    }, arguments: {
      'username': UserData.getInstance().Username,
      "locald": userdata,
    });
  }
  print("Category ID : $categoryID");
  print("Group ID : $groupID");
  print("Userdata  : $userdata");
  print("Lang ID : ${userdata.Lang}");
  Navigator.of(context).pushNamedAndRemoveUntil(
    QuestionScreen.RouteName,
    (_) {
      return false;
    },
    arguments: {
      "userdata": userdata,
      "lang": userdata.Lang,
      "category": category,
      "group": groupo,
    },
  );
}

class SplashApp extends StatefulWidget {
  final Function onInitializationComplete = runMainApp;
  static const String RouteName = "/splash/";

  const SplashApp({
    Key key,
    // @required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  void initState() {
    super.initState();
    // start the ticker to control the progress value
    // updateTime();
  }

  double tickerValue = 0;

  /// some thing that update a value every time the time ticks
  /// Method Name : updateTime
  void updateTime() {
    Ticker ticker;
    ticker = new Ticker((Duration duration) {
      if (duration.inSeconds >= 50) {
        ticker.stop();
      }
      setState(() {
        this.tickerValue = duration.inSeconds * 0.02;
        print(this.tickerValue);
      });
    });
    ticker.start();
  }

  Future<void> _initializeAsyncDependencies(BuildContext context) async {
    // print("......................................................................  It Is Calling Me    ....................................................................................");
    // setState((){
    //   loadCsvData().then( (listo){
    //     print("........................................................I Goot Called ............................ ....");
    //     lists = listo;
    //   }  );
    // });
    // print(lists);
    UserData.getInstance().initialize();
    Future.delayed(
      Duration(milliseconds: 3000),
      () => widget.onInitializationComplete(context),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    _initializeAsyncDependencies(context);

    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: context.watch<ThemeProvider>().theTheme,
    //     home: _buildBody(),
    //   );
    // }

    // Widget _buildBody() {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar : AppBar(
      //   title : Text(
      //     " Drivers Exercise " ,
      //   ) ,
      // ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.elliptical(1000, 1000))),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(width: 0, style: BorderStyle.none),
                ),
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
                  margin: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, style: BorderStyle.none),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(100, 50),
                    ),
                  ),
                  child: Stack(
                    overflow: Overflow.clip,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/onewTwo.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: AnimatedLiquidLinearProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
