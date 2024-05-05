import 'package:bangapp/loaders/notification_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../loaders/friend_request_skeleton.dart';
import '../../models/friend.dart';
import '../../providers/friends_provider.dart';
import 'package:bangapp/screens/Profile/user_profile.dart';

import '../../widgets/app_bar_tittle.dart';


class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}
class _FriendsState extends State<Friends> {
  @override
  void initState() {
    super.initState();
    final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    friendProvider.getSuggestedFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  AppBarTitle(text: 'Invite Friends'),
      ),
      body: Consumer<FriendProvider>(
        builder: (context, friendProvider, _) {
          return friendProvider.isLoading
              ? FriendRequestSkeleton()
              : friendProvider.friends.isEmpty
              ? Center(child: Text('No data available'))
              : FriendCards(suggestedFriends: friendProvider.friends,friendProvider: friendProvider);
        },
      ),
    );

  }
}

class FriendCards extends StatelessWidget {
  final List<Friend> suggestedFriends;
  final FriendProvider friendProvider;
  const FriendCards({required this.suggestedFriends,required this.friendProvider,});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestedFriends.length,
      itemBuilder: (context, index) {
        Friend friend = suggestedFriends[index];
        return ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(userid: friend.userId),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(friend.image),
              radius: 28.0,
            ),
          ),
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(userid: friend.userId),
                ),
              );
            },
            child: Text(
              friend.name,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),

          trailing: ElevatedButton(
            onPressed: () async {
              await friendProvider.requestFriendship(friend.userId);
              if(friendProvider.addingFriend == true){
                Fluttertoast.showToast(
                  msg: friendProvider.requestMessage,
                  toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                  gravity: ToastGravity.CENTER, // Toast position
                  timeInSecForIosWeb: 1, // Time duration for iOS and web
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            style: friend.isFriend!
                ? ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300)
                : ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Colors.black)),
            child: Text(
              friend.isFriend! ? 'Cancel' : 'Add Friend',
              style: TextStyle(color: Colors.black),
            ),
          )

        );
      },
    );
  }
}

