class Invoice{
  bool? invoice_data;
  String? location;
  num? amt;
  String? date;
  String? category;
  String? subcategory;
  List<dynamic>? items;

  Invoice({
    this.invoice_data,
    this.location,   
    this.amt,
    this.date,
    this.category,
    this.subcategory,
    this.items,
    
});
 factory Invoice.fromJson(Map<String, dynamic> json){



        return Invoice(
          invoice_data: json['invoice_data'],
          location: json['address'],
          amt: json['total_amount_spent'],
          date: json['date'],
          category: json['category'],
          subcategory: json['sub_category'],
          items: json['items']
        );
      }

Map<String,dynamic> tojon (){
return{
"invoice_data":this.invoice_data,
"address":this.location,
"total_amount_spent":this.amt,
"date":this.date,
"category":this.category,
"subcategory":this.subcategory,
"items":this.items
};}

}