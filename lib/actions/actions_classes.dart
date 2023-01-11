import 'package:flutter/material.dart';
import '../libs.dart';

void showPopup(
    String lang, String title, List<String> content, BuildContext context) {
  showDialog(
    context: context,
    builder: (conta) {
      return AlertDialog(
        title: Text(
          Translation.translate(lang, title),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 25,
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => Navigator.pop(conta),
              child: Text(
                Translation.translate(lang, "Ok"),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        // shape: CircleBorder(),
        contentPadding: EdgeInsets.all(20),
        titlePadding: EdgeInsets.all(10),
        content: Text(
          () {
            String finalVal = '';
            for (String val in content) {
              finalVal += Translation.translate(lang, val);
            }
            return finalVal;
          }(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    },
    barrierDismissible: true,
  );
}

void ShowResult(String lang, GradeResult gradeResult, BuildContext context) {
  showDialog(
    context: context,
    builder: (conta) {
      return AlertDialog(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            Translation.translate(lang, "Grade Result"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 25,
        actions: <Widget>[
          OutlinedButton(
              onPressed: () => Navigator.pop(conta),
              child: Text(
                Translation.translate(lang, "Ok"),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        // shape: CircleBorder(),
        contentPadding: EdgeInsets.all(20),
        titlePadding: EdgeInsets.all(10),
        content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Translation.translate(lang, "Category ") +
                      " : " +
                      Translation.translate(
                          lang,
                          DatabaseManager
                              .categories[gradeResult.Categoryid - 1].Name),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  Translation.translate(lang, "Group ") +
                      " : " +
                      "${gradeResult.Groupid}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Text(
                    "${gradeResult.AnsweredCount} /${gradeResult.AskedCount}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            )),
      );
    },
    barrierDismissible: true,
  );
}
