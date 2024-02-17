class UserModel {
  final String? name;
  final String? profileurl;
  final int? id;


  UserModel({
    this.profileurl,
    this.id,

    this.name,
  });
  factory UserModel.fromJson(Map<dynamic,dynamic> json){
    return UserModel(
      id: json["user_id"] != null ? json["user_id"] : "",
      profileurl:json["user_image"] !=null ?json["user_image"]:"",
      name:json["name"] !=null ?json["name"]:"",
    );
  }
  Map<dynamic ,dynamic> toJson()=>
  {
  "user_id": id,
  "user_image": profileurl,
  "name": name
  };
}

class UserModelRegister {
  final String name;
  final String image;
  final int id;
  final String email;


  UserModelRegister({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
  });
  factory UserModelRegister.fromJson(Map<dynamic,dynamic> json){
    return UserModelRegister(
      id: json["id"] != null ? json["id"] : "",
      image:json["image"] !=null ?json["image"]:"",
      name:json["name"] !=null ?json["name"]:"",
      email:json["email"] !=null ? json["name"]:""
    );
  }
  Map<dynamic ,dynamic> toJson()=>
      {
        "id": id,
        "token": image,
        "name": name,
        "email":email,
      };
}
