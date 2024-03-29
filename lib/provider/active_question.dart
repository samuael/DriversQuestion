// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import '../libs.dart';
import 'package:flutter/foundation.dart';

class ActiveQuestion with ChangeNotifier, DiagnosticableTreeMixin {
  Question _question;

  Question get question => _question;

  void setQuestion(Question question) {
    this._question = question;
    notifyListeners();
  }
}
