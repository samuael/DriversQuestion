import 'package:DriversMobile/db/dbsqflite.dart';

import '../libs.dart' show Category, Group;
import 'package:flutter/foundation.dart' show DiagnosticableTreeMixin;
import 'package:flutter/material.dart';

class ActiveQuestionInfo with ChangeNotifier, DiagnosticableTreeMixin {
  Category category = DatabaseManager.categories[0];
  Group group =
      Group(Categoryid: 1, GroupNumber: 1, ID: 1, QuestionsCount: 101);

  void setQuestionsInfo(Category cate, Group gro) {
    this.category = cate;
    this.group = gro;
    notifyListeners();
  }
}
