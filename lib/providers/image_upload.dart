import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';
import '../services/token_storage_helper.dart';

class ImageUploadProvider extends ChangeNotifier {
  bool _isUploading = false;
  String _uploadText = 'Uploading Image...';
  bool get isUploading => _isUploading;
  String get uploadText => _uploadText;

  Future<bool> startUpload(body, image) async {
    _isUploading = true;
    _uploadText = 'Uploading Image...';
    print(body);
    print('imageBody');
    notifyListeners();
    final token = await TokenManager.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    if (body != null) {
      String addimageUrl = '$baseUrl/imageadd';
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..headers.addAll(headers)
        ..fields.addAll(body)
        ..files.add(await http.MultipartFile.fromPath('image', image));
      try {
        var response = await http.Response.fromStream(await request.send());

        if (response.statusCode == 201) {
          final response2 = jsonDecode(response.body);
          finishUpload();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }


  void finishUpload( ) {
    _isUploading = false;
    // _uploadProgress = 0.0;
    _uploadText = 'Upload Complete';
    notifyListeners();
  }
}
