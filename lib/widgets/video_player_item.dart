import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String type;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl, required this.type,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(widget.type == 'video'){
      return Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: VideoPlayer(videoPlayerController),
      );
    }
    else{
      return Container(
        width: size.width,
        height: size.height,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.videoUrl,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 30, 34, 45),
            highlightColor:
            const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
            child: Container(
              color: const Color.fromARGB(255, 30, 34, 45),
            ),
          ),
        ),
      );
    }

  }
}
