import 'package:bangapp/message/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:bangapp/constants/urls.dart';

import '../message/constants.dart';
class VideoRect extends StatefulWidget {
  final String?  message;

  const VideoRect({Key? key, this.message}) : super(key: key);

  @override
  _VideoRectState createState() => _VideoRectState();
}

class _VideoRectState extends State<VideoRect> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.message!)) // replace with your video file path
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return Scaffold(
                body: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close full screen on tap
                  },
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: VideoPlayer(_controller),
              ),
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
