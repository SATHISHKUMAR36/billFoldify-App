class RecurringPayments {
  int? recurringid;
  String? userid;
  num? amount;
  int? acid;
  int? catid;
  int? subcatid;
  String? frequency;
  String? startdate;
  String? enddate;
  String? nextoccurance;
  String? status;
  String? note;
  String? bankname;
  String? catname;
  String? subcatname;
  String? transactiontype;

  RecurringPayments(
      {this.recurringid,
      this.userid,
      this.acid,
      this.amount,
      this.catid,
      this.enddate,
      this.frequency,
      this.nextoccurance,
      this.note,
      this.startdate,
      this.status,
      this.subcatid,
      this.bankname,
      this.catname,
      this.subcatname,
      this.transactiontype});
  factory RecurringPayments.fromJson(Map<String, dynamic> json) {
    return RecurringPayments(
      recurringid: json['RecurringID'],
      userid: json['UserID'],
      amount: json['Amount'],
      acid: json['AccountID'],
      catid: json['CategoryID'],
      subcatid: json['SubCategoryID'],
      frequency: json['Frequency'],
      startdate: json['StartDate'],
      enddate: json['EndDate'],
      nextoccurance: json['NextOccurance'],
      status: json['Status'],
      note: json['Note'],
      bankname: json['BankName'],
      catname: json['CategoryName'],
      subcatname: json['SubcategoryName'],
      transactiontype: json['TransactionType']
    );
  }
}
