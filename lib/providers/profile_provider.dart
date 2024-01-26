import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import '../models/image_post.dart';
import '../services/api_cache_helper.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = true;
  late String myImage = profileUrl;
  late int myPostCount= 0;
  late int myFollowerCount= 0;
  late int myFollowingCount= 0;
  late String description= "";
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  List<ImagePost> _posts = [];
  List<ImagePost> get posts => _posts;
  bool  get isLoading => _isLoading;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 15,
  );

  Future<void> getMyPosts() async {
    List<dynamic> data = await apiCacheHelper.getMyPosts(pageNumber: _pageNumber);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _isLoading = false;
    _pageNumber++;
    notifyListeners();
  }

  Future<void> getUserPost(userId) async {
    List<dynamic> data =  await apiCacheHelper.getUserPost(pageNumber: _pageNumber, userId: userId);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _isLoading = false;
    _pageNumber++;
    notifyListeners();
  }

  void increaseLikes(int postId) {
    final post = _posts.firstWhere((update) => update.postId == postId);
    if (post.isLikedA) {
      post.likeCountA--;
      post.isLikedA = false;
    } else {
      post.likeCountA++;
      post.isLikedA = true;
    }
    notifyListeners();
  }


}
