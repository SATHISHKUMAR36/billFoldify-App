import 'package:billfold/budget/budgetsummodel.dart';

class BudgetSumbase{
  List<BudgetSum>? budget;
  BudgetSumbase({this.budget});
  factory BudgetSumbase.fromMap(Map<String, dynamic> json){
      var data=json['budgetview'];
      return BudgetSumbase( budget: (data as List<dynamic>?)
            ?.map((e) => BudgetSum.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}