import 'dart:convert';
import 'package:bangapp/services/service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/models/notification.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';

class Activity extends StatefulWidget {
  @override
  _Activity createState() => _Activity();
}

class _Activity extends State<Activity> {
  List<NotificationItem> notifications = [];
  bool isLoading = true; // Initially set to true to show the loader
  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print(userId);
    final response =
        await http.get(Uri.parse('$baseUrl/getNotifications/$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final notificationModel = NotificationModel.fromJson(data); // Parse JSON
      setState(() {
        notifications = notificationModel.notifications;
        isLoading = false; // Set isLoading to false when data is loaded
      });
    } else {
      // Handle API error
      isLoading = false; // Set isLoading to false when data is loaded
      print('Failed to load notifications');
    }
  }

GestureDetector _notificationList(NotificationItem notification) {
  return GestureDetector(
    onTap: () async {
      var postDetails = await Service().getPostInfo(notification.postId);
      print('this is post');

      var firstPost = postDetails[0]['image'];
      print(firstPost);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => POstView(
            postDetails[0]['user']['name'],
            postDetails[0]['body'] ?? "",
            postDetails[0]['image'],
            postDetails[0]['challenge_img'] ?? '',
            postDetails[0]['width'],
            postDetails[0]['height'],
            postDetails[0]['id'],
            postDetails[0]['commentCount'],
            postDetails[0]['user_id'],
            postDetails[0]['isLiked'],
            postDetails[0]['likeCount'] ?? 0,
            postDetails[0]['type'],
            postDetails[0]['user']['followerCount'],
          ),
        ),
      );
    },
    child: ListTile(
      leading: CircleAvatar(
        // Update based on notification data
        backgroundImage: NetworkImage(profileUrl+notification.userImage),
        radius: 28.0,
      ),
      title: Text(
        notification.userName.toString(),
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      subtitle: Text(
        notification.message,
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12.0,
        ),
      ),
      trailing: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.userPlus,
          color: Colors.blueAccent,
          size: 19.0,
        ),
        onPressed: () {
          // Handle the action when the user presses the IconButton
        },
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Display a loading indicator
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _notificationList(notification);
              },
            ),
    );
  }
}
