import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:bangapp/models/post.dart';
import 'package:bangapp/screens/Widgets/post_item.dart';
import '../Widgets/small_box.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
   bool _loading = true;
  final int _numberOfPostsPerRequest = 10;
  List<Post>? _posts;
  final int _nextPageTrigger = 3;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPostsView(),
    );
  }

  Widget buildPostsView() {
    if (_posts == null || _posts!.isEmpty) {
      if (_loading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        );
      } else if (_error) {
        return Center(
          child: errorDialog(size: 20),
        );
      } else {
        return Center(
          child: Text("No posts available."),
        );
      }
    }

    return ListView.builder(
      itemCount: _posts!.length + (_isLastPage ? 0 : 1) + (_posts!.isEmpty ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return SmallBoxCarousel();
        }
        // Calculate the adjusted index to account for inserted carousels
        //int adjustedIndex = index - (index ~/ 8) - (index > 0 && index <= 8 ? 1 : 0);
        int adjustedIndex = index - (index ~/ 8);
        final Post post = _posts![adjustedIndex];
        if (index == 0 || (index >= 8 && (index - 8) % 8 == 0)) {
          return Column(
            children: [
              SmallBoxCarousel(),
              PostItem(post.postId,post.userId,post.name,post.image,post.challengeImg,post.caption,post.type,post.width,post.height,post.likeCountA,post.likeCountB,post.commentCount,post.followerCount,post.challenges,post.isLiked,post.isPinned),
            ],
          );
        } else {
          if (adjustedIndex == _posts!.length - _nextPageTrigger) {
            fetchData();
          }
          if (adjustedIndex == _posts!.length) {
            if (_error) {
              return Center(
                child: errorDialog(size: 15),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          return PostItem(post.postId,post.userId,post.name,post.image,post.challengeImg,post.caption,post.type,post.width,post.height,post.likeCountA,post.likeCountB,post.commentCount,post.followerCount,post.challenges,post.isLiked,post.isPinned);
      }
      },
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await get(Uri.parse(
          "https://alitaafrica.com/social-backend-laravel/api/getPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
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
            challenges: challenges , // Pass the list of challenges to the Post constructor
          );
        }).toList();
        setState(() {
          _isLastPage = postList.length < _numberOfPostsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _posts?.addAll(postList);
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (e) {
      errorDialog(size: 30);
      // ... existing error handling ...
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
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData();
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),)),
        ],
      ),
    );
  }

}