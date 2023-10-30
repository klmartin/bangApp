import 'dart:convert';

import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/message/screens/chats/chats_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Chat/chat_model.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/services/fetch_post.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';

List<dynamic> followinglist = [];
late int cufollowing;
bool _persposts = true;
late int followers;
List<dynamic> followlist = [];


class UserProfile extends StatefulWidget {

  final userid;

  UserProfile(
      {required this.userid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ScrollController? _scrollController;
  bool _isLoading = false;
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  List<ImagePost> allImagePosts = [];


  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    super.initState();
  }
  void _scrollListener() {
    if (!_isLoading && _scrollController!.position.extentAfter < 200.0) {
      // Load more posts when the user is close to the end of the list
      _pageNumber++;
      _loadMorePosts();
    }
  }

  void _loadMorePosts() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final List<dynamic> newPosts = await getMyPosts(_pageNumber);

    setState(() {
      _isLoading = false;
      // Append the newly loaded posts to the existing list
      allImagePosts.addAll(newPosts.map((post) {
        return ImagePost(post['user']['name'],
            post['body'],
            post['image'],
            post['challenge_img'],
            post['width'],
            post['height'],
            post['id'],
            post['commentCount'],
            post['user_id'],
            post['isLikedA'],
            post['like_count_A'],
            post['type'],
            post['user']['followerCount'],
            post['created_at']
        );
      }));
    });
  }


  Future<List<dynamic>> getMyPosts(int pageNumber) async {
    var response = await http.get(Uri.parse("$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=${widget.userid}"));
    print(response.body);
    var data = json.decode(response.body);
    print(data);
    print('this i s data');
    return data['data']['data'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title:  GestureDetector(
        onTap: () async {
      Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
          colors: [Colors.pink, Colors.redAccent, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.navigate_before_outlined, size: 30),
        ),
      ),
      automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 10)
        ],
      ),
      body:Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(logoUrl),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '10 posts',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Metropolis'),
                    ),
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.ellipsisV,
                  size: 10,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '4 ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Metropolis'),
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.ellipsisV,
                  size: 10,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      '2 following',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Metropolis'),
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Metropolis',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
                // constraints: BoxConstraints(maxWidth: ),
                child: Text('this is description')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async { //follow or unfollow

                    },
                    child: Text('Unfollow Follow',
                      style: TextStyle(
                          color:Colors.white),
                    )),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ChatsScreen();
                        // return PmScreen(selectedUser: widget.userid, name: '', profileUrl: '',);
                      }));
                    },
                    child: Text(
                      'Message',
                      style: TextStyle(color: Colors.black),
                    )),
              )),
            ],
          ),
          FutureBuilder(
          future: getMyPosts(_pageNumber),
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlue,
                  ),
                );
            }
            if (snapshot.hasData) {
              final List<dynamic> posts = snapshot.data! as List<dynamic>;
              for (var post in posts) {
                final imagePost = ImagePost(
                    post['user']['name'],
                    post['body'] ?? "",
                    post['image'],
                    post['challenge_img'] ?? "",
                    post['width'],
                    post['height'],
                    post['id'],
                    post['commentCount'],
                    post['user_id'],
                    post['isLikedA'],
                    post['like_count_A'],
                    post['type'],
                    post['user']['followerCount'],
                    post['created_at']
                );
                allImagePosts.add(imagePost);
              }

            }
            return allImagePosts.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No photos yet',
                  style: TextStyle(fontFamily: 'Metropolis'),
                )
              ],
            )
                : Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  for (var i = 0; i < allImagePosts.length; i++)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => POstView(
                            allImagePosts[i].name,
                            allImagePosts[i].caption,
                            allImagePosts[i].imageUrl,
                            allImagePosts[i].challengeImgUrl,
                            allImagePosts[i].imgWidth,
                            allImagePosts[i].imgHeight,
                            allImagePosts[i].postId,
                            allImagePosts[i].commentCount,
                            allImagePosts[i].userId,
                            allImagePosts[i].isLiked,
                            allImagePosts[i].likeCount,
                            allImagePosts[i].type,
                            allImagePosts[i].followerCount,
                          )));
                        },
                        child: CachedNetworkImage(
                          imageUrl: allImagePosts[i].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ),
        ],
      ),
    ));
  }
}

class ImagePost {
  final String imageUrl;
  final String name;
  String caption;
  String challengeImgUrl;
  int imgWidth;
  int imgHeight;
  int postId;
  int commentCount;
  int userId;
  bool isLiked;
  int likeCount;
  String type;
  int followerCount;
  String createdAt;
  ImagePost(this.name,this.caption,this.imageUrl,this.challengeImgUrl, this.imgWidth, this.imgHeight, this.postId, this.commentCount, this.userId,this.isLiked,this.likeCount,this.type,this.followerCount,this.createdAt);
}
