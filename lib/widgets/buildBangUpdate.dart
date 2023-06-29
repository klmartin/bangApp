import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';

Object buildBangUpdate(BuildContext context, filename,type,caption) {
  if ( type == 'image') {
    return GestureDetector(
      onTap: () {
      },
      child:  Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {},
              child: CachedNetworkImage(
                imageUrl: filename,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 30, 34, 45),
                  highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                  child: Container(
                    color: const Color.fromARGB(255, 30, 34, 45),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(CupertinoIcons.chat_bubble_text, color: Colors.black, size: 40),
                SizedBox(height: 8),
                Icon(CupertinoIcons.heart, color: Colors.black, size: 40),
                SizedBox(height: 8),
                Icon(CupertinoIcons.share, color: Colors.black, size: 40),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(caption, style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  letterSpacing: -1,
                ) ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  else if (type == 'video') {
    VideoPlayerController _videoPlayerController = VideoPlayerController.network(filename);
    ChewieController _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
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
              body: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as per your video's dimensions
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoPlayerController),
            Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}
