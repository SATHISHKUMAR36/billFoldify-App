import 'package:billfold/add_family/familymodel.dart';

class Familybase{
  List<Family>? Familes;
  Familybase({this.Familes});
  factory Familybase.fromMap(Map<String, dynamic> json){
      var data=json['familydetails'];
      return Familybase( Familes: (data as List<dynamic>?)
            ?.map((e) => Family.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}