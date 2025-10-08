import 'package:billfold/add_expenses/expensedaily.dart';

class Expensedailybase{
  List<Expensedaily>? expenses;
  List<Expensedaily>? incomes;
  Expensedailybase({this.expenses,this.incomes});
  factory Expensedailybase.fromMap(Map<String, dynamic> json){
      var expense=json['expensedetails'];
      var income=json['incomedetails'];
      
      return Expensedailybase( 
        expenses: (expense as List<dynamic>?)
            ?.map((e) => Expensedaily.fromJson(e as Map<String, dynamic>))
            .toList(),
            incomes: (income as List<dynamic>?)
            ?.map((e) => Expensedaily.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}