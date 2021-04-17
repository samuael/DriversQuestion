import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class XlsxLoader {
  static ByteData data;
  static Future<List<List<dynamic>>> LoadXlsxIndexed(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    if (XlsxLoader.data == null) {
      data = await rootBundle.load(path);
    }
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
      if (row.length > 4) {
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

  // LoadXlsxImageContaining ...
  static Future<List<List<dynamic>>> LoadXlsxImageContaining(
      String path, String sheetName) async {
    List<List<String>> mainList = [];
    if (XlsxLoader.data == null) {
      data = await rootBundle.load(path);
    }
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
          if (index != null && index > 0 && index <= (row.length - 3)) {
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
      // image containing row has to have at least 5 element or column cells
      // 0 - Question body  , 1 - Imageurl  , 2-answer Index  , > 3  : answers
      if (newRow.length >= 5 && valid) {
        mainList.add(newRow);
      }
    }
    return mainList;
  }
}
