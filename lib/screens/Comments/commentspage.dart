import 'package:bangapp/providers/posts_provider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsPage extends StatefulWidget {
  final int? userId;
  final postId;
  PostsProvider myProvider;

  CommentsPage({
    required this.userId,
    this.postId,
    required this.myProvider,
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
    CircularProgressIndicator();
    _fetchComments();
    getUserImageFromSharedPreferences();
    commentWriteText = 'Write a comment...';
  }

  Future<void> _fetchComments() async {
    final response = await Service().getComments(widget.postId.toString());

    setState(() {
      filedata = response.map((comment) {
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
      userImageURL = prefs.getString('user_image') ?? "";
      userName = prefs.getString('name') ?? " ";
    });
  }

  Future<int?> handleSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentUserId = prefs.getInt('user_id');
    // Use currentUserId as needed
    return currentUserId;
  }

  Widget commentChild(data) {
    return FutureBuilder(
        future: handleSharedPreferences(),
        builder: (context, snapshot) {
          int? currentUserId = snapshot.data as int?;
          return ListView(
            children: [
              for (var i = 0; i < data.length; i++)
                currentUserId == data[i]['user_id']
                    ? Dismissible(
                        key: Key(data[i]['id'].toString()),
                        onDismissed: (direction) async {
                          final response = await Service()
                              .deleteComment(data[i]['comment_id']);
                          if (response['message'] ==
                              'Comment deleted successfully') {
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
                          padding:
                              const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                          child: ExpansionTile(
                            key: Key('expansion_${data[i]['id']}'),
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
                                  backgroundImage:
                                      CommentBox.commentImageParser(
                                    imageURLorPath: data[i]['pic'],
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              data[i]['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[i]['message'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    print(data[i]['comment_id']);
                                    setState(() {
                                      replyId = data[i]['comment_id'];
                                      commentWriteText = 'Reply to';
                                      isReply = true;
                                    });
                                    commentController.text =
                                        '@${data[i]['name']} ';
                                    FocusScope.of(context)
                                        .requestFocus(commentFocusNode);
                                  },
                                  child: Text("Reply"),
                                ),
                                Center(
                                  child: data[i]['replies_count'] > 0
                                      ? GestureDetector(
                                          onTap: () async {
                                            print('comment pressed');
                                            final response = await Service()
                                                .getCommentReplies(data[i]
                                                        ['comment_id']
                                                    .toString());
                                            print(response);
                                            setState(() {
                                              replydata =
                                                  response.map((comment) {
                                                return {
                                                  'user_image': comment['user_image_url'],
                                                  'body': comment['body'] ?? "",
                                                  'user_name' : comment['user']['name'],
                                                  'date' : comment['created_at'],

                                                };
                                              }).toList();
                                            });
                                          },
                                          child: Text(
                                              '${data[i]['replies_count']} Replies'),
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                            trailing: Text(data[i]['date'],
                                style: TextStyle(fontSize: 10)),
                            children: [
                              // List of replies goes here
                              for (var reply in replydata)
                                ListTile(
                                  leading: GestureDetector(
                                    onTap: () async {

                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: CommentBox.commentImageParser(
                                          imageURLorPath: reply['user_image'],
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    reply['user_name'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(reply['body']),
                                  trailing: Column(
                                      children:[
                                        Text(reply['date'], style: TextStyle(fontSize: 7)),
                                      ]

                                  ),
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
                                  imageURLorPath: data[i]['pic'],
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            data[i]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[i]['message'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  print(data[i]['comment_id']);
                                  setState(() {
                                    replyId = data[i]['comment_id'];
                                    commentWriteText = 'Reply to';
                                    isReply = true;
                                  });
                                  commentController.text =
                                      '@${data[i]['name']} ';
                                  FocusScope.of(context)
                                      .requestFocus(commentFocusNode);
                                },
                                child: Text("Reply"),
                              ),
                              Center(
                                child: data[i]['replies_count'] > 0
                                    ? GestureDetector(
                                        onTap: () async {
                                          print('comment pressed');
                                          final response = await Service()
                                              .getCommentReplies(data[i]
                                                      ['comment_id']
                                                  .toString());
                                          print(response);
                                          setState(() {
                                            replydata = response.map((comment) {
                                              return {
                                                'user_image': comment['user_image_url'],
                                                'body': comment['body'] ?? "",
                                                'user_name' : comment['user']['name'],
                                              };
                                            }).toList();
                                            repliesChild(replydata);
                                          });
                                        },
                                        child: Text(
                                            '${data[i]['replies_count']} Replies'),
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                          trailing: Text(data[i]['date'],
                              style: TextStyle(fontSize: 10)),
                          children: [
                            // List of replies goes here
                            for (var reply in replydata)
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
                                      borderRadius: new BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: CommentBox.commentImageParser(
                                        imageURLorPath: reply['user_image'] ,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  reply['user_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(reply['body']),
                                trailing: Column(
                                    children:[
                                      Text(data[i]['date'], style: TextStyle(fontSize: 7)),
                                    ]

                                ),
                                // trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
                              ),
                          ],
                        ),
                      ),
            ],
          );
        });
  }

  Widget repliesChild(data) {
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
          userImage: NetworkImage(userImageURL),
          child: commentChild(filedata),
          labelText: commentWriteText,
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              if (isReply == false) {
                setState(() {
                  var value = {
                    'name': userName,
                    'pic': userImageURL,
                    'message': commentController.text,
                    'date': '2021-01-01 12:00:00',
                    'replies_count': 0,
                  };
                  filedata.insert(0, value);
                });
                try {
                  await Service().postComment(
                    context,
                    widget.postId,
                    commentController.text,
                    widget.userId,
                  );
                } catch (e) {
                  print('Error posting comment: $e');
                  // Handle the error as needed
                }
                widget.myProvider.incrementCommentCountByPostId(widget.postId);
                commentController.clear();
                FocusScope.of(context).unfocus();
              } else {
                try {
                  await Service().postCommentReply(
                    context,
                    widget.postId,
                    replyId,
                    commentController.text,
                  );
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
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.black),
        ),
      ),
    );
  }
}
