import 'package:flutter/material.dart';

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
        } catch (s, e) {
          print("error character $el");
        }
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
    print("inside to map method te ids variable $ids ");
    return ids;
  }

  Map<String, dynamic> toMap() {
    return {
      "categoryid": this.Categoryid,
      "groupid": this.Groupid,
      "askedcount": this.AskedCount,
      "answeredcount": this.AnsweredCount,
      "id": this.ID,
      "askedquestions": this.join(),
    };
  }
}
