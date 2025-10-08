class BudgetSum {
  int? catid;
  int? subcatid;
  double? budgetamt;
  double? amt;

  BudgetSum({this.catid, this.subcatid, this.budgetamt, this.amt});

  factory BudgetSum.fromJson(Map<String, dynamic> json) {
    return BudgetSum(
      catid: json['CategoryID'],
      subcatid: json['SubcategoryID'],
      budgetamt: json['BudgetAmount'],
      amt: json['Amount'],
    );
  }
}
