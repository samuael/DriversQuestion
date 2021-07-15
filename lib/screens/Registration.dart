// import 'package:DriversMobile/handlers/list_loaders.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "dart:math" as math;
// import "dart:async";
// import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';
import '../libs.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key}) : super(key: key);

  static final RouteName = "/register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static int loadingIndex = 0;
  static final Loadings = ["Loading.", "Loading..", "Loading..."];

  int counter = 0;
  DatabaseManager databaseManager;
  String dropdownValue = "";
  int groutCounter = 0;
  String lang;
  bool loading = false;
  String message = "";
  Color messageColor = Colors.red;
  List<Question> motorIndexedQuestions = [];
  List<Question> otherIndexedQuestions = [];

  final TextEditingController nameController = TextEditingController();
  String password;
  final TextEditingController passwordController = TextEditingController();
  int questionCounter = 0;
  bool success = true;
  // Userdata

  UserData Userdata;

  String username;

  @override
  void initState() {
    databaseManager = DatabaseManager.getInstance();
    databaseManager.OpenDatabase().then((_) {
      print("Database is Ready ...");
    });

    this.Userdata = UserData.getInstance();
    this.Userdata.initialize();

    super.initState();
  }

  void running() {
    setState(() {
      message = Loadings[loadingIndex];
      loadingIndex++;
      loadingIndex = loadingIndex % 3;
    });
  }

  void tickerFunction(Duration duration) {}

  @override
  Widget build(BuildContext context) {
    final argumentsMap =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    Userdata = argumentsMap["locald"] as UserData;
    Userdata.initialize();
    this.lang = Userdata.Lang;

    this.lang = "amh";
    this.Userdata.SetLanguage("amh");
    this.Userdata.initialize();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // centerTitle: true,
        title: Text(
            Translation.translate(lang, 'Registration') != null
                ? Translation.translate(lang, 'Registration')
                : 'Registration',
            // views[selectedIndex]['title'] as String,
            // Translation.translate("Registration") ,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        actions: [
          Container(
            // width: double.infinity,
            color: Colors.white,
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
                  Userdata.SetLanguage(this.lang);
                  Userdata.initialize();
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Card(
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
              child: Column(children: [
                Container(
                  height: 160,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    Translation.translate(lang,
                                "Register Your name Including the Companiese Password") !=
                            null
                        ? Translation.translate(lang,
                            "Register Your name Including the Companiese Password")
                        : "Register Your name Including the Companiese Password",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ]),
            ),
          ),
          Container(
            // height: 150,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    30,
                  ),
                  topRight: Radius.circular(
                    30,
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  this.loading == true
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Center(
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : Center(),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                      // vertical: 10,
                    ),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: message == "" ? Colors.white : messageColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(message,
                        style: TextStyle(
                          color: messageColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    // height: 40,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoTextField(
                      autofocus: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      placeholder: Translation.translate(
                                  this.lang, 'eg. Name : muhammed') !=
                              null
                          ? Translation.translate(
                              this.lang, 'eg. Name : muhammed')
                          : 'eg. Name : muhammed',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: RaisedButton(
                      onPressed: () => () async {
                        // select questions from the list_loaders and put that
                        // list of question to the sql database .
                      }(),
                      color: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Translation.translate(this.lang, 'Register') !=
                                      null
                                  ? Translation.translate(this.lang, 'Register')
                                  : "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).primaryColorLight,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

List<String> Shuffle(List<String> answers) {
  answers.shuffle(math.Random.secure());
}
