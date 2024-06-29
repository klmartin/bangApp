import 'package:bangapp/screens/Profile/user_profile.dart';
import 'package:bangapp/services/service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/notification.dart';
import '../../providers/Profile_Provider.dart';
import '../../providers/friends_provider.dart';
import '../../providers/notification_provider.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Posts/notificationView_model.dart';
import '../../providers/profile_provider.dart';
import '../../services/token_storage_helper.dart';
import 'package:bangapp/loaders/notification_skeleton.dart';

import '../Posts/postView_model.dart';

class Activity extends StatefulWidget {
  @override
  _Activity createState() => _Activity();
}

class _Activity extends State<Activity> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  int _pageNumber = 1;
  int _perPage = 15;
  late FriendProvider friendProvider;
  late NotificationProvider notificationProvider;

  bool isLoading = true; // Initially set to true to show the loader
  @override
  void initState() {
    print('from notification');
    super.initState();
    friendProvider = Provider.of<FriendProvider>(context, listen: false);

    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    notificationProvider.fetchNotifications(_pageNumber, _perPage);
    _scrollController.addListener(() {
      _scrollPosition = _scrollController.offset;
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _pageNumber++;
      // loadMoreNotifications(
      //   _pageNumber,
      // ); // Trigger loading of the next page
    }
  }

  ListTile _friendRequestList(NotificationItem notification) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userid: notification.userId),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(notification.userImage),
          radius: 28.0,
        ),
      ),
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userid: notification.userId),
            ),
          );
        },
        child: Text(
          notification.userName,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),
      subtitle: Text(
        notification.message,
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12.0,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              String decline =
              await friendProvider.declineFriendship(notification.postId);
              if (decline.isNotEmpty) {
                Fluttertoast.showToast(
                  msg: friendProvider.requestMessage,
                  toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                  gravity: ToastGravity.CENTER, // Toast position
                  timeInSecForIosWeb: 1, // Time duration for iOS and web
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                notificationProvider.deleteNotification(notification.id);
              }
            },
            icon: Icon(Icons.close),
            iconSize: 30,
            color: Colors.red,
            padding: EdgeInsets.zero,
            splashRadius: 35,
          ),
          SizedBox(width: 3), // Add some space between buttons
          IconButton(
            onPressed: () async {
              String decline =
              await friendProvider.acceptFriendship(notification.postId);
              if (decline == "Confirmed") {
                Fluttertoast.showToast(
                  msg: friendProvider.requestMessage,
                  toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                  gravity: ToastGravity.CENTER, // Toast position
                  timeInSecForIosWeb: 1, // Time duration for iOS and web
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                notificationProvider.deleteNotification(notification.id);
              }
            },
            icon: Icon(Icons.check),
            iconSize: 30,
            color: Colors.green,
            padding: EdgeInsets.zero,
            splashRadius: 35,
          ),
        ],
      ),
    );
  }

  GestureDetector _notificationList(NotificationItem notification) {
    return GestureDetector(
      onTap: () async {
        var postDetails = await Service().getPostInfo(notification.postId);
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
                postDetails[0]['cache_url'],
                postDetails[0]['thumbnail_url'],
                postDetails[0]['aspect_ratio'],
                postDetails[0]['price'],
                postDetails[0]['post_views_count'],
                Provider.of<ProfileProvider>(context, listen: false)),
          ),
        );
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(userid: notification.userId),
              ),
            );
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(notification.userImage),
            radius: 28.0,
          ),
        ),
        title: InkWell(
          onTap: () async {
            var postDetails = await Service().getPostInfo(notification.postId);
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
                    postDetails[0]['cache_url'],
                    postDetails[0]['thumbnail_url'],
                    postDetails[0]['aspect_ratio'],
                    postDetails[0]['price'],
                    postDetails[0]['post_views_count'],
                    Provider.of<ProfileProvider>(context, listen: false)),
              ),
            );
          },
          child: Text(
            notification.userName.toString(),
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        subtitle: InkWell(
          onTap: () async {
            var postDetails = await Service().getPostInfo(notification.postId);
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
                    postDetails[0]['cache_url'],
                    postDetails[0]['thumbnail_url'],
                    postDetails[0]['aspect_ratio'],
                    postDetails[0]['price'],
                    postDetails[0]['post_views_count'],
                    Provider.of<ProfileProvider>(context, listen: false)),
              ),
            );
          },
          child: Text(
            notification.message,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 12.0,
            ),
          ),
        ),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 50.0,
            width: 40.0,
            color: Color(0xffFF0E58),
            child: CachedNetworkImage(
              imageUrl: notification.postType == 'video'
                  ? notification.thumbnailUrl
                  : notification.postUrl,
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

  @override
  Widget build(BuildContext context) {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    return Scaffold(
        body: notificationProvider.isLoading
            ? NotificationSkeleton()
            : ListView.builder(
                shrinkWrap: true,
                key: const PageStorageKey<String>('notification'),
                controller: _scrollController, // Attach the ScrollController
                itemCount: notificationProvider.notification.length,
                itemBuilder: (context, index) {
                  final notification = notificationProvider.notification[index];
                  return Dismissible(
                    key: Key(notification.id.toString()), // Use a unique key
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        notificationProvider
                            .deleteNotification(notification.id);
                      } else if (direction == DismissDirection.endToStart) {
                        notificationProvider
                            .deleteNotification(notification.id);
                      }
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
                    child: notification.type == "friend"
                        ? _friendRequestList(notification)
                        : _notificationList(notification),
                  );
                },
              ));
  }
}
