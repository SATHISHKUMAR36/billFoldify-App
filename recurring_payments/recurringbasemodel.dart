import 'package:billfold/recurring_payments/recurringmodel.dart';

class Recurringbase{
  List<RecurringPayments>? recurringpayments;
  Recurringbase({this.recurringpayments});
  factory Recurringbase.fromMap(Map<String, dynamic> json){
      var data=json['recurringpayments'];
      return Recurringbase( recurringpayments: (data as List<dynamic>?)
            ?.map((e) => RecurringPayments.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}