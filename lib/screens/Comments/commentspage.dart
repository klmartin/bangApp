// import 'package:bangapp/providers/posts_provider.dart';
// import 'package:comment_box/comment/comment.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../services/service.dart';

// class CommentsPage extends StatefulWidget {
//   static const String id = 'comment_screen';
//   final int? userId;
//   final postId;

//   const CommentsPage({
//     Key? key,
//     required this.userId,
//     this.postId,
//   }) : super(key: key);

//   @override
//   _CommentsPageState createState() => _CommentsPageState();
// }

// class _CommentsPageState extends State<CommentsPage> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController commentController = TextEditingController();
//   List<Map<String, dynamic>> filedata = [];

//   @override
//   void initState() {
//     super.initState();
//     // Load data when the widget initializes
//     _fetchComments();
//   }

//   Future<void> _fetchComments() async {
//     // Fetch comments data and populate the filedata list
//     final response = await Service().getComments(widget.postId.toString());
//     final comments = response;
//     setState(() {
//       filedata = comments.map((comment) {
//         return {
//           'name': comment['user']['name'],
//           'pic':
//               'https://img.icons8.com/fluency/48/user-male-circle--v1.png',
//           'message': comment['body'],
//           'date': comment['created_at'],
//         };
//       }).toList();
//     });
//   }

//   Widget commentChild(data) {
//     return ListView(
//       children: [
//         for (var i = 0; i < data.length; i++)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
//             child: ListTile(
//               leading: GestureDetector(
//                 onTap: () async {
//                   // Display the image in large form.
//                   print('Comment Clicked');
//                 },
//                 child: Container(
//                   height: 50.0,
//                   width: 50.0,
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(50)),
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(data[i]['pic']),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 data[i]['name'],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(data[i]['message']),
//               trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
//             ),
//           )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           color: Colors.black,
//           icon: Icon(CupertinoIcons.back),
//         ),
//         title: Text(
//           'Comments',
//           style: TextStyle(
//             fontFamily: 'Metropolis',
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         child: CommentBox(
//           userImage: NetworkImage(
//               'https://img.icons8.com/fluency/48/user-male-circle--v1.png'),
//           child: commentChild(filedata),
//           labelText: 'Write a comment...',
//           errorText: 'Comment cannot be blank',
//           backgroundColor: Colors.white,
//           withBorder: false,
//           sendButtonMethod: () async {
//             if (formKey.currentState!.validate()) {
//               // Post a comment and update data
//               final response = await Service().postComment(
//                 context,
//                 widget.postId,
//                 commentController.text,
//               );

//               // Update the comment count and add the new comment to the list
//               final countUpdate = Provider.of<PostsProvider>(context, listen: false);
//               countUpdate.increaseLikes(widget.postId);

//               setState(() {
//                 var value = {
//                   'name': response['data']['user']['name'],
//                   'pic':
//                       'https://img.icons8.com/fluency/48/user-male-circle--v1.png',
//                   'message': commentController.text,
//                   'date': '2021-01-01 12:00:00'
//                 };
//                 filedata.insert(0, value);
//               });

//               commentController.clear();
//               FocusScope.of(context).unfocus();
//             } else {
//               print('Not validated');
//             }
//           },
//           formKey: formKey,
//           commentController: commentController,
//           textColor: Colors.black,
//           sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.black),
//         ),
//       ),
//     );
//   }
// }

import 'package:bangapp/providers/posts_provider.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsPage extends StatefulWidget {
  final int? userId;
  final postId;
  PostsProvider myProvider;

   CommentsPage({
    required this.userId,
    this.postId,
    required  this.myProvider,
  });
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
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
    final response = await Service().getComments(widget.postId.toString());
    print(response);
    setState(() {
      filedata = response.map((comment) {
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

  void getUserImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userImageURL = prefs.getString('user_image') ?? "";
      print(userImageURL);
      print("this is image after set state");
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
                          imageURLorPath:data[i]['pic'])),
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
              final response = await Service().postComment(
                context,
                widget.postId,
                commentController.text,
                widget.userId
              );
              widget.myProvider.incrementCommentCountByPostId(widget.postId);
              print(commentController.text);
              setState(() {
                var value = {
                  'name': response['data']['user']['name'],
                  'pic': response['data']['user']['user_image_url'],
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
