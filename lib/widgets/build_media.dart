import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';



Widget buildMediaWidget(BuildContext context, String mediaUrl, String mediaType,imgWidth,imgHeight) {
  if (mediaType == 'image') {
    return GestureDetector(
      onTap: () {
        viewImage(context, mediaUrl);
      },
      child: CachedNetworkImage(
        imageUrl: mediaUrl,
        placeholder: (context, url) => AspectRatio(
          aspectRatio: imgWidth / imgHeight,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 30, 34, 45),
            highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
            child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
          ),
        ),
      ),
    );
  } else if (mediaType == 'video') {
    return GestureDetector(
      onTap: () {
        // Play the video
      },
      child: Chewie(
        controller: ChewieController(
          videoPlayerController: VideoPlayerController.network(mediaUrl),
          autoPlay: false,
          looping: false,
          placeholder: Container(
            color: const Color.fromARGB(255, 30, 34, 45),
          ),
        ),
      ),
    );
  } else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}

void viewImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: SizedBox.expand(
          child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}

