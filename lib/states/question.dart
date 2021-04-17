import 'package:drivers_question/libs.dart';
import 'package:flutter/material.dart';

class QuestionsState with ChangeNotifier {
  Question _question;

  Question get question {
    return _question;
  }

  void setQuestion(Question question) {
    this._question = question;
    notifyListeners();
  }

  void answerQuestion(int answerIndex) {
    // here the logic for the answer validation will be placed.
    // and notification of the 
  }
}
