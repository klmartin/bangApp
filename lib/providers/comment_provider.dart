import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> comments = [];


  Future<void> fetchCommentsForPost(int postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/comments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      comments =
          data.map((commentData) => Comment.fromJson(commentData)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Future addComment(postId, body) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final response = await http.post(
  //       Uri.parse(
  //           'https://bangapp.pro/BangAppBackend/api/postComment'),
  //       body: {
  //         'post_id': postId.toString(),
  //         'user_id': prefs.getInt('user_id').toString(), // Convert to string
  //         'body': body,
  //       },
  //     );
  //     print(jsonDecode(response.body));
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print(e);
  //     return e;
  //   }
  // }

  Future<void> addComment(int postId, String body) async {
    final url = Uri.parse('$baseUrl/postComment');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(
      url,
    );
    final response = await http.post(
      url,
      body: {
        'post_id': postId.toString(),
        'user_id': prefs.getInt('user_id').toString(), // Convert to string
        'body': body,
      },
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];

      print(data);

      notifyListeners();
    } else {
      throw Exception('Failed to add comment');
    }
  }

  Future<void> updateComment(int commentId, String body) async {
    final url = Uri.parse('$baseUrl/comments/$commentId');
    final response = await http.put(
      url,
      body: json.encode({'body': body}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      print(data);
      final updatedComment = Comment.fromJson(data);
      final index =
          comments.indexWhere((comment) => comment.id == updatedComment.id);
      if (index != -1) {
        comments[index] = updatedComment;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final url = Uri.parse('$baseUrl/comments/$commentId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      comments.removeWhere((comment) => comment.id == commentId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete comment');
    }
  }

    int _commentCount = 0;

    int get commentCount => _commentCount;

    Future<void> getCommentCount(int postId) async {

            print('Comment count updated: $_commentCount');

      final url = '$baseUrl/get_comments_count/$postId';
  print(url);
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          _commentCount = responseData['data']['comment_count'];
          notifyListeners();
        } else {
          throw Exception('Failed to load comment count');
        }
      } catch (error) {
        throw error;
      }
    }




}
