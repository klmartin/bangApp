import 'package:bangapp/screens/Widgets/post_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../providers/Profile_Provider.dart';
import 'package:bangapp/services/service.dart';
import '../../providers/post_likes.dart';
import '../../widgets/build_media.dart';
import '../../widgets/like_sheet.dart';
import '../Comments/post_comment.dart';
import '../Widgets/readmore.dart';
import 'package:provider/provider.dart';

class NotifyView extends StatefulWidget {
  String? name;
  String? caption;
  String? imgurl;
  String? challengeImgUrl;
  int? imgWidth;
  int? imgHeight;
  int? postId;
  int? commentCount;
  int? userId;
  bool? isLiked;
  int? likeCount;
  String? type;
  int? followerCount;
  String? created;
  String? user_image;
  int? pinnedImage;
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  int postViews;
  ProfileProvider? myProvider;

  NotifyView(
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
    this.cacheUrl,
    this.thumbnailUrl,
    this.aspectRatio,
    this.postViews,
    this.myProvider,
  );
  static const id = 'postview';
  @override
  _NotifyViewState createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: NotifyCard(
                widget.name!,
                widget.caption!,
                widget.imgurl!,
                widget.challengeImgUrl!,
                widget.imgWidth!,
                widget.imgHeight!,
                widget.postId!,
                widget.commentCount!,
                widget.userId!,
                widget.isLiked!,
                widget.likeCount!,
                widget.type!,
                widget.followerCount!,
                widget.created!,
                widget.user_image!,
                widget.pinnedImage!,
                widget.cacheUrl,
                widget.thumbnailUrl,
                widget.aspectRatio,
                widget.postViews,
                widget.myProvider!),
          ),
        ),
      ),
    );
  }
}

class NotifyCard extends StatefulWidget {
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
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  int? price;
  int postViews;
  ProfileProvider myProvider;
  ScrollController _scrollController = ScrollController();
  NotifyCard(
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
      this.cacheUrl,
      this.thumbnailUrl,
      this.aspectRatio,
      this.postViews,
      this.myProvider);
  @override
  State<NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  bool _isEditing = false;

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
          backgroundColor: Colors.white,
          actions: [SizedBox(width: 10)],
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(1, 30, 34, 45),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        "notification") ??
                    Container(),
                InkWell(
                  onTap: () => widget.type == 'image'
                      ? viewImage(context, widget.postUrl)
                      : null,
                  child: AspectRatio(
                    aspectRatio: widget.imgWidth / widget.imgHeight,
                    child: buildMediaWidget(
                        context,
                        widget.postUrl,
                        widget.type,
                        widget.pinned,
                        widget.cacheUrl,
                        widget.thumbnailUrl,
                        widget.aspectRatio,
                        widget.postId,
                        widget.postId),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.72,
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
                                  3), // Add some spacing between the username and caption
                          Expanded(
                            child: ReadMoreText(
                              widget.caption,
                              trimLines: 1,
                              colorClickableText:
                                  Theme.of(context).primaryColor,
                              trimMode: TrimMode.line,
                              trimCollapsedText: '...Show more',
                              trimExpandedText: '...Show less',
                              textColor: Colors.black,
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
                                color: Colors.black,
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
                                        userId: widget.userId,
                                        postId: widget.postId,
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
                                      print('tapped');

                                      Service().likeAction(
                                          widget.postId, "A", widget.userId);
                                      setState(() {
                                        if (widget.isLiked) {
                                          widget.likeCount--;
                                          widget.isLiked = false;
                                        } else {
                                          widget.likeCount++;
                                          widget.isLiked = true;
                                        }
                                      });
                                    },
                                    child: widget.isLiked
                                        ? Icon(CupertinoIcons.heart_fill,
                                            color: Colors.red, size: 25)
                                        : Icon(CupertinoIcons.heart,
                                            color: Colors.red, size: 25),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<UserLikesProvider>(context,
                                              listen: false)
                                          .getUserLikedPost(widget.postId);

                                      LikesModal.showLikesModal(
                                          context, widget.postId);
                                    },
                                    child: Text(
                                      "${widget.likeCount.toString()} likes",
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CommentsPage(
                              userId: widget.userId,
                              postId: widget.postId,
                            );
                          },
                        ));
                      },
                      child: Text('${widget.commentCount} comments')
                  ),
                ),
              ],
            )));
  }
}

class PostCaptionWidget extends StatefulWidget {
  final String? caption;
  final String? name;
  final bool isEditing;

  const PostCaptionWidget({
    Key? key,
    this.caption,
    this.name,
    required this.isEditing,
  }) : super(key: key);

  @override
  _PostCaptionWidgetState createState() => _PostCaptionWidgetState();
}

class _PostCaptionWidgetState extends State<PostCaptionWidget> {
  bool _isEditing = false;
  TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.caption ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      return TextField(
        controller: _captionController,
        style: Theme.of(context).textTheme.bodyLarge!,
        decoration: InputDecoration(
          hintText: 'Type your caption...',
        ),
      );
    } else {
      return ReadMoreText(
        widget.caption ?? "",
        trimLines: 2,
        colorClickableText: Theme.of(context).primaryColor,
        trimMode: TrimMode.line,
        trimCollapsedText: '...Show more',
        trimExpandedText: '...Show less',
        textColor: Colors.black,
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
          color: Colors.black,
        ),
      );
    }
  }
}
