class IncomeCategory {
  int? categoryid;
  String? userid;
  String? categoryname;
  String? description;
 

  IncomeCategory({
    this.categoryid,
    this.userid,
    this.categoryname,
    this.description,
    
  });

  factory IncomeCategory.fromJson(Map<String, dynamic> json) {
    return IncomeCategory(
      categoryid: json['CategoryID'],
      userid: json['UserID'],
      categoryname: json['CategoryName'],
      description: json['Description']
    );
  }
}
