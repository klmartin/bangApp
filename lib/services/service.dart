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

  Future<bool> addImage(Map<String, String> body, String filepath) async {
    print(body);
    String addimageUrl = '$baseUrl/imageadd';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    try {
      var response = await http.Response.fromStream(await request.send());
      print("this is video response");

      print(response.body);
      if (response.statusCode == 201) {
final data = jsonDecode(response.body);
   Post post = Post(
     postId: data['id'],
     userId: data['user_id'],
     name: data['user']['name'],
     image: data['image'],
     challengeImg: data['challenge_img'],
     caption: data['body'] ?? '',
     type: data['type'],
     width: data['width'],
     height: data['height'],
     likeCountA: data['like_count_A'],
     likeCountB: data['like_count_B'],
     commentCount: data['commentCount'],
     followerCount: data['user']['followerCount'],
     isLiked: data['isLiked'],
     isPinned: data['pinned'],
     challenges: data['challenges'],
     isLikedB: data['isLikedB'],
     isLikedA: data['isLikedA'],
     createdAt: data['created_at'],
   );
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

Future<Map<String, dynamic>> getPostInfo(postId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('user_id');
    final response = await http.get(Uri.parse('$baseUrl/getPostInfo/$userId/$postId'));
    return json.decode(response.body);
  }



  Future<void> likeAction(postId, likeType,userId) async {
    try {
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
          this.sendUserNotification(userId, prefs.getString('name'), body, prefs.getInt('user_id').toString(),'like',postId);
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
            'https://bangapp.pro/BangAppBackend/api/storeToken'),
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
        Uri.parse(
            'https://bangapp.pro/BangAppBackend/api/sendNotification'),
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
            'https://bangapp.pro/BangAppBackend/api/sendUserNotification'),
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
        'https://bangapp.pro/BangAppBackend/api/setUserProfile';
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
        'https://bangapp.pro/BangAppBackend/api/getBangBattle'));
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
            'https://bangapp.pro/BangAppBackend/api/likePost'),
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
          'https://bangapp.pro/BangAppBackend/api/getMessages'),
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
          'https://bangapp.pro/BangAppBackend/api/getMessagesFromUser'),
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
          'https://bangapp.pro/BangAppBackend/api/sendMessage'),
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
    final response = await http.get(Uri.parse('$baseUrl/api/v1/users/getCurrentUser'), headers: {
      'Authorization': '${ prefs.getString('token')}',
    });

    if (response.statusCode == 200) {
      setState(() {
       var  _currentUser = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load current user');
    }
  }
  void setState(Null Function() param0) {}
}
