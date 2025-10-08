class InterBank {
  int? transid;
  String? userid;
  int? Sendacid;
  String? sendbank;
  int? receiveacid;
  String? receivebank;
  num? amount;
  String? date;

  InterBank(
      {this.transid,
      this.userid,
      this.Sendacid,
      this.receiveacid,
      this.amount,
      this.sendbank,
      this.receivebank,this.date});

  factory InterBank.fromJson(Map<String, dynamic> json) {
    return InterBank(
        transid: json['TransID'],
        userid: json['UserID'],
        receiveacid: json['ReceiveAccountID'],
        sendbank: json['SendBankName'],
         receivebank: json['ReciveBankName'],
        Sendacid: json['SendAccountID'],
        amount: json['Amount'],
        date:json['Date']);
  }
}
