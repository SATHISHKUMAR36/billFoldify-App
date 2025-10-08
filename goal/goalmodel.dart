class Goal {
  // String? image;
  int? goalid;
  String? userid;
  String? goalname;
  num? targetamt;
  num? currentamt;
  num? dueamt;
  String? startdate;
  String? duedate;
  String? description;
  Goal({
    this.goalid,
    this.userid,
    this.goalname,
    this.targetamt,
    this.currentamt,
    this.startdate,
    this.duedate,
    this.description,
    this.dueamt,
  });
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalid: json['GoalID'],
      userid: json['UserID'],
      goalname: json['GoalName'],
      targetamt: json['TargetAmount'],
      currentamt: json['CurrentAmount'],
      dueamt: json['DueAmount'],
      startdate: json['StartDate'],
      duedate: json['DueDate'],
      description: json['Description']
    );
  }
}
