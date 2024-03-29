import 'package:flutter/material.dart';
import '../libs.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  static const RouteName = "/questions/";
  static QuestionScreen _instance;
  static QuestionScreen getInstance() {
    if (_instance == null) {
      _instance = QuestionScreen();
    }
    return _instance;
  }

  QuestionScreen({Key key}) : super(key: key);
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with WidgetsBindingObserver {
  Category category;
  Group group;
  UserData userdata;
  List<QuestionItem> questionItems = [];
  List<Question> questions = [];
  QuestionItem questionItem;
  Question question;
  DatabaseManager databaseManager;
  GradeResult gradeResult;
  int index = 0;
  bool showQuestion = false;
  bool goToCategoriesPage = false;
  bool next = true;
  bool prev = false;
  bool skip = false;
  bool result = false;
  UserDataProvider userdataProvider;

  @override
  void initState() {
    databaseManager = DatabaseManager.getInstance();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {}
  }

  void nextQuestion() {
    if (gradeResult.AskedCount == group.QuestionsCount) {
      showPopup(
          userdataProvider.language,
          "No More Question!",
          [
            '''You have done all the questions of this test!''',
            '''\nYour Score is''',
            '''  ${gradeResult.AnsweredCount}/${gradeResult.AskedCount}\n''',
            '''To re-take this test,\nReset the result of this test in the grade Result Page!'''
          ],
          context);
      return;
    }
    if (next && this.gradeResult != null) {
      if (index < questions.length - 1) {
        setState(() {
          index++;
          this.question = this.questions[index];
          this.questionItem = this.questionItems[index];
          databaseManager
              .getGradeResult(question.Groupid, question.Categoryid)
              .then((gradeResul) {
            this.gradeResult = gradeResul;
          });
          this.next = true;
        });
      } else {
        if (databaseManager == null) {
          this.databaseManager = DatabaseManager.getInstance();
        }
        databaseManager
            .getQuestion(this.gradeResult.Categoryid, this.gradeResult.Groupid)
            .then((questi) {
          if (questi != null) {
            setState(() {
              this.question = questi;
              this.questions.add(questi);
              this.questionItem = QuestionWidget(question);
              this.questionItems.add(questionItem);
              this.index++;
              this.showQuestion = true;
              this.next = false;
            });
          }
        });
      }
      if (index > 0) {
        this.prev = true;
      }
    } else {
      showDialog(
        context: context,
        builder: (conta) {
          return AlertDialog(
            title: Text(
              Translation.translate(
                  userdataProvider.language, "Wait a second ... "),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevation: 25,
            actions: <Widget>[
              OutlinedButton(
                  onPressed: () => Navigator.pop(conta),
                  child: Text(
                    Translation.translate(userdataProvider.language, "Ok"),
                    style: TextStyle(
                      backgroundColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                    ),
                  ))
            ],
            backgroundColor: Theme.of(context).primaryColor,
            contentPadding: EdgeInsets.all(20),
            titlePadding: EdgeInsets.all(10),
            content: Text(
              this.gradeResult == null
                  ? Translation.translate(userdataProvider.language,
                      "your are not allowed to access questions\nchoose a group first")
                  : Translation.translate(userdataProvider.language,
                      "First ! Answer this question"),
              textAlign: TextAlign.justify,
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

  void goToCategoreis(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      CategoryScreen.RouteName,
      (_) {
        return false;
      },
    );
  }

  // The grade result of te question must not be passed to the main Question Itm Widget
  // but we will return the correct answers Index in the return value and depending on this value
  // the question item will update the answers background
  // and also a popup view will be shown
  // since teh group and the category are global the QuestionItme class has to pass only the
  // Question ID and the answer Index of the Question Only
  Future<int> answerQuestion(int questionID, answerIndex) async {
    int answerI = 0;
    await databaseManager
        .answerQuestion(questionID, answerIndex, this.gradeResult)
        .then((answerIn) {
      setState(() {
        if (answerIndex == answerIn) {
          final was = gradeResult.Questions.indexOf("$questionID");
          if (was < 0) {
            this.gradeResult.Questions.add("$questionID");
            this.gradeResult.AnsweredCount++;
            this.gradeResult.AskedCount++;
          }
        } else {
          final was = gradeResult.Questions.indexOf("$questionID");
          if (was < 0) {
            this.gradeResult.Questions.add("$questionID");
            this.gradeResult.AskedCount++;
          }
          this.next = true;
        }
        answerI = answerIn;
      });
      this.prev = true;
      this.next = true;
    });
    return answerI;
  }

  void skipQuestion() {
    if (skip && !next) {
      this.questions.removeAt(index);
      this.questionItems.removeAt(index);
      if (index < (questions.length - 1)) {
        index++;
        this.question = questions[index];
        this.questionItem = questionItems[index];
      } else {
        this.index--;
        nextQuestion();
      }
    }
  }

  void previousQuestion(BuildContext context) {
    setState(() {
      if (this.index > 0) {
        this.question = questions[index - 1];
        this.questionItem = questionItems[index - 1];
        this.index--;
        if (index == 0) {
          this.prev = false;
        }
        this.next = true;
      } else {
        showDialog(
          context: context,
          builder: (conta) {
            return AlertDialog(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  Translation.translate(
                      userdataProvider.language, "Wait wait ... "),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              elevation: 25,
              actions: <Widget>[
                OutlinedButton(
                    onPressed: () => Navigator.pop(conta),
                    child: Text(
                      Translation.translate(userdataProvider.language, "Ok"),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        backgroundColor: Theme.of(context).primaryColor,
                        color: Colors.white,
                      ),
                    ))
              ],
              backgroundColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.all(20),
              titlePadding: EdgeInsets.all(10),
              content: Text(
                Translation.translate(
                    userdataProvider.language, "No Other Question to preview"),
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
    });
  }

  QuestionItem QuestionWidget(Question question) {
    if (question != null) {
      this.questionItem = QuestionItem(
        key: UniqueKey(),
        question: question,
        questionNumber: gradeResult.AskedCount + 1,
        answerQuestion: answerQuestion,
      );
    }
    return this.questionItem;
  }

  Widget getGoToCategoriesPage() {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(),
      child: Center(
          child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Card(
          elevation: 6,
          child: ElevatedButton(
            onPressed: () => goToCategoreis(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Translation.translate(
                      userdataProvider.language, "Go To Categories"),
                  style: TextStyle(
                    backgroundColor: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget starterWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        GestureDetector(
          onTap: nextQuestion,
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: Text(
              Translation.translate(userdataProvider.language, "Start"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    this.userdataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    // /// if the route is coming from the Category page then the data will be saved in the Shared Preferences
    // // and if the Route is Coming from main Page First Page
    // // then the First page will get the group and the category from the shared Preferences and
    // // will call the question page
    // // if there is no category and group id saved in the
    // // shared preferences then  the first page to be
    // // shown will be the category page
    if (arguments != null) {
      this.userdata = arguments["userdata"] as UserData;
      this.category = arguments["category"] as Category;
      this.group = arguments["group"] as Group;
    }
    if (this.userdata == null || this.category == null || this.group == null) {
      this.category = context.watch<ActiveQuestionInfo>().category;
      this.group = context.watch<ActiveQuestionInfo>().group;
      this.userdata = context.watch<UserDataProvider>().userdata;
    }

    if (group == null || category == null) {
      this.goToCategoriesPage = true;
    } else {
      this.userdata.SetCategory(category.ID);
      this.userdata.SetGroup(group.ID);
      this.userdata.initialize();
    }
    if (!goToCategoriesPage) {
      databaseManager.getGradeResult(group.ID, category.ID).then((value) {
        if (this.gradeResult != null) {
          return;
        }
        setState(() {
          this.gradeResult = value;
        });
      });
      if (gradeResult != null) {
        setState(() {
          result = true;
        });
      }
      userdata.initialize();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(Translation.translate(
          userdataProvider.language,
          "Question Page",
        )),
        key: UniqueKey(),
        centerTitle: true,
        elevation: 0,
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Theme.of(context).canvasColor,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    Translation.translate(
                        userdataProvider.language, "Categories"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 10,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                CategoryScreen.RouteName,
                (_) {
                  return false;
                },
              );
            },
          )
        ],
      ),
      drawer: NavigationDrawer(
        key: UniqueKey(),
        containerContext: context,
      ),
      /*
        *
        * Bottom Navigation bar Begins 
        *
        */
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            if (index == 0) {
              previousQuestion(context);
            } else if (index == 1) {
              if (result) {
                ShowResult(userdataProvider.language, gradeResult, context);
              }
            } else {
              if (gradeResult != null) {
                nextQuestion();
              }
            }
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.skip_previous,
              color: prev ? Colors.white : Colors.black26,
            ),
            label: Translation.translate(userdataProvider.language, "Previous"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment,
                color: result ? Colors.white : Colors.black26),
            label: Translation.translate(userdataProvider.language, "Result"),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.skip_next,
                color: next ? Colors.white : Colors.black26,
              ),
              label: Translation.translate(userdataProvider.language, "Next")),
        ],
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        ResultScreen.RouteName,
                        (_) {
                          return false;
                        },
                      ),
                      splashColor: Colors.brown[300],
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      Translation.translate(
                                              userdataProvider.language,
                                              "Category ") +
                                          " : " +
                                          (goToCategoriesPage
                                              ? Translation.translate(
                                                  userdataProvider.language,
                                                  "Unset")
                                              : Translation.translate(
                                                  userdataProvider.language,
                                                  this.category.Name)),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      Translation.translate(
                                              userdataProvider.language,
                                              "Test Number ") +
                                          " : " +
                                          (goToCategoriesPage
                                              ? "?"
                                              : "${this.group.GroupNumber}"),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                width: 100,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  this.gradeResult != null
                                      ? "${gradeResult.AnsweredCount} / ${gradeResult.AskedCount}"
                                      : " ?/? ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            goToCategoriesPage
                ? getGoToCategoriesPage()
                : (questionItem == null
                    ? starterWidget()
                    : (questionItem == null
                        ? QuestionWidget(question)
                        : questionItem)),
          ],
        ),
      ),
    );
  }
}
