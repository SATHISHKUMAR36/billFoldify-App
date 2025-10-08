import 'package:billfold/add_family/Familyviewmodel.dart';

class Familyviewbase{
  List<Familyview>? Familes;
  Familyviewbase({this.Familes});
  factory Familyviewbase.fromMap(Map<String, dynamic> json){
      var data=json['familydetails'];
      return Familyviewbase( Familes: (data as List<dynamic>?)
            ?.map((e) => Familyview.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}