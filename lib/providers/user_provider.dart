import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';


class UserProvider extends ChangeNotifier {
  Map<String, dynamic> userData = {};

  Future<void> fetchUserData() async {
    userData = await Service().getMyInformation();

    notifyListeners();
  }
}
