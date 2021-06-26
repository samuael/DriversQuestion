import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "dart:math" as math;
import "dart:async";
import 'package:flutter/services.dart' show ByteData, rootBundle;
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

  Future<List<List<dynamic>>> LoadXlsx(String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;
      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });
      final List<String> newRow = [];
      for (var f = 0; f < row.length; f++) {
        newRow.add("${row[f]}");
      }
      if (newRow.length >= 3) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }

  Future<List<List<dynamic>>> LoadXlsxIndexed(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;

      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });

      int index = 0;
      bool valid = false;
      if (row.length > 4) {
        try {
          index = int.tryParse("${row[1]}");
          if (index != null && index > 0 && index <= (row.length - 2)) {
            valid = true;
          }
        } catch (s, e) {
          valid = false;
          index = 0;
        }
      }

      final List<String> newRow = [];
      for (var f = 0; f < row.length; f++) {
        newRow.add("${row[f]}");
      }
      if (newRow.length >= 4 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
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
                        print(
                          "${nameController.text} ${passwordController.text}",
                        );
                        if (nameController.text != "") {
                          // loginStore.getCodeWithPhoneNumber(context, phoneController.text.toString());
                          username = nameController.text;
                          setState(() {
                            this.message =
                                (Translation.translate(this.lang, "Loading") !=
                                            null
                                        ? Translation.translate(
                                            this.lang, "Loading")
                                        : "Loading") +
                                    "...";
                            this.loading = true;
                            messageColor = Colors.green;
                          });
                          int Countero = 0;
                          int CounterOther = 0;

                          await LoadXlsxIndexed(
                                  "assets/file.xlsx", "MotorIndexed")
                              .then((rows) {
                            int category = 1;
                            for (var row in rows) {
                              int index = int.parse(row[1]);
                              List<String> answers = row.sublist(2);
                              final question = Question(
                                  Categoryid: category,
                                  Body: row[0],
                                  Answers: answers,
                                  Answerindex: index - 1);
                              this.motorIndexedQuestions.add(question);
                            }
                          });

                          // Populating the Motor Category
                          await LoadXlsx("assets/file.xlsx", "Motor")
                              .then((listoo) {
                            int category = 1;
                            int groupId = 0;
                            int initIndex = 0;
                            int initIndexForIndexed = 0;
                            int totalGroups = ((listoo.length +
                                        motorIndexedQuestions.length) /
                                    100)
                                .ceil();
                            List<List<String>> questions = [];
                            List<Question> QuestObjects = [];
                            List<Group> GroupObjects = [];
                            List<GradeResult> gradeResultObjects = [];
                            for (var p = 0; p < totalGroups; p++) {
                              groupId = p + 1;
                              List<Question> groupIndexedQuestions =
                                  List<Question>();
                              if (groupId < totalGroups) {
                                int indexedLength =
                                    (motorIndexedQuestions.length / totalGroups)
                                        .ceil();
                                groupIndexedQuestions =
                                    motorIndexedQuestions.sublist(
                                        initIndexForIndexed,
                                        (initIndexForIndexed + indexedLength));
                                questions = listoo.sublist(
                                  initIndex,
                                  (initIndex + 100 - indexedLength),
                                );
                                initIndexForIndexed += indexedLength;
                                initIndex += (100 - indexedLength);
                              } else {
                                groupIndexedQuestions = this
                                    .motorIndexedQuestions
                                    .sublist(initIndexForIndexed);
                                questions = listoo.sublist(initIndex);
                              }
                              // initIndex += 100;
                              this.groutCounter++;

                              for (var a = 0;
                                  a < groupIndexedQuestions.length;
                                  a++) {
                                final question = groupIndexedQuestions[a];
                                question.Groupid = this.groutCounter;
                                QuestObjects.add(question);
                              }

                              final group = Group(
                                ID: this.groutCounter,
                                GroupNumber: groupId,
                                Categoryid: category,
                              );
                              final gradeResult = GradeResult(
                                ID: this.groutCounter,
                                Categoryid: category,
                                Groupid: group.ID,
                                AnsweredCount: 0,
                                AskedCount: 0,
                                Questions: [],
                              );
                              gradeResultObjects.add(gradeResult);
                              group.QuestionsCount = (questions.length +
                                  groupIndexedQuestions.length);
                              GroupObjects.add(group);
                              // Generating Questios Object for each one of the List element
                              for (var t = 0; t < questions.length; t++) {
                                List<String> oneQuestion = questions[t];
                                final answer = oneQuestion[1];
                                final answers = oneQuestion.sublist(1);
                                answers.shuffle(math.Random.secure());
                                int index = answers.indexOf(answer);

                                Question quest = Question(
                                  // ID: questionCounter,
                                  Categoryid: category,
                                  Groupid: group.ID,
                                  Body: oneQuestion[0],
                                  Answerindex: index,
                                  Answers: answers,
                                );
                                QuestObjects.add(quest);
                              }
                            }
                            QuestObjects.shuffle(math.Random.secure());
                            for (var k = 0; k < QuestObjects.length; k++) {
                              this.questionCounter++;
                              final quest = QuestObjects[k];
                              quest.ID = this.questionCounter;
                              QuestObjects[k] = quest;
                            }

                            databaseManager.InsertGroups(GroupObjects)
                                .then((value) {
                              if (GroupObjects.length < value) {
                                setState(() {
                                  this.message = Translation.translate(
                                              this.lang,
                                              "Internal Code Error. \nPlease Try Again....") !=
                                          null
                                      ? Translation.translate(this.lang,
                                          "Internal Code Error. \nPlease Try Again....")
                                      : "Internal Code Error. \nPlease Try Again....";
                                  this.messageColor = Colors.red;
                                  this.loading = false;
                                  this.success = false;
                                });
                              }
                            });
                            databaseManager.InsertGradeResults(
                                    gradeResultObjects)
                                .then((counts) {
                              if (counts < gradeResultObjects.length) {
                                setState(() {
                                  // this.message =
                                  //     " Internal Error while Saving the GradeResults  1";
                                  // this.success = false;
                                  // this.messageColor = Colors.red;
                                  // this.loading = false;
                                });
                              }
                            });
                            databaseManager.InsertQuestions(QuestObjects)
                                .then((onValue) {
                              Countero = onValue;
                            });
                          });
                          await LoadXlsxIndexed(
                                  "assets/file.xlsx", "OthersIndexed")
                              .then((rows) {
                            int category = 2;
                            for (var row in rows) {
                              int index = int.parse(row[1]);
                              List<String> answers = row.sublist(2);
                              final question = Question(
                                  Categoryid: category,
                                  Body: row[0],
                                  Answers: answers,
                                  Answerindex: index - 1);
                              this.otherIndexedQuestions.add(question);
                            }
                          });

                          await LoadXlsx("assets/file.xlsx", "Others")
                              .then((listoo) {
                            int category = 2;
                            int groupId = 0;
                            int initIndex = 0;
                            int initIndexForIndexed = 0;
                            int totalGroups = ((listoo.length +
                                        otherIndexedQuestions.length) /
                                    100)
                                .ceil();
                            List<List<String>> questions = [];
                            List<Question> QuestObjects = [];
                            List<Group> GroupObjects = [];
                            List<GradeResult> gradeResultObjects = [];
                            for (var p = 0; p < totalGroups; p++) {
                              groupId = p + 1;
                              List<Question> groupIndexedQuestions = [];
                              if (groupId < totalGroups) {
                                int indexedLength =
                                    (otherIndexedQuestions.length / totalGroups)
                                        .ceil();
                                groupIndexedQuestions =
                                    otherIndexedQuestions.sublist(
                                        initIndexForIndexed,
                                        (initIndexForIndexed + indexedLength));
                                questions = listoo.sublist(initIndex,
                                    (initIndex + 100 - indexedLength));
                                initIndex += (100 - indexedLength);
                                initIndexForIndexed += indexedLength;
                              } else {
                                groupIndexedQuestions = otherIndexedQuestions
                                    .sublist(initIndexForIndexed);
                                questions = listoo.sublist(initIndex);
                              }
                              // initIndex += 100;
                              this.groutCounter++;

                              for (var a = 0;
                                  a < groupIndexedQuestions.length;
                                  a++) {
                                final question = groupIndexedQuestions[a];
                                question.Groupid = this.groutCounter;
                                QuestObjects.add(question);
                              }

                              final group = Group(
                                ID: this.groutCounter,
                                GroupNumber: groupId,
                                Categoryid: category,
                              );
                              final gradeResult = GradeResult(
                                ID: this.groutCounter,
                                Categoryid: category,
                                Groupid: group.ID,
                                AnsweredCount: 0,
                                AskedCount: 0,
                                Questions: [],
                              );
                              gradeResultObjects.add(gradeResult);
                              group.QuestionsCount = questions.length +
                                  groupIndexedQuestions.length;
                              GroupObjects.add(group);
                              // Generating Questios Object for each one of the List element
                              for (var t = 0; t < questions.length; t++) {
                                List<String> oneQuestion = questions[t];
                                final answer = oneQuestion[1];
                                final answers = oneQuestion.sublist(1);
                                answers.shuffle(math.Random.secure());
                                int index = answers.indexOf(answer);
                                // this.questionCounter++;
                                Question quest = Question(
                                  Categoryid: category,
                                  Groupid: group.ID,
                                  Body: oneQuestion[0],
                                  Answerindex: index,
                                  Answers: answers,
                                );
                                QuestObjects.add(quest);
                              }
                            }
                            QuestObjects.shuffle(math.Random.secure());
                            for (var w = 0; w < QuestObjects.length; w++) {
                              this.questionCounter++;
                              final quest = QuestObjects[w];
                              quest.ID = this.questionCounter;
                              QuestObjects[w] = quest;
                            }

                            databaseManager.InsertGroups(GroupObjects)
                                .then((value) {
                              if (GroupObjects.length < value) {
                                setState(() {
                                  this.message = Translation.translate(
                                              this.lang,
                                              "Internal Code Error. \nPlease Try Again....") !=
                                          null
                                      ? Translation.translate(this.lang,
                                          "Internal Code Error. \nPlease Try Again....")
                                      : "Internal Code Error. \nPlease Try Again....";
                                  this.messageColor = Colors.red;
                                  this.loading = false;
                                  this.success = false;
                                });
                              }
                            });

                            databaseManager.InsertGradeResults(
                                    gradeResultObjects)
                                .then((counts) {
                              if (counts < gradeResultObjects.length) {
                                setState(() {
                                  // this.message =
                                  //     " Internal Error while Saving the GradeResults 2 ";
                                  // this.success = false;
                                  // this.messageColor = Colors.red;
                                  // this.loading = false;
                                });
                              }
                            });

                            databaseManager.InsertQuestions(QuestObjects)
                                .then((onValue) {
                              CounterOther = onValue;
                              setState(() {
                                message =
                                    "Succesfully Added ${Countero + CounterOther} Questions ... ";
                                loading = false;
                              });
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
                            });
                          });
                          // Load Data to the database

                        } else if (nameController.text.isEmpty) {
                          setState(() {
                            message = Translation.translate(this.lang,
                                        "Please Fill the name Correctly ") !=
                                    null
                                ? Translation.translate(this.lang,
                                    "Please Fill the name Correctly ")
                                : "Please Fill the name Correctly ";
                            messageColor = Colors.red;
                          });
                        }
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
