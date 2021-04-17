import 'package:drivers_question/libs.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "dart:math" as math;
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    bool runningImageLoad = false;
    final argumentsMap =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    Userdata = argumentsMap["locald"] as UserData;

    this.Userdata = context.read<UserDataState>().state;

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
        centerTitle: true,
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
              child: Column(
                children: [
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
                                  "Register Your name") !=
                              null
                          ? Translation.translate(lang,
                              "Register Your name")
                          : "Register Your name",
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
                ],
              ),
            ),
          ),
          Container(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    -30,
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

                          // counts the number of inserted motor question instances
                          int Countero = 0;
                          // counts the number of inserted other vehicle instances
                          int CounterOther = 0;

                          await XlsxLoader.LoadXlsxIndexed(
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
                          // populating the motor category filez
                          await XlsxLoader.LoadXlsxIndexed(
                                  "assets/file.xlsx", "MotorImageAnswer")
                              .then((rows) {
                            int category = 2;
                            for (var row in rows) {
                              int index = int.parse(row[1]);
                              List<String> answers = row.sublist(2);
                              answers = answers.map(
                                (answer) {
                                  return answer.trim() + ".JPG";
                                },
                              ).toList();
                              final question = Question(
                                Categoryid: category,
                                Body: row[0],
                                imageurl: "",
                                Answers: answers,
                                isImageAnswers: true,
                                Answerindex: index - 1,
                              );
                              this.otherIndexedQuestions.add(question);
                            }
                          });
                          // getting the image containing question from the database and populating them to the dataase
                          // Populating the Motor Category
                          await XlsxLoader.LoadXlsxImageContaining(
                                  "assets/file.xlsx", "MotorImageContaining")
                              .then((listoo) {
                            int category = 1;
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
                            print("Total Groups Length : $totalGroups");
                            print(
                                "Total Indexed Questions Length : ${otherIndexedQuestions.length}");
                            print(
                                "Total Questions Length : ${listoo.length + otherIndexedQuestions.length}");
                            // this loop will run for each group
                            for (var p = 0; p < totalGroups; p++) {
                              print(
                                  "--------------------------------------------------");
                              groupId = p + 1;
                              List<Question> groupIndexedQuestions = [];
                              if (groupId < totalGroups) {
                                int indexedLength =
                                    (otherIndexedQuestions.length / totalGroups)
                                        .ceil();
                                print(" Indexed Length : $indexedLength");
                                int length = (initIndex + 100 - indexedLength);
                                //  get the values if the length is less than the remaining questions to take
                                print("$initIndex   $initIndexForIndexed");
                                if (initIndex < listoo.length) {
                                  if (length <
                                      listoo.length - (initIndex + 1)) {
                                    questions =
                                        listoo.sublist(initIndex, length);
                                    initIndex += (100 - indexedLength);
                                  } else {
                                    questions = listoo.sublist(initIndex);
                                    initIndex = listoo.length - 1;
                                  }
                                }
                                int secondLength =
                                    (initIndexForIndexed + indexedLength);
                                if (initIndexForIndexed <
                                    otherIndexedQuestions.length) {
                                  if (secondLength <
                                      otherIndexedQuestions.length -
                                          (initIndexForIndexed + 1)) {
                                    groupIndexedQuestions =
                                        otherIndexedQuestions.sublist(
                                            initIndexForIndexed, secondLength);
                                    initIndexForIndexed += indexedLength;
                                  } else {
                                    groupIndexedQuestions =
                                        otherIndexedQuestions
                                            .sublist(initIndexForIndexed);
                                    initIndexForIndexed =
                                        otherIndexedQuestions.length - 1;
                                  }
                                }
                              } else {
                                groupIndexedQuestions =
                                    otherIndexedQuestions.sublist(
                                        initIndex < otherIndexedQuestions.length
                                            ? initIndex
                                            : otherIndexedQuestions.length - 1);
                                questions = listoo.sublist(
                                    initIndexForIndexed < listoo.length
                                        ? initIndexForIndexed
                                        : listoo.length - 1);
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
                                String imageurl =
                                    "${oneQuestion[1].trim()}.JPG";
                                final answer = oneQuestion[2];
                                final answers = oneQuestion.sublist(3);
                                int answerIndex =
                                    int.parse(answer, onError: (answer) {
                                  return 0;
                                });

                                if (answerIndex == 0 ||
                                    answerIndex > answers.length ||
                                    answerIndex < 0) {
                                  continue;
                                }
                                Question quest = Question(
                                  // ID: questionCounter,
                                  Categoryid: category,
                                  Groupid: group.ID,
                                  Body: oneQuestion[0],
                                  imageurl: imageurl,
                                  Answerindex: answerIndex,
                                  Answers: answers,
                                );
                                print(
                                    "Looping Over the Image Questions ....  ${quest.toMap()}");
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

                            // inserting the Question in the database
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
                                .then((counts) {});
                            databaseManager.InsertQuestions(QuestObjects)
                                .then((onValue) {
                              Countero = onValue;
                            });
                          });
                          // if (!runningImageLoad) {
                          //   print("The Image Question Doesn't RUn");
                          //   return;
                          // }
                          // populating the motor category filez
                          await XlsxLoader.LoadXlsxIndexed(
                                  "assets/file.xlsx", "OthersIndexed")
                              .then((rows) {
                            int category = 2;
                            for (var row in rows) {
                              int index = int.parse(row[1]);
                              List<String> answers = row.sublist(2);
                              final question = Question(
                                  Categoryid: category,
                                  Body: row[0],
                                  imageurl: "",
                                  Answers: answers,
                                  Answerindex: index - 1);
                              this.otherIndexedQuestions.add(question);
                            }
                          });
                          // populating the motor category filez
                          await XlsxLoader.LoadXlsxIndexed(
                                  "assets/file.xlsx", "OthersImageAnswer")
                              .then((rows) {
                            int category = 2;
                            for (var row in rows) {
                              int index = int.parse(row[1]);
                              List<String> answers = row.sublist(2);
                              answers = answers.map(
                                (answer) {
                                  return answer.trim() + ".JPG";
                                },
                              ).toList();
                              final question = Question(
                                Categoryid: category,
                                Body: row[0],
                                imageurl: "",
                                Answers: answers,
                                isImageAnswers: true,
                                Answerindex: index - 1,
                              );
                              this.otherIndexedQuestions.add(question);
                            }
                          });

                          await XlsxLoader.LoadXlsxImageContaining(
                                  "assets/file.xlsx", "OthersImageContaining")
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
                            print("Total Groups Length : $totalGroups");
                            print(
                                "Total Indexed Questions Length : ${otherIndexedQuestions.length}");
                            print(
                                "Total Questions Length : ${listoo.length + otherIndexedQuestions.length}");
                            // this loop will run for each group
                            for (var p = 0; p < totalGroups; p++) {
                              groupId = p + 1;
                              List<Question> groupIndexedQuestions = [];
                              if (groupId < totalGroups) {
                                int indexedLength =
                                    (otherIndexedQuestions.length / totalGroups)
                                        .ceil();
                                print(" Indexed Length : $indexedLength");
                                int length = (initIndex + 100 - indexedLength);

                                //  get the values if the length is less than the remaining questions to take
                                if (initIndex < listoo.length) {
                                  if (length <
                                      listoo.length - (initIndex + 1)) {
                                    questions =
                                        listoo.sublist(initIndex, length);
                                    initIndex += (100 - indexedLength);
                                  } else {
                                    questions = listoo.sublist(initIndex);
                                    initIndex = listoo.length - 1;
                                  }
                                }
                                int secondLength =
                                    (initIndexForIndexed + indexedLength);
                                if (initIndexForIndexed <
                                    otherIndexedQuestions.length) {
                                  if (secondLength <
                                      otherIndexedQuestions.length -
                                          (initIndexForIndexed + 1)) {
                                    groupIndexedQuestions =
                                        otherIndexedQuestions.sublist(
                                            initIndexForIndexed, secondLength);
                                    initIndexForIndexed += indexedLength;
                                  } else {
                                    groupIndexedQuestions =
                                        otherIndexedQuestions
                                            .sublist(initIndexForIndexed);
                                    initIndexForIndexed =
                                        otherIndexedQuestions.length - 1;
                                  }
                                }
                              } else {
                                groupIndexedQuestions =
                                    otherIndexedQuestions.sublist(
                                        initIndex < otherIndexedQuestions.length
                                            ? initIndex
                                            : otherIndexedQuestions.length - 1);
                                questions = listoo.sublist(
                                    initIndexForIndexed < listoo.length
                                        ? initIndexForIndexed
                                        : listoo.length - 1);
                              }
                              // initIndex += 100;
                              this.groutCounter++;

                              // giving a group ID and a category id for the Indexed images
                              // that i found in the indexed questions list
                              for (var a = 0;
                                  a < groupIndexedQuestions.length;
                                  a++) {
                                final question = groupIndexedQuestions[a];
                                question.Groupid = this.groutCounter;
                                QuestObjects.add(question);
                              }

                              // creating the group ---
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

                                final imageName =
                                    "${(oneQuestion[1]).trim()}.JPG";
                                final answer = oneQuestion[2];
                                final answers = oneQuestion.sublist(3);
                                int answerIndex =
                                    int.parse(answer, onError: (answer) {
                                  return 0;
                                });
                                if (answerIndex <= 0 ||
                                    answerIndex > answers.length) {
                                  continue;
                                }
                                // this.questionCounter++;
                                Question quest = Question(
                                  Categoryid: category,
                                  imageurl: imageName,
                                  Groupid: group.ID,
                                  Body: oneQuestion[0],
                                  Answerindex: answerIndex,
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
