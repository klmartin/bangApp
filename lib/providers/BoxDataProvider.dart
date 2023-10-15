import 'dart:convert';

import 'package:bangapp/screens/Widgets/small_box2.dart';
import 'package:flutter/material.dart';
import '../services/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BoxDataProvider with ChangeNotifier {
  List<dynamic> _boxes = [];
  List<dynamic> get boxes => _boxes;

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final response = await http.get(
        Uri.parse('https://bangapp.pro/BangAppBackend/api/getBangBattle/$userId'));
    final data = jsonDecode(response.body)['data'];
    print(data);
    _boxes = data.map((e) => BoxData2.fromJson(e)).toList();
    print(boxes);
    notifyListeners();
  }

  void increaseLikes(postId, type) {
    final box = _boxes.firstWhere((element) => element.postId == postId);

    // Check if the user has already liked the other type, and if so, toggle the like.
    if (type == 1) {
      if (box.isLikedB) {
        box.likeCountB--; // Decrease the like count for the other type
        box.isLikedB = false; // Unlike the other type
      }
      if (box.isLikedA) {
        box.likeCountA--; // Decrease the like count for the other type
        box.isLikedA = false; // Unlike the other type
      }
      if (box.isLikedA == false) {
        box.isLikedA = true; // Toggle the like for type 1
        box.likeCountA++; // Increase the like count for type 1
      }
    } else if (type == 2) {
      if (box.isLikedA) {
        box.likeCountA--; // Decrease the like count for the other type
        box.isLikedA = false; // Unlike the other type
      }
      if (box.isLikedB) {
        box.likeCountB--; // Decrease the like count for the other type
        box.isLikedB = false; // Unlike the other type
      }
      box.isLikedB = true; // Toggle the like for type 2
      box.likeCountB++; // Increase the like count for type 2
    }

    notifyListeners();
  }

  void updateCommentCount(postId,) {
    final post = _boxes.firstWhere((element) => element.postId == postId);
    post.commentCount++;
    notifyListeners();
  }
}

class BoxData2 {
  int postId;
  final String imageUrl1;
  final String imageUrl2;
  final String text;
  final int battleId;
  int likeCountA;
  int likeCountB;
  bool isLikedA;
  bool isLikedB;
  int commentCount;

  BoxData2({
    required this.postId,
    required this.isLikedA,
    required this.isLikedB,
    required this.commentCount,
    required this.likeCountA,
    required this.likeCountB,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.text,
    required this.battleId,
  });

  factory BoxData2.fromJson(Map<String, dynamic> json) {
    return BoxData2(
      postId: json['id'],
      imageUrl1: json['battle1'],
      imageUrl2: json['battle2'],
      text: json['body'],
      battleId: json['id'],
      isLikedA: json['isLikedA'],
      isLikedB: json['isLikedB'],
      likeCountA: json['like_count_A'],
      likeCountB: json['like_count_B'],
      commentCount: json['comment_count'],
    );
  }
}
