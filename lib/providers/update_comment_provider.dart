import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/models/UpdateComment.dart';

class UpdateCommentProvider extends ChangeNotifier {
  List<UpdateComment> _comments = [];

  List<UpdateComment>? get comments => _comments;
  bool _loading = false;
  bool _postingLoading = false;
  bool get loading => _loading;
  bool get postingLoading => _postingLoading;

  Future<void> fetchCommentsForPost(int postId) async {
    _comments.clear();
    _loading = true;
    notifyListeners();
    final Map<String, dynamic> response =
        await Service().getUpdateComments(postId.toString());
    if (response.containsKey('comments')) {
      final List<dynamic> commentsData = response['comments'];
      _comments = commentsData
          .map((commentData) => UpdateComment.fromJson(commentData))
          .toList();
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(context, postId, commentText) async {
    _postingLoading = true;
    notifyListeners();
    var response = await Service().postUpdateComment(postId, commentText);
    if (response != null && response.containsKey('data')) {
      var newCommentData = response['data'];
      UpdateComment newComment = UpdateComment.fromJson(newCommentData);
      _comments.insert(0, newComment);
      _postingLoading = false;
      notifyListeners();
    } else {
      _postingLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCommentReply(context, commentId, postId, commentText) async {
    _postingLoading = true;
    var response = await Service().postUpdateCommentReply(context, postId, commentId, commentText);
    if(response != null && response.containsKey('data')){
      var newReplyData = response['data'];
      CommentReplies newReply = CommentReplies.fromJson(newReplyData);
      int commentIndex =
      _comments.indexWhere((comment) => comment.id == commentId);
      if (commentIndex != -1) {
        _comments[commentIndex].commentReplies!.insert(0, newReply);
        _comments[commentIndex].repliesCount =
            _comments[commentIndex].repliesCount! + 1;
        _postingLoading = false;
        notifyListeners();
      }
    }
    else{
      _postingLoading = false;
      notifyListeners();
    }

  }

  Future<void> deleteComment(int commentId) async {
      _comments.removeWhere((comment) => comment.id == commentId);
      notifyListeners();
  }
}
