import 'dart:convert';

import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/image_post.dart';
import '../services/api_cache_helper.dart';
import '../services/token_storage_helper.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = true;
  late String myImage = profileUrl;
  late int myPostCount = 0;
  late int myFollowerCount = 0;
  late int myFollowingCount = 0;
  late String description = "";
  late int _currentPageNumber = 0;
  final int _numberOfPostsPerRequest = 20;
  List<ImagePost> _posts = [];
  List<ImagePost> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> getMyPosts(_pageNumber) async {
    print('pageNumber');
    print(_pageNumber);
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id').toString();
    final String cacheKey = 'cached_my_posts';

    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;
    if (minutes >= 3) {
      final response = await get(
        Uri.parse(
          "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      final responseData = json.decode(response.body);

      prefs.setString(cacheKey, json.encode(responseData));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

      processResponseData(responseData);
      _isLoading = false;
      _currentPageNumber = _pageNumber;
      _pageNumber++;
      print(_pageNumber);
      notifyListeners();
    } else if (_pageNumber != _currentPageNumber) {
      final cacheData = prefs.getString(cacheKey);
      if (cacheData != null) {
        processResponseData(json.decode(cachedData));
      }
      final response = await get(
        Uri.parse(
          "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      final responseData = json.decode(response.body);

      prefs.setString(cacheKey, json.encode(responseData));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

      processResponseData(responseData);
      _isLoading = false;
      _currentPageNumber = _pageNumber;
      _pageNumber++;
      print(_pageNumber);
      notifyListeners();
    } else {
      print('Using cached data');
      final cacheData = prefs.getString(cacheKey);
      if (cacheData != null) {
        processResponseData(json.decode(cachedData));
      }
    }
  }

  void processResponseData(Map<String, dynamic> responseData) {
    if (responseData.containsKey('data')) {
      List<dynamic> responseList = responseData['data']['data'];
      _posts.addAll(
          responseList.map((json) => ImagePost.fromJson(json)).toList());
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserPost(userId,_pageNumber) async {
    print('pageNumber');
    print(_pageNumber);
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cacheKey = 'cached_my_posts_$userId';

    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;
    if (minutes >= 3) {
      final response = await get(
        Uri.parse(
          "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      final responseData = json.decode(response.body);

      prefs.setString(cacheKey, json.encode(responseData));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

      processResponseData(responseData);
      _isLoading = false;
      _currentPageNumber = _pageNumber;
      _pageNumber++;
      print(_pageNumber);
      notifyListeners();
    } else if (_pageNumber != _currentPageNumber) {
      final cacheData = prefs.getString(cacheKey);
      if (cacheData != null) {
        processResponseData(json.decode(cachedData));
      }
      final response = await get(
        Uri.parse(
          "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      final responseData = json.decode(response.body);

      prefs.setString(cacheKey, json.encode(responseData));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

      processResponseData(responseData);
      _isLoading = false;
      _currentPageNumber = _pageNumber;
      _pageNumber++;
      print(_pageNumber);
      notifyListeners();
    } else {
      print('Using cached data');
      final cacheData = prefs.getString(cacheKey);
      if (cacheData != null) {
        processResponseData(json.decode(cachedData));
      }
    }
  }

  void deletePostById(int postId) {
    _posts.removeWhere((post) => post.postId == postId);
    _isLoading = true;
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
