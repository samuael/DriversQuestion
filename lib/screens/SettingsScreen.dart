import '../libs.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  /// Theme Related Datas
  bool visibleTheme = false;
  IconData themeIcon = Icons.arrow_forward_ios;
  //username changing related actions
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
    /// language related selections
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
    // initialization of variables
    this.themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    this.userdataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    this.userdata = userdataProvider.userdata;
    this.selectedLanguage =
        userdataProvider.language.toLowerCase() == "eng" ? 0 : 1;
    print("The Selected Language is : $selectedLanguage");
    //------
    return Scaffold(
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Consumer<UserDataProvider>(
          builder: (context, userDataProvider, _) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.elliptical(200, 200),
                      topLeft: Radius.elliptical(200, 200))),
              child: Text(
                  Translation.translate(
                              userDataProvider.language, "Settings") ==
                          null
                      ? "Settings"
                      : Translation.translate(
                          userDataProvider.language, "Settings"),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
            );
          },
        ),
      ),
      body: Container(
        // color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
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
                  // hint: Text('Choose Language'),
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
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      visibleUsernameEntry = !visibleUsernameEntry;
                      usernameIcon = Icons.arrow_drop_down_circle_outlined;
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    Translation.translate(
                        this.userdataProvider.language, "Change Username"),
                  ),
                  trailing: Icon(usernameIcon),
                ),
              ),
              ChangeUsername(),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 50),
                    )),
                height: 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
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
      ),
    );
  }
}
// yfthiwqi