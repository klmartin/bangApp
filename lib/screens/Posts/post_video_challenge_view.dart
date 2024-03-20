import 'package:bangapp/screens/Widgets/post_options.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../providers/posts_provider.dart';
import '../../services/animation.dart';
import 'package:bangapp/services/service.dart';
import '../../widgets/build_media.dart';
import '../Comments/post_comment.dart';
import '../Widgets/readmore.dart';
import 'package:provider/provider.dart';

class POstVideoChallengeView extends StatefulWidget {
  String name;
  String caption;
  String imgurl;
  String challengeImgUrl;
  int imgWidth;
  int imgHeight;
  int postId;
  int commentCount;
  int userId;
  bool isLiked;
  int likeCount;
  String type;
  int followerCount;
  String created;
  String user_image;
  int pinnedImage;
  int postViews;

  POstVideoChallengeView(
    this.name,
    this.caption,
    this.imgurl,
    this.challengeImgUrl,
    this.imgWidth,
    this.imgHeight,
    this.postId,
    this.commentCount,
    this.userId,
    this.isLiked,
    this.likeCount,
    this.type,
    this.followerCount,
    this.created,
    this.user_image,
    this.pinnedImage,
    this.postViews,
  );
  static const id = 'postview';
  @override
  _POstViewState createState() => _POstViewState();
}

class _POstViewState extends State<POstVideoChallengeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: PostCard(
                widget.name,
                widget.caption,
                widget.imgurl,
                widget.challengeImgUrl,
                widget.imgWidth,
                widget.imgHeight,
                widget.postId,
                widget.commentCount,
                widget.userId,
                widget.isLiked,
                widget.likeCount,
                widget.type,
                widget.followerCount,
                widget.created,
                widget.user_image,
                widget.pinnedImage,
                widget.postViews,
                ),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  String postUrl;
  String name;
  String caption;
  String challengeImgUrl;
  int imgWidth;
  int imgHeight;
  int postId;
  int commentCount;
  int userId;
  bool isLiked;
  int likeCount;
  String type;
  int followerCount;
  String createdAt;
  String userImage;
  int pinned;
  int postViews;

  ScrollController _scrollController = ScrollController();
  PostCard(
      this.name,
      this.caption,
      this.postUrl,
      this.challengeImgUrl,
      this.imgWidth,
      this.imgHeight,
      this.postId,
      this.commentCount,
      this.userId,
      this.isLiked,
      this.likeCount,
      this.type,
      this.followerCount,
      this.createdAt,
      this.userImage,
      this.pinned,
      this.postViews,
      );
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isEditing = false;

  var myProvider;
  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.redAccent, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(Icons.navigate_before_outlined, size: 30),
            ),
          ),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: [SizedBox(width: 10)],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(1, 30, 34, 45),
          ),
          child: Column(
            children: [
              postOptions(
                      context,
                      widget.userId,
                      widget.userImage,
                      widget.name,
                      widget.followerCount,
                      widget.postUrl,
                      widget.postId,
                      widget.userId,
                      widget.type,
                      widget.createdAt,
                      widget.postViews,
                      "profile") ??
                  Container(),
              AspectRatio(
                aspectRatio: 190 / 120,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          viewImage(context, widget.postUrl);
                        },
                        child: Container(
                          height: 250,
                          child: Stack(
                            children: [
                              Chewie(
                                controller: ChewieController(
                                  videoPlayerController:
                                      VideoPlayerController.network(
                                          widget.postUrl),
                                  autoPlay: false,
                                  looping: true,
                                  showControls: true, // Hide controls if needed
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
                          viewImage(context, widget.challengeImgUrl);
                        },
                        child: Container(
                          height: 250, // Set your desired fixed height here
                          child: Stack(
                            children: [
                              Chewie(
                                controller: ChewieController(
                                  videoPlayerController:
                                      VideoPlayerController.network(
                                          widget.challengeImgUrl),
                                  autoPlay: false,
                                  looping: true,
                                  showControls: true, // Hide controls if needed
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
                            countUpdate.increaseLikes2(widget.postId, 1);
                            Service()
                                .likeAction(widget.postId, "A", widget.userId);
                          },
                          child: widget.isLiked
                              ? Icon(CupertinoIcons.heart_fill,
                                  color: Colors.red, size: 25)
                              : Icon(CupertinoIcons.heart,
                                  color: Colors.red, size: 25),
                        ),
                        Text("${widget.likeCount.toString()} Likes")
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
                                  postId: widget.postId, userId: widget.userId,
                                  // myProvider: myProvider,
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
                                countUpdate.increaseLikes2(widget.postId, 2);
                                Service().likeAction(
                                    widget.postId, "B", widget.userId);
                              },
                              child: widget.isLiked
                                  ? Icon(CupertinoIcons.heart_fill,
                                      color: Colors.red, size: 25)
                                  : Icon(CupertinoIcons.heart,
                                      color: Colors.red, size: 25),
                            ),
                            Text("${widget.likeCount.toString()} Likes")
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.caption != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 2),
                  child: Row(
                    children: [
                      Text(
                        widget.name, // Add your username here
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
                          widget.caption,
                          trimLines: 1,
                          style: Theme.of(context).textTheme.bodyLarge!,
                          colorClickableText: Theme.of(context).primaryColor,
                          trimMode: TrimMode.line,
                          trimCollapsedText: '...Show more',
                          trimExpandedText: '...Show less',
                          moreStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Text("${widget.commentCount} comments"),

              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
