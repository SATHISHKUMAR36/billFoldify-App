class Subcategory {
  int? categoryid;
  int? subcategoryid;
  String? userid;
  String? subcategoryname;
  String? description;
 

  Subcategory({
    this.categoryid,
    this.subcategoryid,
    this.userid,
    this.subcategoryname,
    this.description,
    
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      categoryid: json['CategoryID'],
      subcategoryid:json['SubcategoryID'] ,
      userid: json['UserID'],
      subcategoryname: json['SubcategoryName'],
      description: json['Description']
    );
  }
}
