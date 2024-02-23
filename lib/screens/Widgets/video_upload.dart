import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';

import '../../services/token_storage_helper.dart';

class VideoUpload extends StatefulWidget {
  final String? video;
  final Map<String, String> body;
  const VideoUpload({Key? key, this.video,required this.body}) : super(key: key);

  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  late Subscription _subscription;
  Timer? _statusTimer;
  int _processingStatus = 0;
  int? _videoId;

  @override
  void initState() {
    super.initState();
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('compression progress: $progress');
      // Handle the compression progress here
    });
    print("init state");
    _statusTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchProcessingStatus();
    });
    // Call addImage in initState to set _videoId
    addImage();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
    _statusTimer?.cancel();
  }

  Future<void> _fetchProcessingStatus() async {
    try {
      print("videoId");
      print(_videoId);
      // Check if _videoId is null before making the HTTP request
      if (_videoId != null) {
        final response = await http.get(
          Uri.parse('https://video.bangapp.pro/api/v1/get/video/processing-status?contentId=$_videoId'),
        );
        print(response.body);
        if (response.statusCode == 200) {
          final statusData = jsonDecode(response.body);
          final int newStatus = int.parse(statusData['data']['processing_percentage']);
          print("newSta");
          print(newStatus);
          // Update the processing status if it has changed
          if (_processingStatus != newStatus) {
            setState(() {
              _processingStatus = newStatus;
            });
            // Check if the processing is completed (status = 100)
            if (_processingStatus == 100) {
              // Processing is completed, show a message or perform further actions
              print('Video processing completed');
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
    print('boddy');
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
    if (bodyy['type'] == "video") {
      String addvideoUrl = 'https://video.bangapp.pro/api/v1/upload-video';
      var request = http.MultipartRequest('POST', Uri.parse(addvideoUrl))
        ..headers.addAll(headers)
        ..fields.addAll(bodyy)
        ..files.add(await http.MultipartFile.fromPath('video', widget.video!));
      try {
        var response = await http.Response.fromStream(await request.send());
        print(response.body);
        if (response.statusCode == 201) {
          final response2 = jsonDecode(response.body);
            print("nipoo hapa");
            print(response2['data']['post_id']);
            setState(() {
              _videoId = response2['data']['post_id'];
            });
            // Call _fetchProcessingStatus once _videoId is set
            _fetchProcessingStatus();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Compression Status: $_processingStatus%'),
            // Add other UI components as needed
          ],
        ),
      ),
    );
  }
}

