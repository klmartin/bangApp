import 'package:flutter/foundation.dart';
import 'package:bangapp/services/service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _userData = {};
  Map<String, dynamic> get userData => _userData;


  Future<void> fetchUserData() async {
    try {
      final Map<String, dynamic>? existingData = await readUserDataFromFile();
      print(existingData);
      print('this is existing data');
      _userData = await Service().getMyInformation();
      notifyListeners();
      if (existingData == null || !mapEquals(existingData, _userData)) {
        print('naingia ku save data hapa');
        await saveUserDataToFile(userData);
      }
    } catch (e) {
      // Handle errors gracefully, e.g., log the error or show a message to the user.
      print('Error fetching user data: $e');
    }
  }

  Future<void> saveUserDataToFile(Map<String, dynamic> userData) async {
    try {
        final directory = await getExternalStorageDirectory();
        final file = File('${directory!.path}/userData.json');
        await file.writeAsString(json.encode(userData));
        print('Saving data to file');
        print("${file.path}");
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<Map<String, dynamic>> readUserDataFromFile() async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/userData.json');
      print('${file.path}');
      print('This is user data file path');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        print(jsonString);
        print('this is the userData');
        return json.decode(jsonString);
      } else {
        return {};
      }
    } catch (e) {
      print('Error reading user data: $e');
      return {};
    }
  }

  Future<void> clearUserDataFile() async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/userData.json');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error clearing user data file: $e');
    }
  }

  void clearUserData() {
    _userData = {};
    notifyListeners();
  }

  void addFollowerCount(int count) {
    _userData['followerCount'] += count;
    print('set count to $count');
    notifyListeners();
  }

}
