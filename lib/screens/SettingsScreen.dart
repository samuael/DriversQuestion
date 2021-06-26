import '../libs.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  final themeImages = [
    "assets/images/defaultTheme.png",
    "assets/images/blueBlack.png",
    "assets/images/themeBrown.png",
    "assets/images/tealTheme.png",
    "assets/images/deepOrange.png"
  ];

  Color usernameTextColor = Colors.green;
  String usernameText = "";

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
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
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
                height: 30,
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
              Container(
                child: Text(
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
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                height: 250,
                child: new ListView.builder(
                  itemCount: themeImages.length,
                  itemBuilder: (BuildContext context, int index) {
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
                        usernameText,
                        style: TextStyle(
                          color: usernameTextColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 10),
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: CupertinoTextField(
                          // autofocus: true,
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
                              ? Translation.translate(this.lang, ' Username ')
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
      ),
    );
  }

  void changeUsername() {
    setState(() {
      this.usernameText = usernameController.text;
      if (this.usernameText.length <= 2) {
        this.usernameText = Translation.translate(this.lang,
                    "Invalid Character Length \n Character Length Has to be greater than 2") !=
                null
            ? Translation.translate(this.lang,
                "Invalid Character Length \n Character Length Has to be greater than 2")
            : "Invalid Character Length \n Character Length Has to be greater than 2";
        this.usernameTextColor = Colors.red;
      } else {
        this.userdata.SetUsername(this.usernameText);
        this.userdata.initialize();
        /*
      * *
      * *
      */
        this.usernameText = Translation.translate(
                    this.lang, "Username Changed Succesfully ") !=
                null
            ? Translation.translate(this.lang, "Username Changed Succesfully ")
            : "Username Changed Succesfully ";
        this.usernameTextColor = Colors.green;
      }
    });
  }

  void changeTheme(BuildContext contaext, int index) {
    this.userdata.SetThmeIndex(index);
    this.userdata.initialize();

    showDialog(
      context: context,
      builder: (conta) {
        return AlertDialog(
          title: Text(
            Translation.translate(lang, "Theme Change") != null
                ? Translation.translate(lang, "Theme Change")
                : "Theme Change",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevation: 25,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(conta),
              child: Text(
                Translation.translate(lang, "ok") != null
                    ? Translation.translate(lang, "Ok")
                    : "Ok",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
              ),
            ),
            // FlatButton(
            //   onPressed: () => Navigator.pop(conta),
            //   child: Text(
            //     Translation.translate(lang, "Cancel") != null
            //         ? Translation.translate(lang, "Cancel")
            //         : "Cancel",
            //     textAlign: TextAlign.justify,
            //     style: TextStyle(
            //       backgroundColor: Theme.of(context).primaryColor,
            //       color: Colors.white,
            //     ),
            //   ),),
            // FlatButton(
            //     onPressed: () => SystemNavigator.pop(animated: true),
            //     child: Text(
            //       Translation.translate(lang, "Exit App") != null
            //           ? Translation.translate(lang, "Exit App")
            //           : "Exit App",
            //       textAlign: TextAlign.justify,
            //       style: TextStyle(
            //         backgroundColor: Theme.of(context).primaryColor,
            //         color: Colors.white,
            //       ),
            //     ),),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          // shape: CircleBorder(),
          contentPadding: EdgeInsets.all(20),
          titlePadding: EdgeInsets.all(10),
          content: Text(
            Translation.translate(
                        lang, "To Apply the change . Restart the App !") !=
                    null
                ? Translation.translate(
                    lang, "To Apply the change . Restart the App !")
                : "To Apply the change . Restart the App !",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }
}
