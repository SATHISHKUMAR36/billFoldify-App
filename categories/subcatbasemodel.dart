
import 'package:billfold/categories/subcatmodel.dart';

class Subcatbase{
  List<Subcategory>? subcategories;
  Subcatbase({this.subcategories});
  factory Subcatbase.fromMap(Map<String, dynamic> json){
      var data=json['subcategories'];
      return Subcatbase( subcategories: (data as List<dynamic>?)
            ?.map((e) => Subcategory.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}