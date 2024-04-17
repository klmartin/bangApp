import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';



class FriendRequestSkeleton extends StatefulWidget {
  const FriendRequestSkeleton();

  @override
  State<FriendRequestSkeleton> createState() => _FriendRequestSkeletonState();
}

class _FriendRequestSkeletonState extends State<FriendRequestSkeleton> {
  bool _enabled = true;
  List<Map<String, dynamic>> friendRequestData = [
    {"id":1,"name":"crispin","followerCount":2,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},
    {"id":2,"name":"Mr. Vincenzo Heathcote","followerCount":0,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},
    {"id":2,"name":"Mr. Vincenzo Heathcote","followerCount":0,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},
    {"id":1,"name":"crispin","followerCount":2,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},
    {"id":1,"name":"crispin","followerCount":2,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},
    {"id":2,"name":"Mr. Vincenzo Heathcote","followerCount":0,"followingCount":0,"followingMe":false,"followed":false,"user_image_url":"https:\/\/bangapp.pro\/BangAppBackend\/storage\/app\/","postCount":0},

  ];
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child:  ListView.builder(
        itemCount: friendRequestData.length,
        itemBuilder: (context, index) {
          final notification = friendRequestData[index];
          return  ListTile(
              leading: GestureDetector(
                onTap: () {
                  // Handle tap on leading (avatar)
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(notification['user_image_url']),
                  radius: 28.0,
                ),
              ),
              title: InkWell(
                onTap: () {
                  // Handle tap on username
                },
                child: Text(
                  notification['name'],
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ),

              trailing:  OutlinedButton(
                  onPressed: () {

                  },
                  child: Text(
                    'Add Friend',
                    style: TextStyle(color: Colors.black),
                  ))
          );
        },
      ),
    );
  }
}

