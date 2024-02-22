import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

VideoPlayerController? activeController;

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
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  final UniqueKey stickyKey = UniqueKey();
  bool isControllerReady = false;
  bool isPlaying = false;

  Completer videoPlayerInitializedCompleter = Completer();

  //: check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

//:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      ///to do
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (videoController != null) {
      await videoController?.dispose().then((_) {
        isControllerReady = false;

        videoController = null;

        videoPlayerInitializedCompleter = Completer(); // resets the Completer
      });
      if (chewieController != null) {
        chewieController!.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: double.parse(widget.aspectRatio),
      child: VisibilityDetector(
        key: stickyKey,
        onVisibilityChanged: (VisibilityInfo info) async {
          if (info.visibleFraction > 0.70) {
            final fileInfo = await checkCacheFor(widget.cachingVideoUrl);
            if (fileInfo == null) {
              if (videoController == null) {
                videoController = VideoPlayerController.network(widget.videoUrl);

                videoController!.initialize().then((_) async {
                  videoPlayerInitializedCompleter.complete(true);
                  if (mounted) {
                    cachedForUrl(widget.cachingVideoUrl);
                    setState(() {
                      isControllerReady = true;
                    });
                  }

                  videoController!.setLooping(false);
                  videoController!.setVolume(0.0);

                  chewieController = ChewieController(
                    videoPlayerController: videoController!,
                    showControlsOnInitialize: true,
                    allowFullScreen: true,
                    looping: true,
                    useRootNavigator: false,
                    zoomAndPan: true,
                    autoPlay:  true,
                    aspectRatio: double.parse(widget.aspectRatio),
                    showControls: true,
                  );
                });
              }
            } else {
              if (videoController == null) {
                final file = fileInfo.file;
                videoController = VideoPlayerController.file(file);
                videoController!.initialize().then((_) async {
                  videoPlayerInitializedCompleter.complete(true);
                  if (mounted) {
                    setState(() {
                      isControllerReady = true;
                    });
                  }

                  videoController!.setLooping(false);
                  videoController!.setVolume(0.0);

                  chewieController = ChewieController(
                    videoPlayerController: videoController!,
                    showControlsOnInitialize: true,
                    allowFullScreen: true,
                    useRootNavigator: false,
                    looping: true,
                    zoomAndPan: true,
                    autoPlay: true,
                    aspectRatio: double.parse(widget.aspectRatio),
                    showControls: true,
                  );
                });
              }
            }
          } else if (info.visibleFraction < 0.30) {
            if (mounted) {
              setState(() {
                isControllerReady = true;
              });
            }

            videoController?.pause();
            if (mounted) {
              setState(() {
                isPlaying = false;
              });
            }
            // //debugPrint("Am here ####");
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   //debugPrint("Am here");
            //   //   if (activeController == videoController) {
            //   //     activeController = null;
            //   //   }

            //   //   videoController?.dispose().then((_) {
            //   //     if (mounted) {
            //   //       setState(() {
            //   //         videoController = null;

            //   //         videoPlayerInitializedCompleter =
            //   //             Completer(); // resets the Completer
            //   //       });
            //   //     }
            //   //   });
            //   //   // chewieController!.dispose();
            // });
          }
        },
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                videoController != null &&
                isControllerReady) {
              return Chewie(key: widget.key, controller: chewieController!);
            }

            return AspectRatio(
              aspectRatio: double.parse(widget.aspectRatio),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: const Center(
                //   child: SpinKitFadingCircle(
                //     color: AppColors.greenColor,
                //     size: 30,
                //   ),
                // ),
              ),
            );
          },
          future: videoPlayerInitializedCompleter.future,
        ),
      ),
    );
  }
}
