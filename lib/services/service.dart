import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/models/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../screens/Widgets/small_box.dart';

class Service {
  Future<List<dynamic>> getPosts() async {
    var response = await http.get(Uri.parse('$baseUrl/getPosts'));
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  Future<String> sendUserNotification1(userId, name, body,referenceId,type) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/sendUserNotification'),
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type':type,
          'reference_id':referenceId,
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
    print(body);
    String addimageUrl = '$baseUrl/imageadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());


      print(response.body);
      if (response.statusCode == 201) {
        print("Created:::::::::::::::");
        final response2 = jsonDecode(response.body);

        if (response2['data']) {
            print(response2['data']);

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
    String addimageUrl = '$baseUrl/imagechallengadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath))
      ..files.add(await http.MultipartFile.fromPath('image2', filepath2));
    try {
      var response = await http.Response.fromStream(await request.send());
      print(response.body);
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
    String addimageUrl = '$baseUrl/addChallenge';
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
    final response = await http.get(Uri.parse('$baseUrl/userr'), headers: {
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user');
    }
  }

Future<List<dynamic>> getPostInfo(postId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final response = await http.get(Uri.parse('$baseUrl/getPostInfo/$postId'));
    print(response.body);
    return jsonDecode(response.body);
  }



  Future<void> likeAction(postId, likeType,userId) async {
    try {
      print([likeType,postId]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/likePost'),
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
        if(responseData['message']=='Post liked successfully'){
          var name = prefs.getString('name');
          var body = "$name has Liked your post";
          print(this.sendUserNotification(userId, prefs.getString('name'), body, prefs.getInt('user_id').toString(),'like',postId));

        }
        print(postId);
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
        Uri.parse('$baseUrl/likeBangUpdate'),
        body: {
          'post_id': postId.toString(),
          'user_id': prefs.getInt('user_id').toString(), // Convert to string
        },
      );
      print(postId);
      print(prefs.getInt('user_id'));
      print(response.body);
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

  Future postComment(BuildContext context, postId, commentText,userId) async {
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
      var name = prefs.getString('name');
      var body = "$name has Commented on your post";
      this.sendUserNotification(userId, prefs.getString('name'), body, prefs.getInt('user_id').toString(),'comment',postId);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future postUpdateComment(postId, commentText) async {
                    print(Uri.parse('$baseUrl/postUpdateComment'));
                    print(postId);

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
      print(response.body);
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
      final response = await http.delete(
        Uri.parse('$baseUrl/deletePost/$postId'),
      );
      print([response,postId]);
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
        Uri.parse('$baseUrl/storeToken'),
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

  Future<String> sendNotification(userId, name, body, challengeId ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendNotification'),
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


  Future<String> sendUserNotification(userId, name, body,referenceId,type,postId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/sendUserNotification'),
        body: {
          'user_id': userId.toString(),
          'heading': name,
          'body': body,
          'type':type,
          'post_id':postId,
          'reference_id':referenceId,
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
        '$baseUrl/setUserProfile';
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
    var response = await http
        .get(Uri.parse('$baseUrl/getBangBattle'));
    var data = json.decode(response.body)['data'];

    List<BoxData> boxes = [];
    for (var item in data) {
      boxes.add(BoxData.fromJson(item));
    }

    return boxes;
  }

  Future<void> likeBattle(postId,type) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('$baseUrl/likeBangBattle'),
        body: {
          'battle_id': postId.toString(),
          'like_type': type,
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
      Uri.parse('$baseUrl/getMessages'),
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
      Uri.parse('$baseUrl/getMessagesFromUser'),
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
      Uri.parse('$baseUrl/sendMessage'),
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

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/users/getCurrentUser'), headers: {
      'Authorization': '${prefs.getString('token')}',
    });

    if (response.statusCode == 200) {
      setState(() {
        var _currentUser = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load current user');
    }
  }

  Future<int> fetchNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final url = Uri.parse('$baseUrl/getNotificationCount/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('notification_count')) {
          final notificationCount = jsonResponse['notification_count'];
          return notificationCount;
        } else {
          // If the 'notification_count' key is not present in the JSON response
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

  void setState(Null Function() param0) {}
}
