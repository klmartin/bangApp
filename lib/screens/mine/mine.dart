import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/comment_provider.dart';

class CommentPage2 extends StatelessWidget {
  final int postId;

  CommentPage2({required this.postId, required int userId});

@override
Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<CommentProvider>().fetchCommentsForPost(postId);
  });


    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CommentList(postId: postId),
          ),
          CommentInput(postId: postId),
        ],
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final int postId;

  CommentList({required this.postId});

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<CommentProvider>().comments;

    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          subtitle: Text(comment.body),
        );
      },
    );
  }
}

class CommentInput extends StatefulWidget {
  final int postId;

  CommentInput({required this.postId});

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Add a comment',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              final text = _textController.text.trim();
              if (text.isNotEmpty) {
                try {
                  await context
                      .read<CommentProvider>()
                      .addComment(widget.postId, text);
                  _textController.clear();
                } catch (e) {
                  // Handle error
                  print('Failed to add comment: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
