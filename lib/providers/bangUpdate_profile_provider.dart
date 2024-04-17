import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/models/bang_update.dart';

import '../services/api_cache_helper.dart';

class BangUpdateProfileProvider extends ChangeNotifier {
  bool _isLoading = true;
  final int _numberOfPostsPerRequest = 10;
  int _pageNumber = 1;

  List<BangUpdate> _updates = [];
  List<BangUpdate> get updates => _updates;
  bool get  isLoading => _isLoading;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 10,
  );

  Future<void> getMyUpdate() async {
    final post = await apiCacheHelper.getMyUpdate(pageNumber: _pageNumber);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList());
    _isLoading = false;
    _pageNumber++;
    notifyListeners();
  }

  Future<void>  getUserUpdate(userId) async {
    final post = await apiCacheHelper.getUserUpdate(pageNumber: _pageNumber, userId: userId);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json) ).toList()) ;
    _isLoading = false;
    _pageNumber++;
    notifyListeners();
  }

  void increaseLikes(int postId) {
    final post = _updates.firstWhere((update) => update.postId == postId);
    if (post.isLiked) {
      post.likeCount--;
      post.isLiked = false;
    } else {
      post.likeCount++;
      post.isLiked = true;
    }
    notifyListeners();
  }

}
