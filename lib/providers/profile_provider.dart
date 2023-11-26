import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/image_post.dart';

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

  Future<void>  getMyPosts(int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse(
        "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId"));
    print(response.body);
    print('this is data from api');
    var data = json.decode(response.body);
    final List<dynamic> post = data['data']['data'];
    _posts = post.map((json) => ImagePost.fromJson(json)).toList();
    print(posts[0].likeCount);
    print('this is posts getter');
    notifyListeners();

  }


}
