import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FetchPosts {

  Future<List<dynamic>> getMyPosts(id) async {
    print('this is my id');
    print(id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse('https://citsapps.com/social-backend-laravel/api/getMyPosts/'+prefs.getInt('user_id').toString()));
    var data = json.decode(response.body);
    return data['data']['data'];  }
}
