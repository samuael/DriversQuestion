import "package:flutter/material.dart";
import 'package:drivers_question/libs.dart';

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
    UserData.getInstance().initialize();
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: [
            Container(
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
                        "ሳድል ዳም የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
                        "Saddle Drivers Training Institute",
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
                overflow: Overflow.clip,
                children: <Widget>[
                  Container(
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
            Column(children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: const RefreshProgressIndicator(
                  backgroundColor: Colors.black,
                  strokeWidth: 5,
                  semanticsLabel: "Loading...",
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
