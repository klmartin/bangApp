import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';

Widget? buildMediaWidget(BuildContext context, mediaUrl,type, imgWidth, imgHeight,isPinned) {
  if ( type == 'image'&& isPinned==0) {
    return  GestureDetector(
        onTap: () {
          viewImage(context, mediaUrl);
        },
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
          height: imgHeight.toDouble(),
          width: imgWidth.toDouble(),
          fit: BoxFit.cover,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: imgWidth / imgHeight,
            child: Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 30, 34, 45),
              highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
              child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
            ),
          ),
        ),
      );
  }
  else if (type == 'image' && isPinned==1){
    return GestureDetector(
      onTap: () {
        buildFab(isPinned,context);
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: 'http://192.168.165.229/social-backend-laravel/storage/app/images/pinned/PinnedPost.gif',
        placeholder: (context, url) => AspectRatio(
          aspectRatio: imgWidth / imgHeight,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 30, 34, 45),
            highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
            child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
          ),
        ),
      ),
    );
  }
  else if (type == 'video') {
    VideoPlayerController _videoPlayerController = VideoPlayerController.network(mediaUrl);
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
      child: AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as per your video's dimensions
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoPlayerController),
            Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  else {
    print(type);
    print('martin is here');
    return Container(); // Return an empty container if the media type is unknown or unsupported
  }
}

void viewImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: SizedBox.expand(
          child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}

buildFab(value,BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  'Payment Options',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                CupertinoIcons.money_dollar_circle,
                size: 25.0,
              ),
              title: Text('Tigo Pesa'),
              onTap: () {
                print(value);

              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.money_dollar_circle,
                size: 25.0,
              ),
              title: Text('M-pesa'),
              onTap: () async {
                print(value);
                // Navigator.pop(context);
                // await viewModel.pickImage(context: context);

              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.money_dollar_circle,
                size: 25.0,
              ),
              title: Text('Airtel Money'),
              onTap: () {
                print(value);
                // Navigator.pop(context);
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (_) => CreatePost(),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.money_dollar_circle,
                size: 25.0,
              ),
              title: Text('Halo Pesa'),
              onTap: () {
                print(value);
                // Navigator.pop(context);
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (_) => CreatePost(),
                //   ),
                // );
              },
            ),
          ],
        ),
      );
    },
  );
}


