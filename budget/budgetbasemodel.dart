
import 'package:billfold/budget/budgetmodel.dart';

class Budgetbase{
  List<Budget>? budget;
  Budgetbase({this.budget});
  factory Budgetbase.fromMap(Map<String, dynamic> json){
      var data=json['budgetdetails'];
      return Budgetbase( budget: (data as List<dynamic>?)
            ?.map((e) => Budget.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}