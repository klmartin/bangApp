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
      var postDetails = await Service().getPostInfo(notification.userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => POstView(
            postDetails['name'],
            postDetails['caption'],
            postDetails['imgurl'],
            postDetails['challengeImgUrl'],
            postDetails['imgWidth'],
            postDetails['imgHeight'],
            postDetails['postId'],
            postDetails['commentCount'],
            postDetails['userId'],
            postDetails['isLiked'],
            postDetails['likeCount'],
            postDetails['type'],
          ),
        ),
      );

      // Move the Toast.show call here, after the Navigator operation
      Toast.show(
        "Following list updated!",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
    },
    child: ListTile(
      leading: CircleAvatar(
        // Update based on notification data
        backgroundImage: AssetImage(profileUrl + notification.userImage),
        radius: 28.0,
      ),
      title: Text(
        notification.userId.toString(),
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
