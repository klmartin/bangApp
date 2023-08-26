import 'package:flutter/material.dart';

class LikeCounterWidget extends StatefulWidget {
  final int initialLikeCount;

  LikeCounterWidget({required this.initialLikeCount});

  @override
  _LikeCounterWidgetState createState() => _LikeCounterWidgetState();
}

class _LikeCounterWidgetState extends State<LikeCounterWidget> {
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikeCount;
  }

  void incrementLike() {
    setState(() {
      likeCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$likeCount",
      style: TextStyle(
        fontSize: 12.5,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
