import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import '../../services/animation.dart';
import '../Comments/commentspage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SmallBoxCarousel extends StatelessWidget {
  final List<BoxData> boxes;
  final isLiked = false;
  final likeCount = 0;
  final postId = 1;
  SmallBoxCarousel({ this.boxes});
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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Bang Battle',
          style: TextStyle(fontFamily: 'Metropolis',
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -1),

        ),

        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
          ),
          items: boxes.map((box) {
            if(box.imageUrl2 != null){
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    child: Column(
                      children: [
                        Row(  // Replace Column with Row
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewImage(context, box.imageUrl1);
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.network(
                                    box.imageUrl1,  // Replace with the URL of the first image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),  // Add some spacing between the images
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewImage(context, box.imageUrl2);
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.network(
                                    box.imageUrl2,  // Replace with the URL of the first image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle the first heart icon tap
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                                        SizedBox(width: 4),
                                        Positioned(
                                          top: 7.5,
                                          left: 11,
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "$likeCount likes" ,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),//for liking first picture
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
                                            postId: postId,
                                            userId: 1,
                                            // currentUser: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),//for comments
                                  SizedBox(width: 10),
                                  Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle the first heart icon tap
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                                                SizedBox(width: 4),
                                                Positioned(
                                                  top: 7.5,
                                                  left: 11.5,
                                                  child: Text(
                                                    'B',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "$likeCount like",
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),//for liking second picture
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

            }
            else{
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            viewImage(context, box.imageUrl1);
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(
                              box.imageUrl1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle the first heart icon tap
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                                        SizedBox(width: 4),
                                        Positioned(
                                          top: 7.5,
                                          left: 11,
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "$likeCount likes" ,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),//for liking first picture
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
                                            postId: postId,
                                            userId: 1,
                                            // currentUser: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Ionicons.chatbox_outline,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        createRoute(
                                          CommentsPage(
                                            postId: postId,
                                            userId: 1,
                                            // currentUser: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),//for comments
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle the first heart icon tap
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                                                SizedBox(width: 4),
                                                Positioned(
                                                  top: 7.5,
                                                  left: 11.5,
                                                  child: Text(
                                                    'B',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "$likeCount like",
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),//for liking second picture
                                    ],
                                  )

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

          }).toList(),
        ),
      ],
    );
  }


}

class BoxData {
  final String imageUrl1;
  final String imageUrl2;
  final String text;

  BoxData({ this.imageUrl1, this.imageUrl2,  this.text});
}
