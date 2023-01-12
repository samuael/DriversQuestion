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
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.21,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sunny,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.elliptical(120, 30)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    tileElement(
                      theTitle: Translation.translate(
                          context.watch<UserDataProvider>().language,
                          "Category"),
                      icondata: Icons.category,
                      onClick: () => Navigator.of(containerContext)
                          .pushNamedAndRemoveUntil(
                        CategoryScreen.RouteName,
                        (_) {
                          return false;
                        },
                      ),
                    ),
                    tileElement(
                      theTitle: Translation.translate(
                          context.watch<UserDataProvider>().language,
                          'Questions'),
                      icondata: Icons.question_answer,
                      onClick: () => () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          QuestionScreen.RouteName,
                          (_) {
                            return false;
                          },
                        );
                      }(),
                    ),
                    tileElement(
                      theTitle: Translation.translate(
                          context.watch<UserDataProvider>().language, 'Result'),
                      icondata: Icons.score,
                      onClick: () => Navigator.of(containerContext)
                          .pushNamedAndRemoveUntil(
                        ResultScreen.RouteName,
                        (_) {
                          return false;
                        },
                      ),
                    ),
                    tileElement(
                      theTitle: Translation.translate(
                          context.watch<UserDataProvider>().language,
                          'Setting'),
                      icondata: Icons.settings,
                      onClick: () => Navigator.of(containerContext)
                          .pushNamedAndRemoveUntil(
                        SettingsScreen.RouteName,
                        (_) {
                          return false;
                        },
                      ),
                    ),
                    tileElement(
                      theTitle: Translation.translate(
                          context.watch<UserDataProvider>().language,
                          'About Us'),
                      icondata: Icons.people_outline,
                      onClick: () => Navigator.of(containerContext)
                          .pushNamedAndRemoveUntil(
                        AboutScreen.RouteName,
                        (_) {
                          return false;
                        },
                      ),
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.elliptical(400, 100),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            Translation.translate(
                                context.watch<UserDataProvider>().language,
                                "Question And Answer For Driving Trainees "),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text("ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
