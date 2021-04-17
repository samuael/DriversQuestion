class Group {
  int ID;
  int GroupNumber;
  int Categoryid;
  int QuestionsCount;
  Group({this.GroupNumber, this.Categoryid, this.QuestionsCount, this.ID});
  Map<String, dynamic> toMap() {
    return {
      "id": this.ID,
      "group_no": this.GroupNumber,
      "categoryid": this.Categoryid,
      "questionscount": this.QuestionsCount,
    };
  }
}
