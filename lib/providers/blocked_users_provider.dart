import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';

class BlockedUsersProvider extends ChangeNotifier {
  bool _loading = false;
  bool _unblocking = false;
  bool _blocking = false;
  bool _showingFewer = false;
  List<dynamic> _blockedUsers = [];
  List<dynamic>  get blockedUsers => _blockedUsers;

  bool get loading => _loading;
  bool get unblocking => _unblocking;
  bool get blocking => _blocking;
  bool get showingFewer => _showingFewer;

  Future<void> fetchBlockedUsers() async {
    _loading = true;
    notifyListeners();
    _blockedUsers = await Service().getBlockedUsers();
    print(_blockedUsers);
    print("blocked users");
    _loading = false;
    notifyListeners();
  }

  Future<String> unblockUserByID(int userId) async {
    _unblocking = true;
    notifyListeners();
    var message = await Service().unblockUser(userId);
    if(message == "User Unblocked Successfully"){
      _blockedUsers.removeWhere((blockedUser) => blockedUser['user_blocked_id'] == userId);
    }
    _unblocking = false;
    notifyListeners();
    return message;
  }

  Future<String> showFewerPost(imagePostId,imageUserId) async
  {
    _showingFewer = true;
    notifyListeners();
    var message = await Service().showFewerPost(imagePostId, imageUserId);
    _showingFewer = false;
    notifyListeners();
    return message;
  }

  Future<String>blockUser(imageUserId) async
  {
    _blocking = true;
    notifyListeners();
    var message = await Service().blockUser(imageUserId);
    _blocking = false;
    notifyListeners();
    return message;
  }







}
