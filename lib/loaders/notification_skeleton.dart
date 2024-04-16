import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NotificationSkeleton extends StatefulWidget {
  const NotificationSkeleton();

  @override
  State<NotificationSkeleton> createState() => _NotificationSkeletonPageState();
}

class _NotificationSkeletonPageState extends State<NotificationSkeleton> {
  bool _enabled = true;

  List<Map<String, dynamic>> notificationData = [
    {
      "id": 379,
      "user_id": 41,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-28T08:10:12.000000Z",
      "updated_at": "2024-02-28T08:27:04.000000Z",
      "post_id": 680,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/",
      "post_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/https://video.bangapp.pro/video/165de3e87e6492/165de3e87e6492.m3u8",
      "post_thumbnail_url":
          "https://video.bangapp.pro/thumbnail/165de3e87e6492/165de3e87e6492.png",
      "post_type": "video",
      "user": {
        "id": 41,
        "name": "bachulotrainer",
        "image": null,

        "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/",
        "postCount": 4
      },
    },
    {
      "id": 378,
      "user_id": 41,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-28T08:10:00.000000Z",
      "updated_at": "2024-02-28T08:27:04.000000Z",
      "post_id": 682,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/",
      "post_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/https://video.bangapp.pro/video/165deb8b714119/165deb8b714119.m3u8",
      "post_thumbnail_url":
          "https://video.bangapp.pro/thumbnail/165deb8b714119/165deb8b714119.png",
      "post_type": "video",
      "user": {
        "id": 41,
        "name": "bachulotrainer",
        "image": null,
        "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/",
        "postCount": 4
      },
    },
    {
      "id": 343,
      "user_id": 13,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-27T19:49:39.000000Z",
      "updated_at": "2024-02-28T07:29:03.000000Z",
      "post_id": 678,
      "user_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "post_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/https://video.bangapp.pro/video/165de3c435d51f/165de3c435d51f.m3u8",
      "post_thumbnail_url":
          "https://video.bangapp.pro/thumbnail/165de3c435d51f/165de3c435d51f.png",
      "post_type": "video",
      "user": {
        "id": 13,
        "name": "Ghost",
        "image":
            "profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",

        "user_image_url":
            "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "postCount": 637
      },
    },
    {
      "id": 342,
      "user_id": 13,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-27T17:02:50.000000Z",
      "updated_at": "2024-02-27T17:02:56.000000Z",
      "post_id": 534,
      "user_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "post_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/images/kKrtsnNGnIuSiuiShh5UFlBe141kZM6NciuO2oxI.jpg",
      "post_thumbnail_url": null,
      "post_type": "image",
      "user": {
        "id": 13,
        "name": "Ghost",
      },
    },
    {
      "id": 342,
      "user_id": 13,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-27T17:02:50.000000Z",
      "updated_at": "2024-02-27T17:02:56.000000Z",
      "post_id": 534,
      "user_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "post_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/images/kKrtsnNGnIuSiuiShh5UFlBe141kZM6NciuO2oxI.jpg",
      "post_thumbnail_url": null,
      "post_type": "image",
      "user": {
        "id": 13,
        "name": "Ghost",
      },
    },
    {
      "id": 342,
      "user_id": 13,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-27T17:02:50.000000Z",
      "updated_at": "2024-02-27T17:02:56.000000Z",
      "post_id": 534,
      "user_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "post_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/images/kKrtsnNGnIuSiuiShh5UFlBe141kZM6NciuO2oxI.jpg",
      "post_thumbnail_url": null,
      "post_type": "image",
      "user": {
        "id": 13,
        "name": "Ghost",
      },
    },
    {
      "id": 342,
      "user_id": 13,
      "message": "Has Liked Your Post",
      "type": "like",
      "reference_id": 6,
      "is_read": 1,
      "created_at": "2024-02-27T17:02:50.000000Z",
      "updated_at": "2024-02-27T17:02:56.000000Z",
      "post_id": 534,
      "user_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "post_image_url":
      "https://bangapp.pro/BangAppBackend/storage/app/images/kKrtsnNGnIuSiuiShh5UFlBe141kZM6NciuO2oxI.jpg",
      "post_thumbnail_url": null,
      "post_type": "image",
      "user": {
        "id": 13,
        "name": "Ghost",
      },
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child: ListView.builder(
        itemCount: notificationData.length,
        itemBuilder: (context, index) {
          final notification = notificationData[index];
          return _notificationList(notification);
        },
      ),
    );
  }

  GestureDetector _notificationList(notification) {
    return GestureDetector(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(notification['user_image_url']),
          radius: 28.0,
        ),
        title: Text(
          notification['user']['name'].toString(),
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          notification['message'],
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 12.0,
          ),
        ),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 50.0,
            width: 40.0,
            color: Colors.white24,
            child: CachedNetworkImage(
              imageUrl:notification['post_image_url'],
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover, // You can adjust the fit based on your needs
            ),
          ),
        ),
      ),
    );
  }
}
