import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../screens/Comments/updateComment.dart';
import '../screens/Explore/bang_updates_like_button.dart';
import '../screens/Widgets/readmore.dart';
import '../services/animation.dart';
import 'package:bangapp/widgets/user_profile.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';



class ZoomableImageScreen extends StatelessWidget {
  final List<String> imageUrls; // If you have multiple images, provide a list of URLs

  ZoomableImageScreen({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(imageUrls[index]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),
    );
  }
}



Future<Widget> buildBangUpdate2(BuildContext context, bangUpdate, index) async {
  if (bangUpdate.type == 'image') {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: Container(
  height: 400,
  width: double.infinity,
  child: GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ZoomableImageScreen(imageUrls: [bangUpdate.filename]);
          },
        ),
      );
    },
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: bangUpdate.filename,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 30, 34, 45),
        highlightColor:
            const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
        child: Container(
          color: const Color.fromARGB(255, 30, 34, 45),
        ),
      ),
    ),
  ),
)
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Column(
            children: [
              BangUpdateLikeButton(
                  likeCount: bangUpdate.likeCount,
                  isLiked: bangUpdate.isLiked,
                  postId: bangUpdate.postId),
              SizedBox(height: 10),
              Text(
                bangUpdate.likeCount.toString(),
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    createRoute(
                      UpdateCommentsPage(
                        postId: bangUpdate.postId, userId: bangUpdate.postId,
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
              Text(bangUpdate.commentCount.toString(),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20),
              Icon(CupertinoIcons.paperplane, color: Colors.white, size: 30),
              SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: -50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Row(
                  children: [
                    UserProfile(url: bangUpdate.userImage, size: 35),
                    SizedBox(width: 5),
                    Text(
                      bangUpdate.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ReadMoreText(
                        bangUpdate.caption,
                        trimLines: 1,
                        colorClickableText: Colors.white,
                        trimMode: TrimMode.line,
                        trimCollapsedText: '...Show more',
                        trimExpandedText: '...Show less',
                        textColor: Colors.white,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        moreStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                        lessStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  } else if (bangUpdate.type == 'video') {
    VideoPlayerController _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(bangUpdate.filename));
    await _videoPlayerController
        .initialize(); // Initialize the video player controller
    ChewieController _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      autoInitialize: false,
      looping: true,
      placeholder: Container(
        color: const Color.fromARGB(255, 30, 34, 45),
      ),
    );
    return Stack(children: [
      Container(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: _videoPlayerController.value.isInitialized
                ? VisibilityDetector(
                    key: Key('chewie_key'), // Provide a unique key
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction == 0.0) {
                        _videoPlayerController.pause();
                      } else {
                        _videoPlayerController.play();
                      }
                    },
                    child: VideoPlayer(_videoPlayerController))
                : Container(), // Display an empty container if the video is not yet initialized
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Column(
          children: [
            BangUpdateLikeButton(
                likeCount: bangUpdate.likeCount,
                isLiked: bangUpdate.isLiked,
                postId: bangUpdate.postId),
            SizedBox(height: 10),
            Text(
              bangUpdate.likeCount.toString(),
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(
                    UpdateCommentsPage(
                      postId: bangUpdate.postId, userId: bangUpdate.postId,
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
            Text(bangUpdate.commentCount.toString(),
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20),
            Icon(CupertinoIcons.paperplane, color: Colors.white, size: 30),
            SizedBox(height: 20),
          ],
        ),
      ),
      Positioned(
        bottom: 30,
        left: -50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Row(
                children: [
                  UserProfile(url: bangUpdate.userImage, size: 35),
                  SizedBox(width: 5),
                  Text(
                    bangUpdate.userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ReadMoreText(
                  bangUpdate.caption,
                  trimLines: 1,
                  style: Theme.of(context).textTheme.bodyLarge!,
                  colorClickableText: Theme.of(context).primaryColor,
                  trimMode: TrimMode.line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: '...Show less',
                  textColor: Colors.white,
                  moreStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  } else {
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}
