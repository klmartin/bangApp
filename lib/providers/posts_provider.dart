import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/models/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  // ... Rest of the properties ...

  void fetchData() async {


   Future<void> fetchData() async {
    try {
      final response = await get(Uri.parse(
          "$baseUrl/getPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey('data')) {
        List<dynamic> responseList = responseData['data']['data']; // Access the nested 'data' array
        List<Post> postList = responseList.map((data) {
          print(data);
          List<dynamic>? challengesList = data['challenges']; // Add '?' to make it nullable
          List<Challenge> challenges = (challengesList ?? []).map((challengeData) => Challenge(
            id: challengeData['id'],
            postId: challengeData['post_id'],
            userId: challengeData['user_id'],
            challengeImg: challengeData['challenge_img'],
            body: challengeData['body'] ?? '',
            type: challengeData['type'],
            confirmed: challengeData['confirmed'],
          )).toList();
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
            isLiked: data['isFavorited'] == 0 ? false : true ,
            isPinned: data['pinned'],
            challenges: challenges ,
          );
        }).toList();
      notifyListeners();

      } else {

          _loading = false;
          _error = true;
      notifyListeners();

      }
    } catch (e) {
       errorDialog(size: 30);

    }
  }



 Widget errorDialog({required double size}){
    return SizedBox(
      height: 180,
      width: 200,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 10,),
          TextButton(
              onPressed:  ()  {

                  _loading = true;
                  _error = false;
                  fetchData();
              notifyListeners();
              },
              child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),)),
        ],
      ),
    );
  }

  }

  void refreshData() {}}
