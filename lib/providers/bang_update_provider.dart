import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/token_storage_helper.dart';

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
  String? aspectRatio;
  String? cacheUrl;
  String? thumbnailUrl;

  BangUpdate(
      {required this.filename,
      required this.type,
      required this.caption,
      required this.postId,
      required this.userName,
      required this.userImage,
      required this.likeCount,
      required this.isLiked,
      required this.commentCount,
      required this.userId,
        required this.aspectRatio,
        required this.cacheUrl,
        required this.thumbnailUrl,
      });
}

class BangUpdateProvider extends ChangeNotifier {
  List<BangUpdate> _bangUpdates = [];
  bool _loading = true;
  int _currentPage = 1;
  int _perPage = 10;
  int get currentPage => _currentPage;
  bool get isLoading => _loading;
  List<BangUpdate> get bangUpdates => _bangUpdates;

  Future<void> fetchBangUpdates() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id').toString();
      print('nipo hapa');
      print("$baseUrl/bang-updates/$userId/$_perPage/$_currentPage");
      final response = await http.get(
        Uri.parse(
          "$baseUrl/bang-updates/$userId/$_perPage/$_currentPage",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);


        _bangUpdates = List<BangUpdate>.from(data.map((post) {
          return BangUpdate(
            filename: post['filename'],
            type: post['type'],
            caption: post['caption'] ?? "",
            postId: post['id'],
            likeCount: post['bang_update_like_count'] != null &&
                post['bang_update_like_count'].isNotEmpty
                ? post['bang_update_like_count'][0]['like_count']
                : 0,
            userImage: post['user_image_url'],
            userName: post['user']['name'],
            commentCount: post['bang_update_comments'] != null &&
                post['bang_update_comments'].isNotEmpty
                ? post['bang_update_comments'][0]['comment_count']
                : 0,
            isLiked: post['isLiked'],
            userId: post["user_id"],
            aspectRatio:post["aspect_ratio"],
            cacheUrl: post["cache_url"] ?? "",
            thumbnailUrl: post["thumbnail_url"] ?? ""
          );
        }
        ));
        _loading = false;
        notifyListeners();
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle error
      print("Error: $error");
    }
  }

  Future<void> getMoreUpdates() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id').toString();

      // Calculate next page
      _currentPage++;

      final response = await http.get(
        Uri.parse(
          "$baseUrl/bang-updates/$userId/$_currentPage/$_perPage",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        print('this is more update data');
        _loading = false;
        notifyListeners();
        _bangUpdates.addAll(List<BangUpdate>.from(data.map((post) {
          return BangUpdate(
            filename: post['filename'],
            type: post['type'],
            caption: post['caption'] ?? "",
            postId: post['id'],
            likeCount: post['bang_update_like_count'] != null &&
                post['bang_update_like_count'].isNotEmpty
                ? post['bang_update_like_count'][0]['like_count']
                : 0,
            userImage: post['user_image_url'],
            userName: post['user']['name'],
            commentCount: post['bang_update_comments'] != null &&
                post['bang_update_comments'].isNotEmpty
                ? post['bang_update_comments'][0]['comment_count']
                : 0,
            isLiked: post['isLiked'],
            userId: post["user_id"],
              aspectRatio: post["aspect_ratio"],
              cacheUrl: post["cache_url"] ?? "",
              thumbnailUrl: post["thumbnail_url"] ?? ""
          );
        })));
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle error
      print("Error: $error");
    }
  }

  Future<void> refreshUpdates() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id').toString();
      print('nipo hapa');
      print("$baseUrl/bang-updates/$userId/$_perPage/1");
      final response = await http.get(
        Uri.parse(
          "$baseUrl/bang-updates/$userId/$_perPage/1",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _bangUpdates = List<BangUpdate>.from(data.map((post) {
          return BangUpdate(
              filename: post['filename'],
              type: post['type'],
              caption: post['caption'] ?? "",
              postId: post['id'],
              likeCount: post['bang_update_like_count'] != null &&
                  post['bang_update_like_count'].isNotEmpty
                  ? post['bang_update_like_count'][0]['like_count']
                  : 0,
              userImage: post['user_image_url'],
              userName: post['user']['name'],
              commentCount: post['bang_update_comments'] != null &&
                  post['bang_update_comments'].isNotEmpty
                  ? post['bang_update_comments'][0]['comment_count']
                  : 0,
              isLiked: post['isLiked'],
              userId: post["user_id"],
              aspectRatio:post["aspect_ratio"],
              cacheUrl: post["cache_url"] ?? "",
              thumbnailUrl: post["thumbnail_url"] ?? ""
          );
        }
        ));
        _loading = false;
        notifyListeners();
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle error
      print("Error: $error");
    }
  }

  void increaseLikes(int postId) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    print(bangUpdate.isLiked);
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

  void decrementCommentCount(int postId, int newCount) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    bangUpdate.commentCount--;
    notifyListeners();
  }
}
