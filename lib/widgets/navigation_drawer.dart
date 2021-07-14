import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../libs.dart';

class NavigationDrawer extends StatelessWidget {
  final BuildContext containerContext;
  // final UserData userdata;

  NavigationDrawer({Key key, this.containerContext}) : super(key: key);

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

  UserDataProvider userDataProvider;
  @override
  Widget build(BuildContext context) {
    userDataProvider = context.read<UserDataProvider>();

    // String lang;
    // String username;
    // userdata.initialize();
    // lang = userdata.Lang;
    // if (lang == "") {
    //   lang = "eng";
    // }
    // username = userdata.Username;
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
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text(
                          context.watch<UserDataProvider>().username,
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
                theTitle: Translation.translate(
                            context.watch<UserDataProvider>().language,
                            "Category") ==
                        null
                    ? "Category"
                    : Translation.translate(
                        context.watch<UserDataProvider>().language, "Category"),
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
                theTitle: Translation.translate(
                            context.watch<UserDataProvider>().language,
                            'Questions') !=
                        null
                    ? Translation.translate(
                        context.watch<UserDataProvider>().language, 'Questions')
                    : 'Questions',
                icondata: Icons.question_answer,
                onClick: () => () async {
                  context.watch<UserDataProvider>().userdata.initialize();
                  Category category;
                  Group group;
                  final databaseManager = DatabaseManager.getInstance();
                  int categoryID =
                      context.watch<UserDataProvider>().userdata.category;
                  int groupID =
                      context.watch<UserDataProvider>().userdata.group;
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
                      "userdata": context.watch<UserDataProvider>().userdata,
                      "lang": context.watch<UserDataProvider>().userdata.Lang,
                      "category": category,
                      "group": group,
                    },
                  );
                }(),
              ),
              tileElement(
                theTitle: Translation.translate(
                            context.watch<UserDataProvider>().language,
                            'Result') !=
                        null
                    ? Translation.translate(
                        context.watch<UserDataProvider>().language, 'Result')
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
                theTitle: Translation.translate(
                            context.watch<UserDataProvider>().language,
                            'Setting') !=
                        null
                    ? Translation.translate(
                        context.watch<UserDataProvider>().language, 'Setting')
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
                theTitle: Translation.translate(
                            context.watch<UserDataProvider>().language,
                            'About Us') !=
                        null
                    ? Translation.translate(
                        context.watch<UserDataProvider>().language, 'About Us')
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
                      Translation.translate(
                                  context.watch<UserDataProvider>().language,
                                  "Question And Answer For Driving Trainees ") !=
                              null
                          ? Translation.translate(
                              context.watch<UserDataProvider>().language,
                              "Question And Answer For Driving Trainees ")
                          : "Question And Answer For Driving Trainees ",
                    ),
                    Text(
                      "ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
