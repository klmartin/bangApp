import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/widgets/user_profile.dart';

import '../../components/video_player.dart';
import '../../providers/bangUpdate_profile_provider.dart';
import '../../providers/bang_update_provider.dart';
import '../../services/animation.dart';
import '../../widgets/buildBangUpdate2.dart';
import '../Comments/updateComment.dart';
import '../Widgets/readmore.dart';

class UpdateView extends StatefulWidget {
  int? postId;
  String? type;
  String? filename;
  int likeCount;
  bool isLiked;
  int? commentCount;
  String? userImage;
  String userName;
  String? caption;
  String? aspectRatio;
  String? thumbnailUrl;
  String? cacheUrl;
  BangUpdateProfileProvider? myProvider;

  UpdateView(
    this.postId,
    this.type,
    this.filename,
    this.likeCount,
    this.isLiked,
    this.commentCount,
    this.userImage,
    this.userName,
    this.caption,
    this.aspectRatio,
    this.thumbnailUrl,
    this.cacheUrl,
    this.myProvider
  );
  @override
  _UpdateViewState createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == "image") {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            titleSpacing: 8,
            title: GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF40BF5),
                      Color(0xFFBF46BE),
                      Color(0xFFF40BF5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.navigate_before_outlined, size: 30),
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [SizedBox(width: 10)],
          ),
          body: Stack(
            children: [
              Container(
                color: Colors.black,
                child: Center(
                    child: Container(
                  height: 400,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ZoomableImageScreen(
                                imageUrls: [widget.filename!]);
                          },
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.filename!,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 30, 34, 45),
                        highlightColor: const Color.fromARGB(255, 30, 34, 45)
                            .withOpacity(.85),
                        child: Container(
                          color: const Color.fromARGB(255, 30, 34, 45),
                        ),
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
                    GestureDetector(
                      onTap: () async {
                        final upt = widget.myProvider;
                        upt!.increaseLikes(widget.postId!);
                        setState(() {
                          if (widget.isLiked) {
                            widget.likeCount--;
                            widget.isLiked = false;
                          } else {
                            widget.likeCount++;
                            widget.isLiked = true;
                          }
                        });
                        await Service().likeBangUpdate(
                            widget.likeCount, widget.isLiked, widget.postId);
                      },
                      child: widget.isLiked!
                          ? Icon(CupertinoIcons.heart_fill,
                              color: Colors.red, size: 30)
                          : Icon(CupertinoIcons.heart,
                              color: Colors.white, size: 30),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.likeCount.toString(),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            UpdateCommentsPage(
                              postId: widget.postId, userId: widget.postId,
                              // currentUser: 1,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.chat_bubble,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.commentCount.toString(),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 20),
                    Icon(CupertinoIcons.paperplane,
                        color: Colors.white, size: 30),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                left: -60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Row(
                        children: [
                          UserProfile(url: widget.userImage!, size: 35),
                          SizedBox(width: 5),
                          Text(
                            widget.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 70),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ReadMoreText(
                              widget.caption,
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
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            titleSpacing: 8,
            title: GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF40BF5),
                      Color(0xFFBF46BE),
                      Color(0xFFF40BF5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.navigate_before_outlined, size: 30),
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [SizedBox(width: 10)],
          ),
          body: Stack(
            children: [
              Container(
                height:  MediaQuery.of(context).size.height,
                color: Colors.black,
                child: CustomVideoPlayer(
                    videoUrl: widget.filename!,
                    cachingVideoUrl: widget.cacheUrl!,
                    thumbnailUrl: widget.thumbnailUrl!,
                    aspectRatio: widget.aspectRatio!),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final upt = widget.myProvider;
                        upt!.increaseLikes(widget.postId!);
                        setState(() {
                          if (widget.isLiked) {
                            widget.likeCount--;
                            widget.isLiked = false;
                          } else {
                            widget.likeCount++;
                            widget.isLiked = true;
                          }
                        });
                        await Service().likeBangUpdate(
                            widget.likeCount, widget.isLiked, widget.postId);

                      },
                      child: widget.isLiked!
                          ? Icon(CupertinoIcons.heart_fill,
                              color: Colors.red, size: 30)
                          : Icon(CupertinoIcons.heart,
                              color: Colors.white, size: 30),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.likeCount.toString(),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            UpdateCommentsPage(
                              postId: widget.postId, userId: widget.postId,
                              // currentUser: 1,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.chat_bubble,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.commentCount.toString(),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 20),
                    Icon(CupertinoIcons.paperplane,
                        color: Colors.white, size: 30),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                left: -60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Row(
                        children: [
                          UserProfile(url: widget.userImage!, size: 35),
                          SizedBox(width: 5),
                          Text(
                            widget.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 70),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ReadMoreText(
                              widget.caption,
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
          ));
    }
  }
}
