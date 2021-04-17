// Question handler
import 'package:flutter/material.dart';

class Question {
  int ID;
  int Categoryid;
  int Groupid;
  String Body;
  String imageurl;
  List<String> Answers;
  int Answerindex;
  // isImageAnswers  this represent whether the question is having a list of image url's or
  // other sentences representing answer statment .
  bool isImageAnswers;

  Question({
    @required this.ID,
    @required this.Categoryid,
    @required this.Groupid,
    @required this.Body,
    @required this.Answers,
    @required this.Answerindex,
    this.imageurl,
    this.isImageAnswers = false,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "categoryid": this.Categoryid,
      "groupid": this.Groupid,
      "body": this.Body,
      "answerindex": this.Answerindex,
      "answers": this.Answers.join("`"),
      "imageurl": this.imageurl,
      "imageAnswers": this.isImageAnswers,
    };
  }
}
