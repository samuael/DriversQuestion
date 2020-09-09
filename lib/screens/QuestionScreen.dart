import 'package:DriversMobile/db/dbsqflite.dart';
import 'package:DriversMobile/handlers/sharedPreference.dart';
import 'package:DriversMobile/handlers/translation.dart';
import 'package:DriversMobile/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import '../widgets/QuestionItem.dart';
import 'Categories.dart';
import '../datas/datas.dart';
import "ResultScreen.dart";
import '../actions/actions.dart';

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
  String lang = "";
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
  bool next = false;
  bool prev = false;
  bool skip = false;
  bool result = false ;
  // TodaysDataHolder mahder;
  // bool once = true;
  @override
  void initState() {

    databaseManager = DatabaseManager.getInstance();
    WidgetsBinding.instance.addObserver(this);

    // this.mahder = TodaysDataHolder.getInstance();

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
    if (state == AppLifecycleState.detached) {
    }
  }

  void nextQuestion() {
    if (next) {
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
        // print("You Have Called Print hah nigggaa...");
        //if (this.index == this.questions.length - 1) {
        if (databaseManager == null) {
          this.databaseManager = DatabaseManager.getInstance();
          return;
        }
        databaseManager
            .getQuestion(this.category.ID, this.group.ID)
            .then((questi) {
          if (questi != null) {
            // print("From Database : ");
            // print("${questi.Body}  ${questi.Answers}  ${questi.Answerindex}");
            setState(() {
              this.question = questi;
              this.questions.add(questi);
              this.questionItem = QuestionWidget(question);
              this.questionItems.add(questionItem);
              this.index++;
              this.showQuestion = true;
              this.next = false;

              // if (this.mahder == null) {
              //   this.mahder = TodaysDataHolder.getInstance();
              // }

              // CategoryGroupData cgdt = this
              //     .mahder
              //     .categoryGroupDatas["${this.category.ID}:${this.group.ID}"];
              // if (cgdt == null) {
              //   cgdt = CategoryGroupData();
              // }
              // cgdt.questions.add(this.question);
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
              Translation.translate(this.lang, "Wait a second ... ") != null
                  ? Translation.translate(this.lang, "Wait a second ... ")
                  : "Wait a second ... ",
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
                    Translation.translate(this.lang, "Ok") != null
                        ? Translation.translate(this.lang, "Ok")
                        : "Ok",
                    style: TextStyle(
                      backgroundColor: Color(0XFF006699),
                      color: Colors.white,
                    ),
                  ))
            ],
            backgroundColor: Color(0XFF006699),
            // shape: CircleBorder(),
            contentPadding: EdgeInsets.all(20),
            titlePadding: EdgeInsets.all(10),
            content: Text(
              Translation.translate(
                          this.lang, "First ! Answer this question") !=
                      null
                  ? Translation.translate(
                      this.lang, "First ! Answer this question")
                  : "First ! Answer this question",
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

  // the grade result of te question must not be passed to the main Question Itm Widget
  // but we will return the correct answers Index in the returrn value and depending on this value
  // the question item will update the answers backgrouns
  // and also a popup view will be sshown
  // since teh group and the category are global the QuestionItme class has to pass only the
  // Question ID and the answer Index of the Question Only
  Future<int> answerQuestion(int questionID, answerIndex) async {
    int answerI = 0;
    print("previously  ${this.gradeResult.Questions}");
    await databaseManager
        .answerQuestion(questionID, answerIndex, this.gradeResult)
        .then((answerIn) {
      setState(() {
        if (answerIndex == answerIn) {
          final was = gradeResult.Questions.indexOf("$questionID");
          print("Heree  :   ${gradeResult.Questions}");
          if (was < 0) {
            this.gradeResult.Questions.add("$questionID");
            this.gradeResult.AnsweredCount++;
            this.gradeResult.AskedCount++;
          }
        } else {
          final was = gradeResult.Questions.indexOf("$questionID");
          print("Heree  :   ${gradeResult.Questions}");
          if (was < 0) {
            this.gradeResult.Questions.add("$questionID");
            this.gradeResult.AskedCount++;
          }
          this.next = true;
        }
        answerI = answerIn;
      });
      print("After Update ${gradeResult.Questions}");
      // print("this is answer In : $answerIn");
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
    } else {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     Translation.translate(this.lang, "Can't Skip this Question ") != null
      //         ? Translation.translate(this.lang, "Can't Skip this Question ")
      //         : "Can't Skip this Question ",
      //   ),
      // ));
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
              title: Text(
                Translation.translate(this.lang, "Wait wait ... ") != null
                    ? Translation.translate(this.lang, "Wait wait ... ")
                    : "Wait wait ... ",
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
                      Translation.translate(this.lang, "Ok") != null
                          ? Translation.translate(this.lang, "Ok")
                          : "Ok",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        backgroundColor: Color(0XFF006699),
                        color: Colors.white,
                      ),
                    ))
              ],
              backgroundColor: Color(0XFF006699),
              // shape: CircleBorder(),
              contentPadding: EdgeInsets.all(20),
              titlePadding: EdgeInsets.all(10),
              content: Text(
                Translation.translate(
                            this.lang, "No Other Question to preview") !=
                        null
                    ? Translation.translate(
                        this.lang, "No Other Question to preview")
                    : "No Other Question to preview",
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
        questionNumber : gradeResult.AskedCount+1,
        answerQuestion: answerQuestion,
        // nextCallback
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
          child: FlatButton(
            padding: EdgeInsets.all(40),
            color: Theme.of(context).primaryColor,
            onPressed: () => goToCategoreis(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Translation.translate(lang, "Go To Categories") != null
                      ? Translation.translate(lang, "Go To Categories")
                      : "Go To Categories ",
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
          child: FlatButton(
            padding: EdgeInsets.all(40),
            color: Theme.of(context).primaryColor,
            onPressed: nextQuestion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Translation.translate(lang, "Start") != null
                      ? Translation.translate(lang, "Start")
                      : "Start",
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

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    /// if the route is coming from the Category page then the data will be saved in the Shared Preferences
    // and if the Route is Coming from main Page First Page
    // then the First page will get the group and the category from the shared Preferences and
    // will call the question page
    // if there is no category and group id saved in the shared preferences then  the first page to be shown will be the category page
    this.userdata = arguments["userdata"] as UserData;
    this.lang = arguments["lang"] as String;
    this.category = arguments["category"] as Category;
    this.group = arguments["group"] as Group;
    if (group == null || category == null) {
      this.goToCategoriesPage = true;
    } else {
      // print("Saving the Category and the Group to the Shared Preferences ...");
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
      if(gradeResult != null ){
        setState(() {
          result = true;
          next=true;
        });
      }



    }
    // databaseManager.printAllQuestions(category.ID , group.ID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translation.translate(
                    lang,
                    "Question Page",
                  ) !=
                  null
              ? Translation.translate(
                  lang,
                  "Question Page",
                )
              : "Question Page",
        ),
        key: UniqueKey(),
        centerTitle: true,
      ),
      drawer: NavigationDrawer(
        key: UniqueKey(),
        containerContext: context,
        userdata: userdata,
      ),
      /*
        *
        * Bottom Navigation bar Begins 
        *
        */
      bottomNavigationBar: BottomNavigationBar(
        // onTap: selectedIndexSet,
        onTap: (int index) {
          setState(() {
            if (index == 0) {
              previousQuestion(context);
            } else if (index == 1) {
              if(result){
                ShowResult(this.lang  , gradeResult , context);
              }
            } else {
              if(gradeResult != null ) {
                nextQuestion();
              }
            }
          });
          // print("selected Index is : $selectedIndex");
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black26,
        unselectedItemColor: Colors.white,
        // currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.skip_previous,
              color: prev ? Colors.white : Colors.black26,
            ),
            title: Text(
              Translation.translate(lang, "Previous") != null
                  ? Translation.translate(lang, "Previous")
                  : "Previous",
              style: TextStyle(
                color: prev ? Colors.white : Colors.black26,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment,
                color: result ? Colors.white : Colors.black26),
            title: Text(Translation.translate(lang, "Result") != null
                ? Translation.translate(lang, "Result")
                : "Result"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.skip_next,
              color: next ? Colors.white : Colors.black26,
            ),
            title: Text(Translation.translate(lang, "Next") != null
                ? Translation.translate(lang, "Next")
                : "Next"),
          ),
        ],
      ),
      /*
        *
        * Bottom Navigation bar End 
        *
        */
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
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
                    height: 100,
                    child: Row(
                      children: <Widget>[
                        // Expanded(
                        //   flex: 1,
                        //   child: Container(
                        //     height: 100,
                        //     width: 100,
                        //     child: new AnimatedBuilder(
                        //       builder: (BuildContext context, Widget _widget) {
                        //         return Transform.rotate(
                        //           angle: animationController.value * 6.3,
                        //           child: _widget,
                        //         );
                        //       },
                        //       key: UniqueKey(),
                        //       animation: animationController,
                        //       child: CircleAvatar(
                        //         child: Image.asset("assets/images/tyrePng.png"),
                        //         backgroundColor: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                (Translation.translate(lang, "Category ") !=
                                            null
                                        ? Translation.translate(
                                            lang, "Category ")
                                        : "Category ") +
                                    " : " +
                                    (goToCategoriesPage
                                        ? (Translation.translate(
                                                    lang, "Unset") !=
                                                null
                                            ? Translation.translate(
                                                lang, "Unset")
                                            : "Unset")
                                        : (Translation.translate(
                                                    lang, this.category.Name) !=
                                                null
                                            ? Translation.translate(
                                                lang, this.category.Name)
                                            : this.category.Name)),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                (Translation.translate(lang, "Group Number ") !=
                                            null
                                        ? Translation.translate(
                                            lang, "Group Number ")
                                        : "Group Number  ") +
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
              // the Question Body for  QUestions and ANswers
              goToCategoriesPage
                  ? getGoToCategoriesPage()
                  : (questionItem == null
                      ? starterWidget()
                      : (questionItem == null
                          ?
                          // ? () {

                          QuestionWidget(question)
                          : questionItem)),
              // this is the end
            ],
          ),
        ),
      ),
    );
  }
}
