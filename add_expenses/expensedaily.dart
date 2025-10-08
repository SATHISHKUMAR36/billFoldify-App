class Expensedaily {
  String? date;
  num? amt;
  String? transactiontype;

  Expensedaily({
    this.transactiontype,
    this.amt,
    this.date,
  });
  factory Expensedaily.fromJson(Map<String, dynamic> json) {
    return Expensedaily(
      date: json['Date'],
      transactiontype: json['TransactionType'],
      amt: json['Amount'],
    );
  }
}
