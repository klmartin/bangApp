import 'package:bangapp/screens/Widgets/battle_like.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/providers/BoxDataProvider.dart'; // Import the BoxDataProvider
import 'package:cached_network_image/cached_network_image.dart';

import '../../services/service.dart';
import '../Comments/battleComment.dart';

class SmallBoxCarousel extends StatefulWidget {
  @override
  _SmallBoxCarouselState createState() => _SmallBoxCarouselState();
}

class _SmallBoxCarouselState extends State<SmallBoxCarousel> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BoxDataProvider>(context, listen: false);
    provider.fetchData();
  }

  void viewImage(BuildContext context, String imageUrl) {
    // ... (your viewImage function remains the same)
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Bang Battle',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        Consumer<BoxDataProvider>(
          builder: (context, provider, child) {
            final boxes = provider.boxes;
            return boxes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 280,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 7),
                    ),
                    items: boxes.map((box) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            child: Column(
                              children: [
                                Row(
                                  // Replace Column with Row
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        viewImage(context, box.imageUrl1);
                                      },
                                      child: Container(
                                        height: 200,
                                        child: Image.network(
                                          box.imageUrl1,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                                    SizedBox(
                                        width:
                                            10), // Add some spacing between the images
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          viewImage(context, box.imageUrl2);
                                        },
                                        child: Container(
                                          height: 200,
                                          child: Image.network(
                                            box.imageUrl2,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              final countUpdate =
                                                  Provider.of<BoxDataProvider>(
                                                      context,
                                                      listen: false);
                                              Service()
                                                  .likeBattle(box.postId, "A");
                                              countUpdate.increaseLikes(
                                                  box.postId, 1);
                                              // Service().likeAction(postId, "A");
                                            },
                                            child: box.isLikedA
                                                ? Icon(
                                                    CupertinoIcons.heart_fill,
                                                    color: Colors.red,
                                                    size: 25)
                                                : Icon(CupertinoIcons.heart,
                                                    color: Colors.red,
                                                    size: 25),
                                          ),
                                          Text("${box.likeCountA} Likes")
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        BattleComment(
                                                          postId: box.postId,
                                                        )));
                                          },
                                          child: Text(
                                              "${box.commentCount} Comments"),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            BattleComment(
                                                              postId:
                                                                  box.postId,
                                                            )));
                                              },
                                              child: const Icon(
                                                CupertinoIcons.chat_bubble,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                final countUpdate = Provider.of<
                                                        BoxDataProvider>(
                                                    context,
                                                    listen: false);
                                                Service().likeBattle(
                                                    box.postId, "A");
                                                Service().likeBattle(
                                                    box.postId, "B");
                                                countUpdate.increaseLikes(
                                                    box.postId, 2);
                                                // Service().likeAction(postId, "A");
                                              },
                                              child: box.isLikedB
                                                  ? Icon(
                                                      CupertinoIcons.heart_fill,
                                                      color: Colors.red,
                                                      size: 25)
                                                  : Icon(CupertinoIcons.heart,
                                                      color: Colors.red,
                                                      size: 25),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                          ],
                                        ),
                                        Text("${box.likeCountB} Likes")
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
          },
        ),
      ],
    );
  }
}
