/* -- File Loaders */
/* This class loads the instruction from the xlsx file and return a list of list of dynamic data types*/
import '../libs.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

/// ListLoader function to load list<list<dynamic>> from the files.xlsx file.
class ListLoader {
  /// loadNonIndexedXlsx function returns
  /// list of list of dynamic varaibale which contains
  /// title , id , ... answers
  static Future<List<List<dynamic>>> loadNonIndexedXlsx(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;

      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });
      bool valid = row.length >= 3 ? true : false;
      // shuffling the question after getting the correct question result and set it as answer Index
      if (!valid) continue;
      int ansIndex = 0;
      String ans = "${row[1]}";
      List<dynamic> anss = row.getRange(1, row.length).toList();
      List<String> answers = [];
      for (dynamic ans in anss) {
        answers.add("${ans}");
      }
      if (answers == null || answers.length < 2) continue;
      answers = Shuffle(answers);
      for (int v = 0; v < answers.length; v++) {
        if ("${answers[v]}" == ans) {
          ansIndex = v;
          break;
        }
      }
      final List<String> newRow = [row[0], "$ansIndex", ...answers];
      if (newRow.length >= 4 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }

  /* loadIndexedQuestions 
  List<Question> : questions 
  */
  static Future<List<Question>> loadNonIndexedQuestions(
      String path, String sheetName, int category, int group) async {
    List<List<dynamic>> loads =
        await ListLoader.loadNonIndexedXlsx(path, sheetName);
    List<Question> questions = [];
    for (List<dynamic> quest in loads) {
      try {
        int ansindex = int.parse(quest[1]);
        Question question = new Question(
          Categoryid: category,
          Groupid: group,
          Body: "${quest[0]}",
          Answers: quest.getRange(2, quest.length).cast<String>().toList(),
          Answerindex: ansindex,
          qtype: 0,
          questionImage:
              "", // sinece i am sure about the correctness of the integer
        );
        questions.add(question);
      } catch (e, a) {}
    }
    return questions;
  }

  /// loadXlx  loads list of list of dynamic from xlsx input file
  /// Text : string
  /// Answer_number : int
  /// ... Ansers : string
  static Future<List<List<dynamic>>> loadXlsx(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;

      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });
      int index = 0;
      bool valid = false;
      if (row.length >= 4) {
        try {
          index = int.tryParse("${row[1]}");
          if (index != null && index > 0 && index <= (row.length - 2)) {
            valid = true;
          }
        } catch (s, e) {
          valid = false;
          index = 0;
        }
      }

      final List<String> newRow = [];
      for (var f = 0; f < row.length; f++) {
        newRow.add("${row[f]}");
      }
      if (newRow.length >= 4 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }

  /* loadIndexedQuestions 
  List<Question> : questions 
  */
  static Future<List<Question>> loadQuestions(
      String path, String sheetName, int category, int group) async {
    List<List<dynamic>> loads = await ListLoader.loadXlsx(path, sheetName);
    List<Question> questions = [];
    for (List<dynamic> quest in loads) {
      try {
        int ansIndex = int.parse(quest[1]) - 1;
        Question question = new Question(
          Categoryid: category,
          Groupid: group,
          Body: "${quest[0]}",
          Answers: quest.getRange(2, quest.length).toList(),
          Answerindex: ansIndex,
          qtype: 0,
          questionImage:
              "", // sinece i am sure about the correctness of the integer
        );
        questions.add(question);
      } catch (e, a) {
        continue;
      }
    }
    return questions;
  }

  ///    loadXlsxTANINUMS this function loads instruction
  ///    Text  : string
  ///    Answer_Number : int
  ///      ... Images_ Number : string.png
  ///
  ///
  static Future<List<List<dynamic>>> loadXlsxTIA(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;

      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });

      int index = 0;
      bool valid = false;
      if (row.length >= 4) {
        try {
          index = int.tryParse("${row[1]}");
          if (index != null && index > 0 && index <= (row.length - 2)) {
            valid = true;
          }
        } catch (s, e) {
          valid = false;
          index = 0;
        }
      }
      final List<dynamic> newRow = [];
      if (!valid) continue;
      for (var f = 0; f < row.length; f++) {
        if (f == 1)
          newRow.add(index);
        else if (f >= 2) {
          try {
            int no = int.parse("${row[f]}");
            newRow.add("$no.JPG");
          } catch (e, a) {
            newRow.add("${row[f]}");
          }
        } else
          newRow.add("${row[0]}");
      }
      if (newRow.length >= 4 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }

  /* loadTIAQuestions ... 
  List<Question> : questions 
  */
  static Future<List<Question>> loadTIAQuestions(
      String path, String sheetName, int category, int group) async {
    List<List<dynamic>> loads = await ListLoader.loadXlsx(path, sheetName);
    List<Question> questions = [];
    for (List<dynamic> quest in loads) {
      try {
        int ansIndex = int.parse(quest[1]) - 1;
        Question question = new Question(
          Categoryid: category,
          Groupid: group,
          Body: "${quest[0]}",
          Answers: quest.getRange(2, quest.length).toList(),
          Answerindex: ansIndex,
          qtype: 1, //  0000000001
          questionImage: "",
        );
        questions.add(question);
      } catch (e, a) {
        continue;
      }
    }
    return questions;
  }

  ///
  ///------------ Text, Answer_Number , Image_Number , ... Answers
  ///    loadXlsxTANIMANS loader function to load list of list of dynamic
  ///    Text : string
  ///    Ans_number : int
  ///  Image_Number : string.png
  ///... Answers : string
  ///
  static Future<List<List<dynamic>>> loadXlsxITANS(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    ByteData data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    bool validRow =
        false; // this is going to be true if the row has three three or more valid columns
    for (var row in excel.tables[sheetName].rows) {
      int counter = 0;
      List<String> singleRowAsAList = [];
      int ind = 0;
      row.removeWhere((value) {
        if (value == null || "$value" == "" || "$value" == "null") {
          return true;
        }
        return false;
      });
      int index = 0;
      bool valid = false;
      if (row.length > 5) {
        try {
          index = int.tryParse("${row[1]}");
          if (index != null && index > 0 && index <= (row.length - 2)) {
            valid = true;
          }
        } catch (s, e) {
          valid = false;
          index = 0;
        }
      }
      if (!valid) continue;
      final List<dynamic> newRow = [];
      for (var f = 0; f < row.length; f++) {
        if (f == 2)
          newRow.add("${'${row[f]}'.trim()}.JPG");
        else if (f == 1)
          newRow.add(index);
        else
          newRow.add("${row[f]}");
      }
      if (newRow.length >= 4 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }

  /// loadITAQuestions
  /// List<Question> : questions
  ///   text  , ans_number , image_number , ... answers
  ///
  static Future<List<Question>> loadITAQuestions(
      String path, String sheetName, int category, int group) async {
    List<List<dynamic>> loads = await ListLoader.loadXlsx(path, sheetName);
    List<Question> questions = [];
    for (List<dynamic> quest in loads) {
      try {
        int ansIndex = int.parse(quest[1]) - 1;
        Question question = new Question(
          Categoryid: category,
          Groupid: group,
          Body: "${quest[0]}",
          Answers: quest.getRange(3, quest.length).toList(),
          Answerindex: ansIndex,
          qtype: 2,
          questionImage:
              "${quest[2]}.JPG", // sinece i am sure about the correctness of the integer
        );
        questions.add(question);
      } catch (e, a) {
        continue;
      }
    }
    return questions;
  }
}
