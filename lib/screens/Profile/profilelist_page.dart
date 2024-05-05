import 'package:bangapp/widgets/app_bar_tittle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;

import '../../services/animation.dart';
import '../../services/search_history.dart';
import '../../services/token_storage_helper.dart';

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: AppBarTitle(text: ''),
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

            SearchHistoryManager().saveSearch([
              {
                'profileUrl' : this.profileUrl,
                'selected_user': this.selectedUser,
                'name': this.name,
                'bio': this.bio,
                'followCount': this.followCount,
                'followingCount': followingCount,
                'postCount': postCount,
                'isMe': this.isMe
              }
            ]);
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
                          backgroundImage: NetworkImage(this.profileUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 20.0),
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
  final SearchHistoryManager searchHistoryManager = SearchHistoryManager();
  List<Map<String, dynamic>> _searchResults = [];
  void _fetchSearchResults(String keyword) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse('$baseUrl/users/search?keyword=$keyword');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );

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
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    await searchHistoryManager.loadSearchHistory();
    setState(() {}); // Refresh the UI after loading search history
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textCapitalization:TextCapitalization.sentences,
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
          child: _searchController.text.isNotEmpty
              ? ListView.builder(
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
                isMe: false,
              );
            },
          )
              : ListView.builder(
            itemCount: searchHistoryManager.searchHistory.length,
            itemBuilder: (context, index) {
              final entry = searchHistoryManager.searchHistory[index];

              // Accessing the first map in the entry
              final user = entry.isNotEmpty ? entry.first : {};

              print(user);
              print('this is printed user');
              return UserBubble(
                profileUrl: user['profileUrl'] ?? "",
                name: user['name'],
                selectedUser: user['selected_user'],
                bio: user['bio'] ?? '',
                followCount: user['followCount'],
                followingCount: user['followingCount'],
                postCount: user['postCount'],
                isMe: user['isMe'],
              );
            },
          ),
        ),
      ],
    );
  }

}
