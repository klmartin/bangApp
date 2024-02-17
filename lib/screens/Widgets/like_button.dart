import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LikeButton extends StatefulWidget {
  final int likeCount;
  final bool isLiked;
  final int postId;
  bool isChallenge = false;
  bool isButtonA = false;
  bool isButtonB = false;
  LikeButton({
     required this.likeCount,
     required this.isLiked,
     required this.postId,
     required this.isChallenge,
     required this.isButtonA,
     required this.isButtonB
  });
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  bool isALiked = false;
  bool isBLiked = false;
  @override

  void initState() {
    super.initState();
    isALiked = widget.isLiked;
    isALiked = isLiked;
    isBLiked = isLiked;
  }
  void updateLikeButtons(bool likeStatus) {
    setState(() {
      isALiked = widget.isButtonA && likeStatus;
      isBLiked = widget.isButtonB && likeStatus;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(widget.isChallenge == false){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLiked = !isLiked; // Update the isLiked state variable
                      });
                    //   Service().likeAction(widget.likeCount, isLiked, widget.postId,'A',isALiked,isBLiked); // Use the parameters from the widget
                    },
                    child: isLiked
                        ? Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30)
                        : Icon(CupertinoIcons.heart, color: Colors.red, size: 30),
                  ),
                  SizedBox(width: 4),
                ],
              ),
              // LikeButton(likeCount: 0 ,isLiked:isLiked,postId:postId,isChallenge: false,isButtonA: false,isButtonB: true),
              SizedBox(width: 4),
            ],
          ),
          SizedBox(height: 2),
          Text(
            "${widget.likeCount} likes" ,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    else{
      if(widget.isButtonB){
        return  Row(
          children: [
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLiked = !isLiked; // Update the isLiked state variable
                  isALiked = !isLiked;
                  isBLiked = !isLiked;
                });
                updateLikeButtons(isLiked);
                // Service().likeAction(widget.likeCount, isLiked, widget.postId,'B',isALiked,isBLiked); // Use the parameters from the widget
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      !isBLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                      SizedBox(width: 4),
                      Positioned(
                        top: 7.5,
                        left: 11,
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
                    '${widget.likeCount} likes',
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
      else if(widget.isButtonA){
        return GestureDetector(
          onTap: () async {
            setState(() {
              isLiked = !isLiked; // Update the isLiked state variable
              isALiked = !isLiked;
              isBLiked = !isLiked;
            });
            updateLikeButtons(isLiked);
            // Service().likeAction(widget.likeCount, isLiked, widget.postId,'A',isALiked,isBLiked); // Use the parameters from the widget
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isALiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
                  SizedBox(width: 4),
                  Positioned(
                    top: 7.5,
                    left: 10.5,
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
                "${widget.likeCount} likes" ,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    }

  }
}
