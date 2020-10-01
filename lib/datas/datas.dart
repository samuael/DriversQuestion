import 'package:DriversMobile/db/dbsqflite.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/QuestionItem.dart';

final List<String> LETTERS = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
];

class CategoryGroupData {
  List<Question> questions = [];
}

class QuestionData {
  Map<String, Color> answerToBackgroundColor = {};
  Map<String, Color> answerToTextColor = {};
  QStage stage = QStage.NotAnswered;
}

class TodaysDataHolder {
  static TodaysDataHolder instance;
  static TodaysDataHolder getInstance() {
    if (instance == null) {
      instance = TodaysDataHolder();
    }
    return instance;
  }

  Map<String, CategoryGroupData> categoryGroupDatas = {};
  Map<int, QuestionData> questionDatas = {};

  Future<bool> deleteResetedGroupQuestions(int categoryid, int groupid) async {
    GradeResult gradeResult;
    DatabaseManager databaseManager = DatabaseManager.getInstance();
    print("Category ID : ${categoryid}   // Group ID : ${groupid}");
    await databaseManager
        .getGradeResult(groupid, categoryid)
        .then((gradeReesult) {
      gradeResult = gradeReesult;
    });

    if (gradeResult == null) {
      print("it is because of gradeResult is null nigga ");
      return false;
    }
    print(" DATAS PAGE : Grade Result Questions Length : ${gradeResult.Questions.length}   and Questions : ${gradeResult.Questions}");
    try {
      print("${gradeResult.Questions}");
      // print(gradeResult.toMap());
      for (var id in gradeResult.Questions) {
        print("Question ID : ${id}");
        if(id=="" || id==null){
          continue;
        }
        if (int.parse(id) == null) {
          continue;
        }
        this.questionDatas[int.parse(id)] = QuestionData();
      }
    }catch(s , e){
      print("it is because of Question ID Parsing Nigga ...");
      // return false;
    }
    return true;
  }

  Future<void> deleteAllGroupQuestions() async {
    this.questionDatas.forEach((key, value) {
      this.questionDatas[key] = QuestionData();
    });
  }
}
