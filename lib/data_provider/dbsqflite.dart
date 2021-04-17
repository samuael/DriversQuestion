import 'dart:async';
import 'package:drivers_question/libs.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

// Category model Representing the Vehicles Category...
class Category {
  int ID;
  String Name;
  String imageDir;
  List<Group> groups;
  Category({this.ID, this.Name, this.imageDir, this.groups});

  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "name": this.Name,
    };
  }

  // populateGroups a method to populate the Groups From the database and return
  //
  Future<List<Group>> populateGroups(DatabaseManager databaseManager) async {
    databaseManager.getGroupsOfCategory(this.ID).then((groups) {
      this.groups = groups;
      return this.groups;
    });
  }
}

// DatabaseManager  class
class DatabaseManager {
  Database database;

  static DatabaseManager databaseManager;

  static DatabaseManager getInstance() {
    if (DatabaseManager.databaseManager == null) {
      databaseManager = DatabaseManager();
    }
    return databaseManager;
  }

  static final List<Category> categories = [
    Category(
      ID: 1,
      Name: "Motor",
      imageDir: "assets/images/Urban.jpg",
      groups: [],
    ),
    Category(
      ID: 2,
      Name: "Others",
      imageDir: "assets/images/newOne.jpeg",
      groups: [],
    ),
  ];
  // OpenDatabase  method
  Future<void> OpenDatabase() async {
    if (database == null) {
      database = await openDatabase(
          join(
            await getDatabasesPath(),
            // db name
            "drivers.db",
            // Version
          ),
          version: 2, onCreate: (Database database, int version) async {
        await database.execute(
            "CREATE TABLE questions (id INTEGER PRIMARYKEY AUTO INCREMENT NOT NULL ,categoryid INTEGER , groupid INTEGER, body TEXT , imageurl TEXT ,answers TEXT, answerindex INTEGER , imageAnswers BOOLEAN )");
        await database.execute(
            "CREATE TABLE graderesult (id INTEGER PRIMARYKEY AUTO INCREMENT,categoryid INTEGER NOT NULL , groupid INTEGER NOT NULL, askedcount INTEGER  ,answeredcount INTEGER  , askedquestions TEXT )");
        await database.execute(
            "CREATE TABLE groups (  id INTEGER PRIMARYKEY AUTO INCREMENT NOT NULL , group_no INTEGER NOT NULL ,categoryid INTEGER NOT NULL , questionscount INTEGER )");
      });
    }
  }

  Future<Group> GetGroupByID(int groupID) async {
    await OpenDatabase();
    Group group;

    await database
        .query("groups", where: "id=?", whereArgs: [groupID], limit: 1)
        .then((rows) {
      group = Group(
        ID: groupID,
        GroupNumber: rows[0]["group_no"] as int,
        Categoryid: rows[0]["categoryid"] as int,
        QuestionsCount: rows[0]["questionscount"] as int,
      );
    });
    return group;
  }

  // InsertQuestion method for saving questions to the database
  Future<int> InsertQuestions(List<Question> questions) async {
    await OpenDatabase();
    int Counter = 0;
    for (var question in questions) {
      int va = await database.insert('questions', question.toMap());
      if (va == 0) {
      } else {
        Counter++;
      }
    }
    return Counter;
  }

  Future<int> insertAll(List<Question> questions) async {
    await OpenDatabase();
    final batch = database.batch();
    for (var question in questions) {
      batch.insert("questions", question.toMap());
    }
    batch.commit().then((onValue) {
      return onValue.length;
    });
  }

  Future<int> UpdateQuestion(Question question) async {
    await OpenDatabase();
    return await database.update(
      "questions",
      question.toMap(),
      where: "id=?",
      whereArgs: [question.ID],
    );
  }

  Future<int> InsertGroups(List<Group> groups) async {
    await OpenDatabase();
    int Counter = 0;
    for (var group in groups) {
      int va = await database.insert('groups', group.toMap());
      if (va == 0) {
        return -1;
      } else {
        Counter++;
      }
    }
    return Counter;
  }

  Future<List<Group>> getGroupsOfCategory(int category) async {
    await OpenDatabase();
    final List<Group> groups = [];
    final List<Map<String, dynamic>> quests = await database.query(
      "groups",
      columns: [
        "id",
        "categoryid",
        "group_no",
        "questionscount",
      ],
      distinct: true,
      where: "categoryid=?",
      whereArgs: [category],
    );
    // print(quests
    return List.generate(quests.length, (i) {
      // print(
      //     "${quests[i]["id"]}  $category  ${quests[i]["group_no"] as int}  ${quests[i]["questionscount"] as int}");
      return Group(
        Categoryid: category,
        GroupNumber: quests[i]["group_no"] as int,
        QuestionsCount: quests[i]["questionscount"] as int,
        ID: (quests[i]["id"]) as int,
      );
    });
  }

  Future<List<Group>> getAllGroups() async {
    await OpenDatabase();
    final List<Group> groups = [];
    final List<Map<String, dynamic>> quests =
        await database.query("groups", distinct: true);
    return List.generate(quests.length, (i) {
      return Group(
        Categoryid: quests[i]["categoryid"],
        GroupNumber: quests[i]["group_id"] as int,
      );
    });
  }

  Future<Question> getQuestion(int category, int group) async {
    await OpenDatabase();
    Question question;
    GradeResult graderesult = await getGradeResult(group, category);
    if (graderesult == null) {
      graderesult = GradeResult(Categoryid: category, Groupid: group);
    }
    String ids = "";
    if (graderesult.Questions.length > 0) {
      ids = "${graderesult.Questions[0]}";
      int c = 0;
      for (var el in graderesult.Questions) {
        if (c == 0) {
          c++;
          continue;
        }
        ids += ",$el";
      }
    }
    await database
        .rawQuery(
      "SELECT id , answers , body , imageurl , answerindex , categoryid , groupid , imageAnswers FROM questions WHERE id NOT IN ($ids) AND groupid=$group AND categoryid=$category  LIMIT 1",
    )
        .then((rows) {
      if (rows.length > 0) {
        List<String> answers = (rows[0]["answers"] as String).split("`");
        if (answers.length <= 1) {
          return null;
        }
        question = Question(
          ID: (rows[0]["id"]) as int,
          Categoryid: category,
          Groupid: group,
          imageurl: rows[0]["imageurl"],
          Body: rows[0]["body"] as String,
          Answers: answers,
          Answerindex: rows[0]["answerindex"] as int,
          isImageAnswers: (rows[0]["imageAnswers"] as int) == 1,
        );
      }
    });
    return question;
  }

  Future<Question> getQuestionByID(int questionID) async {
    await OpenDatabase();
    // print("The Question IDDD : $questionID");
    Question quest;
    await database
        .query(
      "questions",
      columns: [
        "id",
        "body",
        "imageurl",
        "categoryid",
        "groupid",
        "answerindex",
        "answers",
        "imageAnswers",
      ],
      where: "id = ?",
      whereArgs: [questionID],
      limit: 1,
    )
        .then((question) {
      if (question.length <= 0) {
        return null;
      }
      final answers = (question[0]["answers"] as String).split("`");
      quest = Question(
        Categoryid: question[0]["categoryid"],
        Groupid: question[0]["groupid"],
        Body: question[0]["body"],
        imageurl: question[0]["imageurl"],
        Answers: answers,
        Answerindex: question[0]["answerindex"] as int,
        ID: question[0]["id"] as int,
        isImageAnswers: (question[0]["imageAnswers"] as int) == 1,
      );
      print(quest.toMap());
    });
    return quest;
  }

  // The return value is the index of the Correct value
  Future<int> answerQuestion(
    int questionID,
    answerIndex,
    GradeResult gradeResult,
  ) async {
    Question question;
    if (gradeResult.Questions.contains("$questionID")) {
      return -1;
    }
    await getQuestionByID(questionID).then((qu) {
      question = qu;
    });
    if (question == null) {
      return -2;
    }
    gradeResult.AskedCount++;
    List<String> values = [...gradeResult.Questions, "$questionID"];
    gradeResult.Questions = values;
    if (question.Answerindex == answerIndex) {
      gradeResult.AnsweredCount++;
    }
    int success;
    await UpdateGradeResult(gradeResult).then((succ) {
      success = succ;
    });
    if (success >= 0) {
      return question.Answerindex;
    } else {
      return -3;
    }
  }

  Future<int> InsertGradeResults(List<GradeResult> gradeResults) async {
    int counter = 0;
    await OpenDatabase();
    for (var gres in gradeResults) {
      database.insert("graderesult", gres.toMap()).then((index) {
        if (index > 0) {
          counter++;
        }
      });
    }
    return counter;
  }

  Future<List<GradeResult>> resetAllGradeResults() async {
    await OpenDatabase();
    final mapo = {
      "askedcount": 0,
      "answeredcount": 0,
      "askedquestions": "",
    };
    int counter = 0;
    await database.update("graderesult", mapo).then((affected) {
      counter = affected;
    });

    List<GradeResult> results;
    await GradeResults().then((gresults) {
      results = gresults;
    });
    return results;
  }

  Future<GradeResult> restGradeResultByID(
      int grid, int categoryid, int groupid) async {
    GradeResult tobe = GradeResult(
      ID: grid,
      Categoryid: categoryid,
      Groupid: groupid,
      AnsweredCount: 0,
      AskedCount: 0,
      Questions: List<String>(),
    );
    int changed = 0;
    await UpdateGradeResult(tobe).then((inde) {
      inde = changed;
    });
    if (changed <= 0) {
      // print("Not Succesful nigga ");
    }
    GradeResult gradeResult;
    await OpenDatabase();
    await database
        .query(
      "graderesult",
      where: "id=?",
      whereArgs: [grid],
      limit: 1,
    )
        .then((rows) {
      if (rows.length == null || rows.length <= 0) {
        return;
      }
      final row = rows[0];
      final questionids = (row["askedquestions"] as String).split("`");
      gradeResult = GradeResult(
        Categoryid: row["categoryid"] as int,
        Groupid: row["groupid"] as int,
        AskedCount: row["answeredcount"] as int,
        AnsweredCount: row["askedcount"] as int,
        ID: row["id"] as int,
        Questions: questionids,
      );
    });
    return gradeResult;
  }

  Future<int> UpdateGradeResult(GradeResult gradeResult) async {
    int counter = 0;
    await OpenDatabase();
    database.update(
      "graderesult",
      gradeResult.toMap(),
      where: "id=?",
      whereArgs: [gradeResult.ID],
    ).then((index) {
      if (index > 0) {
        counter = index;
      }
    });
    return counter;
  }

  Future<List<GradeResult>> GradeResults() async {
    List<GradeResult> gradeResults = [];
    await OpenDatabase();
    await database
        .query(
      "graderesult",
    )
        .then((rows) {
      for (var row in rows) {
        final questionIDs = (row["askedquestions"] as String).split("`");
        GradeResult gradeResult = GradeResult(
          ID: row["id"] as int,
          Categoryid: row["categoryid"] as int,
          Groupid: row["groupid"] as int,
          AnsweredCount: row["answeredcount"] as int,
          AskedCount: row["askedcount"] as int,
          Questions: questionIDs,
        );
        gradeResults.add(gradeResult);
      }
    });
    return gradeResults;
  }

  Future<GradeResult> getGradeResult(int groupid, int categoryid) async {
    await OpenDatabase();
    // save the grade and asked question to the database abnd return the grade result
    GradeResult graderResult = GradeResult();
    await database.query("graderesult",
        where: "categoryid=? and groupid=?",
        whereArgs: [categoryid, groupid]).then((value) {
      if (value.length > 0) {
        final questionsID = (value[0]["askedquestions"] as String != null
                ? value[0]["askedquestions"] as String
                : "")
            .split("`");
        graderResult.Categoryid = value[0]["categoryid"] as int;
        graderResult.AnsweredCount = value[0]["answeredcount"] as int;
        graderResult.Groupid = value[0]["groupid"];
        graderResult.AskedCount = value[0]["askedcount"] as int;
        graderResult.Questions = questionsID;
        graderResult.ID = value[0]["id"] as int;
      } else {
        graderResult = GradeResult(
          Categoryid: categoryid,
          Groupid: groupid,
          AskedCount: 0,
          AnsweredCount: 0,
          Questions: List<String>(),
        );
      }
    });
    if (graderResult.ID == null) {
      int count = Sqflite.firstIntValue(
          await database.rawQuery('SELECT COUNT(*) FROM graderesult'));
      graderResult.ID = count;
      await saveGradeResult(graderResult);
    }
    return graderResult;
  }

  Future<bool> saveGradeResult(GradeResult result) async {
    await OpenDatabase();
    int va = await database.insert('graderesult', result.toMap());
    if (va == 0) {
      return false;
    }
    return true;
  }

  Future<bool> resetResult() async {
    await OpenDatabase();
    final val = await database.delete("graderesult");
    if (val > 0) {
      return true;
    }
    return false;
  }
}
