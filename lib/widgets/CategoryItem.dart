import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../libs.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final String lang;

  const CategoryItem({
    Key key,
    this.category,
    this.lang,
  }) : super(key: key);

  // this is showing that the data in the Clicked Category Will Be Saved and
  // the Page Will Route you to the Question Page
  void goToQuestions(int groupID, int categoryID, BuildContext context) {
    final userdata = UserData.getInstance();
    userdata.SetCategory(categoryID);
    userdata.SetGroup(groupID);

    userdata.initialize();
    Group group;
    //here filling the categoiry with the groups which are found in the provider.
    for (var grp in category.groups) {
      if (grp.ID == groupID) {
        group = grp;
      }
    }
    if (group == null) {
      return;
    }
    Provider.of<ActiveQuestionInfo>(context, listen: false)
        .setQuestionsInfo(category, group);
    Navigator.of(context).pushNamedAndRemoveUntil(
      QuestionScreen.RouteName,
      (context) {
        return false;
      },
      arguments: {
        "category": this.category,
        "lang": this.lang,
        "userdata": userdata,
        "group": group,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          // height: 200,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          (Translation.translate(this.lang, "The") != null
                                  ? Translation.translate(this.lang, "The")
                                  : "The") +
                              " " +
                              (Translation.translate(lang, category.Name) !=
                                      null
                                  ? Translation.translate(lang, category.Name)
                                  : category.Name) +
                              " " +
                              (category.ID == 1
                                  ? (Translation.translate(
                                              this.lang, "Cycle") !=
                                          null
                                      ? Translation.translate(
                                          this.lang, "Cycle")
                                      : "Cycle")
                                  : (Translation.translate(
                                              this.lang, "Vehicles") !=
                                          null
                                      ? Translation.translate(
                                          this.lang, "Vehicles")
                                      : "Vehicles")) +
                              " " +
                              (Translation.translate(this.lang, "Questions") !=
                                      null
                                  ? Translation.translate(
                                      this.lang, "Questions")
                                  : "Questions"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontFamily: FontFamily.Apple_Symbols.toString(),
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //
                  // The List Of Groups Are To Be Listed below here
                  //
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Column(
                      children: context
                                  .watch<GroupProvider>()
                                  .groups[this.category.ID - 1]
                                  .length >
                              0
                          ? (context
                              .watch<GroupProvider>()
                              .groups[this.category.ID - 1]
                              .map((Group group) {
                              print(
                                  "The Category ID is : ${this.category.ID - 1}");
                              return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      goToQuestions(
                                        group.ID,
                                        group.Categoryid,
                                        context,
                                      );
                                    },
                                    key: UniqueKey(),
                                    leading: Icon(
                                      Icons.group_work,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      (Translation.translate(
                                                      lang, "Test Number ") !=
                                                  null
                                              ? Translation.translate(
                                                  lang, "Test Number ")
                                              : "Test Number ") +
                                          " : " +
                                          "${group.GroupNumber}",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${group.QuestionsCount} ${Translation.translate(lang, " Questions ") != null ? Translation.translate(lang, " Questions ") : " Questions "}",
                                      // +
                                      //             Translation.translate(
                                      //                 lang, " Questions "
                                      //                 ) != null
                                      //     ? Translation.translate(lang, " Questions " , )
                                      //     : " Questions ").toUpperCase(),

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      child: Text(
                                        "${group.GroupNumber}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ));
                            }).toList())
                          : [
                              Center(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: CircularProgressIndicator()))
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
