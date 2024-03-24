import 'package:bangapp/providers/posts_provider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/providers/comment_provider.dart';

import '../../loaders/comment_line_skeleton.dart';
import '../../providers/Profile_Provider.dart';

class CommentsPage extends StatefulWidget {
  final int? userId;
  final postId;


  CommentsPage({
    required this.userId,
    this.postId,
  });
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  String commentWriteText = '';
  bool isReply = false;
  int? replyId;
  List filedata = [];
  List replydata = [];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final commentProvider =
    Provider.of<CommentProvider>(context, listen: false);
    commentProvider.comments!.clear();
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    if (commentProvider.comments!.isEmpty) {
      commentProvider.fetchCommentsForPost(widget.postId);
    }
    commentWriteText = 'Write a comment...';
  }

  Widget commentChild() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final commentProvider = Provider.of<CommentProvider>(context, listen: true); // Set listen to true
    return  commentProvider.loading ? Center(
      child: LoadingAnimationWidget.fallingDot(color: Colors.black, size: 50
      ),
    ) :ListView.builder(
        itemCount: commentProvider.comments!.length,
        itemBuilder: (context, index) {
          final comments = commentProvider.comments;
          final comment = comments?[index];
          return userProvider.userData['id'] == comment?.userId
              ? Dismissible(
            key: Key(comment!.id.toString()),
            onDismissed: (direction) async {
              final response = await Service().deleteComment(comment.id);
              if (response['message'] == 'Comment deleted successfully') {
                Fluttertoast.showToast(msg: response['message']);
              }
              // setState(() {
              //   comments?.removeAt(index);
              // });
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
              child: ExpansionTile(
                key: Key('expansion_${comment.id}'),
                leading: GestureDetector(
                  onTap: () async {
                    // Display the image in large form.
                    print("Comment Clicked");
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                      new BorderRadius.all(Radius.circular(50)),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                        imageURLorPath: comment.userImageUrl,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  comment.commentUser!.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment?.body ?? "",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        print(comment.id);
                        setState(() {
                          replyId = comment.id;
                          commentWriteText = 'Reply to';
                          isReply = true;
                        });
                        commentController.text =
                        '@${comment.commentUser?.name} ';
                        FocusScope.of(context)
                            .requestFocus(commentFocusNode);
                      },
                      child: Text("Reply"),
                    ),
                    Center(
                      child: comment.repliesCount! > 0
                          ? Text('${comment.repliesCount} Replies')
                          : Container(),
                    )
                  ],
                ),
                trailing: Text(comment.createdAt ?? "",
                    style: TextStyle(fontSize: 10)),
                children: [
                  // List of replies goes here

                  for (var reply in comment.commentReplies!)
                    ListTile(
                      leading: GestureDetector(
                        onTap: () async {},
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                            new BorderRadius.all(Radius.circular(30)),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                            CommentBox.commentImageParser(
                              imageURLorPath: reply.userImageUrl,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        reply.replyUser!.name ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(reply.body ?? ""),
                      trailing: Column(children: [
                        Text(reply.createdAt!,
                            style: TextStyle(fontSize: 7)),
                      ]),
                    ),
                ],
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ExpansionTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                    new BorderRadius.all(Radius.circular(50)),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: CommentBox.commentImageParser(
                      imageURLorPath: comment!.userImageUrl ?? "",
                    ),
                  ),
                ),
              ),
              title: Text(
                comment!.commentUser?.name ?? "",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.body ?? "",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      print(comment.id);
                      setState(() {
                        replyId = comment.id;
                        commentWriteText = 'Reply to';
                        isReply = true;
                      });
                      commentController.text =
                      '@${comment.commentUser?.name} ';
                      FocusScope.of(context)
                          .requestFocus(commentFocusNode);
                    },
                    child: Text("Reply"),
                  ),
                  Center(
                    child: comment.repliesCount! > 0
                        ? Text('${comment.repliesCount} Replies')
                        : Container(),
                  )
                ],
              ),
              trailing: Text(comment.createdAt ?? "",
                  style: TextStyle(fontSize: 10)),
              children: [
                // List of replies goes here
                for (var reply in comment.commentReplies!)
                  ListTile(
                    leading: GestureDetector(
                      onTap: () async {
                        // Display the image in large form.
                        print("Comment Clicked");
                      },
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                          new BorderRadius.all(Radius.circular(30)),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: CommentBox.commentImageParser(
                            imageURLorPath: reply.userImageUrl,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      reply.replyUser!.name ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(reply.body ?? ""),
                    trailing: Column(children: [
                      Text(reply.createdAt!,
                          style: TextStyle(fontSize: 7)),
                    ]),
                    // trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
                  ),
              ],
            ),
          );
        });
  }

  Widget repliesChild(data) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index]['body']),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    final commentProvider =
    Provider.of<CommentProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body:  Container(
        child: CommentBox(
          userImage: NetworkImage(userProvider.userData['user_image_url']),
          child: commentChild(),
          labelText: commentWriteText,
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              if (isReply == false) {
                try {
                  commentProvider.addComment(context, widget.postId,
                      commentController.text, widget.userId);
                } catch (e) {
                  print('Error posting comment: $e');
                  // Handle the error as needed
                }
                commentController.clear();
                FocusScope.of(context).unfocus();
              } else {
                try {
                  commentProvider.addCommentReply(
                      context, replyId, widget.postId, commentController.text);

                  commentController.clear();
                  setState(() {
                    isReply = false;
                    commentWriteText = 'Write a comment...';
                  });
                  // Fluttertoast.showToast(msg: response['message']);
                  FocusScope.of(context).unfocus();
                } catch (e) {
                  print('Error posting comment: $e');
                }
              }
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          focusNode: commentFocusNode,
          commentController: commentController,
          textColor: Colors.black,
          sendWidget: commentProvider.postingLoading
              ? LoadingAnimationWidget.fallingDot(color: Colors.black, size: 30
          )
              : Icon(Icons.send_sharp, size: 30, color: Colors.black),
        ),
      ),
    );
  }
}
