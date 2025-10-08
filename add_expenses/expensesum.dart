class Expensesum {
  String? date;
  DateTime? datetimedata;
  num? amt;
  String? transactiontype;

  Expensesum({
    this.transactiontype,
    this.amt,
    this.datetimedata,
    this.date,
  });
  factory Expensesum.fromJson(Map<String, dynamic> json) {
    return Expensesum(
      datetimedata: DateTime.parse(json['Date']+'01'),
      // DATE_FORMAT(date, '%Y-%m') 
      date: json['Date'],
      transactiontype: json['TransactionType'],
      amt: json['Amount'],
    );
  }
}
