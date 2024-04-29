import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:better_player/better_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final String aspectRatio;
  final String cachingVideoUrl;

  const CustomVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.aspectRatio,
    required this.cachingVideoUrl,
  }) : super(key: key);

  @override
  CustomVideoPlayerState createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late BetterPlayerController _betterPlayerController;
  bool isControllerReady = false;
  bool? isMuted;
  final UniqueKey stickyKey = UniqueKey();
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _initializePlayer();
  }

  void _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isMuted = prefs.getBool('isMuted') ?? false;
    });
  }

  //:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      ///to do
    });
  }

  // void onVisibilityChanged(double visibleFraction) async {
  //   if (_betterPlayerController != null) { // Check if controller is not null
  //     bool? isPlaying = await _betterPlayerController.isPlaying();
  //     bool? initialized = _betterPlayerController.isVideoInitialized();
  //     if (visibleFraction >= 0.90) {
  //       if (initialized! && !isPlaying!) {
  //         _betterPlayerController.play();
  //       }
  //     } else if (visibleFraction <= 0.10) {
  //       if (initialized! && isPlaying!) {
  //         _betterPlayerController.pause();
  //       }
  //     }
  //   }
  // }


  void _initializePlayer() async {
    final fileInfo = await checkCacheFor(widget.cachingVideoUrl);
    if (fileInfo == null) {
      cachedForUrl(widget.cachingVideoUrl);
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          aspectRatio: double.parse(widget.aspectRatio),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: true,
            enableOverflowMenu: false,
            enableSkips: false,
            enableMute: true,
            enableFullscreen: true,
            enablePlayPause: true,
            enableProgressBar: true,
          ),
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.videoUrl,
          liveStream: false,
          videoFormat: BetterPlayerVideoFormat.hls,
        ),
      );
    } else {
      final file = fileInfo.file;
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          aspectRatio: double.parse(widget.aspectRatio),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: true,
            enableOverflowMenu: false,
            enableSkips: false,
            enableMute: true,
            enableFullscreen: true,
            enablePlayPause: true,
            enableProgressBar: true,
          ),
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          file.path,
          liveStream: false,

        ),
      );
    }
    setState(() {
      isControllerReady = true;
    });
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose(); // Check if controller is not null before disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: (VisibilityInfo info) async {
        if (info.visibleFraction > 0.90) {
          _betterPlayerController.play();
        } else if (info.visibleFraction < 0.10) {
          _betterPlayerController.pause();
        }
      },
      child: AspectRatio(
        aspectRatio: double.parse(widget.aspectRatio),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (_betterPlayerController != null && isControllerReady) {
              return BetterPlayer(
                key: widget.key,
                controller: _betterPlayerController,
              );
            } else {
              return AspectRatio(
                aspectRatio: double.parse(widget.aspectRatio),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          },
          future: Future.value(true), // Dummy future, since we no longer need completer
        ),
      ),
    );
  }
}

