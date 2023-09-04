import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:like_button/like_button.dart';
import '../Comments/battleComment.dart';
import 'package:bangapp/services/service.dart';

class BattleLike extends StatefulWidget {
  int likeCountA;
  int likeCountB;
  bool isLiked;
  int battleId;
  bool bLikeButton = false;

  BattleLike({
    required this.likeCountA,
    required this.likeCountB,
    required this.isLiked,
    required this.battleId,
    required this.bLikeButton,
  });

  @override
  _BattleLikeState createState() => _BattleLikeState();
}

class _BattleLikeState extends State<BattleLike> {
  bool battleALike = false;
  bool battleBLike = false;

  @override
  void initState() {
    super.initState();
    battleALike = widget.isLiked;
    battleBLike = widget.isLiked;
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

      // Update likeCountA and likeCountB based on button states
      if (battleALike) {
        widget.likeCountA++; // Increment like count when A is liked
        if (battleBLike) {
          widget.likeCountB--; // Decrement like count for B when A is liked
        }
      } else if (battleBLike) {
        widget.likeCountB++; // Increment like count when B is liked
        if (battleALike) {
          widget.likeCountA--; // Decrement like count for A when B is liked
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (widget.bLikeButton == false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LikeButton(
            onTap: (isLiked) async {
              await _handleLikeTap('A');
              return battleALike;
            },
            size: 30,
            countPostion: CountPostion.bottom,
            likeCount: widget.likeCountA,
            likeBuilder: (bool isLiked) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    battleALike ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: battleALike ? Colors.red : Colors.red,
                    size: 32,
                  ),
                  Text(
                    'A',
                    style: TextStyle(
                      color: battleALike ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              );
            },
          ),
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
                      builder: (context) => BattleComment(postId: widget.battleId, userId: 1),
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(width: 10),
              LikeButton(
                onTap: (isLiked) async {
                  await _handleLikeTap('B');
                  return battleBLike;
                },
                size: 30,
                countPostion: CountPostion.bottom,
                likeCount: widget.likeCountB,
                likeBuilder: (bool isLiked) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        battleBLike ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: battleBLike ? Colors.red : Colors.red,
                        size: 30,
                      ),
                      Text(
                        'B',
                        style: TextStyle(
                          color: battleBLike ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),

                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

