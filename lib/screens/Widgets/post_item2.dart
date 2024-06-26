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
import 'package:video_player/video_player.dart';
import '../../models/post.dart';
import '../../services/animation.dart';
import '../../widgets/build_media.dart';
import '../Comments/commentspage.dart';
import 'dart:io';

class PostItem2 extends StatelessWidget {
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

  PostItem2(
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
    if (challengeImg != null &&
        challenges.isEmpty &&
        type == 'image') //challenge image
    {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          children: [
            postOptions(context, userId, userImage, name, followerCount, image,
                    postId, userId, type, createdAt, postViews, "posts") ??
                Container(),
            AspectRatio(
              aspectRatio: 190 / 120,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        viewImage(context, image);
                      },
                      child: Container(
                        height: 250,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: image,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              height: double.infinity,
                              placeholder: (context, url) => AspectRatio(
                                aspectRatio: width / height,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 30, 34, 45),
                                  highlightColor:
                                      const Color.fromARGB(255, 30, 34, 45)
                                          .withOpacity(.85),
                                  child: Container(
                                      color: const Color.fromARGB(
                                          255, 30, 34, 45)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "A",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5), // Add some spacing between the images
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        viewImage(context, challengeImg);
                      },
                      child: Container(
                        height: 250, // Set your desired fixed height here
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: challengeImg,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              height: double.infinity,
                              placeholder: (context, url) => AspectRatio(
                                aspectRatio: width / height,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 30, 34, 45),
                                  highlightColor:
                                      const Color.fromARGB(255, 30, 34, 45)
                                          .withOpacity(.85),
                                  child: Container(
                                      color: const Color.fromARGB(
                                          255, 30, 34, 45)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "B",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //displaying first challenge picture
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final countUpdate = Provider.of<PostsProvider>(
                              context,
                              listen: false);
                          countUpdate.increaseLikes2(postId, 1);
                          Service().likeAction(postId, "A", userId);
                        },
                        child: isLikedA
                            ? Icon(CupertinoIcons.heart_fill,
                                color: Colors.red, size: 25)
                            : Icon(CupertinoIcons.heart,
                                color: Colors.black, size: 25),
                      ),
                      // Text("${likeCountA.toString()} Likes")
                    ],
                  ), //for liking first picture
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      GestureDetector(
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
                        child: const Icon(
                          CupertinoIcons.chat_bubble,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          final countUpdate = Provider.of<PostsProvider>(
                              context,
                              listen: false);
                          countUpdate.increaseLikes2(postId, 2);
                          Service().likeAction(postId, "B", userId);
                        },
                        child: isLikedB
                            ? Icon(CupertinoIcons.heart_fill,
                                color: Colors.red, size: 25)
                            : Icon(CupertinoIcons.heart,
                                color: Colors.black, size: 25),
                      ),
                    ],
                  ), //for comments

                  // Text("${likeCountB.toString()} Likes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${likeCountA.toString()} Likes"),
                  GestureDetector(
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
                  Text("${likeCountB.toString()} Likes")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Row(
                children: [
                  Text(
                    name, // Add your username here
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5), // Add some spacing between the username and caption
                  Expanded(
                    child: ReadMoreText(
                      caption,
                      trimLines: 1,
                      colorClickableText: Colors.black,
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
                        color: Color(0xFFF40BF5),
                      ),
                      moreStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF40BF5),
                      ),
                      delimiterStyle: TextStyle(color:Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    } else if (challengeImg != null &&
        challenges.isEmpty &&
        type == 'video') //challenge video
    {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          children: [
            postOptions(context, userId, userImage, name, followerCount, image,
                    postId, userId, type, createdAt, postViews, "posts") ??
                Container(),
            AspectRatio(
              aspectRatio: 190 / 120,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        viewImage(context, image);
                      },
                      child: Container(
                        height: 250,
                        child: Stack(
                          children: [
                            Container(),
                            Positioned(
                              bottom: 5,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "A",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5), // Add some spacing between the images
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        viewImage(context, challengeImg);
                      },
                      child: Container(
                        height: 250, // Set your desired fixed height here
                        child: Stack(
                          children: [
                            Container(),
                            Positioned(
                              bottom: 5,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "B",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //displaying first challenge picture
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final countUpdate = Provider.of<PostsProvider>(
                              context,
                              listen: false);
                          countUpdate.increaseLikes2(postId, 1);
                          Service().likeAction(postId, "A", userId);
                        },
                        child: isLikedA
                            ? Icon(CupertinoIcons.heart_fill,
                                color: Colors.red, size: 25)
                            : Icon(CupertinoIcons.heart,
                                color: Colors.black, size: 25),
                      ),
                      Text("${likeCountA.toString()} Likes")
                    ],
                  ), //for liking first picture
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
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
                        child: const Icon(
                          CupertinoIcons.chat_bubble,
                          color: Colors.black,
                          size: 25,
                        ),
                      ), //for comments
                      const SizedBox(
                        width: 10,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final countUpdate = Provider.of<PostsProvider>(
                                  context,
                                  listen: false);
                              countUpdate.increaseLikes2(postId, 2);
                              Service().likeAction(postId, "B", userId);
                            },
                            child: isLikedB
                                ? Icon(CupertinoIcons.heart_fill,
                                    color: Colors.red, size: 25)
                                : Icon(CupertinoIcons.heart,
                                    color: Colors.black, size: 25),
                          ),
                          Text("${likeCountB.toString()} Likes")
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 2),
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
                    // Wrap the ReadMoreText with an Expanded widget
                    child: ReadMoreText(
                      caption,
                      trimLines: 1,
                      colorClickableText: Colors.black,
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
                        color: Color(0xFFF40BF5),
                      ),
                      moreStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF40BF5),
                      ),
                      delimiterStyle: TextStyle(color:Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
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
            const SizedBox(height: 10),
          ],
        ),
      );
    } else if (challengeImg == null && challenges.isEmpty) //single post
    {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            postOptions(context, userId, userImage, name, followerCount, image,
                    postId, userId, type, createdAt, postViews, "posts") ??
                Container(),
            buildMediaWidget(context, image, type, isPinned, cacheUrl,
                    thumbnailUrl, aspectRatio, postId, price) ??
                Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
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
                          colorClickableText: Colors.black,
                          trimMode: TrimMode.line,
                          textColor: Colors.black,
                          trimCollapsedText: '...Show more',
                          trimExpandedText: '...Show less',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          lessStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF40BF5),
                          ),
                          moreStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFF40BF5),
                          ),
                          delimiterStyle: TextStyle(color:Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
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
                          SizedBox(width: 4),
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
                                        color: Colors.black, size: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8),
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
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<UserLikesProvider>(context, listen: false)
                            .getUserLikedPost(postId);
                        LikesModal.showLikesModal(context, postId);
                      },
                      child: Text(
                        "$likeCountA likes",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      );
    } else if (challengeImg == null && challenges.isNotEmpty) {
      return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(1, 30, 34, 45),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              postOptions(
                      context,
                      userId,
                      userImage,
                      name,
                      followerCount,
                      image,
                      postId,
                      userId,
                      type,
                      createdAt,
                      postViews,
                      "posts") ??
                  Container(),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final imageUrl = challenges[index].challengeImg;
                    return AspectRatio(
                      aspectRatio: width / height,
                      child: buildMediaWidget(context, imageUrl, type, isPinned,
                          cacheUrl, thumbnailUrl, aspectRatio, postId, price),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
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
                                colorClickableText:Colors.black,
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
                                  color: Color(0xFFF40BF5),
                                ),
                                moreStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFF40BF5),
                                  fontWeight: FontWeight.bold,
                                ),
                                delimiterStyle: TextStyle(color:Colors.black),
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
                                        Service()
                                            .likeAction(postId, "A", userId);
                                      },
                                      child: isLiked
                                          ? Icon(CupertinoIcons.heart_fill,
                                              color: Colors.red, size: 25)
                                          : Icon(CupertinoIcons.heart,
                                              color: Colors.black, size: 25),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<UserLikesProvider>(context,
                                                listen: false)
                                            .getUserLikedPost(postId);

                                        LikesModal.showLikesModal(
                                            context, postId);
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
                ],
              ),
              const SizedBox(height: 20),
            ],
          ));
    } else {
      return Container();
    }
  }
}
