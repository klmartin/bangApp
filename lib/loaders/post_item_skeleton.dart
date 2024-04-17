import 'dart:typed_data';
import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/providers/posts_provider.dart';
import 'package:bangapp/screens/Widgets/post_options.dart';
import 'package:bangapp/screens/Widgets/readmore.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/widgets/like_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/post.dart';
import '../../services/animation.dart';
import '../../widgets/build_media.dart';
import 'dart:io';

import '../screens/Comments/commentspage.dart';

class PostItemSkeleton extends StatelessWidget {
  final int postId;
  final int userId;
  final String name;
  final String type;
  final String image;
  final challengeImg;
  final String caption;
  final int width;
  final int height;
  final int likeCountA;
  final int likeCountB;
  final int commentCount;
  final int followerCount;
  final List<Challenge> challenges;
  final isLiked;
  final int isPinned;
  var isLikedA;
  var isLikedB;
  var like_count_A;
  var like_count_B;
  var createdAt;
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  String? price;
  int postViews;
  final String userImage;

  PostsProvider myProvider;

  PostItemSkeleton(
      this.postId,
      this.userId,
      this.name,
      this.image,
      this.challengeImg,
      this.caption,
      this.type,
      this.width,
      this.height,
      this.likeCountA,
      this.likeCountB,
      this.commentCount,
      this.followerCount,
      this.challenges,
      this.isLiked,
      this.isPinned,
      this.isLikedA,
      this.isLikedB,
      this.createdAt,
      this.userImage,
      this.cacheUrl,
      this.thumbnailUrl,
      this.aspectRatio,
      this.price,
      this.postViews,
      {required this.myProvider});

  Future<Uint8List> fileToUint8List(File file) async {
    List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
    return Uint8List(0);
  }

  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            postOptions(context, userId, userImage, name, followerCount, image,
                postId, userId, type, createdAt,postViews, "posts") ??
                Container(),
            AspectRatio(
              aspectRatio: width / height,
              child: GestureDetector(
                onTap: () {
                  viewImage(context, image);
                },
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: height.toDouble(),
                  width: width.toDouble(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => AspectRatio(
                    aspectRatio: width / height,
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xFFE0E0E0), // Light grey base color
                      highlightColor: const Color(0xFFE5DADA), // Light grey highlight color
                      child: Container(color: Colors.white), // White container color
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8),
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Row(
                    children: [
                      Text(
                        name, // Add your username here
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          width:
                          5), // Add some spacing between the username and caption
                      Expanded(
                        child: ReadMoreText(
                          caption,
                          trimLines: 1,
                          colorClickableText: Theme.of(context).primaryColor,
                          trimMode: TrimMode.line,
                          textColor: Colors.black,
                          trimCollapsedText: '...Show more',
                          trimExpandedText: '...Show less',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          lessStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          moreStyle: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CommentsPage(
                                    userId: userId,
                                    postId: postId,
                                    myProvider: myProvider,
                                  );
                                },
                              ));
                            },
                            child: const Icon(
                              CupertinoIcons.chat_bubble,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final countUpdate =
                                  Provider.of<PostsProvider>(context,
                                      listen: false);
                                  countUpdate.increaseLikes(postId);
                                  Service().likeAction(postId, "A", userId);
                                },
                                child: isLiked
                                    ? Icon(CupertinoIcons.heart_fill,
                                    color: Colors.red, size: 25)
                                    : Icon(CupertinoIcons.heart,
                                    color: Colors.red, size: 25),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<UserLikesProvider>(context,
                                      listen: false)
                                      .getUserLikedPost(postId);

                                  LikesModal.showLikesModal(context, postId);
                                },
                                child: Text(
                                  "$likeCountA likes",
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        CommentsPage(
                          postId: postId, userId: userId,
                          myProvider: myProvider,
                          // currentUser: 1,
                        ),
                      ),
                    );
                  },
                  child: Text("$commentCount comments")),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
  }
}
