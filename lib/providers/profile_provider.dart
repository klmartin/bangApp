import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import '../models/image_post.dart';
import '../services/api_cache_helper.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = true;
  late String myImage = profileUrl;
  late int myPostCount = 0;
  late int myFollowerCount = 0;
  late int myFollowingCount = 0;
  late String description = "";
  final int _numberOfPostsPerRequest = 10;
  int _pageNumber = 1;
  List<ImagePost> _posts = [];
  List<ImagePost> get posts => _posts;
  bool get isLoading => _isLoading;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 15,
  );

  Future<void> getMyPosts() async {
    List<dynamic> data =
        await apiCacheHelper.getMyPosts(pageNumber: _pageNumber);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _isLoading = false;
    _pageNumber++;
    print('pageNumber');
    print(_pageNumber);
    notifyListeners();
  }

  Future<void> getUserPost(userId) async {
    List<dynamic> data = await apiCacheHelper.getUserPost(
        pageNumber: _pageNumber, userId: userId);
    _posts.addAll(data.map((json) => ImagePost.fromJson(json)).toList());
    _isLoading = false;
    _pageNumber++;
    print('pageNumber');
    print(_pageNumber);
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

  void increaseLikes2(int postId, int postType) {
    print("333333333333333333333333333333333333333333333333333");
    final post = _posts.firstWhere((update) => update.postId == postId);
    // ignore: unnecessary_null_comparison
    if (post != null) {
      if (postType == 1) {
        if (post.isLikedA == false) {
          post.likeCountA++;
          post.isLikedA = true;
        } else {
          post.likeCountA--;
          post.isLikedA = false;
        }

        // If the user has previously liked type B, un-like it.
        if (post.isLikedB == true) {
          post.likeCountB--;
          post.isLikedB = false;
        }
      } else if (postType == 2) {
        if (post.isLikedB == false) {
          post.likeCountB++;
          post.isLikedB = true;
        } else {
          post.likeCountB--;
          post.isLikedB = false;
        }

        // If the user has previously liked type A, un-like it.
        if (post.isLikedA == true) {
          post.likeCountA--;
          post.isLikedA = false;
        }
      }

      notifyListeners();
    } else {}
  }
}
