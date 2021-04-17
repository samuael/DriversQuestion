import 'package:drivers_question/libs.dart';
import 'package:flutter/foundation.dart';

class GroupsState with ChangeNotifier {
  List<Group> groups;

  List<Group> createGroups(List<Group> groups) {
    this.groups = groups;
    notifyListeners();
  } 
}
