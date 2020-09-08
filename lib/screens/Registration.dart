import 'package:DriversMobile/db/dbsqflite.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "../handlers/sharedPreference.dart";
import "dart:math" as math;
import "dart:async";
import 'package:flutter/services.dart' show ByteData, rootBundle;
import "../handlers/translation.dart";
import 'package:excel/excel.dart';
import 'Categories.dart';

class RegistrationScreen extends StatefulWidget {
  static final RouteName = "/register";
  RegistrationScreen({Key key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Userdata

  UserData Userdata;
  String username;
  String password;
  DatabaseManager databaseManager;
  int questionCounter = 0;
  int groutCounter = 0;
  @override
  void initState() {
    super.initState();
    databaseManager = DatabaseManager.getInstance();
    databaseManager.OpenDatabase().then((_) {
      print("Database is Ready ...");
    });
  }

  int counter = 0;
  String dropdownValue = "";
  String message = "";

  Color messageColor = Colors.red;
  String lang;
  bool loading = false;
  bool success = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
        if (value == null ||
            "$value" == "" ||
            "$value" == "null" ||
            "$value".length <= 3) {
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

  void running() {
    setState(() {
      message = Loadings[loadingIndex];
      loadingIndex++;
      loadingIndex = loadingIndex % 3;
    });
  }

  static int loadingIndex = 0;
  void tickerFunction(Duration duration) {}
  static final Loadings = ["Loading.", "Loading..", "Loading..."];
  @override
  Widget build(BuildContext context) {
    final argumentsMap =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    Userdata = argumentsMap["locald"] as UserData;

    return Scaffold(
          appBar: AppBar(
            title: Text(
              Translation.translate(lang, 'Registration') != null
                  ? Translation.translate(lang, 'Registration')
                  : 'Registration',
              // views[selectedIndex]['title'] as String,
              // Translation.translate("Registration") ,
              textAlign: TextAlign.center,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
            ),
            child: Column(children: [
              Card(
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
                    height: 130,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      Translation.translate(lang,
                          "Register Your name Including the Companiese Password")!= null  ? Translation.translate(lang,
                          "Register Your name Including the Companiese Password") : "Register Your name Including the Companiese Password" ,
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
                    height: 20,
                  ),
                ]),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      height: 200,
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
                                vertical: 10,
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: message == ""
                                        ? Colors.white
                                        : messageColor),
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
                              height: 40,
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: CupertinoTextField(
                                autofocus: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                controller: nameController,
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                placeholder: Translation.translate(this.lang  , 'eg. Name : muhammed') != null ? Translation.translate(this.lang  , 'eg. Name : muhammed') : 'eg. Name : muhammed',
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
                                obscureText: true,
                                autofocus: true,
                                placeholderStyle: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),

                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                controller: passwordController,
                                // keyboardType: TextInputType.passwords,
                                maxLines: 1,
                                placeholder: Translation.translate( this.lang , ' Company Password ....') != null ?  Translation.translate( this.lang , ' Company Password ....') : "Company Password ..." ,
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
                                  if (nameController.text != "" &&
                                      passwordController.text != "") {
                                    // loginStore.getCodeWithPhoneNumber(context, phoneController.text.toString());
                                    username = nameController.text;
                                    password = passwordController.text;
                                    if (UserData.PASSWORD == password) {
                                      setState(() {
                                        this.message = (Translation.translate(this.lang  , "Loading") != null ?  Translation.translate(this.lang  , "Loading") : "Loading") + "..." ;
                                        this.loading = true;
                                        messageColor = Colors.green;
                                      });
                                      int Countero = 0;
                                      int CounterOther = 0;
                                      // Populating the Motor Category
                                      await LoadXlsx(
                                              "assets/file.xlsx", "Motor")
                                          .then((listoo) {
                                        int category = 1;
                                        int groupId = 0;
                                        int initIndex = 0;
                                        int totalGroups =
                                            (listoo.length / 100).ceil();
                                        List<List<String>> questions = [];
                                        List<Question> QuestObjects = [];
                                        List<Group> GroupObjects = [];
                                        List<GradeResult> gradeResultObjects =
                                            [];
                                        for (var p = 0; p < totalGroups; p++) {
                                          groupId = p + 1;
                                          if (groupId < totalGroups) {
                                            questions = listoo.sublist(
                                                initIndex, initIndex + 100);
                                          } else {
                                            questions =
                                                listoo.sublist(initIndex);
                                          }
                                          initIndex += 100;
                                          this.groutCounter++;
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
                                          group.QuestionsCount =
                                              questions.length;
                                          GroupObjects.add(group);
                                          // Generating Questios Object for each one of the List element
                                          for (var t = 0;
                                              t < questions.length;
                                              t++) {
                                            List<String> oneQuestion =
                                                questions[t];
                                            final answer = oneQuestion[1];
                                            final answers =
                                                oneQuestion.sublist(1);
                                            answers
                                                .shuffle(math.Random.secure());
                                            int index = answers.indexOf(answer);
                                            this.questionCounter++;
                                            Question quest = Question(
                                                ID: questionCounter,
                                                Categoryid: category,
                                                Groupid: group.ID,
                                                Body: oneQuestion[0],
                                                Answerindex: index,
                                                Answers: answers);
                                            QuestObjects.add(quest);
                                          }
                                        }
                                        databaseManager.InsertGroups(
                                                GroupObjects)
                                            .then((value) {
                                          if (GroupObjects.length < value) {
                                            setState(() {
                                              this.message =
                                                  Translation.translate(this.lang , "Internal Code Error. \nPlease Try Again....") != null ? Translation.translate(  this.lang ,  "Internal Code Error. \nPlease Try Again....") : "Internal Code Error. \nPlease Try Again...." ;
                                              this.messageColor = Colors.red;
                                              this.loading = false;
                                              this.success = false;
                                            });
                                          }
                                        });
                                        databaseManager.InsertGradeResults(
                                                gradeResultObjects)
                                            .then((counts) {
                                          if (counts <
                                              gradeResultObjects.length) {
                                            setState(() {
                                              // this.message =
                                              //     " Internal Error while Saving the GradeResults  1";
                                              // this.success = false;
                                              // this.messageColor = Colors.red;
                                              // this.loading = false;
                                            });
                                          }
                                        });
                                        databaseManager.InsertQuestions(
                                                QuestObjects)
                                            .then((onValue) {
                                          Countero = onValue;
                                        });
                                      });
                                      await LoadXlsx(
                                              "assets/file.xlsx", "Others")
                                          .then((listoo) {
                                        int category = 2;
                                        int groupId = 0;
                                        int initIndex = 0;
                                        int totalGroups =
                                            (listoo.length / 100).ceil();
                                        List<List<String>> questions = [];
                                        List<Question> QuestObjects = [];
                                        List<Group> GroupObjects = [];
                                        List<GradeResult> gradeResultObjects =
                                            [];
                                        for (var p = 0; p < totalGroups; p++) {
                                          groupId = p + 1;
                                          if (groupId < totalGroups) {
                                            questions = listoo.sublist(
                                                initIndex, initIndex + 100);
                                          } else {
                                            questions =
                                                listoo.sublist(initIndex);
                                          }
                                          initIndex += 100;
                                          this.groutCounter++;
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
                                          group.QuestionsCount =
                                              questions.length;
                                          GroupObjects.add(group);
                                          // Generating Questios Object for each one of the List element
                                          for (var t = 0;
                                              t < questions.length;
                                              t++) {
                                            List<String> oneQuestion =
                                                questions[t];
                                            final answer = oneQuestion[1];
                                            final answers =
                                                oneQuestion.sublist(1);
                                            answers
                                                .shuffle(math.Random.secure());
                                            int index = answers.indexOf(answer);
                                            this.questionCounter++;
                                            Question quest = Question(
                                                ID: questionCounter,
                                                Categoryid: category,
                                                Groupid: group.ID,
                                                Body: oneQuestion[0],
                                                Answerindex: index,
                                                Answers: answers);
                                            QuestObjects.add(quest);
                                          }
                                        }
                                        databaseManager.InsertGroups(
                                                GroupObjects)
                                            .then((value) {
                                          if (GroupObjects.length < value) {
                                            setState(() {
                                              this.message =
                                                   Translation.translate( this.lang , "Internal Code Error. \nPlease Try Again....") != null ? Translation.translate( this.lang  ,  "Internal Code Error. \nPlease Try Again....") : "Internal Code Error. \nPlease Try Again....";
                                              this.messageColor = Colors.red;
                                              this.loading = false;
                                              this.success = false;
                                            });
                                          }
                                        });

                                        // for/
                                        databaseManager.InsertGradeResults(
                                                gradeResultObjects)
                                            .then((counts) {
                                          if (counts <
                                              gradeResultObjects.length) {
                                            setState(() {
                                              // this.message =
                                              //     " Internal Error while Saving the GradeResults 2 ";
                                              // this.success = false;
                                              // this.messageColor = Colors.red;
                                              // this.loading = false;
                                            });
                                          }
                                        });

                                        databaseManager.InsertQuestions(
                                                QuestObjects)
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
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  CategoryScreen.RouteName,
                                                  (_) {
                                            return true;
                                          }, arguments: {
                                            'username': username,
                                            "locald": Userdata,
                                          });
                                        });
                                      });

                                      // Load Data to the database
                                    } else {
                                      setState(() {
                                        message = Translation.translate(this.lang  ,  "Incorrect Company Password ") != null ? Translation.translate(this.lang  ,  "Incorrect Company Password ") :"Incorrect Company Password ";
                                        loading = false;
                                        messageColor = Colors.red;
                                      });
                                    }
                                  } else if (nameController.text.isEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    setState(() {
                                      message =
                                          Translation.translate( this.lang  ,"Please Fill the name Correctly ") != null ?  Translation.translate( this.lang  ,"Please Fill the name Correctly ") : "Please Fill the name Correctly " ;
                                      messageColor = Colors.red;
                                    });
                                  } else if (passwordController.text.isEmpty &&
                                      nameController.text.isNotEmpty) {
                                    setState(() {
                                      message =
                                          Translation.translate(this.lang  , "Invalid Password! \n Try The Company Pasword Correctly ") != null ? Translation.translate(this.lang  , "Invalid Password! \n Try The Company Pasword Correctly ")  : "Invalid Password! \n Try The Company Pasword Correctly " ;
                                      messageColor = Colors.red;
                                    });
                                  } else {
                                    setState(() {
                                      message = Translation.translate(this.lang  , "Please Fiil the input fields ") != null ? Translation.translate(this.lang  , "Please Fiil the input fields ") : "Please Fiil the input fields " ;
                                      messageColor = Colors.red;
                                    });
                                  }
                                }(),
                                color: Theme.of(context).primaryColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        Translation.translate(this.lang , 'Register') != null ? Translation.translate(this.lang , 'Register') : "Register",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
                      )))
            ]),
          ),
        );
  }
}

List<String> Shuffle(List<String> answers) {
  answers.shuffle(math.Random.secure());
}
