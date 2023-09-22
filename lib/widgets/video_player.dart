import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerPage extends StatefulWidget {
  final String mediaUrl;
  VideoPlayerPage({required this.mediaUrl});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      placeholder: Container(
        color: const Color.fromARGB(255, 30, 34, 45),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
          child: Stack(
            children: [
              VisibilityDetector(
                key: Key('chewie_key'), // Provide a unique key
                onVisibilityChanged: (VisibilityInfo info) {
                  if (info.visibleFraction == 0.0) {
                    _chewieController.pause();
                  } else {
                    _chewieController.play();
                  }
                },
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ],
          ),
      );
  }
}

