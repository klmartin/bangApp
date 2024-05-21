import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:bangapp/services/token_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../models/hobby.dart';
import '../providers/BoxDataProvider.dart';

class Service {
  Future<List<dynamic>> getPosts() async {
    final token = await TokenManager.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/getPosts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  Future<String> sendUserNotification1(
      userId, name, body, referenceId, type) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/sendUserNotification'),
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type': type,
          'reference_id': referenceId,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
      // Handle exceptions, if any
    }
  }

  Future<bool> addImage(Map<String, String> body, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    print('this is body');
    print(body);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    if (body['type'] == "video") {
      print(body);
      print('this is video body');
      String addvideoUrl = 'https://video.bangapp.pro/api/v1/upload-video';
      var request = http.MultipartRequest('POST', Uri.parse(addvideoUrl))
        ..headers.addAll(headers)
        ..fields.addAll(body)
        ..files.add(await http.MultipartFile.fromPath('video', filepath));
      try {
        var response = await http.Response.fromStream(await request.send());
        prefs.setBool('i_just_posted', true);
        prefs.setBool('i_just_posted_profile', true);
        print(response.body);
        print('video uploaded');
        if (response.statusCode == 201) {
          final response2 = jsonDecode(response.body);
          if (response2['data']) {
          } else {}
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      String addimageUrl = '$baseUrl/imageadd';
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..headers.addAll(headers)
        ..fields.addAll(body)
        ..files.add(await http.MultipartFile.fromPath('image', filepath));
      try {
        var response = await http.Response.fromStream(await request.send());

        if (response.statusCode == 201) {
          final response2 = jsonDecode(response.body);
          if (response2['url']) {
          } else {}
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
  }

  Future<bool> addBangUpdate(Map<String, String> body, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    String addimageUrl = '$baseUrl/addBangUpdate';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(addimageUrl),
    )
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        final response2 = jsonDecode(response.body);

        if (response2['data']) {
        } else {
          print("No response.........");
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addChallengImage(
      Map<String, String> body, String filepath, String filepath2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    String addimageUrl = '$baseUrl/imagechallengadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath))
      ..files.add(await http.MultipartFile.fromPath('image2', filepath2));
    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addChallenge(
      Map<String, String> body, String filepath, int userId) async {
    final token = await TokenManager.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addimageUrl = '$baseUrl/addChallenge';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        String notificationSent = await sendNotification(
            userId,
            prefs.getString('name'),
            'Has Challenged Your Post',
            data['challengeId'],
            'challenge');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('$baseUrl/userr'), headers: {
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user');
    }
  }

  Future<List<dynamic>> loadMoreUpdates(pageNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id').toString();
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse(
          "$baseUrl/user-bang-updates?_page=$pageNumber&_limit=10&user_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error loading updates: $e");
      return []; // Or handle the error as needed, returning an empty list for simplicity
    }
  }

  Future<List<dynamic>> loadMoreUserUpdates(pageNumber, userId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse(
          "$baseUrl/user-bang-updates?_page=$pageNumber&_limit=10&user_id=$userId",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      return json.decode(response.body);
    } catch (e) {
      print("Error loading updates: $e");
      return []; // Or handle the error as needed, returning an empty list for simplicity
    }
  }

  Future<List<dynamic>> getPostInfo(postId) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    print([userId, postId]);
    print('this is data');
    final response = await http.get(
      Uri.parse('$baseUrl/getPostInfo/$postId/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );
    print(response.body);
    return jsonDecode(response.body);
  }

  Future<void> likeAction(postId, likeType, userId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/likePost'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'like_type': likeType,
        }),
      );
      print(response.body);
      print('this is response');
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Post liked successfully') {
          var name = prefs.getString('name');
          var body = "$name has Liked your post";
        }
      } else {
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<void> likeBangUpdate(likeCount, isLiked, postId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print([postId, prefs.getInt('user_id').toString()]);
      final response = await http.post(
        Uri.parse('$baseUrl/likeBangUpdate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        final updatedLikeCount = responseData['likeCount'];
      } else {
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<Map<String, dynamic>> getComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/getComments/$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      return {};
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getCommentReplies(String commentId) async {
    try {
      print(commentId);
      print('the postId');
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/getCommentsReplies/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData['commentsReplies'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future<int> buyFollowers(count, hobbies) async {
    try {
      print([count, hobbies]);
      print('buying followers');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await TokenManager.getToken();
      final response = await http.post(Uri.parse('$baseUrl/buyFollowers'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
          body: json.encode({
            'user_id': prefs.getInt('user_id').toString(),
            'hobbies': hobbies,
            'count': count
          }));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        print("buyFollowers response");
        return responseData['followers_added'];
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getBattleCommentReplies(String commentId) async {
    try {
      print(commentId);
      print('the postId');
      print('$baseUrl/getBattleCommentsReplies/$commentId');
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/getBattleCommentsReplies/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData['commentsReplies'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getUpdateCommentReplies(String commentId) async {
    try {
      print(commentId);
      print('the postId');
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/getUpdateCommentsReplies/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData['commentsReplies'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future<List<Hobby>> fetchHobbies() async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cacheKey = 'cached_hobby';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;
    final String cachedData = prefs.getString(cacheKey) ?? '';
    var minutes = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
        .inMinutes;

    if (minutes > 1000 || cachedData.isEmpty) {
      final response = await http.get(
        Uri.parse('$baseUrl/hobbies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        prefs.setString(cacheKey, response.body);
        prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Hobby.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hobbies');
      }
    } else {
      if (cachedData.isNotEmpty) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((json) => Hobby.fromJson(json)).toList();
      } else {
        final response = await http.get(
          Uri.parse('$baseUrl/hobbies'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          prefs.setString(cacheKey, response.body);
          prefs.setInt(
              '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Hobby.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load hobbies');
        }
      }
    }
  }

  Future<Map<String, dynamic>> getUpdateComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/bangUpdateComment/$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> getBattleComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/bangBattleComment/$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print(e);
      return {};
      // Handle exceptions, if any
    }
  }

  Future<Map<String, dynamic>> postComment(
      BuildContext context, postId, commentText, userId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print([postId, commentText, prefs.getInt('user_id')]);
      print('this is token');
      final response = await http.post(
        Uri.parse('$baseUrl/postComment'),
        body: jsonEncode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(),
          'body': commentText,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future postCommentReply(
      BuildContext context, postId, commentId, commentText) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print([commentId, commentText, prefs.getInt('user_id')]);
      final response = await http.post(
        Uri.parse('$baseUrl/postCommentReply'),
        body: jsonEncode({
          'comment_id': commentId.toString(),
          'user_id': prefs.getInt('user_id').toString(),
          'body': commentText,
          'post_id': postId,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future postUpdateCommentReply(
      BuildContext context, postId, commentId, commentText) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print([commentId, commentText, prefs.getInt('user_id')]);
      final response = await http.post(
        Uri.parse('$baseUrl/postUpdateCommentReply'),
        body: jsonEncode({
          'comment_id': commentId.toString(),
          'user_id': prefs.getInt('user_id').toString(),
          'body': commentText,
          'post_id': postId,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future postBattleCommentReply(
      BuildContext context, postId, commentId, commentText) async {
    try {
      print([postId, commentId, commentText]);
      print('this is commentreply data');
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print([commentId, commentText, prefs.getInt('user_id')]);
      final response = await http.post(
        Uri.parse('$baseUrl/postBattleCommentReply'),
        body: jsonEncode({
          'comment_id': commentId.toString(),
          'user_id': prefs.getInt('user_id').toString(),
          'body': commentText,
          'post_id': postId,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future postUpdateComment(postId, commentText) async {
    final token = await TokenManager.getToken();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        Uri.parse('$baseUrl/postUpdateComment'),
        body: jsonEncode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future postBattleComment(postId, commentText) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/postBattleComment'),
        body: jsonEncode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Map<String, dynamic>> deletePost(postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/deletePost/$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        // Handle the case where response.body is empty
        return {'error': 'Empty response body'};
      }
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteComment(commentId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/deleteComment/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        // Handle the case where response.body is empty
        return {'error': 'Empty response body'};
      }
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteBattleComment(commentId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/deleteBattleComment/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        // Handle the case where response.body is empty
        return {'error': 'Empty response body'};
      }
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteUpdateComment(commentId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/deleteUpdateComment/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Empty response body'};
      }
    } catch (e) {
      print(e);
      return {'error': e.toString()};
    }
  }

  Future acceptChallenge(postId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/acceptChallenge'),
        body: jsonEncode({
          'post_id': postId.toString(),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      prefs.setBool('i_just_posted', true);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future declineChallenge(postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/declineChallenge'),
        body: jsonEncode({
          'post_id': postId.toString(),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future sendTokenToBackend(token, id) async {
    try {
      final authToken = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/storeToken'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: jsonEncode({
          'user_id': id,
          'device_token': token,
        }),
      );
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<String> sendNotification(userId, name, body, challengeId, type) async {
    try {
      final token = await TokenManager.getToken();
      print("nimefika kwenye notification");
      final response = await http.post(
        Uri.parse('$baseUrl/sendNotification'),
        body: jsonEncode({
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type': type,
          'challengeId': challengeId.toString(),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
      // Handle exceptions, if any
    }
  }

  Future<String> sendUserNotification(
      userId, name, body, referenceId, type, postId) async {
    final token = await TokenManager.getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendUserNotification'),
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type': type,
          'post_id': postId,
          'reference_id': referenceId,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
      // Handle exceptions, if any
    }
  }

  Future<void> setUserProfile(
    dateOfBirth,
    String? phoneNumber,
    String Hobbies,
    occupation,
    bio,
    filepath,
    name,
  ) async {
    try {
      final token = await TokenManager.getToken();
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> body = {
        'user_id': prefs.getInt('user_id').toString(),
        'phoneNumber': phoneNumber?.toString() ??
            '', // Check for null before converting to string
        'hobbies': selectedHobbiesText,
        'date_of_birth': dateOfBirth.toString(),
        'occupation': occupation,
        'bio': bio,
        'name': name
      };

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/setUserProfile'))
            ..headers.addAll(headers)
            ..fields.addAll(body);

      // Add the file path only if it is not null
      if (filepath != null) {
        request.files.add(await http.MultipartFile.fromPath('image', filepath));
      }

      var response = await http.Response.fromStream(await request.send());
      print(response);
      print('this is edit response');
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
      } else {
        // Handle other response codes or errors
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<BoxData2>> getBangBattle() async {
    final token = await TokenManager.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/getBangBattle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );
    var data = json.decode(response.body)['data'];

    List<BoxData2> boxes = [];
    for (var item in data) {
      boxes.add(BoxData2.fromJson(item));
    }
    return boxes;
  }

  Future<void> likeBattle(postId, type) async {
    final token = await TokenManager.getToken();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/likeBangBattle'),
        body: jsonEncode({
          'battle_id': postId.toString(),
          'like_type': type,
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print('this is response');
      print(response.body);
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        print(responseData);
      } else {}
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<ChatMessage>> getMessage() async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$baseUrl/getMessages'),
      body: {
        'user_id': prefs.getInt('user_id').toString(),
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;

      List<ChatMessage> messages = [];
      for (var item in data) {
        messages.add(ChatMessage.fromJson(item));
      }
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<List<ChatMessage>> getMessages(userId) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$baseUrl/getMessagesFromUser'),
      body: {
        'other_user_id': userId,
        'user_id': prefs.getInt('user_id').toString(),
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;

      List<ChatMessage> messages = [];
      for (var item in data) {
        messages.add(ChatMessage.fromJson(item));
      }
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(receiverId, String message) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      body: {
        'user_id': prefs.getInt('user_id').toString(),
        'receiver_id': receiverId.toString(),
        'message': message,
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );

    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message');
    }
  }

  Future<Map<String, dynamic>> getMyInformation({int? userId}) async {
    print("im here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final viewerId = prefs.getInt('user_id');
    final token = await TokenManager.getToken();
    print("$baseUrl/users/getMyInfo?user_id=$userId?&viewer_id=$viewerId");
    if (userId != null) {
      var response = await http.get(
        Uri.parse(
            "$baseUrl/users/getMyInfo?user_id=$userId?&viewer_id=$viewerId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print(response.body);
      var data = json.decode(response.body);
      return data;
    } else {
      var userId = prefs.getInt('user_id').toString();
      var response = await http.get(
        Uri.parse(
            "$baseUrl/users/getMyInfo?user_id=$userId?&viewer_id=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      var data = json.decode(response.body);
      return data;
    }
  }

  Future<int> fetchNotificationCount() async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final url = Uri.parse('$baseUrl/getNotificationCount/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('notification_count')) {
          final notificationCount = jsonResponse['notification_count'];
          return notificationCount;
        } else {
          return 0; // Or handle this case as needed
        }
      } else {
        // If the request was not successful (e.g., 404, 500, etc.)
        return 0; // Or handle this case as needed
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      return 0; // Or handle this case as needed
    }
  }

  Future<void> updateIsSeen(int postId) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final apiUrl =
        '$baseUrl/updateIsSeen/$postId/$userId'; // Replace with your actual API URL
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
      } else {
        // Handle errors if needed
        print('Failed to update post $postId');
      }
    } catch (e) {
      // Handle exceptions if needed
      print('Exception: $e');
    }
  }

  Future<void> updateBangUpdateIsSeen(int postId) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final apiUrl =
        '$baseUrl/updateBangUpdateIsSeen/$postId/$userId'; // Replace with your actual API URL
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
      } else {
        // Handle errors if needed
        print('Failed to update post $postId');
      }
    } catch (e) {
      // Handle exceptions if needed
      print('Exception: $e');
    }
  }

  Future deleteNotification(notificationId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/deleteNotification/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print([response.body, notificationId]);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future notificationIsRead(notificationId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/notificationIsRead/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      print([response.body, notificationId]);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Map<String, dynamic>> pinMessage() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/pinMessage'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: jsonEncode({
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> pinProfile() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/pinProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: jsonEncode({
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        }),
      );
      print(response.body);
      print('pin profile response');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> setUserPinPrice(price) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/setUserPinPrice'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: jsonEncode({
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'price': price
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> setUserPinProfilePrice(price) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/setUserPinProfilePrice'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: jsonEncode({
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'price': price
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteUserAccount() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id').toString();
      final response = await http.get(
        Uri.parse('$baseUrl/deleteUserAccount/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getResetLink(email) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/resetPassword/$email'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> editPost(postId, caption) async {
    print([postId, caption]);
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/editPost'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'id': postId,
          'caption': caption,
        }),
      );
      print('this is edit response');
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      print('error');
      return {};
    }
  }

  Future<Map<String, dynamic>> reportPost(postId, reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id').toString();
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/reportPost'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json
            .encode({'post_id': postId, 'user_id': userId, 'reason': reason}),
      );
      print('this is report response');
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      print('error');
      return {};
    }
  }

  Future<Map<String, dynamic>> subscribeUser(userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/subscribe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'subscriber_id': prefs.getInt('user_id').toString(),
          'user_id': userId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      print('error');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchUserInsight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/insights/${prefs.getInt('user_id').toString()}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      print('error');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getSuggestedFriends(contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userId = prefs.getInt('user_id').toString();
      final String cacheKey = 'cached_friends';
      final token = await TokenManager.getToken();
      final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;
      var minutes = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
          .inMinutes;
      final String cachedData = prefs.getString(cacheKey) ?? '';
      var response = "";
      if (minutes > 5 || cachedData.isEmpty) {
        final res = await http.post(
          Uri.parse('$baseUrl/getSuggestedFriends'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
          body: json.encode({
            'user_id': prefs.getInt('user_id').toString(),
            'contacts': contacts,
          }),
        );
        if (res.statusCode == 200) {
          prefs.setInt(
              '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
          response = json.decode(res.body);
          prefs.setString(cacheKey, json.encode(response));
        }
      } else {
        response = json.decode(cachedData);
      }
      final responseData = json.decode(response);

      return List<Map<String, dynamic>>.from(responseData['suggested_friends']);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFriends({userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = userId ?? prefs.getInt('user_id');
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/allFriends/${user_id.toString()}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        return List<Map<String, dynamic>>.from(responseData['friends']);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowers({userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = userId ?? prefs.getInt('user_id');
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/allFollowers/${user_id.toString()}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        return List<Map<String, dynamic>>.from(responseData['followers']);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> requestFriendship(friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/requestFriendship'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'user_id': prefs.getInt('user_id').toString(),
          'friend_id': friendId,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> acceptFriendship(friendship_id) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/acceptFriendship'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'friendship_id': friendship_id,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('message')) {
        return responseData['message'];
      } else {
        return responseData['error'];
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> declineFriendShip(friendship_id) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/declineFriendship'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'friendship_id': friendship_id,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('message')) {
        return responseData['message'];
      } else {
        return responseData['error'];
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> showFewerPost(imagePostId, imageUserId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id');
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/fewerPosts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({
          'user_id': userId,
          'user_post_id': imageUserId,
          'post_id': imagePostId,
        }),
      );
      print(response.body);
      print('show fewer post');
      final responseData = json.decode(response.body);
      return responseData['message'];
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> removeFriendship(imageUserId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id');
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/deleteFriendship'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({'user_id': userId, 'friend_id': imageUserId}),
      );
      final responseData = json.decode(response.body);
      return responseData['message'];
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> blockUser(imageUserId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id');
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/blockUser'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({'user_id': userId, 'blocked_user_id': imageUserId}),
      );
      print(response.body);
      print('block user');
      final responseData = json.decode(response.body);

      return responseData['message'];
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<List<dynamic>> getBlockedUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse(
            '$baseUrl/getBlockedUsers/${prefs.getInt('user_id').toString()}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData["users_blocked"];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      print('error');
      return [];
    }
  }

  Future<String> unblockUser(blockedUserId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id');
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/unblockUser'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
        body: json.encode({'user_id': userId, 'blocked_user_id': blockedUserId}),
      );
      print(response.body);
      print('block user');
      final responseData = json.decode(response.body);

      return responseData['message'];
    } catch (e) {
      print(e);
      return "";
    }
  }
}
