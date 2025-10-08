class Category {
  int? categoryid;
  String? userid;
  String? categoryname;
  String? description;
 

  Category({
    this.categoryid,
    this.userid,
    this.categoryname,
    this.description,
    
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryid: json['CategoryID'],
      userid: json['UserID'],
      categoryname: json['CategoryName'],
      description: json['Description']
    );
  }
}
