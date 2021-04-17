import 'package:drivers_question/libs.dart';
import 'package:flutter/material.dart';

class GradeResultState with ChangeNotifier {
  GradeResult _gradeResult;
  GradeResult get gradeResult {
    return _gradeResult;
  }

  void changeGradeResult(GradeResult gradeResult) {
    this._gradeResult = gradeResult;
    notifyListeners();
  }
}
