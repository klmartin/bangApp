import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Chat/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../providers/comment_provider.dart';
import '../screens/Widgets/small_box.dart';

class Service {
  Future<List<dynamic>> getPosts() async {
    var response = await http.get(Uri.parse(
        '$baseUrl/getPosts'));
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  Future<bool> addImage(Map<String, String> body, String filepath) async {
    print(body);
    String addimageUrl =
        '$baseUrl/imageadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      print(response);
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return data['url'];
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
    String addimageUrl =
        '$baseUrl/imagechallengadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addimageUrl =
        '$baseUrl/addChallenge';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String notificationSent = await sendNotification(
            userId,
            prefs.getString('name'),
            'Has Challenged Your Post',
            data['challengeId']);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('$baseUrl/userr'),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('token')}',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user');
    }
  }

  Future<void> likeAction(
      likeCount, isLiked, postId, likeType, isALiked, isBLiked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(
            '$baseUrl/likePost'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'like_type': likeType,
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        final updatedLikeCount = responseData['likeCount'];
        if (likeType == 'A') {
          isALiked = true;
          isBLiked = !isLiked;
        } else if (likeType == 'B') {
          isALiked = !isLiked;
          isBLiked = true;
        }

        setState(() {
          likeCount = likeCount;
          isLiked = isLiked;
          isALiked = isALiked;
          isBLiked = isBLiked;
        });
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(
            '$baseUrl/likeBangUpdate'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
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
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<dynamic>> getComments(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getComments/$postId'),
      );
              print('$baseUrl/getComments/$postId');

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
      final response = await http.get(
        Uri.parse('$baseUrl/bangUpdateComment/$postId'),
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

  Future<List<dynamic>> getBattleComments(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bangBattleComment/$postId'),
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

  // Future postComment(postId, commentText) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/postComment'),
  //       body: {
  //         'post_id': postId.toString(),
  //         'user_id': prefs.getInt('user_id').toString(), // Convert to string
  //         'body': commentText,
  //       },
  //     );
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print(e);
  //     return e;
  //   }
  // }

  Future postComment(BuildContext context, postId, commentText) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$baseUrl/postComment'),
      body: {
        'post_id': postId.toString(),
        'user_id': prefs.getInt('user_id').toString(),
        'body': commentText,
      },
    );
    final responseData = json.decode(response.body);
      // If the comment was posted successfully, update the comment count
      final commentProvider = Provider.of<CommentProvider>(context, listen: false);
      await commentProvider.getCommentCount(postId);
        // commentProvider.incrementCommentCount();

      return  jsonDecode(response.body);

  } catch (e) {
    print(e);
    throw e;
  }
}


  Future postUpdateComment(postId, commentText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/postUpdateComment'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
        },
      );
      print('data is saved');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future postBattleComment(postId, commentText) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/postBattleComment'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
          'body': commentText,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.delete(
        Uri.parse('$baseUrl/deletePost/$postId'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future acceptChallenge(postId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/acceptChallenge'),
        body: {
          'post_id': postId.toString(),
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
      final response = await http.post(
        Uri.parse(
            'https://alitaafrica.com/social-backend-laravel/api/storeToken'),
        body: {
          'user_id': id.toString(),
          'device_token': token,
        },
      );
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<String> sendNotification(userId, name, body, challengeId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://alitaafrica.com/social-backend-laravel/api/sendNotification'),
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'challengeId': challengeId.toString(),
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

  Future<bool> setUserProfile(username, bio, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getInt('user_id');
    String addimageUrl =
        'https://alitaafrica.com/social-backend-laravel/api/setUserProfile';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(username)
      ..fields.addAll(user_id as Map<String, String>)
      ..fields.addAll(bio)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return data['url'];
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<BoxData>> getBangBattle() async {
    var response = await http.get(Uri.parse(
        'https://alitaafrica.com/social-backend-laravel/api/getBangBattle'));
    var data = json.decode(response.body)['data'];

    List<BoxData> boxes = [];
    for (var item in data) {
      boxes.add(BoxData.fromJson(item));
    }

    return boxes;
  }

  Future<void> likeBattle(postId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(
            'https://alitaafrica.com/social-backend-laravel/api/likePost'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Update the like count based on the response from the API
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          // likeCount = likeCount;
        });
      } else {
        // Handle API error, if necessary
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
  }

  Future<List<ChatMessage>> getMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          'https://alitaafrica.com/social-backend-laravel/api/getMessages'),
      body: {
        'user_id': prefs.getInt('user_id').toString(),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          'https://alitaafrica.com/social-backend-laravel/api/getMessagesFromUser'),
      body: {
        'other_user_id': userId,
        'user_id': prefs.getInt('user_id').toString(),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          'https://alitaafrica.com/social-backend-laravel/api/sendMessage'),
      body: {
        'user_id': prefs.getInt('user_id').toString(),
        'receiver_id': receiverId.toString(),
        'message': message,
      },
    );

    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message');
    }
  }

  void setState(Null Function() param0) {}
}
