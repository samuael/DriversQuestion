import 'package:flutter/material.dart';
import '../libs.dart';

void showPopup(
    String lang, String title, String content, BuildContext context) {
  showDialog(
    context: context,
    builder: (conta) {
      return AlertDialog(
        title: Text(
          Translation.translate(lang, title) != null
              ? Translation.translate(lang, title)
              : title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 25,
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(conta),
              child: Text(
                Translation.translate(lang, "Ok") != null
                    ? Translation.translate(lang, "Ok")
                    : "Ok",
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
          Translation.translate(lang, content) != null
              ? Translation.translate(lang, content)
              : content,
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
        title: Text(
          Translation.translate(lang, "Grade Result") != null
              ? Translation.translate(lang, "Grade Result")
              : "Grade Result",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 25,
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(conta),
              child: Text(
                Translation.translate(lang, "Ok") != null
                    ? Translation.translate(lang, "Ok")
                    : "Ok",
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
            child: Column(
          children: [
            Text(
              (Translation.translate(lang, "Category ") != null
                      ? Translation.translate(lang, "Category")
                      : "Category ") +
                  " : " +
                  (Translation.translate(
                              lang,
                              DatabaseManager
                                  .categories[gradeResult.Categoryid - 1]
                                  .Name) !=
                          null
                      ? Translation.translate(
                          lang,
                          DatabaseManager
                              .categories[gradeResult.Categoryid - 1].Name)
                      : DatabaseManager
                          .categories[gradeResult.Categoryid - 1].Name),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              (Translation.translate(lang, "Group ") != null
                      ? Translation.translate(lang, "Group")
                      : "Group") +
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
