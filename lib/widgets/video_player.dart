import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerPage extends StatefulWidget {
  final String mediaUrl;
  VideoPlayerPage({required this.mediaUrl});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.mediaUrl);
    await _videoPlayerController.initialize();
    setState(() {
      isVideoPlaying = true;
    });

    await _downloadAndCacheVideo();
  }

  Future<void> _downloadAndCacheVideo() async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.downloadFile(widget.mediaUrl);

    // Use fileInfo.file instead of widget.mediaUrl
    final file = fileInfo.file;

    if (file != null && file.existsSync()) {
      // Video is in cache, create ChewieController if not created yet
      if (_chewieController == null) {
        _chewieController = ChewieController(
          videoPlayerController: VideoPlayerController.file(file),
          autoPlay: true,
          looping: false,
        );
        setState(() {}); // Trigger a rebuild once the ChewieController is created
      }
    } else {
      // Video is not in cache, create ChewieController with regular controller
      if (_videoPlayerController.value.isInitialized) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
        );
        setState(() {}); // Trigger a rebuild once the ChewieController is created
      }
    }
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
      aspectRatio: _videoPlayerController.value.aspectRatio ?? 16 / 9,
      child: FutureBuilder(
        future: _chewieController?.videoPlayerController.initialize(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              VisibilityDetector(
                key: Key('chewie_key'),
                onVisibilityChanged: (VisibilityInfo info) {
                  if (_chewieController != null) {
                    if (info.visibleFraction == 0.0) {
                      _chewieController!.pause();
                    } else {
                      _chewieController!.play();
                    }
                  }
                },
                child: _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : Container(),
              ),
              if (!isVideoPlaying)
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 30, 34, 45),
                  highlightColor:
                  const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                  child: Container(height:double.infinity, color: const Color.fromARGB(255, 30, 34, 45)),
                ),
            ],
          );
        },
      ),
    );
  }
}
