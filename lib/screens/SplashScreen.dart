import 'package:DriversMobile/screens/QuestionScreen.dart';
import "package:flutter/material.dart";
import "package:csv/csv.dart";
import "dart:io";
import "dart:convert";
import "../handlers/sharedPreference.dart";
import "../screens/Registration.dart";
import "../screens/Categories.dart";
import '../db/dbsqflite.dart';

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
  userdata.GetUsername().then((username) {
    print(username);
    if (username == "") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RegistrationScreen.RouteName, (_) {
        return false;
      }, arguments: {
        // 'username': username,
        "locald": userdata,
      });
    } else if ((categoryID != null && groupID != null) &&
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
  databaseManager.GetGroupByID(groupID).then((group) {
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
  print("Executing niggaa ...");
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
  bool _hasError = false;
  @override
  void initState() {
    super.initState();
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
    Future.delayed(
      Duration(milliseconds: 5000),
      () => widget.onInitializationComplete(context),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    _initializeAsyncDependencies(context);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Color(0xFF006699),
        backgroundColor: Color(0x444),
        fontFamily: "Raleway",
        // fontSize : 23 ,
        // fontWeight: FontWeight.bold  ,
        textTheme: Theme.of(context).textTheme.copyWith(
              body1: TextStyle(
                  // fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
              body2: TextStyle(
                // fontFamily: "RobotoCondensed",
                fontWeight: FontWeight.bold,
              ),
              title: TextStyle(
                fontSize: 30,
                // fontFamily: "RobotoCondensed",
              ),
            ),
      ),
      title: 'Splash Screen',
      home: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
        // appBar : AppBar(
        //   title : Text(
        //     " Drivers Exercise " ,
        //   ) ,
        // ),
        body: Column(children: [
      Container(
        // backgroundColor: Color(0xFF006699),
        child: Card(
          elevation: 3,
          // backgroundColor : Colors.blue  ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                25,
              ),
              bottomRight: Radius.circular(
                25,
              ),
            ),
          ),

          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            Container(
                child: Text(
                  "ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 3,
                )),
            Container(
                child: Text(
                  "Shambel Drivers Training Institute",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 3,
                )),
            Container(
                child: Text(
                  " Drivers Exercise Question ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 3,
                )),
          ]),
        ),
      ),
      Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              25,
            ),
            bottomRight: Radius.circular(
              25,
            ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: const CircularProgressIndicator(),
              )
            ])
          ],
        ),
      )
    ]));
  }
}
