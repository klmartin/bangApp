class UserModel {
  final String name;
  final String profileurl;
  final int id;
  // final int followers;
  // final int following;
  // final int posts;

  UserModel({
      this.profileurl,
     this.id,
    // this.followers,
    // this.following,
    // this.posts,
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
// {
// // "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4xMDAuMTAzL3NvY2lhbC1iYWNrZW5kLWxhcmF2ZWwvYXBpL2xvZ2luIiwiaWF0IjoxNjgyMDc1MTA0LCJleHAiOjE2ODIwNzg3MDQsIm5iZiI6MTY4MjA3NTEwNCwianRpIjoiZ1Q3T3RsdGZKR09BUXV6cyIsInN1YiI6IjEiLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.p3wbpgDkNSwxizo6ZX1YZJBQyHqCECC7yc6e9jsQGzM",
// // "user_id": 1,
// // "user_image": "http://192.168.100.103/social-backend-laravel/storage/app/images/M1HA0tKisKZkhuNLFdSDpUwgvVO7zQvvCSDzqran.jpg",
// // "name": "mohammed"