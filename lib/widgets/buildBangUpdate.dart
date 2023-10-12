import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:bangapp/widgets/LikeCounterWidget.dart';
import 'package:bangapp/widgets/user_profile.dart';
import 'package:bangapp/screens/Explore/bang_updates_like_button.dart';
import 'package:bangapp/constants/urls.dart';
import '../screens/Comments/updateComment.dart';
import '../services/animation.dart';

Widget? buildBangUpdate(BuildContext context, filename,type,caption,postId,likeCount,index) {
  if ( type == 'image') {
    return GestureDetector(
      onTap: () {
      },
      child:  Stack(
        children: [

          Text("Chemba ya Umbea",style:TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w700,fontFamily: 'Metropolis',letterSpacing: -1)),
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
                BangUpdateLikeButton(likeCount: 0,isLiked:false,postId:postId),
                SizedBox(height: 10),
                LikeCounterWidget(initialLikeCount: likeCount),
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
                  "0 " ,
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
                url: 'https://bangapp.pro/BangAppBackend/storage/app/bangInspiration/bang_logo.jpg',
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
    VideoPlayerController _videoPlayerController = VideoPlayerController.network(filename);
    ChewieController _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      placeholder: Container(
        color: const Color.fromARGB(255, 30, 34, 45),
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as per your video's dimensions
        child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoPlayerController),
            ],
        ),
      ),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BangUpdateLikeButton(likeCount: likeCount,isLiked:false,postId:postId),
                SizedBox(height: 10),
                LikeCounterWidget(initialLikeCount: likeCount),
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
                  "0 " ,
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
                        url: 'https://bangapp.pro/BangAppBackend/storage/app/bangInspiration/bang_logo.jpg',
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
