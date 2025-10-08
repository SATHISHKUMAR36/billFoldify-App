

import 'package:billfold/add_expenses/Invoicedata/getinvoicemodel.dart';

class Invoicebase{
  List<Getinvoice>? expenses;
  Invoicebase({this.expenses});
  factory Invoicebase.fromMap(Map<String, dynamic> json){
      var data=json['invoicedetails'];
      return Invoicebase( expenses: (data as List<dynamic>?)
            ?.map((e) => Getinvoice.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}