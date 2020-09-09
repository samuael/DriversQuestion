import 'package:DriversMobile/handlers/sharedPreference.dart';
import 'package:DriversMobile/widgets/navigation_drawer.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../handlers/translation.dart';
import '../handlers/sharedPreference.dart';

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
  TextEditingController usernameController = new TextEditingController();

  Color usernameTextColor=Colors.green;
  String usernameText="";

  @override
  Widget build(BuildContext context) {
    if (userdata == null) {
      userdata = UserData.getInstance();
      userdata.initialize();
      this.lang = userdata.Lang;
      this.username = userdata.Username;
    }
    return Scaffold(
        drawer: NavigationDrawer(
          containerContext: context,
          key: UniqueKey(),
          userdata: userdata,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Translation.translate(this.lang, "Settings") == null
                ? "Settings"
                : Translation.translate(this.lang, "Settings"),
          ),
        ),
        body:SingleChildScrollView( child : Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                Translation.translate(lang, "Select Language"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      FontFamily.Abadi_MT_Condensed_Extra_Bold.toString(),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              // width: double.infinity,
              child: DropdownButton<String>(
                hint: Text(
                  Translation.translate(lang, "Select Language"),
                  style: TextStyle(
                    fontFamily:
                        FontFamily.Abadi_MT_Condensed_Extra_Bold.toString(),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
                // value: lang,
                onChanged: (String language) {
                  setState(() {
                    this.lang = language;
                    userdata.SetLanguage(this.lang);
                  });
                },
                items: Translation.languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.language),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Translation.translate(
                            this.lang,
                            language.toUpperCase(),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  new Text(
                    Translation.translate(lang, "Select Theme") != null
                        ? Translation.translate(lang, "Select Theme")
                        : "Select Theme",
                    style: TextStyle(
                      fontFamily:
                          FontFamily.Abadi_MT_Condensed_Extra_Bold.toString(),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                          ),
                          foregroundDecoration: BoxDecoration(
                            color: Colors.white10,
                          ),
                          child: Card(
                            elevation: 3,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          foregroundDecoration: BoxDecoration(
                            color: Colors.white10,
                          ),
                          child: Card(
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black38,
                  ),
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Center(
                        child: Text(
                          Translation.translate(
                                      this.lang, " Change Username ") !=
                                  null
                              ? Translation.translate(
                                  this.lang, " Change Username ")
                              : "Change Username",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      usernameText ,
                      style: TextStyle(
                        color: usernameTextColor ,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        autofocus: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        controller: usernameController,
                        // keyboardType: TextInputType.passwords,
                        maxLines: 1,
                        placeholder: Translation.translate(
                            this.lang, ' Username ') !=
                            null
                            ? Translation.translate(
                            this.lang, ' Username ')
                            : " Username ",
                      ),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      padding: EdgeInsets.all(5),
                      color: Theme.of(context).primaryColor,
                      splashColor: Colors.white24,
                      onPressed: changeUsername,
                      child: Text(
                          Translation.translate(this.lang, "Submit") != null
                              ? Translation.translate(this.lang, "Submit")
                              : "Submit",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        ),
    );
  }


  void changeUsername() {
    setState(() {
      this.usernameText = usernameController.text;
      if(this.usernameText.length <= 2 ){
        this.usernameText= Translation.translate(this.lang, "Invalid Character Length \n Character Length Has to be greater than 2") != null ? Translation.translate(this.lang, "Invalid Character Length \n Character Length Has to be greater than 2") : "Invalid Character Length \n Character Length Has to be greater than 2" ;
        this.usernameTextColor = Colors.red;
      }else {
        this.userdata.SetUsername(this.usernameText);
        this.userdata.initialize();
        /*
      * *
      * *
      */
        this.usernameText = Translation.translate(this.lang , "Username Changed Succesfully ") != null ? Translation.translate(this.lang , "Username Changed Succesfully ") : "Username Changed Succesfully ";
        this.usernameTextColor = Colors.green;
      }
    });

  }
}
