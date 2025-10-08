

import 'package:billfold/categories/incomecatmodel.dart';

class Incomecatbase{
  List<IncomeCategory>? categories;
  Incomecatbase({this.categories});
  factory Incomecatbase.fromMap(Map<String, dynamic> json){
      var data=json['categories'];
      return Incomecatbase( categories: (data as List<dynamic>?)
            ?.map((e) => IncomeCategory.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}