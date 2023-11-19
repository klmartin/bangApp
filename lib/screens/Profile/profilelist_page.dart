import 'package:bangapp/message/screens/messages/message_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;

import '../../services/animation.dart';
import '../../services/fetch_post.dart';
import '../Chat/chat_model.dart';

void main() => runApp(ProfileList());

class ProfileList extends StatefulWidget {
  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
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
    required this.selectedUser,
    required bool isMe,
    required this.followCount,
    required this.followingCount,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMe) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              createRoute(
                User.UserProfile(
                  userid: this.selectedUser,
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
                          backgroundImage:
                              NetworkImage(this.profileUrl),
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

