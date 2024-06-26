import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';
import '../services/token_storage_helper.dart';

class ChallengeUploadProvider extends ChangeNotifier {
  bool _isUploading = false;
  String _uploadText = 'Uploading Image...';
  bool get isUploading => _isUploading;
  String get uploadText => _uploadText;

  Future<bool> startUpload(body, filepath,filepath2) async {

    _isUploading = true;
    _uploadText = 'Uploading Image...';
    notifyListeners();
    final token = await TokenManager.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    if (body != null) {
      String addimageUrl = '$baseUrl/imagechallengadd';
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..headers.addAll(headers)
        ..fields.addAll(body)
        ..files.add(await http.MultipartFile.fromPath('image', filepath))
        ..files.add(await http.MultipartFile.fromPath('image2', filepath2));
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
    _uploadText = 'Upload Complete';
    notifyListeners();
  }
}
