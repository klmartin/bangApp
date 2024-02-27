import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../nav.dart';

import '../../providers/video_upload.dart';

class VideoUpload extends StatefulWidget {
  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  Timer? _statusTimer;

  bool isProcessing = false;

  @override
  void initState()  {

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    _statusTimer?.cancel();
  }


  @override
  // Widget build(BuildContext context) {
  //   final videoUploadProvider = Provider.of<VideoUploadProvider>(context);
  //
  //   return Container(
  //     height: 25,
  //     child: Column(
  //       children: [
  //         LinearProgressIndicator(
  //           value: videoUploadProvider.uploadProgress / 100.0, // Ensure the value is between 0.0 and 1.0
  //           color: Colors.red,
  //           backgroundColor: Colors.black,
  //         ),
  //         Text(videoUploadProvider.uploadText)
  //       ],
  //     ),
  //   );
  //
  // }

  Widget build(BuildContext context) {
    final videoUploadProvider = Provider.of<VideoUploadProvider>(context);

    return Container(
      height: 25,
      child: Column(
        children: [
          LinearProgressIndicator(
            value: videoUploadProvider.uploadProgress / 100.0,
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
          Text(videoUploadProvider.uploadText)
        ],
      ),
    );
  }



}

