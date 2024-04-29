import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangapp/services/service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../nav.dart';
import '../providers/Profile_Provider.dart';
import '../providers/blocked_users_provider.dart';
import '../providers/friends_provider.dart';
import '../providers/posts_provider.dart';

class HidePostWidget extends StatefulWidget {
  final int imagePostId;
  final int imageUserId;
  const HidePostWidget(
      {required this.imagePostId,
      required this.imageUserId,
      Key? key})
      : super(key: key);

  @override
  _HidePostWidgetState createState() => _HidePostWidgetState();
}

class _HidePostWidgetState extends State<HidePostWidget> {
  @override

  Widget build(BuildContext context) {
    final blockedUsersProvider =
    Provider.of<BlockedUsersProvider>(context, listen: true);
    final friendProvider =
    Provider.of<FriendProvider>(context, listen: true);
    return Column(
      children: [
        ListTile(
          onTap: () async {
            String reason = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Options"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text("Show Fewer Similar Posts"),
                          onTap:() async {
                            String message = await blockedUsersProvider.showFewerPost(widget.imagePostId, widget.imageUserId);
                            Fluttertoast.showToast(msg: message);
                            if (message == "We Will Show You Fewer Posts Like This") {
                              final postsProvider = Provider.of<PostsProvider>(
                                  context,
                                  listen: false);
                              postsProvider.deletePostById(widget.imagePostId);
                            }
                          },
                          subtitle: blockedUsersProvider.showingFewer
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                          color: Color(0xFFF40BF5), size: 35)
                              : Container(),
                        ),
                        ListTile(
                          title: Text("Unfriend User"),
                          onTap: () async {
                            String message = await friendProvider.removeFriendship(widget.imageUserId);
                            Fluttertoast.showToast(msg: message);
                            if (message ==
                                "Friendship Deleted Successfully") {
                              final postsProvider = Provider.of<PostsProvider>(
                                  context,
                                  listen: false);
                              postsProvider.deletePostById(widget.imagePostId);
                            }
                          },
                          subtitle:friendProvider.removingFriend ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Color(0xFFF40BF5), size: 35): Container()
                        ),
                        ListTile(
                          title: Text("Block User"),
                          onTap:  () async {
                            String message = await blockedUsersProvider.blockUser(widget.imageUserId);
                            if(message == "User blocked successfully"){
                              final postsProvider = Provider.of<PostsProvider>(
                                  context,
                                  listen: false);
                              postsProvider.deletePostByUserID(widget.imageUserId);
                            }
                            Fluttertoast.showToast(msg: message);
                          },
                          subtitle: blockedUsersProvider.blocking
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Color(0xFFF40BF5), size: 35)
                              : Container(),
                        ),
                        // Add more reasons as needed
                      ],
                    ),
                  ),
                );
              },
            );
            // If user selects a reason, report the post
          },
          minLeadingWidth: 20,
          leading: Icon(
            CupertinoIcons.eye_slash,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Hide Post",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Divider(
          height: .5,
          thickness: .5,
          color: Colors.grey.shade800,
        )
      ],
    );
  }
}
