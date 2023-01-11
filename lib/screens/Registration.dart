import "package:flutter/material.dart";
import "dart:math" as math;
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
    databaseManager.OpenDatabase().then((_) {});

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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // centerTitle: true,
        elevation: 0,
        title: Text(
          Translation.translate(lang, 'Registration'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(100, 50),
                  )),
              child: Container(
                child: Column(children: [
                  // Row(children: [
                  //   Expanded(
                  //     child: Container(
                  //       child: Image.asset(
                  //         "assets/images/logo.png",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  //   Expanded(
                  //     child: Container(
                  //       child: Image.asset(
                  //         "assets/images/logo.png",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ]),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                // padding: EdgeInsets.all(20),
                                child: Text(
                                  Translation.translate(lang, "Welcome!"),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Text(
                                Translation.translate(
                                      lang,
                                      "Initialize Questions by pressing the Start button",
                                    ) +
                                    "\n" +
                                    Translation.translate(lang,
                                        "Loading Questions may take time please be patient!"),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(100, 50),
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
                              child: const CircularProgressIndicator(
                                  color: Colors.white),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: this.loading
                          ? ElevatedButton(
                              child: Text(
                              Translation.translate(this.lang, "Loading") +
                                  "...",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ))
                          : ElevatedButton(
                              onPressed: () => () async {
                                if (this.loading) return;
                                setState(() {
                                  this.loading = true;
                                  this.messageColor = Colors.white;
                                  this.message = Translation.translate(
                                          this.lang, "Loading") +
                                      " ... ";
                                });
                                this.username = nameController.text;
                                if (username == null || username == "") {
                                  this.username = "ሰልጣኞች መለማመጃ";
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

                                // ------------------------------------------
                                motorQuestions.addAll(
                                    await ListLoader.loadNonIndexedQuestions(
                                        "assets/file.xlsx", "Motor", 1, 0));
                                motorQuestions.addAll(
                                    await ListLoader.loadQuestions(
                                        "assets/file.xlsx",
                                        "MotorIndexed",
                                        1,
                                        0));
                                // shuffling questions and giving an ID for each of them at the
                                // same time giving a group to them
                                // The ID of the groups will start from 1.
                                int totalGroups = 0;
                                int totalQuestions = 0;
                                int count = 0;
                                int agcount = 1;

                                int a = 0;
                                do {
                                  motorQuestions[a].ID = ++totalQuestions;
                                  // group id represents the group's id which this question is in.
                                  motorQuestions[a].Groupid = totalGroups + 1;
                                  motorQuestions[a].Categoryid = 1;
                                  if ((a != 0 && a % 100 == 0) ||
                                      (
                                          // or If this is the last value of 'a'
                                          a == motorQuestions.length - 1)) {
                                    Group group = Group(
                                      ID: ++totalGroups,
                                      Categoryid: 1,
                                      GroupNumber: agcount++,
                                      QuestionsCount: count,
                                    );
                                    GradeResult gradeResult = GradeResult(
                                      ID: totalGroups,
                                      Categoryid: 1,
                                      Groupid: group.ID,
                                      AnsweredCount: 0,
                                      AskedCount: 0,
                                      Questions: [],
                                    );
                                    // this variable signifies the groups count
                                    groups.add(group);
                                    gradeResults.add(gradeResult);
                                    count = 0;
                                  }
                                  count++;
                                  a++;
                                } while (a < motorQuestions.length);
                                // -------------------starting populating others categories questions -------------

                                /// getting others questions
                                List<Question> othersQuestions = [];
                                othersQuestions.addAll(
                                    await ListLoader.loadNonIndexedQuestions(
                                        "assets/file.xlsx", "Others", 2, 0));
                                othersQuestions.addAll(
                                  await ListLoader.loadQuestions(
                                      "assets/file.xlsx",
                                      "OthersIndexed",
                                      2,
                                      0),
                                );
                                // shuffling questions and giving an ID for each of them at the
                                // same time giving a group to them
                                count = 0;
                                int bgcount = 1;

                                int b = 0;
                                do {
                                  othersQuestions[b].ID = ++totalQuestions;
                                  othersQuestions[b].Groupid = totalGroups + 1;
                                  othersQuestions[b].Categoryid = 2;
                                  if ((b != 0 && b % 100 == 0) ||
                                      (b != 0 &&
                                          // or If this is the last value of 'b'
                                          b == othersQuestions.length - 1)) {
                                    Group group = Group(
                                        ID: ++totalGroups,
                                        Categoryid: 2,
                                        GroupNumber: bgcount++,
                                        QuestionsCount: count);
                                    GradeResult gradeResult = GradeResult(
                                      ID: totalGroups,
                                      Categoryid: 2,
                                      Groupid: group.ID,
                                      AnsweredCount: 0,
                                      AskedCount: 0,
                                      Questions: [],
                                    );
                                    groups.add(group);
                                    gradeResults.add(gradeResult);
                                    count = 0;
                                  }
                                  count++;
                                  b++;
                                } while (b < othersQuestions.length);

                                //-- Starting Icons test questions population.

                                /// getting icons questions
                                List<Question> iconsQuestions = [];
                                iconsQuestions.addAll(
                                    await ListLoader.loadITAQuestions(
                                        "assets/file.xlsx",
                                        "sign_question",
                                        3,
                                        0));
                                iconsQuestions.addAll(
                                    await ListLoader.loadTIAQuestions(
                                        "assets/file.xlsx",
                                        "sing_answer",
                                        3,
                                        0));
                                // shuffling questions and giving an ID for each of them at the
                                // same time giving a group to them
                                count = 0;
                                int cgcount = 1;

                                int c = 0;
                                do {
                                  iconsQuestions[c].ID = ++totalQuestions;
                                  iconsQuestions[c].Groupid = totalGroups + 1;
                                  iconsQuestions[c].Categoryid = 3;
                                  if ((c != 0 && c % 100 == 0) ||
                                      (c != 0 &&
                                          // or If this is the last value of 'b'
                                          c == iconsQuestions.length - 1)) {
                                    Group group = Group(
                                      ID: ++totalGroups,
                                      Categoryid: 3,
                                      GroupNumber: cgcount++,
                                      QuestionsCount: count,
                                    );
                                    GradeResult gradeResult = GradeResult(
                                      ID: totalGroups,
                                      Categoryid: 3,
                                      Groupid: group.ID,
                                      AnsweredCount: 0,
                                      AskedCount: 0,
                                      Questions: [],
                                    );
                                    groups.add(group);
                                    gradeResults.add(gradeResult);
                                    count = 0;
                                  }
                                  count++;
                                  c++;
                                } while (c < iconsQuestions.length);

                                /// TODO : ---
                                motorQuestions.addAll(othersQuestions);
                                motorQuestions.addAll(iconsQuestions);
                                success = true;
                                await DatabaseManager.getInstance()
                                    .InsertQuestions(motorQuestions)
                                    .then((int insertedCount) {
                                  if (motorQuestions.length != insertedCount) {
                                    setState(() {
                                      message =
                                          "ERROR Inserting Questions ... ";
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
                                      this.message = Translation.translate(
                                          this.lang,
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
                              // color: Colors.white,
                              // shape: const RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(14))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      Translation.translate(this.lang, 'Start'),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Theme.of(context).primaryColorLight,
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
