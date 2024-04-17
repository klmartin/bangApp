import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VideoSkeletonSkeleton extends StatefulWidget {
  const VideoSkeletonSkeleton();

  @override
  State<VideoSkeletonSkeleton> createState() =>
      _VideoSkeletonSkeletonState();
}

class _VideoSkeletonSkeletonState extends State<VideoSkeletonSkeleton> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(), // Replace YourCardContent with your actual card content
      ),
    );
  }

}
