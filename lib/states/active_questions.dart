import 'package:drivers_question/libs.dart';
import 'package:flutter/material.dart';

class ActiveQuestionsState with ChangeNotifier {
  List<Question> questions;

  ActiveQuestionsState() {
    this.questions = [];
  }

  void addQuestion(Question question) {
    this.questions.add(question);
    notifyListeners();
  }

  void removeQuestion(int questionID) {
    this.questions.removeWhere((question) => question.ID == questionID);
    notifyListeners();
  }
  // i don't have to load all the questions that are not asked after the Loading of the class
  //
}
