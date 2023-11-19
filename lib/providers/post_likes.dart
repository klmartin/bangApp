import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class UserLikesProvider extends ChangeNotifier {
      final List<dynamic> _likedUsers = [];

  get likedUsers => _likedUsers;

  Future<void> getUserLikedPost(int postId) async {

  try {
    final url = Uri.parse("$baseUrl/getPostLikes/$postId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _likedUsers.clear();
      _likedUsers.addAll(
        (data['liked_users'] as List)
            .map((user) => User.fromJson(user))
            .toList(),
      );
      notifyListeners();
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (error) {
    print("Exception: $error");
  }
  }

}




class User {
  final int id;
  final String name;
  final String image;
  final int followerCount;
  final int followingCount;
  final bool followingMe;
  final bool followed;
  final String userImageUrl;
  final int postCount;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.followerCount,
    required this.followingCount,
    required this.followingMe,
    required this.followed,
    required this.userImageUrl,
    required this.postCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      followingMe: json['followingMe'] ?? false,
      followed: json['followed'] ?? false,
      userImageUrl: json['user_image_url'] ?? '',
      postCount: json['postCount'] ?? 0,
    );
  }
}
