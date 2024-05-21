import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/update_video_upload.dart';

class UpdateVideoUpload extends StatefulWidget {
  @override
  _UpdateVideoUploadState createState() => _UpdateVideoUploadState();
}

class _UpdateVideoUploadState extends State<UpdateVideoUpload> {
  Timer? _statusTimer;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _statusTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final updateVideoUploadProvider = Provider.of<UpdateVideoUploadProvider>(context);
    return Container(
      height: 25,
      child: Column(
        children: [
          updateVideoUploadProvider.uploadText == "Uploading Video..."
              ? LinearProgressIndicator(
            color: Colors.red,
            backgroundColor: Colors.black,
          )
              : LinearProgressIndicator(
            value: updateVideoUploadProvider.uploadProgress / 100.0,
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
          Text(updateVideoUploadProvider.uploadText)
        ],
      ),
    );
  }
}
