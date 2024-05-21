import 'dart:convert';
import 'package:bangapp/services/token_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiCacheHelper {
  final String baseUrl;
  final int numberOfPostsPerRequest;

  ApiCacheHelper({
    required this.baseUrl,
    required this.numberOfPostsPerRequest,
  });

  Future<Map<dynamic, dynamic>> getCachedData({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    var data = {};
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    if (cachedData.isNotEmpty && minutes <= 3 || iJustPosted != true) {
      data = json.decode(cachedData);
    } else {
      data = await apiCall();
      prefs.setString(cacheKey, json.encode(data));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    }
    return data;
  }

  Future<List<dynamic>> getCachedData2({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted_profile');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    var data = {};
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    if (cachedData.isNotEmpty && minutes > 3) {
      data = json.decode(cachedData);
    } else {
      data = await apiCall();
      prefs.setString(cacheKey, json.encode(data));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    }
    print(data);
    print('this is data');
    return data['data']['data'];
  }

  Future<List<dynamic>> getCachedData5({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted_profile');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    var data = {};
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    data = await apiCall();
    prefs.setString(cacheKey, json.encode(data));
    prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

    print(data);
    print('this is data');
    return data['data']['data'];
  }

  Future<List<dynamic>> getCachedData3({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    List<dynamic> data;
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    if (cachedData.isNotEmpty && minutes <= 3 && iJustPosted != true) {
      print(cachedData);
      print("hello cache data");
      data = json.decode(cachedData);
    } else {
      data = await apiCall();
      prefs.setString(cacheKey, json.encode(data));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    }

    return data;
  }

  Future<List<dynamic>> getCachedData6({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    List<dynamic> data;

    data = await apiCall();
    prefs.setString(cacheKey, json.encode(data));
    prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

    return data;
  }

  Future<List<dynamic>> getCachedData4({
    required String cacheKey,
    required Function apiCall,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final iJustPosted = prefs.getBool('i_just_posted');
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;

    List<dynamic> data;
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    if (cachedData.isNotEmpty && minutes <= 3000000000) {
      print(cachedData);
      data = json.decode(cachedData);
    } else {
      data = await apiCall();
      prefs.setString(cacheKey, json.encode(data));
      prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    }

    return data;
  }

  Future<Map<dynamic, dynamic>> fetchData({required int pageNumber}) async {
    final token = await TokenManager.getToken();
    return getCachedData(
      cacheKey: 'cached_posts',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            '$baseUrl/getPost?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> getMyPosts({required int pageNumber}) async {
    final token = await TokenManager.getToken();
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id').toString();
    print(
      "$baseUrl/getMyPosts?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
    );
    return getCachedData2(
      cacheKey: 'cached_profile_posts',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/getMyPosts?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId&viewer_id=$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> getUserPost({required int pageNumber, userId}) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final viewerId = prefs.getInt('user_id').toString();

    print(token);
    print(
        "$baseUrl/getMyPosts?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId&viewer_id=$viewerId");
    return getCachedData5(
      cacheKey: 'cached_user_profile_posts_$userId',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final viewerId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/getMyPosts?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId&viewer_id=$viewerId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> fetchPostData({required int pageNumber}) async {
    final token = await TokenManager.getToken();
    return getCachedData3(
      cacheKey: 'cached_fetch_post_data',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/getPost?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );

        if (response.statusCode == 200) {
          print(json.decode(response.body));
          print(
              "$baseUrl/getPost?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId");

          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> getMyUpdate({required int pageNumber}) async {
    final token = await TokenManager.getToken();
    return getCachedData3(
      cacheKey: 'cached_get_my_update',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();

        final response = await http.get(
          Uri.parse(
            "$baseUrl/user-bang-updates?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          print(json.decode(response.body));
          print('this is reposnse');
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> getUserUpdate({required int pageNumber, userId}) async {
    final token = await TokenManager.getToken();
    return getCachedData3(
      cacheKey: 'cached_fetch_post_data_$userId',
      apiCall: () async {
        final response = await http.get(
          Uri.parse(
            "$baseUrl/user-bang-updates?_page=$pageNumber&_limit=$numberOfPostsPerRequest&user_id=$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> fetchBangUpdates({required int pageNumber}) async {
    final token = await TokenManager.getToken();
    return getCachedData6(
      cacheKey: 'cached_get_my_update',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/bang-updates/user_id=$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        print('chembea');

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> fetchHobbies() async {
    final token = await TokenManager.getToken();
    print(token);
    return getCachedData4(
      cacheKey: 'cached_get_hobbies',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/hobbies",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          print(response.body);
          print('this is response');
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }

  Future<List<dynamic>> getMyNotification() async {
    final token = await TokenManager.getToken();
    return getCachedData3(
      cacheKey: 'cached_get_my_update',
      apiCall: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id').toString();
        final response = await http.get(
          Uri.parse(
            "$baseUrl/getNotifications/$userId",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        if (response.statusCode == 200) {
          print(json.decode(response.body));
          print('this is notification reposnse');
          return json.decode(response.body);
        } else {
          // Handle server error
          throw Exception('Failed to load data');
        }
      },
    );
  }
}
