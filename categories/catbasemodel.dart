import 'package:billfold/categories/catmodel.dart';

class Catbase{
  List<Category>? categories;
  Catbase({this.categories});
  factory Catbase.fromMap(Map<String, dynamic> json){
      var data=json['categories'];
      return Catbase( categories: (data as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}