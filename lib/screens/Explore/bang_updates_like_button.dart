import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:flutter/cupertino.dart';

class BangUpdateLikeButton extends StatefulWidget {
  final int likeCount;
  final bool isLiked;
  final int postId;
  BangUpdateLikeButton({
    required this.likeCount,
    required this.isLiked,
    required this.postId,
  });
  @override
  _BangUpdateLikeButtonState createState() => _BangUpdateLikeButtonState();
}

class _BangUpdateLikeButtonState extends State<BangUpdateLikeButton> {
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked; // Initialize the isLiked state variable with the value from the widget
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              isLiked = !isLiked; // Update the isLiked state variable
            });
            await Service().likeBangUpdate(widget.likeCount, isLiked, widget.postId); // Use the parameters from the widget
          },
          child: isLiked
              ? Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30)
              : Icon(CupertinoIcons.heart, color: Colors.white, size: 30),
        ),
        SizedBox(width: 4),
      ],
    );
  }
}
