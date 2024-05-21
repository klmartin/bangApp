import 'package:flutter/foundation.dart';
import 'package:bangapp/services/service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileDataProvider extends ChangeNotifier {
  Map<String, dynamic> _userData = {};
  String _userFriendStatus = "Add Friend";
  get userFriendStatus => _userFriendStatus;
  Map<String, dynamic> get userData => _userData;

  void getUserInfo(userId) async {
    if(userId != _userData['id']){
      _userData.clear();
      notifyListeners();
      _userData = await Service().getMyInformation(userId: userId);
      print('this is userData');
      print(_userData);
      notifyListeners();
    }
  }

  void setUserRequestStatus(status)
  {
    _userData['isFriendRequest'] = status;
    if(status == true){
      _userFriendStatus = "Cancel";
      notifyListeners();
    }
    else{
      _userFriendStatus = "Add Friend";
      notifyListeners();
    }
  }

  void clearUserData() {
    _userData = {};
    notifyListeners();
  }




}
