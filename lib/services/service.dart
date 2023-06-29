import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  Object get uid => null;
  Future<bool> addImage(Map<String, String> body, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addimageUrl = 'https://kimjotech.com/BangAppBackend/api/imageadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return data['url'];
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addChallengImage(Map<String, String> body, String filepath,String filepath2) async {
    String addimageUrl = 'https://kimjotech.com/BangAppBackend/api/imagechallengadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath))
      ..files.add(await http.MultipartFile.fromPath('image2', filepath2));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return data['url'];
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('https://kimjotech.com/BangAppBackend/api/userr'),
          headers: {
            'Authorization': 'Bearer ${ prefs.getString('token')}',
          });
    if (response.statusCode == 200) {
      print('current User${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user');
    }
  }

  void likeAction(likeCount,isLiked) async {
    print("martin");
    try {
      // Make a POST request to the Laravel API route for liking
      final response = await http.post(Uri.parse('https://your-laravel-api.com/like'),
        body: {
          'itemId': 'your-item-id',
          'userId': 'your-user-id',
        },
      );
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        final updatedLikeCount = responseData['likeCount'];
        setState(() {
          likeCount = updatedLikeCount;
          isLiked = !isLiked;
        });
      } else {
        // Handle API error, if necessary
      }
    } catch (e) {
      // Handle exceptions, if any
    }
  }

  void setState(Null Function() param0) {}

}
