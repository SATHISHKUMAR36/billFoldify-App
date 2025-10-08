
import 'package:billfold/bank_details/interbankmodel.dart';

class Interbankbase{
  List<InterBank>? banks;
  Interbankbase({this.banks});
  factory Interbankbase.fromMap(Map<String, dynamic> json){
      var data=json['interbankdetails'];
      return Interbankbase( banks: (data as List<dynamic>?)
            ?.map((e) => InterBank.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}