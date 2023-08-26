import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Comments/battleComment.dart';
import 'package:bangapp/services/service.dart';

class BattleLike extends StatefulWidget {
  final int likeCount;
  final bool isLiked;
  final int battleId;
  bool bLikeButton = false;

  BattleLike({
    required this.likeCount,
    required this.isLiked,
    required this.battleId,
    required this.bLikeButton,
  });

  @override
  _BattleLikeState createState() => _BattleLikeState();
}

class _BattleLikeState extends State<BattleLike> {
  bool isLiked = false;
  bool battleALike =false;
  bool battleBLike = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    battleALike = widget.isLiked;
    battleBLike = false;
  }

  _handleLikeTap(type) {
    Service().likeBattle(widget.battleId);
    setState(() {
      if (type == 'A') {
        battleALike = !battleALike;
        battleBLike = false; // Reset B button state
      } else if (type == 'B') {
        battleBLike = !battleBLike;
        battleALike = false; // Reset A button state
      }

      // Update isLiked based on A and B button states
      isLiked = battleALike || battleBLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.bLikeButton== false){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _handleLikeTap('A'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    battleALike
                        ? Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30)
                        : Icon(CupertinoIcons.heart, color: Colors.red, size: 30),
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
                  "${widget.likeCount} likes",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                    MaterialPageRoute(
                      builder: (context) => BattleComment(postId: widget.battleId, userId: 1, messageStreamState: null),
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.black,
                  size: 30,
                ),
              ), //for comments
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _handleLikeTap('B'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        battleBLike
                            ? Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30)
                            : Icon(CupertinoIcons.heart, color: Colors.red, size: 30),
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
                      "${widget.likeCount} like",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ), //for liking second picture
            ],
          ),
        ],
      );
    }
    else if(widget.bLikeButton){
      return  Row(
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
                    !battleBLike ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
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
                  "${widget.likeCount} like",
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
      );
    }
   else{return Container();}
  }
}
