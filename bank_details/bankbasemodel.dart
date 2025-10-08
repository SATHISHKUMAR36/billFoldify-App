import 'package:billfold/bank_details/bankmodel.dart';

class Bankbase{
  List<Bank>? banks;
  Bankbase({this.banks});
  factory Bankbase.fromMap(Map<String, dynamic> json){
      var data=json['bankdetails'];
      return Bankbase( banks: (data as List<dynamic>?)
            ?.map((e) => Bank.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}