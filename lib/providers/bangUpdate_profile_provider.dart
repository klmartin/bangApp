import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/models/bang_update.dart';

import '../services/api_cache_helper.dart';

class BangUpdateProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;

  List<BangUpdate> _updates = [];
  List<BangUpdate> get updates => _updates;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 10,
  );

  Future<void> getMyUpdate() async {
    final post = await apiCacheHelper.getMyUpdate(pageNumber: _pageNumber);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList());
    _pageNumber++;
    notifyListeners();
  }

  Future<void>  getUserUpdate(userId) async {
    final post = await apiCacheHelper.getUserUpdate(pageNumber: _pageNumber, userId: userId);
    print(post);
    print('this is post');
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json) ).toList()) ;
    _pageNumber++;
    notifyListeners();
  }
}
