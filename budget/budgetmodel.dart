class Budget {
  int? budgetid;
  String? userid;
  int? catid;
  int? subcatid;
  String? startdate;
  String? enddate;
  String? frequency;
  double? budgetamt;
  double? threshold;
  String? catname;
  String? subcatname;

  Budget(
      {this.budgetid,
      this.userid,
      this.catid,
      this.subcatid,
      this.startdate,
      this.enddate,
      this.frequency,
      this.budgetamt,
      this.threshold,
      this.catname,
      this.subcatname});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      budgetid: json['BudgetID'],
      userid: json['UserID'],
      catid: json['CategoryID'],
      subcatid: json['SubcategoryID'],
      budgetamt: json['BudgetAmount'],
      startdate: json['StartDate'],
      enddate: json['EndDate'],
      frequency: json['Frequency'],
      threshold: json['AlertThreshold'],
      catname: json['CategoryName'],
      subcatname: json['SubcategoryName'],
    );
  }
}
