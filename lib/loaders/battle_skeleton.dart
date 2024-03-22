import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BattleSkeleton extends StatefulWidget {
  const BattleSkeleton();

  @override
  State<BattleSkeleton> createState() => _BattleSkeletonPageState();
}

class _BattleSkeletonPageState extends State<BattleSkeleton> {
  bool _enabled = true;
  Map<String, dynamic> postData = {
    "id": 68,
    "body": "Tuwe wakweli!! A -Pacome or B -Chama 😜",
    "subtitle": "Changia mchezaji wako",
    "price": "1000",
    "type": "image",
    "battle1":
        "https://bangapp.pro/BangAppBackend/storage/app/bangBattle/65e45005b3553_battle1.jpg",
    "battle2":
        "https://bangapp.pro/BangAppBackend/storage/app/bangBattle/65e45005b3553_battle2.jpg",
    "cover_image": null,
    "cover_image2": null,
    "pinned": 1,
    "created_at": "2024-03-03T10:25:09.000000Z",
    "updated_at": "2024-03-17T20:02:35.000000Z",
    "isLikedA": false,
    "isLikedB": true,
    "isLiked": false,
    "comment_count": 0,
    "like_count_A": 1,
    "like_count_B": 1,
  };

  Widget build(BuildContext context) {
    double halfScreenWidth = MediaQuery.of(context).size.width / 2;
    return Skeletonizer(
      child: Column( mainAxisAlignment: MainAxisAlignment.start,
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
            Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: halfScreenWidth - 8,
                        child: CachedNetworkImage(
                          imageUrl: postData['battle1'],
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "A",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: halfScreenWidth - 5,
                        child: CachedNetworkImage(
                          imageUrl: postData['battle2'],
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "B",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                ],
              ),
              Text(
                postData['body'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: postData['isLikedA']
                              ? Icon(CupertinoIcons.heart_fill,
                                  color: Colors.red, size: 25)
                              : Icon(CupertinoIcons.heart,
                                  color: Colors.red, size: 25),
                        ),
                        Text("${postData['like_count_A']} Likes")
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Text("${postData['comment_count']} Comments"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
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
                            child: postData['isLikedB']
                                ? Icon(CupertinoIcons.heart_fill,
                                    color: Colors.red, size: 25)
                                : Icon(CupertinoIcons.heart,
                                    color: Colors.red, size: 25),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                        ],
                      ),
                      Text("${postData['like_count_B']} Likes")
                    ],
                  ),
                ],
              )
            ],
          ),
        )]
      ),
    );
  }
}
