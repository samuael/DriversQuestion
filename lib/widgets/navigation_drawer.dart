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
            // mainAxisAlignment: MainAxisAlignment.center
            children: [
              // Card(
              //   elevation: 3,
              //   // height : 100,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //       bottomRight: Radius.elliptical(120, 40),
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       Container(
              //         width: double.infinity,
              //         padding: EdgeInsets.all(20),
              //         child: Stack(
              //           children: [
              //             Image.asset(
              //               "assets/images/logo.png",
              //               fit: BoxFit.cover,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.star,
              //             color: Colors.yellow,
              //           ),
              //           Text(
              //             context.watch<UserDataProvider>().username.length > 15
              //                 ? context
              //                     .watch<UserDataProvider>()
              //                     .username
              //                     .substring(0, 15)
              //                 : context.watch<UserDataProvider>().username,
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 17,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             softWrap: true,
              //             overflow: TextOverflow.fade,
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
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
