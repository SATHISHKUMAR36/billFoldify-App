
import 'package:billfold/add_expenses/expensemodel.dart';

class Expensebase{
  List<Expense>? expenses;
  Expensebase({this.expenses});
  factory Expensebase.fromMap(Map<String, dynamic> json){
      var data=json['expensedetails'];
      return Expensebase( expenses: (data as List<dynamic>?)
            ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}