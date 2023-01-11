import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../libs.dart';

class SelectTheme extends StatelessWidget {
  SelectTheme({Key key}) : super(key: key);

  UserDataProvider userDataProvider;
  ThemeProvider themeProvider;
  final List<String> themeImages = [
    "assets/images/defaultTheme.png",
    "assets/images/blueBlack.png",
    "assets/images/themeBrown.png",
    "assets/images/tealTheme.png",
    "assets/images/deepOrange.png"
  ];

  @override
  Widget build(BuildContext context) {
    userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    this.themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            child: new ListView.builder(
              itemCount: themeImages.length,
              itemBuilder: (BuildContext contexto, int index) {
                return InkWell(
                  onTap: () => changeTheme(context, index),
                  child: Container(
                    // height: 120,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 150,
                    child: Image.asset("${themeImages[index]}"),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  void changeTheme(BuildContext contaext, int index) {
    contaext.read<UserDataProvider>().setThemeIndex(index);
    contaext.read<ThemeProvider>().setTheme(index);
    UserData.getInstance().SetThmeIndex(index);
    ProgressMessageDialog.show(contaext, "Updating Theme ...");
  }
}
