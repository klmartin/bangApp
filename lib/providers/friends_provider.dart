import 'dart:developer';
import 'package:bangapp/services/service.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/friend.dart';


class FriendProvider with ChangeNotifier {
  bool _loading = false;
  bool get isLoading => _loading;
  List<Friend> _friends = [];
  List<Friend> _allFriends = [];
  List<Friend> get allFriends => _allFriends;
  List<Friend> get friends => _friends;
  List _contacts = [];
  String _requestMessage = "";
  String get requestMessage => _requestMessage;
  bool _addingFriend = false;
  bool get addingFriend => _addingFriend;

  Future<void> getSuggestedFriends() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      _loading = true;
      notifyListeners();
      List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      for (var contact in contacts) {
        for (var phone in contact.phones!) {
          _contacts.add(phone.value);
          notifyListeners();
        }
      }
      List<Map<String, dynamic>> responseList = await Service().getSuggestedFriends(_contacts);
      print(responseList);
      _friends = responseList.map((friendData) => Friend(
        userId: friendData['id'],
        name: friendData['name'],
        image: friendData['user_image_url'],
        isFriend: false, // Initialize isFriend to false
      )).toList();
      _loading = false;
      notifyListeners();
      print(friends);
      print('_friends');
    } else {

    }

  }

  Future<void> requestFriendship(friendId) async {
    markFriend(friendId);
    _requestMessage = await Service().requestFriendship(friendId);
    print(_requestMessage);
    print('_requestMessage');
    if(_requestMessage == "Friend added successfully"){
      _addingFriend = true;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<String> acceptFriendship(friendId) async {
    _requestMessage = await Service().acceptFriendship(friendId);
    return _requestMessage;
  }

  Future<String> declineFriendship(friendId) async {
    _requestMessage = await Service().declineFriendShip(friendId);
    return _requestMessage;
  }

  Future<void> getFriends({userId}) async {
    _loading = true;
    _allFriends.clear();
    notifyListeners();
    List<Map<String, dynamic>> responseList;

    if (userId != null) {
      responseList = await Service().getFriends(userId: userId);
    } else {
      responseList = await Service().getFriends();
    }
    _allFriends = responseList.map((friendData) => Friend(
      userId: friendData['id'],
      name: friendData['name'],
      image: friendData['user_image_url'],
      isFriend: false, // Initialize isFriend to false
    )).toList();
    _loading = false;
    notifyListeners();
  }



  void markFriend(int postId) {
    try {
      final post = _friends.firstWhere((update) => update.userId == postId);
      post.isFriend = !post.isFriend!;
      notifyListeners();
    } catch (e) {}
  }

}
