import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/services/service.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/models/bang_update.dart';

import '../services/api_cache_helper.dart';

class BangUpdateProfileProvider extends ChangeNotifier {
  bool _isLoading = true;
  final int _numberOfPostsPerRequest = 10;

  List<BangUpdate> _updates = [];
  List<BangUpdate> get updates => _updates;
  bool get  isLoading => _isLoading;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 10,
  );

  Future<void> getMyUpdate() async {
    final post = await apiCacheHelper.getMyUpdate(pageNumber: 1);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUpdates(_pageNumber) async {
    final post = await Service().loadMoreUpdates(_pageNumber);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json)).toList());
    notifyListeners();
  }


  Future<void>  getUserUpdate(userId) async {
    final post = await apiCacheHelper.getUserUpdate(pageNumber: 1, userId: userId);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json) ).toList()) ;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUserUpdates(userId,_pageNumber) async {
    final post = await Service().loadMoreUserUpdates(_pageNumber, userId);
    _updates.addAll(post.map((json) => BangUpdate.fromJson(json) ).toList()) ;
    _isLoading = false;
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
