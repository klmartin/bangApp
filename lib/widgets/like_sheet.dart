import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/services/animation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;

class LikesModal {

  static void showLikesModal(BuildContext context, int postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UserLikesProvider>(
          builder: (context, likedUsersProvider, _) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Likes (${likedUsersProvider.likedUsers.length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: likedUsersProvider.isLoading
                        ? Center(
                            child:  LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: likedUsersProvider.likedUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      createRoute(
                                        User.UserProfile(
                                          userid: likedUsersProvider
                                              .likedUsers[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        likedUsersProvider
                                            .likedUsers[index].userImageUrl),
                                  ),
                                ),
                                title: Text(likedUsersProvider
                                    .likedUsers[index].name),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
