import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bangapp/widgets/user_profile.dart';
import '../screens/Widgets/readmore.dart';

class BangUpdateSkeleton extends StatefulWidget {
  const BangUpdateSkeleton();

  @override
  State<BangUpdateSkeleton> createState() => _BangUpdateSkeletonPageState();
}

class _BangUpdateSkeletonPageState extends State<BangUpdateSkeleton> {
  bool _enabled = true;

  Widget build(BuildContext context) {
    double halfScreenWidth = MediaQuery.of(context).size.width / 2;
    return Skeletonizer(
      enabled: _enabled,
      child:Stack(
        children: [
          Container(
            color: Colors.black,
            child: Center(
                child: Container(
                  height: 400,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "https://bangapp.pro/BangAppBackend/storage/app/bangUpdates/65e47252406aa.jpg",
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 30, 34, 45),
                      highlightColor:
                      const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                      child: Container(
                        color: const Color.fromARGB(255, 30, 34, 45),
                      ),
                    ),
                  ),
                )),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              children: [

                     Icon(CupertinoIcons.heart_fill,
                    color: Colors.red, size: 30),
                SizedBox(height: 10),
                Text(
                  "10",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(height: 10),
                Text("10",
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
                      UserProfile(url: "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg", size: 35),
                      SizedBox(width: 5),
                      Text(
                        "hbmartin",
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
                        width: MediaQuery.of(context).size.width,
                        child: ReadMoreText(
                          "caption",
                          trimLines: 2,
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
      ),
    );
  }
}
