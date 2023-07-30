import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FetchPosts {
  Future<List<dynamic>> getMyPosts(id) async {
    print('this is my id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var response = await http.get(Uri.parse('http://192.168.124.229/social-backend-laravel/api/getMyPosts/'+prefs.getInt('user_id').toString()));
    var data = json.decode(response.body);
    return data['data']['data'];  }
}
