import 'package:billfold/add_expenses/bankstatement/bankstatementmodel.dart';

class BankStatementbase{
  List<BankStatement>? BankStatements;
  BankStatementbase({this.BankStatements});
  factory BankStatementbase.fromMap(Map<String, dynamic> json){
      var data=json['extracted_data'];
      return BankStatementbase( BankStatements: (data as List<dynamic>?)
            ?.map((e) => BankStatement.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}