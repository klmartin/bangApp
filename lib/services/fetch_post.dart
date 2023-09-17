import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/constants/urls.dart';

class FetchPosts {

  Future<List<dynamic>> getMyPosts(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var response = await http.get(Uri.parse('$baseUrl/getMyPosts/'+prefs.getInt('user_id').toString()));
    var data = json.decode(response.body);
    return data['data']['data'];  }

  Future<List<dynamic>> getUserPosts(id) async {
    var response = await http.get(Uri.parse('$baseUrl/getMyPosts/'+id.toString()));
    print(response.body);
    var data = json.decode(response.body);
    return data['data']['data'];  }
}
