import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:bangapp/services/token_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../providers/BoxDataProvider.dart';

class Service {
  Future<List<dynamic>> getPosts() async {
    final token = await TokenManager.getToken();
    var response = await http.get(Uri.parse('$baseUrl/getPosts'),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type':
      'application/json', // Include other headers as needed
    },);
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  Future<String> sendUserNotification1(userId, name, body, referenceId, type) async {
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
          'Content-Type':
          'application/json', // Include other headers as needed
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
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
    String addimageUrl = '$baseUrl/imageadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      prefs.setBool('i_just_posted', true);
      prefs.setBool('i_just_posted_profile', true);
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
  }

  Future<bool> addBangUpdate(Map<String, String> body, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
    String addimageUrl = '$baseUrl/addBangUpdate';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl),)
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        final response2 = jsonDecode(response.body);
        prefs.setBool('i_just_posted_bang_update', true);
        prefs.setBool('i_just_posted_profile', true);
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

  Future<bool> addChallengImage(Map<String, String> body, String filepath, String filepath2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
    String addimageUrl = '$baseUrl/imagechallengadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath))
      ..files.add(await http.MultipartFile.fromPath('image2', filepath2));
    try {
      var response = await http.Response.fromStream(await request.send());
      prefs.setBool('i_just_posted', true);
      prefs.setBool('i_just_posted_profile', true);
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

  Future<bool> addChallenge(Map<String, String> body, String filepath, int userId) async {
    final token = await TokenManager.getToken();
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
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

  Future<List<dynamic>> getPostInfo(postId, userId) async {
    final token = await TokenManager.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final response =
        await http.get(Uri.parse('$baseUrl/getPostInfo/$postId/$userId'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
        },);
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
      final response = await http.post(
        Uri.parse('$baseUrl/likeBangUpdate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
        },
        body: json.encode({
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        }),
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
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/getComments/$postId'),
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['comments'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getUpdateComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/bangUpdateComment/$postId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
      );
      if (response.statusCode == 200) {
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getBattleComments(String postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/bangBattleComment/$postId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['comments'];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return ['err'];
      // Handle exceptions, if any
    }
  }

  Future postComment(BuildContext context, postId, commentText, userId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
      print(response.body);
      print('this is app');
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
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
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
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future deletePost(postId) async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/deletePost/$postId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },
      );
      print([response, postId]);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future acceptChallenge(postId) async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/acceptChallenge'),
        body: {
          'post_id': postId.toString(),
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
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
        body: {
          'post_id': postId.toString(),
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
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
      final token = await TokenManager.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/storeToken'),
        body: {
          'user_id': id.toString(),
          'device_token': token,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
        },
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
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type': type,
          'challengeId': challengeId.toString(),
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
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
          'Content-Type':
          'application/json', // Include other headers as needed
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

  Future<void> setUserProfile(date_of_birth, String? phoneNumber, String Hobbies, occupation, bio, filepath, name) async {
    try {
      final token = await TokenManager.getToken();
      final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> body = {
        'user_id': prefs.getInt('user_id').toString(),
        'phoneNumber': phoneNumber.toString(),
        'hobbies': selectedHobbiesText,
        'date_of_birth': date_of_birth.toString(),
        'occupation': occupation,
        'bio': bio,
        'name': name
      };
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/setUserProfile'))
            ..headers.addAll(headers)
            ..fields.addAll(body)
            ..files.add(await http.MultipartFile.fromPath('image', filepath));
      var response = await http.Response.fromStream(await request.send());
      print(response);
      print('this is edit response');
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);

        setState(() {});
      } else {}
    } catch (e) {
print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<BoxData2>> getBangBattle() async {
    final token = await TokenManager.getToken();
    var response = await http.get(Uri.parse('$baseUrl/getBangBattle'),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type':
      'application/json', // Include other headers as needed
    },);
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
        body: {
          'battle_id': postId.toString(),
          'like_type': type,
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
          'application/json', // Include other headers as needed
        },
      );
      print('this is response');
      print(response.body);
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {});
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
        'Content-Type':
        'application/json', // Include other headers as needed
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
        'Content-Type':
        'application/json', // Include other headers as needed
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
        'Content-Type':
        'application/json', // Include other headers as needed
      },
    );

    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message');
    }
  }

  Future<Map<String, dynamic>> getMyInformation({int? userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    if (userId != null) {
      var response = await http.get(
        Uri.parse("$baseUrl/users/getMyInfo?user_id=$userId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Include other headers as needed
        },
      );
      var data = json.decode(response.body);
      return data;
    } else {
      var userId = prefs.getInt('user_id').toString();
      var response = await http.get(
        Uri.parse("$baseUrl/users/getMyInfo?user_id=$userId"),
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
      final response = await http.get(url,headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },);
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
      final response = await http.get(Uri.parse(apiUrl),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },);
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
      final response = await http.get(Uri.parse(apiUrl),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },);
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
        Uri.parse('$baseUrl/deleteNotification/$notificationId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
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
        Uri.parse('$baseUrl/notificationIsRead/$notificationId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },
      );
      print([response.body, notificationId]);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<void> pinMessage() async {
    try {
      final token = await TokenManager.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/pinMessage'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
        'application/json', // Include other headers as needed
      },
        body: {
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        print(responseData);
      } else {
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  void setState(Null Function() param0) {}
}
