import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangapp/services/service.dart';

class DeletePostWidget extends StatefulWidget {
  final int imagePostId;

  const DeletePostWidget({required this.imagePostId, Key? key}) : super(key: key);

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

      if (responseBody != null && responseBody['message'] == 'Post deleted successfully') {
        Fluttertoast.showToast(msg: responseBody['message']);
      }
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
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
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
