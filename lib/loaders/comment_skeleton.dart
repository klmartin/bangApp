import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentSkeleton extends StatefulWidget {
  const CommentSkeleton();

  @override
  State<CommentSkeleton> createState() => _CommentSkeletonPageState();
}

class _CommentSkeletonPageState extends State<CommentSkeleton> {
  bool _enabled = true;
Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child: Container(),
    );
  }
}
