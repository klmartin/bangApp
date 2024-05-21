import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/services/animation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;

import '../providers/follower_provider.dart';

class FollowersModal {
  static void showFollowersModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<FollowerProvider>(
            builder: (context, followerProvider, _) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Followers (${followerProvider.allFollowers.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: followerProvider.isLoading
                          ? Center(
                        child:  LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: followerProvider.allFollowers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    User.UserProfile(
                                      userid: followerProvider
                                          .allFollowers[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    followerProvider
                                        .allFollowers[index].userImageUrl),
                              ),
                            ),
                            title: Text(followerProvider
                                .allFollowers[index].name),
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
