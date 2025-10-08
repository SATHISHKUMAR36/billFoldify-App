class Getinvoice{
  int? transactionid;
  String? userid;
  String? transactiontype;
  num? amt;
  String? description;
  String? date;
  int? catid;
  int? subcatid;
  int? acid;
  String? merchant;
  String? location;
  String? currency;
  num? exchangerate;
  String? receptpath;
  String? note;
  String? catname;
  String? subcatname;
  String? bankname;
  String? address;
  String? item_name;

  Getinvoice({
  this.transactionid,
    this.userid,   
    this.transactiontype,
    this.amt,
    this.description,
    this.date,
    this.catid,
    this.subcatid,
    this.acid,
    this.merchant,
    this.location,
    this.currency,
    this.exchangerate,
    this.receptpath,
    this.note,
    this.catname,
    this.subcatname,
    this.bankname,
    this.address,
    this.item_name
    
});
 factory Getinvoice.fromJson(Map<String, dynamic> json){



        return Getinvoice(
          transactionid: json['TransactionID'],
          userid: json['UserID'],
          transactiontype: json['TransactionType'],
          amt: json['Amount'],
          description: json['Description'],
          date: json['Date'],
          catid: json['CategoryID'],
          subcatid: json['SubcategoryID'],
          acid: json['AccountID'],
          merchant: json['Merchant'],
          location: json['Location'],
          currency: json['Currency'],
          exchangerate: json['ExchangeRate'],
          receptpath: json['ReceiptPath'],
          note: json['Note'],
          catname: json['CategoryName'],
          subcatname: json['SubcategoryName'],
          bankname: json["BankName"],   
          address: json['address'],
          item_name: json['item_name']
        );
      }



}