import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';

class VideoPlayerPage extends StatefulWidget {
  final String mediaUrl;

  VideoPlayerPage({required this.mediaUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController? _chewieController;

  bool isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.mediaUrl)
      ..initialize().then((_) {
        setState(() {
          // Video has been initialized and is ready to play
          isVideoPlaying = true;
        });
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9, // Set your desired aspect ratio
      child: Stack(
        children: [
          VisibilityDetector(
            key: Key('chewie_key'),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 0.0) {
                _chewieController?.pause();
              } else {
                _chewieController?.play();
              }
            },
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
          if (!isVideoPlaying)
            Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 30, 34, 45),
              highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
              child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
            ),
        ],
      ),
    );
  }
}
