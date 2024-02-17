import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

Widget? buildBangUpdate(BuildContext context, filename,type,caption,postId,likeCount,index) {
  if ( type == 'image') {
    return GestureDetector(
      onTap: () {
      },
      child:  Stack(
        children: [
          Text("Chemba ya Umbea",style:TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w700,fontFamily: 'Metropolis',letterSpacing: -1)),
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
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as per your video's dimensions
        child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoPlayerController),
            ],
        ),
      ),
          ),
      ]
      )

    );
  }
  else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}
