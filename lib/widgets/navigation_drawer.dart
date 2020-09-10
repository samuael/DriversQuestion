import 'package:DriversMobile/db/dbsqflite.dart';
import 'package:DriversMobile/handlers/translation.dart';
import 'package:DriversMobile/screens/Categories.dart';
import 'package:DriversMobile/screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import '../screens/SettingsScreen.dart';
// import '../screens/Registration.dart';
import '../handlers/sharedPreference.dart';
import '../screens/ResultScreen.dart';
import '../screens/QuestionScreen.dart';
import "../screens/AboutScreen.dart";

class NavigationDrawer extends StatelessWidget {
  final BuildContext containerContext;
  final UserData userdata;

  const NavigationDrawer({Key key, this.containerContext, this.userdata})
      : super(key: key);

  Widget tileElement({String theTitle, IconData icondata, Function onClick}) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icondata),
        ),
        title: Text(
          theTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onClick,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang;
    String username;
    userdata.initialize();
    lang = userdata.Lang;
    if (lang == "") {
      lang = "eng";
    }
    username = userdata.Username;
    // print("The Language $lang");
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center
            children: [
              Card(
                elevation: 3,
                // height : 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      30,
                    ),
                    bottomRight: Radius.circular(
                      30,
                    ),
                  ),
                ),
                // alignment: Alignment.center,
                // color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    Container(
                        child: Stack(children: [
                      Image.asset(
                        "assets/images/onewTwo.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ])),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.person)
                         ,
                         Text(
                           username,
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                             // fontStyle: FontStyle.italic,
                           ),
                           softWrap: true,
                           overflow: TextOverflow.fade,
                         ),
                       ],
                     )

                  ],
                ),
              ),
              tileElement(
                theTitle: Translation.translate(lang, "Category") == null
                    ? "Category"
                    : Translation.translate(lang, "Category"),
                icondata: Icons.category,
                onClick: () =>
                    Navigator.of(containerContext).pushNamedAndRemoveUntil(
                  CategoryScreen.RouteName,
                  (_) {
                    return false;
                  },
                ),
              ),
              tileElement(
                theTitle: Translation.translate(lang, 'Questions') != null
                    ? Translation.translate(lang, 'Questions')
                    : 'Questions',
                icondata: Icons.question_answer,
                onClick: () => () async {
                  userdata.initialize();
                  Category category;
                  Group group;
                  final databaseManager = DatabaseManager.getInstance();
                  int categoryID = userdata.category;
                  int groupID = userdata.group;
                  if (categoryID != null && groupID != null) {
                    category = DatabaseManager.categories[categoryID - 1];
                    await databaseManager.GetGroupByID(groupID).then((grou) {
                      group = grou;
                    });
                  }
                  return Navigator.of(context).pushNamedAndRemoveUntil(
                    QuestionScreen.RouteName,
                    (_) {
                      return false;
                    },
                    arguments: {
                      "userdata": userdata,
                      "lang": userdata.Lang,
                      "category": category,
                      "group": group,
                    },
                  );
                }(),
              ),
              tileElement(
                theTitle: Translation.translate(lang, 'Result') != null
                    ? Translation.translate(lang, 'Result')
                    : 'Result',
                icondata: Icons.score,
                onClick: () =>
                    Navigator.of(containerContext).pushNamedAndRemoveUntil(
                  ResultScreen.RouteName,
                  (_) {
                    return false;
                  },
                ),
              ),
              tileElement(
                theTitle: Translation.translate(lang, 'Setting') != null
                    ? Translation.translate(lang, 'Setting')
                    : 'Setting',
                icondata: Icons.settings,
                onClick: () =>
                    Navigator.of(containerContext).pushNamedAndRemoveUntil(
                  SettingsScreen.RouteName,
                  (_) {
                    return false;
                  },
                ),
              ),
              tileElement(
                theTitle: Translation.translate(lang, 'About Us') != null
                    ? Translation.translate(lang, 'About Us')
                    : 'About Us',
                icondata: Icons.people_outline,
                onClick: () =>
                    Navigator.of(containerContext).pushNamedAndRemoveUntil(
                  AboutScreen.RouteName,
                  (_) {
                    return false;
                  },
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  height: 100,
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  child: Column(children: [
                    Text(
                      // Translation.translate(
                      Translation.translate(lang, "Question And Answer For Driving Trainees ") != null ? Translation.translate(lang, "Question And Answer For Driving Trainees ") :"Question And Answer For Driving Trainees " ,
                    ),
                    Text(
                      "ሳድል ዳም የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
