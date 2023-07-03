import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FetchPosts {

  Future<bool> getMyPosts( id ) async {
    String getMyPostsUrl = 'https://kimjotech.com/BangAppBackend/api/imageadd';
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

}
