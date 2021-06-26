// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import '../libs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Questions with ChangeNotifier, DiagnosticableTreeMixin {
  List<Question> _questions;
  int index = 0;

  List<Question> get questions => _questions;

  void setQuestions(List<Question> question) {
    this._questions = question;
    notifyListeners();
  }
}
