// import 'package:DriversMobile/handlers/list_loaders.dart';
import 'package:DriversMobile/handlers/list_loaders.dart';
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
                        setState(() {
                          this.loading = true;
                          this.messageColor = Colors.green;
                          this.message =
                              Translation.translate(this.lang, "Loading") +
                                  " ... ";
                        });
                        this.username = nameController.text;
                        if (username == null || username == "") {
                          this.username = "Unknown";
                          this.Userdata = UserData.getInstance();
                          this.Userdata.SetUsername(this.username);
                        }
                        // select questions from the list_loaders and put that
                        // list of question to the sql database.

                        // groups holding list of groups.
                        List<Group> groups = [];
                        // gradeResults holding the gradeResults for each tests
                        List<GradeResult> gradeResults = [];

                        /// getting motor questions
                        List<Question> motorQuestions = [];
                        motorQuestions.addAll(
                            await ListLoader.loadNonIndexedQuestions(
                                "assets/file.xlsx", "Motor", 1, 0));
                        motorQuestions.addAll(await ListLoader.loadQuestions(
                            "assets/file.xlsx", "MotorIndexed", 1, 0));
                        // shuffling questions and giving an ID for each of them at the
                        // same time giving a group to them
                        print(
                            "Length Of Motor Questions Found ${motorQuestions.length}");
                        int groupsID = 0;
                        int groupCount = 1;
                        int count = 0;

                        int a = 0;
                        do {
                          motorQuestions[a].ID = a;
                          motorQuestions[a].Groupid = (a / 100).floor();
                          if (motorQuestions[a].Groupid > (groupCount - 1)) {
                            Group group = Group(
                              ID: groupsID,
                              Categoryid: 1,
                              GroupNumber: groupCount,
                              QuestionsCount: count,
                            );
                            GradeResult gradeResult = GradeResult(
                              ID: groupsID,
                              Categoryid: 1,
                              Groupid: group.ID,
                              AnsweredCount: 0,
                              AskedCount: 0,
                              Questions: [],
                            );
                            groupsID++;
                            groupCount++;
                            groups.add(group);
                            gradeResults.add(gradeResult);
                            count = 0;
                          }
                          count++;
                          a++;
                        } while (a < motorQuestions.length);
                        if (count % 100 > 0) {
                          Group group = Group(
                            ID: groupsID,
                            Categoryid: 1,
                            GroupNumber: groupCount,
                            QuestionsCount: count,
                          );
                          GradeResult gradeResult = GradeResult(
                            ID: groupsID,
                            Categoryid: 1,
                            Groupid: group.ID,
                            AnsweredCount: 0,
                            AskedCount: 0,
                            Questions: [],
                          );
                          groupsID++;
                          groupCount++;
                          groups.add(group);
                          gradeResults.add(gradeResult);
                          count = 0;
                        }

                        int othersInit = motorQuestions.length;

                        /// getting others questions
                        List<Question> othersQuestions = [];
                        othersQuestions.addAll(
                            await ListLoader.loadNonIndexedQuestions(
                                "assets/file.xlsx", "Others", 2, 0));
                        othersQuestions.addAll(await ListLoader.loadQuestions(
                            "assets/file.xlsx", "OthersIndexed", 2, 0));
                        // shuffling questions and giving an ID for each of them at the
                        // same time giving a group to them
                        int ogroupCount = 1, ocount = 0;

                        int b = 0;
                        do {
                          othersQuestions[b].ID = othersInit + b;
                          othersQuestions[b].Groupid = (b / 100).floor();
                          if (othersQuestions[b].Groupid > (ogroupCount - 1)) {
                            Group group = Group(
                                ID: groupsID,
                                Categoryid: 2,
                                GroupNumber: ogroupCount,
                                QuestionsCount: ocount);
                            GradeResult gradeResult = GradeResult(
                              ID: groupsID,
                              Categoryid: 2,
                              Groupid: group.ID,
                              AnsweredCount: 0,
                              AskedCount: 0,
                              Questions: [],
                            );
                            groupsID++;
                            ogroupCount++;
                            groups.add(group);
                            gradeResults.add(gradeResult);
                            ocount = 0;
                          }
                          ocount++;
                          b++;
                        } while (b < othersQuestions.length);
                        if (ocount % 100 > 0) {
                          Group group = Group(
                              ID: groupsID,
                              Categoryid: 2,
                              GroupNumber: ogroupCount,
                              QuestionsCount: ocount);
                          GradeResult gradeResult = GradeResult(
                            ID: groupsID,
                            Categoryid: 2,
                            Groupid: group.ID,
                            AnsweredCount: 0,
                            AskedCount: 0,
                            Questions: [],
                          );
                          groupsID++;
                          ogroupCount++;
                          groups.add(group);
                          gradeResults.add(gradeResult);
                          ocount = 0;
                        }

                        int iconsInit = othersQuestions.length + othersInit;

                        /// getting icons questions
                        List<Question> iconsQuestions = [];
                        iconsQuestions.addAll(await ListLoader.loadITAQuestions(
                            "assets/file.xlsx", "sign_question", 3, 0));
                        iconsQuestions.addAll(await ListLoader.loadTIAQuestions(
                            "assets/file.xlsx", "sing_answer", 3, 0));
                        // shuffling questions and giving an ID for each of them at the
                        // same time giving a group to them
                        int igroupCount = 1, icount = 0;

                        int c = 0;
                        do {
                          iconsQuestions[c].ID = iconsInit + c;
                          iconsQuestions[c].Groupid = (c / 100).floor();
                          if (iconsQuestions[c].Groupid > (igroupCount - 1)) {
                            Group group = Group(
                              ID: groupsID,
                              Categoryid: 3,
                              GroupNumber: igroupCount,
                              QuestionsCount: icount,
                            );
                            GradeResult gradeResult = GradeResult(
                              ID: groupsID,
                              Categoryid: 3,
                              Groupid: group.ID,
                              AnsweredCount: 0,
                              AskedCount: 0,
                              Questions: [],
                            );
                            groupsID++;
                            igroupCount++;
                            groups.add(group);
                            gradeResults.add(gradeResult);
                            icount = 0;
                          }
                          icount++;
                          c++;
                        } while (c < iconsQuestions.length);
                        if (icount % 100 > 0) {
                          Group group = Group(
                            ID: groupsID,
                            Categoryid: 3,
                            GroupNumber: igroupCount,
                            QuestionsCount: icount,
                          );
                          GradeResult gradeResult = GradeResult(
                            ID: groupsID,
                            Categoryid: 3,
                            Groupid: group.ID,
                            AnsweredCount: 0,
                            AskedCount: 0,
                            Questions: [],
                          );
                          groupsID++;
                          igroupCount++;
                          groups.add(group);
                          gradeResults.add(gradeResult);
                          icount = 0;
                        }

                        /// TODO : ---
                        motorQuestions.addAll(othersQuestions);
                        motorQuestions.addAll(iconsQuestions);
                        success = true;
                        await DatabaseManager.getInstance()
                            .InsertQuestions(motorQuestions)
                            .then((int insertedCount) {
                          if (motorQuestions.length != insertedCount) {
                            setState(() {
                              message = "ERROR Inserting Questions ... ";
                              success = false;
                              loading = false;
                            });
                          } else {
                            setState(() {
                              message =
                                  "Succesfully Added ${motorQuestions.length} Questions ... ";
                              loading = false;
                              success = true;
                              message = " succesful ";
                            });
                          }
                        });
                        if (!success) return;
                        await DatabaseManager.getInstance()
                            .InsertGradeResults(gradeResults)
                            .then((int vals) {
                          if (vals != gradeResults.length) {
                            print(
                                " Inserted Grade Results Count $vals :: ${gradeResults.length}");
                            setState(() {
                              message =
                                  "ERROR while Inserting the GradeResults .. ";
                              messageColor = Colors.red;
                              loading = false;
                              success = false;
                            });
                          }
                          success |= false;
                        });
                        if (!success) return;
                        await DatabaseManager.getInstance()
                            .InsertGroups(groups)
                            .then((int groupsInserts) {
                          if (groupsInserts != groups.length) {
                            setState(() {
                              this.message = Translation.translate(this.lang,
                                  "Internal Code Error. \nPlease Try Again....");
                              this.messageColor = Colors.red;
                              this.loading = false;
                              this.success = false;
                            });
                            success = success | false;
                            if (success) {
                              message = " Succesfuly Loaded ";
                              loading = false;
                            }
                          }
                        });
                        // setState(() {
                        //   this.success = true;
                        // });
                        Userdata.SetUsername(username);
                        if (!this.success) {
                          return;
                        }
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            CategoryScreen.RouteName, (_) {
                          return false;
                        }, arguments: {
                          'username': username,
                          "locald": Userdata,
                        });
                        // --
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
  return (answers == null || answers.length == 0) ? [] : answers;
}
