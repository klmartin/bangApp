import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/constants/urls.dart';

import '../../services/fetch_post.dart';
import '../Chat/chat_model.dart';

void main() => runApp(ProfileList());

class ProfileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
          ),
        ),
        body: UsersStream(),
      ),
    );
  }
}

class UserBubble extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String bio;
  final int followCount;
  final int followingCount;
  final int selectedUser;
  final int postCount;
  bool isMe = false;
  UserBubble({
    required this.profileUrl,
    required this.name,
    required this.bio,
    required this.selectedUser, required bool isMe, required this.followCount, required this.followingCount, required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMe) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            print("here");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  body: UserProfile(id: this.selectedUser, name: this.name,bio: this.bio, profileUrl: this.profileUrl,followCount: this.followCount,followingCount: this.followingCount,postCount: this.postCount,),
                ),
              ),
            );
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 32,
                          backgroundImage: CachedNetworkImageProvider(this.profileUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name == null ? '' : name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Metropolis',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Tap to view profile',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Metropolis',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class UsersStream extends StatefulWidget {
  @override
  _UsersStreamState createState() => _UsersStreamState();
}

class _UsersStreamState extends State<UsersStream> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _fetchSearchResults(String keyword) async {
    final url = Uri.parse('$baseUrl/users/search?keyword=$keyword');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults = data.cast<Map<String, dynamic>>();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                _fetchSearchResults(value);
              } else {
                setState(() {
                  _searchResults = [];
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Search users...',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final user = _searchResults[index];
              return UserBubble(
                profileUrl: user['profileUrl'],
                name: user['name'],
                selectedUser: user['id'],
                bio: user['bio'] ?? '',
                followCount: user['followCount'],
                followingCount: user['followCount'],
                postCount: user['postCount'],
                isMe: false, // Assuming the logged-in user is not shown in search results
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserProfile extends StatelessWidget {
  final int? id;
  final String name;
  final String bio;
  final String profileUrl;
  final int followCount;
  final int followingCount;
  final int postCount;
  UserProfile({required this.id,required this.name,required this.bio,required this.profileUrl, required this.followCount, required this.followingCount, required this.postCount});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FetchPosts().getUserPosts(this.id),
      builder: (context, snapshot) {
        List<ImagePost> imagePosts = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        if (snapshot.hasData) {
          final List<dynamic> posts = snapshot.data! as List<dynamic>;
          for (var post in posts) {
            final image = post['image'];
            final imagePost = ImagePost(
              url: image,
            );
            imagePosts.add(imagePost);
          }
        }
        return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
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
                          image: CachedNetworkImageProvider(this.profileUrl),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        '${this.postCount}',
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
                        '${this.followCount}',
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
                        '${this.followingCount}',
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
                this.name,
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
                  child: Text(this.bio)),
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
                                  return PmScreen(selectedUser: '2', name: '', profileUrl: '',);
                                }));
                          },
                          child: Text(
                            'Message',
                            style: TextStyle(color: Colors.black),
                          )),
                    )),
              ],
            ),
           GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: imagePosts.map((imagePost) => KeyedSubtree(
              key: ValueKey(imagePost.url), // or use ObjectKey(imagePost)
              child: imagePost,
            )).toList(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),

        ]));
      },
    );
  }
}


class ImagePost extends StatelessWidget {
  final String url;
  final bool isMe = true;

  ImagePost({required this.url});

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return GestureDetector(
        onTap: () {
          // Navigator.push(
          // context, MaterialPageRoute(builder: (context) => POstView(url)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.red.shade100,
            image: DecorationImage(
                image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }
}
