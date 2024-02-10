import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController commentController = TextEditingController();

  List filedata = [];

  @override
  void initState() {
    super.initState();
    CircularProgressIndicator();
    _fetchComments();
    getUserImageFromSharedPreferences();
  }

  Future<void> _fetchComments() async {
    final response =
        await Service().getBattleComments(widget.postId.toString());
    final comments = response;

    setState(() {
      // CircularProgressIndicator()
      filedata = comments.map((comment) {
        return {
          'name': comment['user']['name'],
          'pic': comment['user_image_url'],
          'message': comment['body'],
          'date': comment['created_at'],
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
      userName = prefs.getString('name') ?? "";
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
          userImage: NetworkImage(userImageURL),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          backgroundColor: Colors.white,
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              setState(() {
                var value = {
                  'name': userName,
                  'pic': userImageURL,
                  'message': commentController.text,
                  'date': '2021-01-01'
                };
                filedata.insert(0, value);
              });
              commentController.clear();
              final response = await Service().postBattleComment(
                widget.postId,
                commentController.text,
              );

              final battleComment =
                  Provider.of<BoxDataProvider>(context, listen: false);
              battleComment.updateCommentCount(widget.postId);

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
