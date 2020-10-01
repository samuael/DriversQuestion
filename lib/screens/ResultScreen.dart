import 'package:DriversMobile/datas/datas.dart';
import 'package:flutter/material.dart';
import '../handlers/translation.dart';
import '../handlers/sharedPreference.dart';
import '../db/dbsqflite.dart';
import '../widgets/navigation_drawer.dart';
import '../actions/actions.dart';

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
  int motorTotalAnswered = 0;
  int otherTotalAnswered = 0;
  List<GradeResult> motorResults = [];
  List<GradeResult> othersResults = [];
  TodaysDataHolder mahder;

  List<GradeResult> gradeResults = [];

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
      showPopup(this.lang, "Internal Error ",
          "Internal ERROR while Reseting Result ! Please Try Again.", context);
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
                this.motorTotalAnswered=0;
                this.motorTotalAsked=0;

                for(var gr in this.motorResults ){

                  this.motorTotalAnswered+=gr.AnsweredCount;
                  this.motorTotalAsked+=gr.AskedCount;
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
                print("The k is $k");
                this.othersResults[k] = gradeResult;
                this.otherTotalAnswered=0;
                this.otherTotalAsked=0;
                
                for(var gr in this.othersResults ){
                  this.otherTotalAnswered+=gr.AnsweredCount;
                  this.otherTotalAsked+=gr.AskedCount;
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
    // clear();
    // initialize();
    int motorTestCounter =0;
    int othersTestCounter =0;
    return Scaffold(
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
        userdata: userData,
      ),
      appBar: AppBar(
        title: Text(
          Translation.translate(this.lang, "Results") != null
              ? Translation.translate(this.lang, "Results")
              : "Results",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        key: UniqueKey(),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 70,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        (Translation.translate(this.lang, " Category  ") != null
                                ? Translation.translate(this.lang, "Category")
                                : "Category") +
                            "  : " +
                            (Translation.translate(this.lang ,this.categories[0].Name) != null ? Translation.translate(this.lang  , this.categories[0].Name) : this.categories[0].Name) ,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          (Translation.translate(this.lang, "Total") != null
                                  ? Translation.translate(this.lang, "Total")
                                  : "Total") +
                              " : $motorTotalAnswered / $motorTotalAsked",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize : 17 ,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ...(this.motorResults.map((gradeResult) {
                return Container(
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
                      (Translation.translate(this.lang, "Test") != null
                              ? Translation.translate(this.lang, "Test")
                              : "Test") +
                          " : ${++motorTestCounter}",
                      style: TextStyle(
                        color:Theme.of(context).textTheme.body1.color,
                      ),
                    ),
                    subtitle: Text(
                      "${gradeResult.AnsweredCount}/${gradeResult.AskedCount}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Theme.of(context).textTheme.body1.color,
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
              Container(
                height: 70,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        (Translation.translate(this.lang, " Category  ") != null
                                ? Translation.translate(this.lang, "Category")
                                : "Category") +
                            "  : " +
                             (Translation.translate( this.lang , this.categories[1].Name ) != null ? Translation.translate( this.lang , this.categories[1].Name ) : this.categories[1].Name ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          (Translation.translate(this.lang, "Total") != null
                                  ? Translation.translate(this.lang, "Total")
                                  : "Total") +
                              " : $otherTotalAnswered / $otherTotalAsked",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize:17,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ...(this.othersResults.map((gradeResult) {
                return Container(
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
                      (Translation.translate(this.lang, "Test") != null
                              ? Translation.translate(this.lang, "Test")
                              : "Test") +
                          " : ${++othersTestCounter}",
                      style: TextStyle(
                        color:Theme.of(context).textTheme.body1.color,
                      ),
                    ),
                    subtitle: Text(
                      "${gradeResult.AnsweredCount}/${gradeResult.AskedCount}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.body1.color,
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
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Center(
                        child: Text(
                          Translation.translate(this.lang, "Reset Results") !=
                                  null
                              ? Translation.translate(
                                  this.lang, "Reset Results")
                              : "Reset Results",
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
      ),
    );
  }
}
