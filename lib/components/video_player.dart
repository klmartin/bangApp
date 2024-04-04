import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor/image_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool? isMuted ;


  Completer videoPlayerInitializedCompleter = Completer();
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
  void initState()  {
    _initializePreferences();

    super.initState();
  }
  void _initializePreferences() async {
    print('nimeingia hapa lu mue video');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isMuted = prefs.getBool('isMuted') ?? false; // Ensure a default value if 'isMuted' is not set
    });

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
                videoController =
                    VideoPlayerController.network(widget.videoUrl);

                videoController!.initialize().then((_) async {
                  videoPlayerInitializedCompleter.complete(true);
                  if (mounted) {
                    cachedForUrl(widget.cachingVideoUrl);
                    setState(() {
                      isControllerReady = true;
                    });
                  }
                  chewieController = ChewieController(
                      videoPlayerController: videoController!,
                      showControlsOnInitialize: true,
                      allowFullScreen: true,
                      looping: true,
                      allowMuting: true,
                      useRootNavigator: false,
                      zoomAndPan: true,
                      autoPlay: true,
                      aspectRatio: double.parse(widget.aspectRatio),
                      showControls: true,
                      additionalOptions: (context) {
                        return <OptionItem>[
                          OptionItem(
                              onTap: () async {
                                bool newMutedValue = !isMuted!;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isMuted', !isMuted!);
                                setState(() {
                                  isMuted = !isMuted!;
                                });
                                if (newMutedValue) {
                                  videoController!.setVolume(0.0); // Mute the video
                                } else {
                                  videoController!.setVolume(1.0); // Unmute the video
                                }
                                Fluttertoast.showToast(msg:isMuted! ?  "Muted All Videos" :"Un-Muted All Videos");

                              },
                              iconData: isMuted! ? Icons.volume_mute : Icons.volume_up,
                              title: isMuted! ?  "Un-Mute All Videos" : "Mute All Videos"),
                        ];
                      });
                });
                if (isMuted == true) {
                  videoController?.setVolume(0.0); // Mute the video if isMuted is true
                } else {
                  videoController?.setVolume(1.0); // Unmute the video if isMuted is false
                }
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
                  chewieController = ChewieController(
                      videoPlayerController: videoController!,
                      showControlsOnInitialize: true,
                      allowFullScreen: true,
                      useRootNavigator: false,
                      looping: true,
                      zoomAndPan: true,
                      allowMuting: true,
                      autoPlay: true,
                      aspectRatio: double.parse(widget.aspectRatio),
                      showControls: true,
                      additionalOptions: (context) {
                        return <OptionItem>[
                          OptionItem(
                              onTap: () async {
                                bool newMutedValue = !isMuted!;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isMuted', !isMuted!);
                                setState(() {
                                  isMuted = !isMuted!;
                                });
                                if (newMutedValue) {
                                  videoController!.setVolume(0.0); // Mute the video
                                } else {
                                  videoController!.setVolume(1.0); // Unmute the video
                                }
                                Fluttertoast.showToast(msg: isMuted! ?  "Muted All Videos" :"Un-Muted All Videos" );
                              },
                              iconData: isMuted! ? Icons.volume_mute : Icons.volume_up,
                              title: isMuted! ?  "Un-Mute All Videos" : "Mute All Videos"),
                        ];
                      });
                });
                if (isMuted == true) {
                  videoController?.setVolume(0.0); // Mute the video if isMuted is true
                } else {
                  videoController?.setVolume(1.0); // Unmute the video if isMuted is false
                }
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
              ),
            );
          },
          future: videoPlayerInitializedCompleter.future,
        ),
      ),
    );
  }
}
