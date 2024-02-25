import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';

import '../../nav.dart';
import '../../services/token_storage_helper.dart';

class VideoUpload extends StatefulWidget {
  final String? video;
  final Map<String, String>? body;
  const VideoUpload({Key? key, this.video, this.body}) : super(key: key);

  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  Timer? _statusTimer;
  String _processingStatus = '0';
  int? _videoId;
  bool isProcessing = false;

  @override
  void initState()  {
    super.initState();
     addImage();

  }

  @override
  void dispose() {
    super.dispose();
    _statusTimer?.cancel();
  }



  Future<void> _fetchProcessingStatus(_videoId) async {
    try {
      if (_videoId != null ) {
        final response = await http.get(
          Uri.parse('https://video.bangapp.pro/api/v1/get/video/processing-status?contentId=$_videoId'),
        );
        print(response.body);
        if (response.statusCode == 200) {
          final statusData = jsonDecode(response.body);
          final String newStatus = statusData['data']['processing_percentage'];
          print("newSta");
          print(newStatus);
          if (_processingStatus != newStatus) {
            setState(() {
              _processingStatus = newStatus;
            });
            if (_processingStatus == '100') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Nav(initialIndex: 0,video: null,videoBody: {},)),
              );
            }
          }
        } else {
          print('Failed to fetch processing status');
        }
      }
    } catch (e) {
      print('Error fetching processing status: $e');
    }
  }

  Future<bool> addImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final bodyy = widget.body;

    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
    if (bodyy != null && _processingStatus!= '100' ) {
      String addvideoUrl = 'https://video.bangapp.pro/api/v1/upload-video';
      var request = http.MultipartRequest('POST', Uri.parse(addvideoUrl))
        ..headers.addAll(headers)
        ..fields.addAll(bodyy)
        ..files.add(await http.MultipartFile.fromPath('video', widget.video!));
      try {
        var response = await http.Response.fromStream(await request.send());
        setState(() {
          isProcessing = true;
        });
        if (response.statusCode == 200) {
          final response2 = jsonDecode(response.body);
            Timer.periodic(Duration(seconds: 3), (timer) {
              _fetchProcessingStatus(response2['data']['post_id']);
            });
            return true;

        } else {
          return false;
        }
      } catch (e) {
        print('Error uploading video: $e');
        return false;
      }
    }
    // Handle other types if needed
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Column(
        children: [
          LinearProgressIndicator(
            value: int.parse(_processingStatus) / 100.0, // Ensure the value is between 0.0 and 1.0
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
          isProcessing ? Text('Processing Video...') : Text('Uploading Video...')
        ],
      ),
    );
  }
}

