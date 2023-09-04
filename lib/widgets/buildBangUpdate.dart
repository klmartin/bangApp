import 'package:bangapp/services/service.dart';
import 'package:bangapp/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:like_button/like_button.dart';
import 'package:bangapp/widgets/user_profile.dart';
import '../screens/Comments/updateComment.dart';
import '../services/animation.dart';

Widget? buildBangUpdate(BuildContext context, filename,type,caption,postId,likeCount,commentCount,index) {
  if ( type == 'image') {
  return GestureDetector(
      onTap: () {
      },
      child:  Stack(
        children: [
          if(index==0)
          Positioned(
            top: 20, // Adjust the top value as needed
            left: 75, // Adjust the left value as needed
            child: Text(
              "CHEMBA ya UMBEA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w700,
                fontFamily: 'Metropolis',
                letterSpacing: -1,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: CachedNetworkImage(
                imageUrl: filename,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 30, 34, 45),
                  highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                  child: Container(
                    color: const Color.fromARGB(255, 30, 34, 45),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LikeButton(
                  onTap: (isLiked) async {
                    await Service().likeBangUpdate(likeCount, isLiked, postId);
                    return !isLiked;
                  },
                  size: 32,
                  countPostion:CountPostion.bottom,
                  likeCount: likeCount,
                  likeBuilder: (bool isLiked) {
                    Icon(
                      isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isLiked ? Colors.red : Colors.red,
                      size: 30,
                    );
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        UpdateCommentsPage(
                          postId: postId, userId: 6,
                          // currentUser: 1,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    CupertinoIcons.chat_bubble,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  commentCount,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Icon(CupertinoIcons.paperplane, color: Colors.white, size: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              UserProfile(
                url: 'https://alitaafrica.com/social-backend-laravel/storage/app/bangInspiration/bang_logo.jpg',
                size: 40),
                SizedBox(width:5),
                Text('Bang App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white)),
              ]
              )),
          SizedBox(height: 20),
          Positioned(
            bottom: 40,
            left: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Set the desired width here
                  child: Text(
                    caption,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ) ,
              ],
            ),
          ),
        ],
      ),
    );
  }
  else if (type == 'video') {
    return GestureDetector(
      child: Stack(
        children: [
          Center(
            child: VideoPlayerPage(mediaUrl: filename),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LikeButton(
                  onTap: (isLiked) async {
                    await Service().likeBangUpdate(likeCount, isLiked, postId);
                    return !isLiked;
                  },
                  size: 30,
                  countPostion:CountPostion.bottom,
                  likeCount: likeCount,
                  likeBuilder: (bool isLiked) {
                    Icon(
                      isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isLiked ? Colors.red : Colors.red,
                      size: 30,
                    );
                   },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        UpdateCommentsPage(
                          postId: postId, userId:6 ,
                          // currentUser: 1,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    CupertinoIcons.chat_bubble,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  commentCount,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Icon(CupertinoIcons.paperplane, color: Colors.white, size: 30),
              ],
            ),
          ),
          Positioned(
              bottom: 80,
              left: 10,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UserProfile(
                        url: 'https://alitaafrica.com/social-backend-laravel/storage/app/bangInspiration/bang_logo.jpg',
                        size: 40),
                    SizedBox(width:5),
                    Text('User Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ]
              )),
          SizedBox(height: 10),
          Positioned(
            bottom: 40,
            left: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

              Container(
              width: MediaQuery.of(context).size.width * 0.8, // Set the desired width here
              child: Text(
                caption,
                softWrap: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              ) ,
              ],
            ),
          ),
      ]
      )

    );
  }
  else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}
