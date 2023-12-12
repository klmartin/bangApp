import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_cache_helper.dart';


class BangUpdate {
  final String filename;
  final String type;
  final String caption;
  final String userName;
  final String userImage;
  final int postId;
  bool isLiked;
  int likeCount;
  int commentCount;
  final int userId;

  BangUpdate({
    required this.filename,
    required this.type,
    required this.caption,
    required this.postId,
    required this.userName,
    required this.userImage,
    required this.likeCount,
    required this.isLiked,
    required this.commentCount,
    required this.userId
  });
}

class BangUpdateProvider extends ChangeNotifier {
  List<BangUpdate> _bangUpdates = [];

  List<BangUpdate> get bangUpdates => _bangUpdates;
  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 10,
  );

  Future<void> fetchBangUpdates() async {

    var data = await apiCacheHelper.fetchBangUpdates(pageNumber: 1);

    _bangUpdates = List<BangUpdate>.from(data.map((post) {
      return BangUpdate(
        filename: post['filename'],
        type: post['type'],
        caption:  post['caption'] ?? "" ,
        postId: post['id'],
        likeCount: post['bang_update_like_count'] != null &&
            post['bang_update_like_count'].isNotEmpty
            ? post['bang_update_like_count'][0]['like_count']
            : 0,
        userImage: post['user_image_url'] ,
        userName: post['user']['name'],
        commentCount: post['bang_update_comments'] != null &&
            post['bang_update_comments'].isNotEmpty
            ? post['bang_update_comments'][0]['comment_count']
            : 0,
        isLiked: post['isLiked'],
        userId: post["user_id"],
      );
    }));

    notifyListeners();
  }
  void increaseLikes(int postId) {
    final bangUpdate =
    _bangUpdates.firstWhere((update) => update.postId == postId);
    if (bangUpdate.isLiked) {
      bangUpdate.likeCount--;
      bangUpdate.isLiked = false;
    } else {
      bangUpdate.likeCount++;
      bangUpdate.isLiked = true;
    }
    notifyListeners();
  }

  void updateCommentCount(int postId, int newCount) {
    final bangUpdate =
    _bangUpdates.firstWhere((update) => update.postId == postId);
    bangUpdate.commentCount++;
    notifyListeners();
  }
}
