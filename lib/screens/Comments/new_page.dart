import 'package:flutter/material.dart';

import '../../providers/posts_provider.dart';

class CommentDemo extends StatelessWidget {
int postId;
PostsProvider myProvider;
CommentDemo(this.postId, this.myProvider);

  @override
  Widget build(myContext) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              myProvider.incrementCommentCountByPostId(postId);
              print("Im hereeeeee");
            },
            child: Text("Increment Comment Count"),
          ),
        ),
      ),
    );
  }
}
