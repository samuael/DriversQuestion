import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import '../datas/datas.dart' as datas;
import "../db/dbsqflite.dart";
import "../handlers/sharedPreference.dart";
import "../handlers/translation.dart";



class QuestionItem extends StatefulWidget {
  final Question question;
  final Function answerQuestion;
  final int questionNumber ;

  QuestionItem({
    Key key,
    this.question,
    this.questionNumber ,
    this.answerQuestion,
  }) : super(key: key);

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

enum QStage {
  NotAnswered,
  Correct,
  NotCorrect,
  ERROR,
}

class _QuestionItemState extends State<QuestionItem> {
  Map<String, int> answerToIndex = {};
  Map<int, String> indexToanswer = {};
  Map<String, Color> answerToBackgroundColor = {};
  Map<String, Color> answerToTextColor = {};
  QStage stage = QStage.NotAnswered;
  Question question;
  datas.TodaysDataHolder mahder;
  String lang ="";
  UserData userdata ;
  // bool once = true; // this thing represents whether it has to run the Fetching thing or not at first build
  // but since i am using the initState method i think i don't have to initiate it
  // nigga you got me

  @override
  void initState() {
    if (this.mahder == null) {
      this.mahder = datas.TodaysDataHolder.getInstance();
    }
    final questData = this.mahder.questionDatas[widget.question.ID];
    if (questData != null) {
      this.stage = questData.stage;
      this.answerToTextColor = questData.answerToTextColor;
      this.answerToBackgroundColor = questData.answerToBackgroundColor;
    } else {
      this.mahder.questionDatas[widget.question.ID] = datas.QuestionData();
    }
    super.initState();
  }

  Future<void> handlerAnswer(String answer) async {
    print("Status : ${stage.toString()}");
    if (stage == QStage.NotAnswered) {
      // print(stage.toString());
      await widget
          .answerQuestion(widget.question.ID, answerToIndex[answer])
          .then((val) {
        if (val == answerToIndex[answer]) {
          answerToBackgroundColor[answer] = Color(0XAA00CC00);
          answerToTextColor[answer] = Colors.white;
          stage = QStage.Correct;
        } else if (val >= 0) {
          answerToBackgroundColor[answer] = Colors.red;
          answerToTextColor[answer] = Colors.white;

          answerToBackgroundColor[indexToanswer[val]] = Color(0XAA00CC00);
          answerToTextColor[indexToanswer[val]] = Colors.white;

          stage = QStage.NotCorrect;
        } else {
          stage = QStage.ERROR;
          for (var ans in this.question.Answers) {
            answerToTextColor[ans] = Color(0X99FF0000);
          }
        }
      });
      setState(() {
        this.answerToBackgroundColor = this.answerToBackgroundColor;
        this.answerToTextColor = this.answerToTextColor;
        this.question = widget.question;
      });
      this.mahder.questionDatas[this.question.ID].answerToBackgroundColor =
          this.answerToBackgroundColor;
      this.mahder.questionDatas[this.question.ID].answerToTextColor =
          this.answerToTextColor;
      this.mahder.questionDatas[this.question.ID].stage = this.stage;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.question = widget.question;
    this.userdata = UserData.getInstance();
    this.userdata.initialize();
      this.lang = userdata.Lang;
    int counter = 0;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Card(
        elevation: 10,
        child: Container(
          decoration : BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                    ),
                  ),
                  child: Text(
                    "(${ widget.questionNumber }). " + this.question.Body,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      //  fontFamily: FontFamily.,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ...this.question.Answers.map((ans) {
                this.answerToIndex[ans] = counter;
                this.indexToanswer[counter] = ans;
                if (answerToBackgroundColor[ans] == null) {
                  answerToBackgroundColor[ans] = Colors.white;
                }
                if (answerToTextColor[ans] == null) {
                  answerToTextColor[ans] = Colors.black;
                }
                final widget = Container(
                  child: ListTile(
                    onTap: () => handlerAnswer(ans),
                    selected: false,
                    leading: CircleAvatar(
                      child: Text(
                        Translation.translate(lang , datas.LETTERS[counter]) != null ?
                        Translation.translate(lang , datas.LETTERS[counter]) :
                        datas.LETTERS[counter]                       
                        ),
                    ),
                    title: Text(
                      ans,
                      style: TextStyle(
                        fontSize: 12,
                        color: answerToTextColor[ans],
                      ),
                    ),
                  ),
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    color: answerToBackgroundColor[ans],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                );
                counter++;
                return widget;
              }).toList(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
