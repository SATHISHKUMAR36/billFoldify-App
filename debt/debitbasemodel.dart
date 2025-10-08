import 'package:billfold/debt/debt_model.dart';

class DebtBaseModel {
  final List<Debt>? iowe;
  final List<Debt>? oweme;


  DebtBaseModel({ this.iowe,this.oweme});

  factory DebtBaseModel.fromMap(Map<String, dynamic> json) {
   var data=json['debts'];
    return DebtBaseModel(
        iowe: (data["i_owe"] as List<dynamic>?)
            ?.map((e) => Debt.fromJson(e as Map<String, dynamic>))
            .toList(),
        oweme : (data["owe_me"] as List<dynamic>?)
            ?.map((e) => Debt.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}