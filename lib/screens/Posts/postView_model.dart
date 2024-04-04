import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/screens/Widgets/post_options.dart';
import 'package:bangapp/widgets/like_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/Profile_Provider.dart';
import 'package:bangapp/services/service.dart';
import '../../services/animation.dart';
import '../../widgets/build_media.dart';
import '../Comments/post_comment.dart';
import '../Widgets/readmore.dart';
import 'package:provider/provider.dart';

class POstView extends StatefulWidget {
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
  String? price;
  int postViews;
  ProfileProvider? myProvider;

  POstView(
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
    this.price,
    this.postViews,
    this.myProvider,
  );
  static const id = 'postview';
  @override
  _POstViewState createState() => _POstViewState();
}

class _POstViewState extends State<POstView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: PostCard(
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
                widget.price,
                widget.postViews,
                widget.myProvider!),
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
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  String? price;
  int postViews;
  ProfileProvider myProvider;
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
      this.cacheUrl,
      this.thumbnailUrl,
      this.aspectRatio,
      this.price,
      this.postViews,
      this.myProvider);
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isEditing = false;
  TextEditingController _captionController = TextEditingController();

  var myProvider;
  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void initState() {
    super.initState();
    _captionController.text = widget.caption ?? '';
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
        body: Stack(
          children:[ Column(
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
                      "profile") ??
                  Container(),
              _isEditing ? AlertDialog(title: Center(child: Text("Edit Caption")),
                  content: TextField(
                    controller: _captionController,
                    style: Theme.of(context).textTheme.bodyLarge!,
                    decoration: InputDecoration(
                      hintText: 'Type your caption...',
                    ),
                  ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      setState(() {
                        widget.caption = _captionController.text;
                        _isEditing = !_isEditing;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text("Save"),
                    onPressed: () async {
                      var editMessage = await Service().editPost(widget.postId, _captionController.text);
                      print(editMessage);

                      Fluttertoast.showToast(
                        msg: editMessage['message'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      if (editMessage['message'] == "Post edited successfully") {
                        setState(() {
                          widget.caption = _captionController.text;
                          _isEditing = !_isEditing;
                        });
                      }
                    },
                  ),
                ]) :Container(),
              InkWell(
                onTap: () {
                  viewImage(context, widget.postUrl);
                },
                child: buildMediaWidget(
                  context,
                  widget.postUrl,
                  widget.type,
                  widget.imgWidth,
                  widget.imgHeight,
                  widget.pinned,
                  widget.cacheUrl,
                  widget.thumbnailUrl,
                  widget.aspectRatio,
                  widget.postId,
                  widget.price,
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
                          child: GestureDetector(
                            onTap: (){
                              toggleEditing();
                            },
                            child: ReadMoreText(
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
                                    widget.myProvider
                                        .increaseLikes(widget.postId);
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
                child: GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CommentsPage(
                        userId: widget.userId,
                        postId: widget.postId,
                      );
                    },
                  ));
                },child: Text('${widget.commentCount} comments')),
              ),
            ],
          )],
        ));
  }
}

class PostCaptionWidget extends StatefulWidget {
   String? caption;
  final String? name;
  final int? postId;
  bool isEditing;
  PostCaptionWidget({
    Key? key,
    this.caption,
    this.name,
    this.postId,
    required this.isEditing,
  }) : super(key: key);

  @override
  _PostCaptionWidgetState createState() => _PostCaptionWidgetState();
}

class _PostCaptionWidgetState extends State<PostCaptionWidget> {
  bool _isEditing = false;
  TextEditingController _captionController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.isCurrent) {
        myFocusNode.requestFocus();
      }
    });
    _captionController.text = widget.caption ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the isEditing state when the caption is pressed
          widget.isEditing = !widget.isEditing;
        });
      },
      child: widget.isEditing
          ? AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _captionController,
              style: Theme.of(context).textTheme.bodyLarge!,
              decoration: InputDecoration(
                hintText: 'Type your caption...',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              var editMessage = await Service().editPost(widget.postId, _captionController.text);

              Fluttertoast.showToast(
                msg: editMessage['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[600],
                textColor: Colors.white,
                fontSize: 16.0,
              );
              if (editMessage['message'] == "Post edited successfully") {
                setState(() {
                  widget.caption = _captionController.text;
                  widget.isEditing = !widget.isEditing;
                });
              }
            },
          ),
        ],
      )
          : ReadMoreText(
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
      ),
    );
  }
}
