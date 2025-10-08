import 'package:billfold/goal/goalmodel.dart';

class Goalbase{
  List<Goal>? goals;
  Goalbase({this.goals});
  factory Goalbase.fromMap(Map<String, dynamic> json){
      var data=json['goaldetails'];
      return Goalbase( goals: (data as List<dynamic>?)
            ?.map((e) => Goal.fromJson(e as Map<String, dynamic>))
            .toList(),);
  }
}