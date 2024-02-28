import 'package:bangapp/constants/urls.dart';
import 'package:flutter/material.dart';
import '../models/image_post.dart';
import '../models/notification.dart';
import '../services/api_cache_helper.dart';


class NotificationProvider extends ChangeNotifier {

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notification => _notifications;

  ApiCacheHelper apiCacheHelper = ApiCacheHelper(
    baseUrl: baseUrl,
    numberOfPostsPerRequest: 15,
  );

  Future<void> fetchNotifications() async {
    List<dynamic> data = await apiCacheHelper.getMyNotification();
    notifyListeners();

  }

  void increaseLikes(int postId) {
    final notification = _notifications.firstWhere((update) => update.postId == postId);
    // if (notification.isLikedA) {
    //   notification.likeCountA--;
    //   notification.isLikedA = false;
    // } else {
    //   notification.likeCountA++;
    //   notification.isLikedA = true;
    // }
    notifyListeners();
  }

}
