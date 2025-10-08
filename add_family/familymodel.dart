class Family {
  int? memberid;
  String? userid;
  String? familyid;
  String? name;
  String? relationship;
  String? gender;
  String? actype;
  num? yob;
  String? familyname;

  Family(
      {this.memberid,
      this.userid,
      this.name,
      this.relationship,
      this.gender,
      this.actype,
      this.familyid,
      this.yob,
      this.familyname
    });
  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
        memberid: json['MemberID'],
        userid: json['UserID'],
        familyid: json['FamilyID'],
        name: json['Name'],
        actype: json['AccountType'],
        gender: json['Gender'],
        yob:json['YearOfBirth'],
        relationship: json['Relationship'],
        familyname:json["FamilyName"]
        )
        ;
  }
}
