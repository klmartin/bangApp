import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/urls.dart';
import '../services/token_storage_helper.dart';


class BangInspirationsProvider with ChangeNotifier {
  List<BangInspiration> _inspirations = [];
  bool _isLoading = false;
  bool _fetched = false;

  bool get isFetched => _fetched;
  List<BangInspiration> get inspirations => _inspirations;
  bool get isLoading => _isLoading;

  Future<void> fetchInspirations(BuildContext context) async {
    try {
      _isLoading = true;
      final token = await TokenManager.getToken();
      final response = await http.get(Uri.parse('$baseUrl/get/bangInspirations'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);
      print(response.body);
      print('bangInpo response');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _inspirations = data.map((json) => BangInspiration.fromJson(json)).toList();
        print(inspirations);
      } else {
        throw Exception('Failed to fetch inspirations');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching inspirations: $e'),
        ),
      );
    } finally {
      _isLoading = false;
      _fetched = true;
      notifyListeners();
    }
  }
Future<BangInspiration?> getSingleVideo(int id) async {
    try {
        final response = await http.get(Uri.parse('$baseUrl/get/bangInspirations/$id'));
        if (response.statusCode == 200) {
            final dynamic data = jsonDecode(response.body);
            return BangInspiration.fromJson(data);
        } else {
            throw Exception('Failed to fetch video');
        }
    } catch (e) {
        print('Error fetching video: $e');
        return null;
    }
}
}

class BangInspiration {
  final int id;
  final String? title;
  final String? profileUrl;
  final String videoUrl;
  final String thumbnail;

  BangInspiration({
    required this.id,
     this.title,
     this.profileUrl,
     required this.videoUrl,
     required this.thumbnail,


  });

  factory BangInspiration.fromJson(Map<String, dynamic> json) {
    return BangInspiration(
      id: json['id'],
      title: json['tittle'],
      profileUrl: json['profile_url'],
      videoUrl: json['video_url'],
      thumbnail: json['thumbnail'],

    );
  }
}
