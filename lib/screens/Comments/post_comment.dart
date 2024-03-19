import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  String commentWriteText = '';
  bool isReply = false;
  int? replyId;
  List filedata = [];
  List replydata = [];

  @override
  void initState() {
    super.initState();
    CircularProgressIndicator();
    _fetchComments();
    getUserImageFromSharedPreferences();
    commentWriteText = 'Write a comment...';
  }

  Future<void> _fetchComments() async {

    print(widget.postId);
    print('this is postId');

    final response = await Service().getComments(widget.postId.toString());
    final comments = response;
    setState(() {
      // CircularProgressIndicator()
      filedata = comments.map((comment) {
        return {
          'name': comment['user']['name'],
          'pic': comment['user_image_url'],
          'message': comment['body'],
          'date': comment['created_at'],
          'user_id': comment['user_id'],
          'comment_id': comment['id'],
          'replies_count': comment['replies_count'] ?? "0",
        };
      }).toList();
    });
  }

  String userImageURL = "";
  String userName = "";

  void getUserImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? " ";
      userImageURL = prefs.getString('user_image') ?? "";
    });
  }

  Future<int?> handleSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentUserId = prefs.getInt('user_id');
    return currentUserId;
  }


  Widget commentChild(data) {

    return FutureBuilder(
        future: handleSharedPreferences(),
        builder: (context,snapshot) {
          int? currentUserId = snapshot.data as int?;

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                    return Dismissible(
                      key: Key(data[i]['id'].toString()),
                      onDismissed: (direction) async {
                        final response = await Service().deleteComment(data[i]['comment_id']);
                        if (response['message'] == 'Comment deleted successfully') {
                          Fluttertoast.showToast(msg: response['message']);
                        }
                        setState(() {
                          data.removeAt(i);
                        });
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
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () async {
                              // Display the image in large form.
                              print("Comment Clicked");
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: CommentBox.commentImageParser(
                                  imageURLorPath: data[i]['pic'],
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            data[i]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(data[i]['message']),
                          trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    );
                  },
                  childCount: data.length,
                ),
              ),
            ],
          );

        }
    );

  }

  @override
  Widget build(BuildContext context) {
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
          userImage: CommentBox.commentImageParser(
              imageURLorPath:userImageURL),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              setState(() {
                var value = {
                  'name':userName,
                  'pic': userImageURL,
                  'message': commentController.text,
                  'date': '2021-01-01 12:00:00'
                };
                filedata.insert(0, value);
              });
              final response = await Service().postComment(
                  context,
                  widget.postId,
                  commentController.text,
                  widget.userId
              );
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          textColor: Colors.black,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.black),
        ),
      ),
    );
  }
}
