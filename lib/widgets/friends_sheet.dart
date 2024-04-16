import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/services/animation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;

import '../providers/friends_provider.dart';

class FriendsModal {

  static void showFriendsModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<FriendProvider>(
            builder: (context, friendProvider, _) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Friends (${friendProvider.allFriends.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: friendProvider.isLoading
                          ? Center(
                        child:  LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: friendProvider.allFriends.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    User.UserProfile(
                                      userid: friendProvider
                                          .allFriends[index].userId,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    friendProvider
                                        .allFriends[index].image),
                              ),
                            ),
                            title: Text(friendProvider
                                .allFriends[index].name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

}
