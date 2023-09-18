import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/models/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsProvider with ChangeNotifier {
  bool _isLastPage = false;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;
  final int _numberOfPostsPerRequest = 10;
  List<Post>? _posts;
  final int _nextPageTrigger = 3;

  List<Post>? get posts => _posts;
  bool get isLastPage => _isLastPage;
  bool get isLoading => _loading;
  bool get isError => _error;

  num get nextPageTrigger => _nextPageTrigger;

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id').toString();
      final response = await get(Uri.parse(
          "$baseUrl/getPost?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$user_id"));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        List<dynamic> responseList = responseData['data']['data'];
        _posts = responseList.map((data) {
          List<dynamic>? challengesList = data['challenges'];
          List<Challenge> challenges = (challengesList ?? [])
              .map((challengeData) => Challenge(
                    id: challengeData['id'],
                    postId: challengeData['post_id'],
                    userId: challengeData['user_id'],
                    challengeImg: challengeData['challenge_img'],
                    body: challengeData['body'] ?? '',
                    type: challengeData['type'],
                    confirmed: challengeData['confirmed'],
                  ))
              .toList();
          return Post(
            postId: data['id'],
            userId: data['user_id'],
            name: data['user']['name'],
            image: data['image'],
            challengeImg: data['challenge_img'],
            caption: data['body'] ?? '',
            type: data['type'],
            width: data['width'],
            height: data['height'],
            likeCountA: data['like_count_A'],
            likeCountB: data['like_count_B'],
            commentCount: data['commentCount'],
            followerCount: data['user']['followerCount'],
            isLiked: data['isLiked'],
            isPinned: data['pinned'],
            challenges: challenges,
            isLikedB: data['isLikedB'],
            isLikedA: data['isLikedA'],
          );
        }).toList();
        // print("listtttttttttttttt");
        // print(posts);
        // print("listtttttttttttttt");

        _loading = false;
        notifyListeners();
      } else {
        _loading = false;
        _error = true;
        notifyListeners();
      }
    } catch (e) {
      // Handle the error here...
    }
  }

  void incrementCommentCountByPostId(int postId) {
    print("Response isss $_posts");
    try {
      // Print the postId being searched for
      print("Searching for postId: $postId");
      // ignore: unrelated_type_equality_checks
      final post = _posts?.firstWhere((update) => update.postId == postId);

      if (post != null) {
        print(post.commentCount);
        post.commentCount++;
        print("Updated comment count for post $postId: ${post.commentCount}");
        notifyListeners();
      } else {
        // Iterate through _posts and print all postIds
        posts?.forEach((post) {
          print("PostId in _posts: ${post.postId}");
        });
        print("Post with postId $postId not found.");
      }
    } catch (e) {
      print("Error updating comment count: $e");
    }
  }

  void increaseLikes(int postId) {
    final post = _posts?.firstWhere((update) => update.postId == postId);
    if (post?.isLiked) {
      post?.likeCountA--;
      post!.isLiked = false;
    } else {
      post!.likeCountA++;
      post.isLiked = true;
    }
    notifyListeners();
  }

  void increaseLikes2(int postId, postType) {
    final post = _posts?.firstWhere((update) => update.postId == postId);

    if (post != null) {
      if (postType == 1) {
        if (post.isLikedA) {
          post.likeCountA--;
          post.isLikedA = false;
        } else if (post.isLikedA == false) {
          post.likeCountA++;
          post.likeCountB--;
          post.isLikedA = true;
          post.isLikedB = false;
        }
      }
      if (postType == 2) {
        if (post.isLikedB) {
          post.likeCountB--;
          post.isLikedB = false;
        } else if (post.isLikedB == false) {
          post.likeCountB++;
          post.likeCountA--;
          post.isLikedB = true;
          post.isLikedA = false;
        }
      }

      notifyListeners();
    } else {
      print("Post with postId $postId not found.");
    }
  }
}
