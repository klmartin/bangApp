import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/models/bang_update.dart';

class BangUpdateProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;

  List<BangUpdate> _updates = [];
  List<BangUpdate> get updates => _updates;


  Future<void>  getMyUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse('$baseUrl/user-bang-updates?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId'));
    print(response.body);
    print('this is data from api');
    var data = json.decode(response.body);
    final List<dynamic> post = data;
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList()) ;
    _pageNumber++;
    notifyListeners();


  }

  Future<void>  getUserUpdate(userId) async {

    var response = await http.get(Uri.parse('$baseUrl/user-bang-updates?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId'));
    print(response.body);
    print('this is data from api');
    var data = json.decode(response.body);
    final List<dynamic> post = data;
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList()) ;
    _pageNumber++;
    notifyListeners();


  }
}
