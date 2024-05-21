import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import '../services/api_cache_helper.dart';
import '../services/token_storage_helper.dart';
import 'package:bangapp/services/service.dart';


class NotificationProvider extends ChangeNotifier {
  bool _loading = false;
  bool get isLoading => _loading;
  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notification => _notifications;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 15,
  );

  Future<void> fetchNotifications(int page, int perPage) async {
    _loading= true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final String cacheKey = 'cached_notifications';
    final String cachedData = prefs.getString(cacheKey) ?? '';
    final int lastCachedTimestamp = prefs.getInt('${cacheKey}_time') ?? 0;
    try {
      if (cachedData.isNotEmpty &&
          DateTime.now()
              .difference(
              DateTime.fromMillisecondsSinceEpoch(lastCachedTimestamp))
              .inMinutes <=
              2) {
        final data = json.decode(cachedData);
        List<dynamic> responseList = data['notifications']['data'];
        final notificationModel = NotificationModel.fromJson(responseList); // Parse JSON
        _notifications = notificationModel.notifications;
        _loading = false;
        notifyListeners();
      } else {
        final token = await TokenManager.getToken();
        // Fetch data from the server with page and perPage parameters
        final response = await http.get(
          Uri.parse('$baseUrl/getNotifications/$userId/$page/$perPage'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
            'application/json', // Include other headers as needed
          },
        );
        print(response.body);
        print('this is response notification');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List<dynamic> responseList = data['notifications']['data'];
          print(data);
          final notificationModel =
          NotificationModel.fromJson(responseList); // Parse JSON
          _notifications = notificationModel.notifications;
          print("nishaiset");
          _loading = false;
          notifyListeners();
          prefs.setString(cacheKey, response.body);
          prefs.setInt(
              '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        } else {
          _loading = false; // Set isLoading to false when data is loaded
          print('Failed to load notifications');
          notifyListeners();
        }
      }
    } catch (e) {
      _loading = false; // Set isLoading to false when data is loaded
      print('Error fetching notifications: $e');
      notifyListeners();
    }
  }

  Future<void> loadMoreNotifications(pageNumber) async {
    print(pageNumber);
  }


  void deleteNotification(int notificationId) async {
    await Service().deleteNotification(notificationId.toString());
    _notifications.removeWhere((NotificationItem) => NotificationItem.id == notificationId);
    notifyListeners();
  }

  void acceptFriendship(int notificationId) async
  {
    await Service().acceptFriendship(notificationId);
  }

  void declineFriendship(int notificationId) async
  {
    await Service().declineFriendShip(notificationId);
  }



}
