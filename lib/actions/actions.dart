import 'package:flutter/material.dart';
import '../handlers/translation.dart';

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
                  backgroundColor: Color(0XFF006699),
                  color: Colors.white,
                ),
              ))
        ],
        backgroundColor: Color(0XFF006699),
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
