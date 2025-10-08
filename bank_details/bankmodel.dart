class Bank {
  int? acid;
  String? userid;
  String? bankname;
  String? actype;
  String? acnumber;
  num? acbalance;
  int? ishidden;

  Bank(
      {this.acid,
      this.userid,
      this.bankname,
      this.actype,
      this.acnumber,
      this.acbalance,
      this.ishidden});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        acid: json['AccountID'],
        userid: json['UserID'],
        actype: json['AccountType'],
        bankname: json['BankName'],
        acnumber: json['AccountNumber'],
        acbalance: json['Balance'],
        ishidden: json['Hidden']);
  }
}
