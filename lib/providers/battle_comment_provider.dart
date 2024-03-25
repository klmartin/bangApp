import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import '../models/BattleComment.dart';

class BattleCommentProvider extends ChangeNotifier {
  List<BattleComment> _comments = [];
  List<BattleComment>? get comments => _comments;
  bool _loading = false;
  bool _postingLoading = false;
  bool get loading => _loading;
  bool get postingLoading => _postingLoading;


  Future<void> fetchCommentsForPost(int postId) async {
    _loading = true;
    notifyListeners();
    final Map<String, dynamic> response = await Service().getBattleComments(postId.toString());
    if (response != null && response.containsKey('comments')) {
      final List<dynamic> commentsData = response['comments'];
      _comments = commentsData.map((commentData) => BattleComment.fromJson(commentData)).toList();
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      throw Exception('Failed to load comments');
    }
  }


  Future<void> addComment(context,postId,commentText) async {
    _postingLoading = true;
    notifyListeners();
    var response = await Service().postBattleComment( postId, commentText);
    if(response != null && response.containsKey('data')){
      var newCommentData = response['data'];
      BattleComment newComment = BattleComment.fromJson(newCommentData);
      _comments.insert(0, newComment);
      _postingLoading = false;
      notifyListeners();
    }
    else{
      _postingLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCommentReply(context, commentId, postId, commentText) async
  {
    _postingLoading = true;
    notifyListeners();
    var response = await Service().postBattleCommentReply(context, postId, commentId, commentText);
    if(response != null && response.containsKey('data')){
      var newReplyData = response['data'];
      BattleCommentReplies newReply = BattleCommentReplies.fromJson(newReplyData);
      int commentIndex = _comments.indexWhere((comment) => comment.id == commentId);
      if (commentIndex != -1) {
        _comments[commentIndex].battlecommentReplies!.insert(0, newReply);
        _comments[commentIndex].repliesCount = _comments[commentIndex].repliesCount! + 1;
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
