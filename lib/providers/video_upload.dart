import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/token_storage_helper.dart';

class VideoUploadProvider extends ChangeNotifier {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadText = 'Uploading Video...';
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String get uploadText => _uploadText;
  Timer? _processingStatusTimer;

  Future<bool> startUpload(body,video) async {
    _isUploading = true;
   _uploadText = 'Uploading Video...';
    print('Is Uploading after setting to true: $_isUploading');
    notifyListeners();
      final token = await TokenManager.getToken();
      final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
      if (body != null ) {
        String addVideoUrl = 'https://video.bangapp.pro/api/v1/upload-video';
        var request = http.MultipartRequest('POST', Uri.parse(addVideoUrl))
          ..headers.addAll(headers)
          ..fields.addAll(body)
          ..files.add(await http.MultipartFile.fromPath('video', video!));
        try {
          var response = await http.Response.fromStream(await request.send());
          print("${response.body} this is video upload response");
          if (response.statusCode == 200) {
            final response2 = jsonDecode(response.body);
            _uploadText = 'Processing Video...';
            _processingStatusTimer = Timer.periodic(Duration(seconds: 3), (timer) {
              _fetchProcessingStatus(response2['data']['post_id']);
              notifyListeners();
            });
            return true;

          } else {
            return false;
          }
        } catch (e) {

          return false;
        }
      }
      return false;

  }

  void updateProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

Future<void> _fetchProcessingStatus(_videoId) async {
  try {
    if (_videoId != null ) {
      final response = await http.get(
        Uri.parse('https://video.bangapp.pro/api/v1/get/video/processing-status?contentId=$_videoId'),
      );
      if (response.statusCode == 200) {
        final statusData = jsonDecode(response.body);
        final String newStatus = statusData['data']['processing_percentage'];

        if (_uploadProgress != double.parse(newStatus)) {
          updateProgress(double.parse(newStatus));
          if (_uploadProgress == double.parse('100')) {
            finishUpload();
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

  void finishUpload( ) {
    _isUploading = false;
    _uploadProgress = 0.0;
    _uploadText = 'Upload Complete';
    _processingStatusTimer?.cancel(); // Cancel the timer when upload is complete
    notifyListeners();
  }
}
