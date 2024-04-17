import 'package:flutter/material.dart';

import 'package:bangapp/services/service.dart';
import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  List<Comment>? get comments => _comments;
  bool _loading = false;
  bool _postingLoading = false;
  bool get loading => _loading;
  bool get postingLoading => _postingLoading;

  Future<void> fetchCommentsForPost(int postId) async {
    print('fetching comments');
    _loading = true;
    notifyListeners();
    final Map<String, dynamic> response = await Service().getComments(postId.toString());
    if (response.containsKey('comments')) {
      final List<dynamic> commentsData = response['comments'];
      print(commentsData);
      print('comments data');
      _comments = commentsData.map((commentData) => Comment.fromJson(commentData)).toList();
      _loading = false;
      print('new comment data');
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(context,postId,commentText, userId) async {
    _postingLoading = true;
    notifyListeners();
    var response = await Service().postComment(context, postId, commentText, userId);
    if(response.containsKey('data')){
      var newCommentData = response['data'];
      Comment newComment = Comment.fromJson(newCommentData);
      _comments.insert(0, newComment);
      _postingLoading = false;
      notifyListeners();
    }
    else{
      _postingLoading = false;
      notifyListeners();
    }

  }

  Future<void> addCommentReply(context, commentId, postId, commentText) async {
    _postingLoading = true;
    notifyListeners();
    var response = await Service().postCommentReply(context, postId, commentId, commentText);
    if (response != null && response.containsKey('data')) {
      var newReplyData = response['data'];
      CommentReplies newReply = CommentReplies.fromJson(newReplyData);
      int commentIndex = _comments.indexWhere((comment) => comment.id == commentId);
      if (commentIndex != -1) {
        _comments[commentIndex].commentReplies!.insert(0, newReply);
        _comments[commentIndex].repliesCount = _comments[commentIndex].repliesCount! + 1;
        _postingLoading = false;
        notifyListeners();
      }
    } else {
      _postingLoading = false;
      notifyListeners();
      print('Error: Invalid response or missing data field.');
      // Handle the error case here, such as showing a message to the user.
    }
  }

  Future<void> deleteComment(int commentId) async {
      _comments.removeWhere((comment) => comment.id == commentId);
      notifyListeners();
  }

}
