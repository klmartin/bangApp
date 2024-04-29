import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String aspectRatio;
  final String thumbnailUrl;
  final String cacheUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.aspectRatio,
    required this.thumbnailUrl,
    required this.cacheUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
late VideoPlayerController _videoPlayerController;
bool _videoInitialized = false;
bool _isPlaying = false; // Track if the video is currently playing

@override
void initState() {
  super.initState();
  _initializePlayer();
}

Future<void> _initializePlayer() async {
  final fileInfo = await _checkCacheFor(widget.cacheUrl);
  if (fileInfo == null) {
    _cachedForUrl(widget.cacheUrl);
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      formatHint: VideoFormat.hls,
    );
  } else {
    final file = fileInfo.file;
    _videoPlayerController = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
  }

  await _videoPlayerController.initialize();
  setState(() {
    _videoInitialized = true;
  });
  _videoPlayerController.play(); // Autoplay the video
  _videoPlayerController.setLooping(true); // Enable looping
  _videoPlayerController.addListener(_videoListener);
}

Future<FileInfo?> _checkCacheFor(String url) async {
  return await DefaultCacheManager().getFileFromCache(url);
}

void _cachedForUrl(String url) async {
  await DefaultCacheManager().getSingleFile(url).then((value) {
    // Do something with the cached file
  });
}

@override
void dispose() {
  _videoPlayerController.dispose();
  super.dispose();
}

void _videoListener() {
  if (_videoPlayerController.value.isPlaying) {
    setState(() {
      _isPlaying = true;
    });
  } else {
    setState(() {
      _isPlaying = false;
    });
  }
}

@override
Widget build(BuildContext context) {
  return VisibilityDetector(
    key: Key(widget.videoUrl),
    onVisibilityChanged: (visibilityInfo) {
      if (visibilityInfo.visibleFraction < 0.7) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    },
    child: GestureDetector(
      onTap: () {
        if (_isPlaying) {
          _videoPlayerController.pause();
        } else {
          _videoPlayerController.play();
        }
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: double.parse(widget.aspectRatio),
            child: _videoInitialized
                ? VideoPlayer(_videoPlayerController)
                : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.thumbnailUrl,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: double.parse(widget.aspectRatio),
                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 30, 34, 45),
                  highlightColor:
                  const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                  child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
                ),
              ),
            ),
          ),
          if (!_videoInitialized)
            Center(
              child: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
            ),
        ],
      ),
    ),
  );
}
}

