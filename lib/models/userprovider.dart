import 'package:flutter/cupertino.dart';
import 'package:bangapp/models/user_model.dart';

class UserProvider extends ChangeNotifier{
  UserModel _user =UserModel(


  );
  UserModel get myUser => _user;
  void setUser(Map<dynamic,dynamic> user){
    _user=UserModel.fromJson(user);
  }
}