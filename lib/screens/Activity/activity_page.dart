import 'dart:convert';
import 'package:bangapp/services/service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/models/notification.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';

import '../../providers/Profile_Provider.dart';
import '../../services/token_storage_helper.dart';

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
        // Use cached data if it exists and is not expired
        final Map<String, dynamic> data = json.decode(cachedData);
        final notificationModel =
            NotificationModel.fromJson(data); // Parse JSON
        setState(() {
          notifications = notificationModel.notifications;
          isLoading = false;
        });
      } else {
        final token = await TokenManager.getToken();
        // Fetch data from the server
        final response = await http.get(
          Uri.parse('$baseUrl/getNotifications/$userId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':
                'application/json', // Include other headers as needed
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final notificationModel =
              NotificationModel.fromJson(data); // Parse JSON
          setState(() {
            notifications = notificationModel.notifications;
            isLoading = false; // Set isLoading to false when data is loaded
          });

          // Save data and timestamp to SharedPreferences
          prefs.setString(cacheKey, response.body);
          prefs.setInt(
              '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        } else {
          // Handle API error
          isLoading = false; // Set isLoading to false when data is loaded
          print('Failed to load notifications');
        }
      }
    } catch (e) {
      // Handle other exceptions (e.g., network error)
      // You may want to set an error flag or log the error
      isLoading = false; // Set isLoading to false when data is loaded
      print('Error fetching notifications: $e');
    }
  }

  GestureDetector _notificationList(NotificationItem notification) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = prefs.getInt('user_id');
        var postDetails =
            await Service().getPostInfo(notification.postId, userId);
        var firstPost = postDetails[0]['image'];
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
                postDetails[0]['like_count_A'] ?? 0,
                postDetails[0]['type'],
                postDetails[0]['user']['followerCount'],
                postDetails[0]['created_at'],
                postDetails[0]['user_image_url'],
                postDetails[0]['pinned'],
                Provider.of<ProfileProvider>(context, listen: false)),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          // Update based on notification data
          backgroundImage: NetworkImage(notification.userImage),
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
                child:
                    CircularProgressIndicator(), // Display a loading indicator
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Dismissible(
                    key: Key(notification.id.toString()), // Use a unique key
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Service()
                            .deleteNotification(notification.id.toString());
                      } else if (direction == DismissDirection.endToStart) {
                        Service()
                            .notificationIsRead(notification.id.toString());
                      }
                      setState(() {
                        notifications.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red, // Background color when swiped left
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.green, // Background color when swiped right
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    child: _notificationList(notification),
                  );
                },
              ));
  }
}
