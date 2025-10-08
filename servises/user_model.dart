class UserAPIDetails{
String? userid;
String? name;
String? email;
String? currency;
String? language;
int? notificaton;
int?facelogin;
int?logout;
String?familylogin;

UserAPIDetails({this.userid,this.email,this.name,this.currency,this.language,this.notificaton,this.facelogin,this.logout,this.familylogin});

factory UserAPIDetails.fromJson(Map<String,dynamic> json){
  return UserAPIDetails(
    userid:json['UserID'],
      email:json['Email'],
    name:json['Name'],
  
    currency: json['Currency'],
    language:json['Language'],
    notificaton:json['Notification'],
    facelogin: json['FaceFingerLogin'],
    logout:json['UserLogout'],
    familylogin:json['FamilyLogin'],

  );
}

Map<String,dynamic> toJson(){
  return{
    'userid':userid,
    'email':email,
    'name':name,
    
    'currency':currency,
    'language':language,
    'notification':notificaton,
    'facelogin':facelogin,
    'logout':logout,
    'familylogin':familylogin
  };
}
}