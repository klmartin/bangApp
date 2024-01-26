import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerPage extends StatefulWidget {
  final String mediaUrl;
  VideoPlayerPage({required this.mediaUrl});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController? _chewieController;


  @override
  void initState()  {
    super.initState();
    initializeVideo();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      placeholder: Container(
        color: const Color.fromARGB(255, 30, 34, 45),
      ),
    );
  }

  Future<void> initializeVideo() async {
    _videoPlayerController = VideoPlayerController.network(widget.mediaUrl);
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        placeholder: Container(
          color: const Color.fromARGB(255, 30, 34, 45),
        ),
      );
    });
  }

Future<void> _progressiveDownloadVideo() async {
    final _dio = Dio();
    final response = await _dio.get(widget.mediaUrl, options: Options(responseType: ResponseType.stream));

     _videoPlayerController = VideoPlayerController.networkUrl(response as Uri);

}
  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    _progressiveDownloadVideo();
    super.dispose();
  }

  Widget buildVideoPlayer() => AspectRatio(
    aspectRatio: _videoPlayerController.value.aspectRatio,
    child: VideoPlayer(_videoPlayerController),
  );


  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    print(_videoPlayerController.value.aspectRatio);
    print('this is aspect ration of the video');
    return AspectRatio(
      aspectRatio:  _videoPlayerController.value.aspectRatio,
      child: Stack(
            children: [
              VisibilityDetector(
                key: Key('chewie_key'), // Provide a unique key
                onVisibilityChanged: (VisibilityInfo info) {
                  if (info.visibleFraction == 0.0) {
                    _chewieController?.pause();
                  } else {
                    _chewieController?.play();
                  }
                },
                child: Chewie(
                  controller: _chewieController!,
                ),
              ),
            ],
          ),

      );
  }
}

