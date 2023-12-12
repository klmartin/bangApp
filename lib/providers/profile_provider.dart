import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/image_post.dart';
import '../services/api_cache_helper.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  late String myImage = profileUrl;
  late int myPostCount= 0;
  late int myFollowerCount= 0;
  late int myFollowingCount= 0;
  late String description= "";
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  List<ImagePost> _posts = [];
  List<ImagePost> get posts => _posts;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 10,
  );

  Future<void> getMyPosts() async {
    List<dynamic> data = await apiCacheHelper.getMyPosts(pageNumber: _pageNumber);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _pageNumber++;
    notifyListeners();
  }

  Future<void> getUserPost(userId) async {
    List<dynamic> data =  await apiCacheHelper.getUserPost(pageNumber: _pageNumber, userId: userId);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _pageNumber++;
    notifyListeners();

  }

  void increaseLikes(int postId) {
    final post = _posts?.firstWhere((update) => update.postId == postId);
    if (post!.isLikedA) {
      post?.likeCountA--;
      post!.isLikedA = false;
    } else {
      post!.likeCountA++;
      post.isLikedA = true;
    }
    notifyListeners();
  }


}
