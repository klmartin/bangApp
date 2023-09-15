import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';

import '../Explore/explore_page2.dart';

class UpdateCommentsPage extends StatefulWidget {
  final int? userId;
  final postId;

  const UpdateCommentsPage({
    Key? key,
    required this.userId,
    this.postId,
  }) : super(key: key);
  @override
  _UpdateCommentsPageState createState() => _UpdateCommentsPageState();
}

class _UpdateCommentsPageState extends State<UpdateCommentsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  List filedata = [];

  @override
  void initState() {
    super.initState();
    CircularProgressIndicator();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response = await Service().getUpdateComments(widget.postId.toString());
    final comments = response;
    setState(() {
      // CircularProgressIndicator()
      filedata = comments.map((comment) {
        return {
          'name': comment['user']['name'],
          'pic': "https://img.icons8.com/fluency/48/user-male-circle--v1.png",
          'message': comment['body'],
          'date': comment['created_at'],
        };
      }).toList();
    });
  }


  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
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
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: "https://img.icons8.com/fluency/48/user-male-circle--v1.png")),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
            ),
          )
      ],
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
              imageURLorPath: "https://img.icons8.com/fluency/48/user-male-circle--v1.png"),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              final response = await Service().postUpdateComment(
                widget.postId,
                commentController.text,
              );
              final up = Provider.of<BangUpdateProvider>(context, listen: false);
              up.updateCommentCount(widget.postId, 1);

              print(commentController.text);
              setState(() {
                var value = {
                  'name': response['data']['user']['name'],
                  'pic': response['data']['user']['image'],
                  'message': commentController.text,
                  'date': '2021-01-01 12:00:00'
                };
                filedata.insert(0, value);
              });
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
