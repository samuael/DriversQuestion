import 'package:flutter/material.dart';
import '../libs.dart';

class ResultScreen extends StatefulWidget {
  static const RouteName = "/results/";
  ResultScreen({Key key}) : super(key: key);

  static ResultScreen screen;

  static ResultScreen getInstance() {
    if (screen == null) {
      screen = ResultScreen(
        key: UniqueKey(),
      );
    }
    return screen;
  }

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  DatabaseManager databaseManager;
  List<Category> categories = [];
  String lang = '';
  String username = '';
  UserData userData;
  int motorTotalAsked = 0;
  int otherTotalAsked = 0;
  int iconTotalAsked = 0;
  int motorTotalAnswered = 0;
  int otherTotalAnswered = 0;
  int iconsTotalAnswered = 0;
  List<GradeResult> motorResults = [];
  List<GradeResult> othersResults = [];
  List<GradeResult> iconsResults = [];

  TodaysDataHolder mahder;

  List<GradeResult> gradeResults = [];
  bool motorSelected = true, otherSelected = true, iconSelected = true;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    this.mahder = TodaysDataHolder.getInstance();
    userData = UserData.getInstance();
    userData.initialize();
    this.lang = userData.Lang;
    this.username = userData.Username;

    databaseManager = DatabaseManager.getInstance();
    categories = DatabaseManager.categories;

    databaseManager.GradeResults().then((gradeResults) {
      this.gradeResults = gradeResults;
      for (var gradeResult in this.gradeResults) {
        if (gradeResult.Categoryid == 1) {
          this.motorResults.add(gradeResult);
          this.motorTotalAnswered += gradeResult.AnsweredCount;
          this.motorTotalAsked += gradeResult.AskedCount;
        } else if (gradeResult.Categoryid == 2) {
          this.othersResults.add(gradeResult);
          this.otherTotalAnswered += gradeResult.AnsweredCount;
          this.otherTotalAsked += gradeResult.AskedCount;
        } else {
          this.iconsResults.add(gradeResult);
          this.iconsTotalAnswered += gradeResult.AnsweredCount;
          this.iconTotalAsked += gradeResult.AskedCount;
        }
      }
      setState(() {
        this.motorTotalAnswered = this.motorTotalAnswered;
        this.motorTotalAsked = this.motorTotalAsked;

        this.otherTotalAnswered = this.otherTotalAnswered;
        this.otherTotalAsked = this.otherTotalAsked;

        // updating motor results ...
        this.motorResults = this.motorResults;
        this.motorTotalAnswered = this.motorTotalAnswered;
        this.motorTotalAsked = this.motorTotalAsked;

        // updating the icons questions results
        this.iconsResults = this.iconsResults;
        this.iconsTotalAnswered = this.iconsTotalAnswered;
        this.iconTotalAsked = this.iconTotalAsked;
      });
    });
  }

  void clear() {
    motorResults = [];
    othersResults = [];
    otherTotalAnswered = 0;
    otherTotalAsked = 0;

    motorTotalAnswered = 0;
    motorTotalAsked = 0;
  }

  Future<void> resetMe(
      int id, int categoryid, int grouid, BuildContext context) async {
    if (this.databaseManager == null) {
      this.databaseManager = DatabaseManager.getInstance();
    }
    bool success = false;
    await this
        .mahder
        .deleteResetedGroupQuestions(categoryid, grouid)
        .then((succes) {
      success = succes;
    });
    if (!success) {
      showPopup(
          this.lang,
          "Internal Error ",
          ["Internal ERROR while Reseting Result ! Please Try Again."],
          context);
      return;
    }
    await databaseManager
        .restGradeResultByID(id, categoryid, grouid)
        .then((gradeResult) {
      if (gradeResult == null) {
        return;
      }
      if (gradeResult.ID > 0 &&
          gradeResult.Categoryid > 0 &&
          gradeResult.Groupid > 0) {
        if (gradeResult.Categoryid == 1) {
          for (var k = 0; k < this.motorResults.length; k++) {
            final gres = this.motorResults[k];
            if (gradeResult.ID == gres.ID &&
                gradeResult.Categoryid == gres.Categoryid &&
                gradeResult.Groupid == gres.Groupid) {
              setState(() {
                this.motorResults[k] = gradeResult;
                this.motorTotalAnswered = 0;
                this.motorTotalAsked = 0;

                for (var gr in this.motorResults) {
                  this.motorTotalAnswered += gr.AnsweredCount;
                  this.motorTotalAsked += gr.AskedCount;
                }
              });
            }
          }
        } else if (gradeResult.Categoryid == 3) {
          for (var k = 0; k < this.iconsResults.length; k++) {
            final gres = this.iconsResults[k];
            if (gradeResult.ID == gres.ID &&
                gradeResult.Categoryid == gres.Categoryid &&
                gradeResult.Groupid == gres.Groupid) {
              setState(() {
                this.iconsResults[k] = gradeResult;
                this.iconsTotalAnswered = 0;
                this.iconTotalAsked = 0;

                for (var gr in this.iconsResults) {
                  this.iconsTotalAnswered += gr.AnsweredCount;
                  this.iconTotalAsked += gr.AskedCount;
                }
              });
            }
          }
        } else {
          for (var k = 0; k < this.othersResults.length; k++) {
            final gres = this.othersResults[k];
            if (gradeResult.ID == gres.ID &&
                gradeResult.Categoryid == gres.Categoryid &&
                gradeResult.Groupid == gres.Groupid) {
              setState(() {
                this.otherTotalAnswered = 0;
                this.otherTotalAsked = 0;

                for (var gr in this.othersResults) {
                  this.otherTotalAnswered += gr.AnsweredCount;
                  this.otherTotalAsked += gr.AskedCount;
                }
              });
            }
          }
        }
      }
    });
  }

  Future<void> resetAll() async {
    if (databaseManager == null) {
      databaseManager = DatabaseManager.getInstance();
    }
    this.mahder.deleteAllGroupQuestions();
    await databaseManager.resetAllGradeResults().then((gradeResultss) {
      clear();
      if (gradeResultss == null) {
        return;
      }
      this.gradeResults = gradeResultss;
      for (var gradeResult in this.gradeResults) {
        if (gradeResult.Categoryid == 1) {
          this.motorResults.add(gradeResult);
          this.motorTotalAnswered += gradeResult.AnsweredCount;
          this.motorTotalAsked += gradeResult.AskedCount;
        } else {
          this.othersResults.add(gradeResult);
          this.otherTotalAnswered += gradeResult.AnsweredCount;
          this.otherTotalAsked += gradeResult.AskedCount;
        }
      }
      setState(() {
        this.motorTotalAnswered = this.motorTotalAnswered;
        this.motorTotalAsked = this.motorTotalAsked;

        this.otherTotalAnswered = this.otherTotalAnswered;
        this.otherTotalAsked = this.otherTotalAsked;

        this.motorResults = this.motorResults;
        this.motorTotalAnswered = this.motorTotalAnswered;
        this.motorTotalAsked = this.motorTotalAsked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int motorTestCounter = 0;
    int othersTestCounter = 0;
    int iconsTestCounter = 0;
    return Scaffold(
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(200, 120),
              topLeft: Radius.elliptical(200, 120),
            ),
          ),
          child: Text(
            Translation.translate(this.lang, "Results"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        key: UniqueKey(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.03,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(10, 10),
                          topRight: Radius.elliptical(10, 10))),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.motorSelected = !this.motorSelected;
                });
              },
              child: Container(
                height: 70,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        Translation.translate(this.lang, " Category  ") +
                            "  : " +
                            Translation.translate(
                                this.lang, this.categories[0].Name),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                            ),
                            child: Text(
                              Translation.translate(this.lang, "Total") +
                                  " : $motorTotalAnswered / $motorTotalAsked",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            motorSelected
                                ? Icons.arrow_downward
                                : Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...(this.motorResults.map((gradeResult) {
              return !motorSelected
                  ? SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.motorcycle,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          Translation.translate(this.lang, "Test") +
                              " : ${++motorTestCounter}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium.color,
                          ),
                        ),
                        subtitle: Text(
                          "${gradeResult.AnsweredCount}/${gradeResult.AskedCount}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyMedium.color,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () => resetMe(
                            gradeResult.ID,
                            gradeResult.Categoryid,
                            gradeResult.Groupid,
                            context,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Icon(
                              Icons.restore,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
            }).toList()),
            GestureDetector(
              onTap: () {
                setState(() {
                  otherSelected = !otherSelected;
                });
              },
              child: Container(
                height: 70,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        Translation.translate(this.lang, " Category  ") +
                            "  : " +
                            Translation.translate(
                                this.lang, this.categories[1].Name),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                            ),
                            child: Text(
                              Translation.translate(this.lang, "Total") +
                                  " : $otherTotalAnswered / $otherTotalAsked",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            otherSelected
                                ? Icons.arrow_downward
                                : Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...(this.othersResults.map(
              (gradeResult) {
                return !otherSelected
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.local_car_wash,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                            Translation.translate(this.lang, "Test") +
                                " : ${++othersTestCounter}",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium.color,
                            ),
                          ),
                          subtitle: Text(
                            "${gradeResult.AnsweredCount}/${gradeResult.AskedCount}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium.color,
                            ),
                          ),
                          trailing: InkWell(
                            onTap: () => resetMe(
                              gradeResult.ID,
                              gradeResult.Categoryid,
                              gradeResult.Groupid,
                              context,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Icon(
                                Icons.restore,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ).toList()),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.iconSelected = !this.iconSelected;
                });
              },
              child: Container(
                height: 70,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        Translation.translate(this.lang, " Category  ") +
                            "  : " +
                            Translation.translate(
                                this.lang, this.categories[2].Name),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                            ),
                            child: Text(
                              Translation.translate(this.lang, "Total") +
                                  " : $iconsTotalAnswered / $iconTotalAsked",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            iconSelected
                                ? Icons.arrow_downward
                                : Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...(this.iconsResults.map((gradeResult) {
              return !iconSelected
                  ? SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.image,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          Translation.translate(this.lang, "Test") +
                              " : ${++iconsTestCounter}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium.color,
                          ),
                        ),
                        subtitle: Text(
                          "${gradeResult.AnsweredCount}/${gradeResult.AskedCount}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyMedium.color,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () => resetMe(
                            gradeResult.ID,
                            gradeResult.Categoryid,
                            gradeResult.Groupid,
                            context,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Icon(
                              Icons.restore,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
            }).toList()),
            InkWell(
              onTap: () => resetAll(),
              hoverColor: Color(0XFF006699),
              child: ClipRRect(
                key: UniqueKey(),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Center(
                      child: Text(
                        Translation.translate(this.lang, "Reset Results"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
