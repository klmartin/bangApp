import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';

Future<Widget> buildBangUpdate2(BuildContext context, bangUpdate, index) async  {

  if (bangUpdate.type == 'image') {
    return Column(
      children: [
        SizedBox(height: 150),
        Stack(
          children: [
            Center(
              child: Container(
                height: 400,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: bangUpdate.filename,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 30, 34, 45),
                    highlightColor:
                        const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                    child: Container(
                      color: const Color.fromARGB(255, 30, 34, 45),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  } else if (bangUpdate.type == 'video') {
    VideoPlayerController  _videoPlayerController =
    VideoPlayerController.networkUrl(Uri.parse(bangUpdate.filename));
    await _videoPlayerController.initialize(); // Initialize the video player controller

    // Get the height and width of the video
    final videoHeight = _videoPlayerController.value.size.height;
    final videoWidth = _videoPlayerController.value.size.width;
    ChewieController _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      autoInitialize: false,
      looping: true,
      placeholder: Container(
        color: const Color.fromARGB(255, 30, 34, 45),
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: _videoPlayerController.value.isInitialized
            ? VideoPlayer(_videoPlayerController)
            : Container(), // Display an empty container if the video is not yet initialized
      ),
    );
  } else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}
