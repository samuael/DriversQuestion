// Question handler
import 'package:flutter/material.dart';
import "../libs.dart";

class Question {
  int ID;
  int Categoryid;
  int Groupid;
  String Body;
  List<String> Answers;
  int Answerindex;

  /// questionImage Image as a question which is to be used with the question text
  ///
  String questionImage;

  /// This qtype variable represents the type of the question.
  /// for example this caould be
  /// 1. 00000000 ( simple Indexed Question  )
  /// 2. 00000001 ( simple Image answer Questions   )
  /// 3. 00000010 (simple image as a question questions )
  int qtype;

  Question({
    this.ID,
    @required this.Categoryid,
    @required this.Groupid,
    @required this.Body,
    @required this.Answers,
    @required this.Answerindex,
    @required this.qtype,
    @required this.questionImage,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "categoryid": this.Categoryid,
      "groupid": this.Groupid,
      "body": this.Body,
      "answerindex": this.Answerindex,
      "answers": this.Answers.join("`"),
      "question_image": this.questionImage == "" || this.questionImage == null
          ? ""
          : this.questionImage,
      "type": this.qtype,
    };
  }

  /// fromJson create a json Question from a Map
  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        ID: json["id"] as int,
        Categoryid: json["categoryid"] as int,
        Groupid: json["groupid"] as int,
        Body: json["body"],
        Answers: json["answers"].split("`"),
        Answerindex: json["answerindex"] as int,
        qtype: json["type"] as int,
        questionImage: json["question_image"],
      );
    } catch (e, a) {
      return null;
    }
  }

  /// isImageQuestion , whether the question has the question in it or not.
  bool isImageQuestion() {
    if (this.questionImage != "" &&
        this
                .questionImage
                .split(".")[this.questionImage.split(".").length - 1] ==
            "png") return true;
    return false;
  }

  /// isAnswerQuestion , whether the question answers are images.
  bool isAnswerQuestion() {
    if (this.Answers[0] != "" &&
        this.Answers[0].split(".")[this.Answers[0].split(".").length - 1] ==
            "png") return true;
    return false;
  }
}

class Category {
  int ID;
  String Name;
  String imageDir;
  List<Group> groups;
  IconData icon;
  Category({this.ID, this.Name, this.imageDir, this.groups, this.icon});

  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "name": this.Name,
    };
  }

  Future<List<Group>> populateGroups(DatabaseManager databaseManager) async {
    databaseManager.getGroupsOfCategory(this.ID).then((groups) {
      this.groups = groups;
      return this.groups;
    });
  }
}

class Group {
  int ID;
  int GroupNumber;
  int Categoryid;
  int QuestionsCount;
  Group({this.GroupNumber, this.Categoryid, this.QuestionsCount, this.ID});
  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "group_no": this.GroupNumber,
      "categoryid": this.Categoryid,
      "questionscount": this.QuestionsCount,
    };
  }
}

class GradeResult {
  int ID;
  int Categoryid;
  int Groupid;
  int AskedCount = 0;
  int AnsweredCount = 0;
  List<String> Questions = [];
  GradeResult({
    this.ID,
    @required this.Categoryid,
    @required this.Groupid,
    this.AnsweredCount,
    this.AskedCount,
    this.Questions,
  });

  String join() {
    String ids = '';

    this.Questions.removeWhere((el) {
      try {
        int val = int.tryParse(el);
        if (val <= 0) {
          return true;
        }
        return false;
      } catch (s, e) {
        return true;
      }
    });
    int count = 0;
    for (var el in this.Questions) {
      if (count == 0) {
        // count++;
        try {
          int val = int.tryParse(el);
          if (val != null && val > 0) {
            ids += "$val";
            count++;
          }
        } catch (s, e) {}
        continue;
      }
      bool valid = false;
      int val = int.parse(el);
      if (val != null && val > 0) {
        valid = true;
      }
      if (valid) {
        ids += "`$el";
      }
    }
    return ids;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "categoryid": this.Categoryid,
      "groupid": this.Groupid,
      "askedcount": this.AskedCount,
      "answeredcount": this.AnsweredCount,
      "askedquestions": this.Questions == null ? "" : this.join(),
    };
  }
}
