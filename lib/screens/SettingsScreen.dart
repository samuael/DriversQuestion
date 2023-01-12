import '../libs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_below/dropdown_below.dart';

class SettingsScreen extends StatefulWidget {
  static const RouteName = "/settings/";
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();

  static SettingsScreen instance;

  static SettingsScreen GetInstance() {
    if (instance == null) {
      SettingsScreen.instance = SettingsScreen(key: UniqueKey());
    }
    return instance;
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  String lang = "";
  UserData userdata;
  String username;

  bool visibleTheme = true;
  IconData themeIcon = Icons.arrow_forward_ios;
  bool visibleUsernameEntry = true;
  IconData usernameIcon = Icons.arrow_forward_ios;

  TextEditingController usernameController = new TextEditingController();

  Color usernameTextColor = Colors.green;
  String usernameText = "";

  UserDataProvider userdataProvider;
  ThemeProvider themeProvider;

  int selectedLanguage = 0;
  String languageSelectionHint = "Select Language";

  List<DropdownMenuItem> getMenuItems() {
    return [
      DropdownMenuItem(
        value: 0,
        child: Text(Translation.translate(
            userdataProvider.language, "English".toUpperCase())),
      ),
      DropdownMenuItem(
        value: 1,
        child: Text(Translation.translate(
            userdataProvider.language, "Amharic".toUpperCase())),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    this.themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    this.userdataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    this.userdata = userdataProvider.userdata;
    this.selectedLanguage =
        userdataProvider.language.toLowerCase() == "eng" ? 0 : 1;
    return Scaffold(
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          Translation.translate(userdataProvider.language, "Settings"),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.03,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(10, 10),
                          topRight: Radius.elliptical(10, 10))),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(Translation.translate(
                  userdataProvider.language, "Select Language")),
              subtitle: DropdownBelow(
                itemWidth: 200,
                itemTextstyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                boxTextstyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor,
                ),
                boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                boxHeight: 45,
                boxWidth: 200,
                value: selectedLanguage,
                items: getMenuItems(),
                onChanged: (item) {
                  setState(() {
                    selectedLanguage = item;
                    this.lang = item == 0 ? "eng" : "amh";
                    userdataProvider.setLanguage(this.lang);
                  });
                },
              ),
              trailing: Icon(Icons.language),
            ),
            GestureDetector(
              onTap: () {
                if (visibleTheme) {
                  setState(() {
                    themeIcon = Icons.arrow_forward_ios;
                    visibleTheme = false;
                  });
                  return;
                }
                setState(() {
                  themeIcon = Icons.arrow_drop_down_circle_outlined;
                  visibleTheme = true;
                });
              },
              child: ListTile(
                title: Text(
                  Translation.translate(
                      this.userdataProvider.language, "Change Theme"),
                ),
                trailing: Icon(themeIcon),
              ),
            ),
            visibleTheme ? SelectTheme() : SizedBox(),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(200, 50),
                ),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም \n\nAddress: \nBenishangul Gumz/Assosa or\nSidama Region/Hawassa",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// yfthiwqi