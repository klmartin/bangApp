import 'package:bangapp/providers/posts_provider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';

import '../Explore/explore_page2.dart';


class BattleComment extends StatefulWidget {
  final int? userId;
  final postId;

  const BattleComment({
    Key? key,
    required this.userId,
    this.postId,
  }) : super(key: key);
  @override
  _BattleCommentState createState() => _BattleCommentState();
}

class _BattleCommentState extends State<BattleComment> {
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
    final response = await Service().getBattleComments(widget.postId.toString());
    final comments = response;
     final bangUpdateProvider =
                  Provider.of<BangUpdateProvider>(context, listen: false);
              bangUpdateProvider.updateCommentCount(
                  widget.postId, filedata.length);

    setState(() {
      // CircularProgressIndicator()
      filedata = comments.map((comment) {
        return {
          'name': comment['user']['name'],
          'pic': 'YOUR_BASE_URL/${comment['user']['image']}',
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
                          imageURLorPath: data[i]['pic'])),
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
              imageURLorPath: "assets/img/userpic.jpg"),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              final response = await Service().postBattleComment(
                widget.postId,
                commentController.text,
              );
              final comm = Provider.of<PostsProvider>(context, listen: false );
              comm.incrementCommentCountByPostId(widget.postId);
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
