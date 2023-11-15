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
  final int _nextPageTrigger = 3;

  List<Post> _posts = [];
  List<Post> _allPosts = [];

  List<Post>? get posts => _posts;
  bool get isLastPage => _isLastPage;
  bool get isLoading => _loading;
  bool get isError => _error;

  num get nextPageTrigger => _nextPageTrigger;

  Future<void> fetchData() async {
    if (!_isLastPage) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await get(Uri.parse(
            "$baseUrl/getPost?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId"));
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          List<dynamic> responseList = responseData['data']['data'];
          final newPosts = responseList.map((data) {
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
                caption: data['body'] ?? 'hi',
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
                createdAt: data['created_at'],
                userImage: data['user_image_url']);
          }).toList();
          _posts.addAll(newPosts);
          _pageNumber++;
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
  }

  void addPost(Post post) {
    _posts!.add(post);
    notifyListeners();
  }

  void incrementCommentCountByPostId(int postId) {
    try {
      // Print the postId being searched for

      // ignore: unrelated_type_equality_checks
      final post = _posts?.firstWhere((update) => update.postId == postId);

      if (post != null) {
        post.commentCount++;
        notifyListeners();
      } else {
        // Iterate through _posts and print all postIds
        posts?.forEach((post) {});
      }
    } catch (e) {}
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

  void increaseLikes2(int postId, int postType) {
    final post = _posts.firstWhere((update) => update.postId == postId);

    // ignore: unnecessary_null_comparison
    if (post != null) {
      if (postType == 1) {
        if (post.isLikedA == false) {
          post.likeCountA++;
          post.isLikedA = true;
        } else {
          post.likeCountA--;
          post.isLikedA = false;
        }

        // If the user has previously liked type B, un-like it.
        if (post.isLikedB == true) {
          post.likeCountB--;
          post.isLikedB = false;
        }
      } else if (postType == 2) {
        if (post.isLikedB == false) {
          post.likeCountB++;
          post.isLikedB = true;
        } else {
          post.likeCountB--;
          post.isLikedB = false;
        }

        // If the user has previously liked type A, un-like it.
        if (post.isLikedA == true) {
          post.likeCountA--;
          post.isLikedA = false;
        }
      }

      notifyListeners();
    } else {}
  }
}
