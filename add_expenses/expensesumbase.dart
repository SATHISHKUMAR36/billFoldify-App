import 'package:billfold/add_expenses/expensesum.dart';

class Expensesumbase{
  List<Expensesum>? expenses;
  List<Expensesum>? incomes;
  Expensesumbase({this.expenses,this.incomes});
  factory Expensesumbase.fromMap(Map<String, dynamic> json){
      var expense=json['expensedetails'];
      var income=json['incomedetails'];
      
      return Expensesumbase( 
        expenses: (expense as List<dynamic>?)
            ?.map((e) => Expensesum.fromJson(e as Map<String, dynamic>))
            .toList(),
            incomes: (income as List<dynamic>?)
            ?.map((e) => Expensesum.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}