import 'dart:convert';

import 'package:bangapp/screens/Widgets/small_box2.dart';
import 'package:flutter/material.dart';
import '../services/service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BoxDataProvider with ChangeNotifier {
  List<dynamic> _boxes = [];
  List<dynamic> get boxes => _boxes;

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://bangapp.pro/BangAppBackend/api/getBangBattle/11'));
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
      box.isLikedB = false; // Unlike the other type
    }
    box.isLikedA = !box.isLikedA; // Toggle the like for type 1
  } else if (type == 2) {
    if (box.isLikedA) {
      box.isLikedA = false; // Unlike the other type
    }
    box.isLikedB = !box.isLikedB; // Toggle the like for type 2
  }

  notifyListeners();
}

}

class BoxData2 {
  int postId;
  final String imageUrl1;
  final String imageUrl2;
  final String text;
  final int battleId;
  final int likeCountA;
  final int likeCountB;
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
