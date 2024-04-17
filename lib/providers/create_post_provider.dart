
import 'package:flutter/material.dart';




class CreatePostProvider extends ChangeNotifier {
  int _pinPost = 0;
  int _bangBattle = 0;
  int get pinPost => _pinPost;
  int get bangBattle => _bangBattle;

  void setPinPost(int value) {
    _pinPost = value;
    notifyListeners();
  }

  void setBangBattle(int value) {
    _pinPost = value;
    notifyListeners();
  }

  int getPinPostValue() {
    return _pinPost;
  }

  int getBangBattle() {
    return _bangBattle;
  }



}
