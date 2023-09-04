import 'package:bangapp/widgets/video_player.dart';
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
        imageUrl: 'https://alitaafrica.com/social-backend-laravel/storage/app/images/pinned/PinnedPost.gif',
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
    return VideoPlayerPage(mediaUrl: mediaUrl);
  } else {
    return Container();
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


