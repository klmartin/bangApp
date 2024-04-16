import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/providers/user_provider.dart';

import '../../providers/battle_comment_provider.dart';

class BattleComment extends StatefulWidget {
  final postId;

  const BattleComment({
    Key? key,
    this.postId,
  }) : super(key: key);
  @override
  _BattleCommentState createState() => _BattleCommentState();
}

class _BattleCommentState extends State<BattleComment> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<_BattleCommentState> _commentPageKey = GlobalKey<_BattleCommentState>();

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
    final battleCommentProvider = Provider.of<BattleCommentProvider>(context, listen: false);
    battleCommentProvider.comments!.clear();
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    battleCommentProvider.fetchCommentsForPost(widget.postId);
    commentWriteText = 'Write a comment...';
  }


  Widget commentChild() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final battleCommentProvider = Provider.of<BattleCommentProvider>(context, listen: true);
    return battleCommentProvider.loading ? Center(
      child: LoadingAnimationWidget.fallingDot(color: Colors.black, size: 50
      ),
    ) : ListView.builder(
        itemCount: battleCommentProvider.comments!.length,
        itemBuilder: (context, index) {
          final comments = battleCommentProvider.comments;
          final comment = comments?[index];
          return userProvider.userData['id'] == comment?.userId
              ? Dismissible(
            key: Key(comment!.id.toString()),
            onDismissed: (direction) async {
              final response = await Service().deleteBattleComment(comment.id);
              battleCommentProvider.deleteComment(comment.id!);
              Fluttertoast.showToast(msg: response['message']);
              final battleComment = Provider.of<BoxDataProvider>(context, listen: false);
              battleComment.decrementCommentCount(widget.postId);
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
                  comment.battlecommentuser!.name ?? "",
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
                        commentController.text = '@${comment.battlecommentuser?.name} ';
                        FocusScope.of(context)
                            .requestFocus(commentFocusNode);
                      },
                      child: Text("Reply"),
                    ),
                    Center(
                      child:  comment.repliesCount! > 0
                          ? Text(
                          '${comment.repliesCount!} Replies')
                          : Container(),
                    )
                  ],
                ),
                trailing:
                Text(comment.createdAt ?? "", style: TextStyle(fontSize: 10)),
                children: [
                  // List of replies goes here
                  for (var reply in comment.battlecommentReplies!)
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
              :Padding(
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
                comment.battlecommentuser?.name ?? "",
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
                      '@${comment.battlecommentuser?.name} ';
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
                for (var reply in comment.battlecommentReplies!)
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
                      Text(reply.createdAt! ,
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
        print('called');
        return ListTile(
          title: Text(data[index]['body']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    final battleCommentProvider = Provider.of<BattleCommentProvider>(context, listen: true);

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
      body: Container(
        child: CommentBox(
          userImage: NetworkImage(userProvider.userData['user_image_url']),
          child: commentChild(),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              if (isReply == false) {
                try {
                  battleCommentProvider.addComment(context, widget.postId, commentController.text);
                } catch (e) {
                  print('Error posting comment: $e');
                  // Handle the error as needed
                }
                final battleComment = Provider.of<BoxDataProvider>(context, listen: false);
                battleComment.updateCommentCount(widget.postId);
                commentController.clear();
                FocusScope.of(context).unfocus();
              } else {
                try {
                 battleCommentProvider.addCommentReply(context, replyId,  widget.postId, commentController.text);
                  commentController.clear();
                 setState(() {
                   isReply = false;
                   commentWriteText = 'Write a comment...';
                 });
                  FocusScope.of(context).unfocus();
                  _commentPageKey.currentState?.refreshPage();
                } catch (e) {
                  print('Error posting comment: $e');
                }
              }
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          textColor: Colors.black,
          sendWidget: battleCommentProvider.postingLoading
              ? LoadingAnimationWidget.fallingDot(color: Colors.black, size: 30
          )
              : Icon(Icons.send_sharp, size: 30, color: Colors.black),
        ),
      ),
    );
  }

  void refreshPage() {print('refreshed page'); setState(() {}); }
}
