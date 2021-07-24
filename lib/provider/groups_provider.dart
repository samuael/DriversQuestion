import 'package:flutter/material.dart';
import '../libs.dart';

/// GroupProvider this class provides the List of groups that are found in the database
/// and  , this list of groups will be shown in the category Page
/// this class is a wrapper class for the SQLite data base class to get the list of
/// groups.
class GroupProvider with ChangeNotifier {
  /// groups a list to hold the groups of the quuestions.
  /// length : 3 0>>motor 1>>others 2 >>Icons.
  List<List<Group>> groups = [[], [], []];
  DatabaseManager dbManager;

  /// fetchGroups fetches the list of groups from the sqlite database using similar method as
  /// the populate method categories and after getting the groups it will populate the categories of
  ///
  Future<void> fetchGroups() async {
    dbManager = DatabaseManager.getInstance();
    this.groups[0] = await dbManager.getGroupsOfCategory(1);
    DatabaseManager.categories[0].groups = this.groups[0];
    //
    this.groups[1] = await dbManager.getGroupsOfCategory(2);
    DatabaseManager.categories[1].groups = this.groups[1];
    //
    this.groups[2] = await dbManager.getGroupsOfCategory(3);
    DatabaseManager.categories[2].groups = this.groups[2];

    //
    notifyListeners();
  }
}
