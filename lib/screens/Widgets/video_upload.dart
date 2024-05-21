import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/video_upload.dart';

class VideoUpload extends StatefulWidget {
  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  Timer? _statusTimer;

  bool isProcessing = false;

  @override
  void initState() {
    print("nina processs");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _statusTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final videoUploadProvider = Provider.of<VideoUploadProvider>(context);
    return Container(
      height: 25,
      child: Column(
        children: [
          videoUploadProvider.uploadText == "Uploading Video..."
              ? LinearProgressIndicator(
                  color: Colors.red,
                  backgroundColor: Colors.black,
                )
              : LinearProgressIndicator(
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
