import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:bangapp/providers/user_provider.dart';
import '../components/video_player.dart';
import '../constants/urls.dart';
import '../providers/payment_provider.dart';
import '../services/azampay.dart';

Widget? buildMediaWidget(BuildContext context, mediaUrl, type, imgWidth,
    imgHeight, isPinned, cacheUrl, thumbnailUrl, aspectRatio, postId, price) {
  if (type == 'image' && isPinned == 0) {
    return AspectRatio(
      aspectRatio: imgWidth / imgHeight,
      child: GestureDetector(
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
              highlightColor:
                  const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
              child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
            ),
          ),
        ),
      ),
    );
  } else if (type == 'image' || type == 'video' && isPinned == 1) {
    return GestureDetector(
      onTap: () {
        buildFab(context, price, postId);
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: pinnedUrl,
        placeholder: (context, url) => AspectRatio(
          aspectRatio: imgWidth / imgHeight,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 30, 34, 45),
            highlightColor:
                const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
            child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
          ),
        ),
      ),
    );
  } else if (type == 'video' && isPinned == 0) {
    return CustomVideoPlayer(
        videoUrl: mediaUrl,
        cachingVideoUrl: cacheUrl,
        thumbnailUrl: thumbnailUrl,
        aspectRatio: aspectRatio);
    //return VideoPlayerPage(mediaUrl: mediaUrl);
  } else {
    return Container();
  }
}

void viewImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          enableRotation: true,
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

buildFab(BuildContext context, price, postId) {
  var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          final userProvider = Provider.of<UserProvider>(innerContext);
          final TextEditingController phoneNumberController =
              TextEditingController(
            text: userProvider.userData['phone_number'].toString(),
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      'Pay to View $price Tshs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.phone),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
                paymentProvider.isPaying
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          paymentProvider.startPaying(userProvider.userData['phone_number'].toString(), price, postId, 'post');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .red, // Set the background color of the button
                        ),
                        child: Text(
                          'Pay',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
              ],
            ),
          );
        },
      );
    },
  ).then((result) {
    var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    paymentProvider.paymentCanceled = true;
    print( paymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
}
