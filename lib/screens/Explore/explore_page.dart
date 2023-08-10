import 'package:flutter/material.dart';
import 'package:bangapp/widgets/SearchBox.dart';
import 'package:bangapp/widgets/buildBangUpdate.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ui';
import '../../models/bang_battle.dart';
import '../Widgets/small_box.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBox(),
        SizedBox(height: 10),
        Expanded(
          child: BangUpdates(),
        ),
      ],
    );
  }
}

class BangUpdates extends StatefulWidget {
  @override
  _BangUpdatesState createState() => _BangUpdatesState();
}

class _BangUpdatesState extends State<BangUpdates> {
  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    getBangUpdates();
  }
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  bool _loading = true;
  final int _numberOfPostsPerRequest = 10;
  List<BangUpdate>? _posts;
  final int _nextPageTrigger = 3;
  Future<void> getBangUpdates() async {
    try {
      final response = await get(Uri.parse(
          "http://192.168.165.229/social-backend-laravel/api/bang-updates?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey('data')) {
        List<dynamic> responseList = responseData['data']['data']; // Access the nested 'data' array
        List<BangUpdate> bangUpdateList = responseList.map((data) {
          List<dynamic>? bangUpdateLike = data['challenges'];
          print(data);
          List<BangUpdateLike> bangBattleLikes = (bangUpdateLike ?? []).map((bangUpdateLikeData) => BangUpdateLike(
            likeCount: bangUpdateLikeData['like_count'],
            postId: bangUpdateLikeData['post_id'],
          )).toList();
          return BangUpdate(
            caption: data['caption'],
            type: data['type'],
            id: data['id'],
            filename:data['filename'],
            createdAt: data['created_at'],
            bangUpdateLikes: bangBattleLikes,
          );
        }).toList();
        setState(() {
          _isLastPage = bangUpdateList.length < _numberOfPostsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _posts?.addAll(bangUpdateList);
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (e) {
      errorDialog(size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        // Calculate the adjusted index to account for inserted carousels
        int adjustedIndex = index - (index ~/ 8) - (index > 0 && index <= 8 ? 1 : 0);
        final BangUpdate bangBattle = _posts![adjustedIndex];
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
          return SmallBoxCarousel();

      },
    );
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
                  getBangUpdates();
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),)),
        ],
      ),
    );
  }
}





