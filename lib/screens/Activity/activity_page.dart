import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:http/http.dart' as http;


class Activity extends StatefulWidget {
  @override
  _Activity createState() => _Activity();

}
class _Activity extends State<Activity> {
    @override

    List<dynamic> notifications = [];
    void initState() {
      super.initState();
      fetchNotifications();
    }

  Future<void> fetchNotifications() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      print(userId);
      final response = await http.get(Uri.parse('$baseUrl/getNotifications/$userId'));
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          notifications = data['notifications'];
        });
      } else {

        // Handle API error
        print('Failed to load notifications');
      }
    }

  @override
  // Widget build(BuildContext context) {
  //   ListTile _notificationList(String userImage, String name, String message,String type) {
  //     return ListTile(
  //       leading: CircleAvatar(
  //         backgroundImage: AssetImage('images/usr$num.jfif'),
  //         radius: 28.0,
  //       ),
  //       title: Text(
  //         name,
  //         style: TextStyle(
  //           fontFamily: 'Metropolis',
  //           fontWeight: FontWeight.bold,
  //           fontSize: 15.0,
  //         ),
  //       ),
  //       subtitle: Text(
  //         message,
  //         style: TextStyle(
  //           fontFamily: 'Metropolis',
  //           fontSize: 12.0,
  //         ),
  //       ),
  //       trailing: IconButton(
  //         icon: FaIcon(
  //           FontAwesomeIcons.userPlus,
  //           color: Colors.blueAccent,
  //           size: 19.0,
  //         ), onPressed: () {  },
  //       ),
  //       onTap: () {
  //         Toast.show("Following list updated!",
  //             duration: Toast.lengthShort, gravity: Toast.bottom);
  //       },
  //     );
  //   }
  //
  //   return ListView.builder(
  //     children: <Widget>[
  //       _notificationList(Random().nextInt(10) + 1, 'Harris', 'Enathu'),
  //     ],
  //   );
  // }
  Widget build(BuildContext context) {
    // Function to build a notification list item
    ListTile _notificationList(Map<String, String> notification) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(notification['userImage']!),
          radius: 28.0,
        ),
        title: Text(
          notification['name']!,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          notification['message']!,
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
        onTap: () {
          Toast.show(
            "Following list updated!",
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
          );
        },
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _notificationList(notification);
      },
    );
  }
}
