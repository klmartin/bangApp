import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangapp/services/service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../nav.dart';
import '../providers/Profile_Provider.dart';
import '../providers/posts_provider.dart';

class DeletePostWidget extends StatefulWidget {
  final int imagePostId;
  final String type;
  const DeletePostWidget(
      {required this.imagePostId, required this.type, Key? key})
      : super(key: key);

  @override
  _DeletePostWidgetState createState() => _DeletePostWidgetState();
}

class _DeletePostWidgetState extends State<DeletePostWidget> {
  bool _isLoading = false;

  Future<void> _deletePost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final responseBody = await Service().deletePost(widget.imagePostId);
      if (responseBody != null &&
          responseBody['message'] == 'Post deleted successfully') {
        Fluttertoast.showToast(msg: responseBody['message']);
        if (widget.type == 'posts') {
          final postsProvider =
              Provider.of<PostsProvider>(context, listen: false);
          postsProvider.deletePostById(widget.imagePostId);
          Navigator.pop(context);
        } else if (widget.type == 'profile') {
          final providerPost =
              Provider.of<ProfileProvider>(context, listen: false);
          providerPost.deletePostById(widget.imagePostId);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Nav(initialIndex: 4)));
        }
      }
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: _isLoading ? null : _deletePost,
          minLeadingWidth: 20,
          leading: Icon(
            CupertinoIcons.delete,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Delete Post",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        if (_isLoading)
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.red, size: 35),
          ),
      ],
    );
  }
}
