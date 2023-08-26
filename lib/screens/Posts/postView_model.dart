import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../services/animation.dart';
import '../../services/extension.dart';
import 'package:bangapp/services/service.dart';
import '../../widgets/build_media.dart';
import '../../widgets/user_profile.dart';
import '../Comments/commentspage.dart';
import '../Profile/profile.dart';
import '../Widgets/readmore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class POstView extends StatefulWidget {
  final  name;
  final  caption;
  final  imgurl;
  final  challengeImgUrl;
  final  imgWidth;
  final  imgHeight;
  final  postId;
  final  commentCount;
  final  userId;
  final  isLiked;
  final  likeCount;
  final  type;

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
            child: PostCard(widget.name,widget.caption,widget.imgurl,widget.challengeImgUrl,widget.imgWidth,widget.imgHeight,widget.postId,widget.commentCount,widget.userId,widget.isLiked,widget.likeCount,widget.type),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String postUrl;
  final name;
  final caption;
  final challengeImgUrl;
  final imgWidth;
  final imgHeight;
  final postId;
  final commentCount;
  final userId;
  var isLiked;
  var likeCount;
  var type;
  var followerCount;
  ScrollController _scrollController = ScrollController();
  PostCard(this.name,this.caption,this.postUrl,this.challengeImgUrl, this.imgWidth, this.imgHeight, this.postId, this.commentCount, this.userId,this.isLiked,this.likeCount,this.type);
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isEditing = false;
  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            Profile(
                              id: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          UserProfile(
                            url: widget.postUrl,
                            size: 40,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontFamily: 'EuclidTriangle',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '        ${widget.followerCount} Followers',
                                    style: const TextStyle(
                                      fontFamily: 'EuclidTriangle',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                  StringExtension
                                      .displayTimeAgoFromTimestamp(
                                    '2023-04-17 13:51:04',
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                        const Color.fromARGB(255, 30, 34, 45),
                        context: context,
                        builder: (BuildContext ctx) {
                          return Container(
                              color: Colors.black26,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Container(
                                      height: 5,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                        children: [
                                          ListTile(
                                            onTap: () async{
                                              try {
                                                var response = await Service().deletePost(widget.postId);
                                                if (response["message"] == "Post deleted successfully") {
                                                  Navigator.push(
                                                    context,
                                                    createRoute(
                                                      Profile(
                                                        id: widget.userId,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // Show a toast indicating deletion failure
                                                  Fluttertoast.showToast(msg: "Post deletion failed.");
                                                }
                                              } catch (e) {
                                                // Show a toast indicating deletion failure (in case of an error)
                                                Fluttertoast.showToast(msg: "Post deletion failed.");
                                              }
                                            },
                                            minLeadingWidth: 20,
                                            leading: Icon(
                                              CupertinoIcons.delete,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              "Delete Post",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          Divider(
                                            height: .5,
                                            thickness: .5,
                                            color:
                                            Colors.grey.shade800,
                                          )
                                        ],
                                      ),
                                    Column(
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            setState(() {
                                              _isEditing = !_isEditing;
                                            });
                                          },
                                          minLeadingWidth: 20,
                                          leading: Icon(
                                            CupertinoIcons.pencil,
                                            color: Theme.of(context)
                                                .primaryColor,
                                          ),
                                          title: Text(
                                            "Edit Post",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        Divider(
                                          height: .5,
                                          thickness: .5,
                                          color:
                                          Colors.grey.shade800,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ListTile(
                                          // onTap: () async {
                                          //   final url = await getUrl(
                                          //     description:
                                          //     state.post.caption,
                                          //     image: state
                                          //         .post.postImageUrl,
                                          //     title:
                                          //     'Check out this post by ${state.post.name}',
                                          //     url:
                                          //     'https://ansh-rathod-blog.netlify.app/socialapp?post_user_id=${state.post.userId}&post_id=${state.post.postId}&type=post',
                                          //   );
                                          //   Clipboard.setData(
                                          //       ClipboardData(
                                          //           text: url
                                          //               .toString()));
                                          //   Navigator.pop(context);
                                          //   showSnackBarToPage(
                                          //     context,
                                          //     'Copied to clipboard',
                                          //     Colors.green,
                                          //   );
                                          // },
                                          minLeadingWidth: 20,
                                          leading: Icon(
                                            CupertinoIcons.link,
                                            color: Theme.of(context)
                                                .primaryColor,
                                          ),
                                          title: Text(
                                            "Copy URL",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        Divider(
                                          height: .5,
                                          thickness: .5,
                                          color: Colors.grey.shade800,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            // launch(state
                                            //     .post.postImageUrl);
                                          },
                                          minLeadingWidth: 20,
                                          leading: Icon(
                                            CupertinoIcons.photo,
                                            color: Theme.of(context)
                                                .primaryColor,
                                          ),
                                          title: Text(
                                            "Challenge Image",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        Divider(
                                          height: .5,
                                          thickness: .5,
                                          color: Colors.grey.shade800,
                                        )
                                      ],
                                    ),
                                  ]));
                        },
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.ellipsis,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                viewImage(context, widget.postUrl);
              },
              child: AspectRatio(
                aspectRatio: widget.imgWidth / widget.imgHeight,
                child: buildMediaWidget(context, widget.postUrl,widget.type,widget.imgWidth,widget.imgHeight,0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 280),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        CommentsPage(
                          postId: widget.postId, userId: widget.userId, messageStreamState: null,
                          // currentUser: 1,
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.chat_bubble,
                    color: Colors.black,
                    size: 29,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LikeButton(likeCount:0,isLiked:widget.isLiked,),
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
                  ),
                ),
              ],
            ),
            if (widget.caption != null) const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // child: ReadMoreText(
              //   widget.caption ?? "",
              //   trimLines: 2,
              //   style: Theme.of(context).textTheme.bodyText1!,
              //   colorClickableText: Theme.of(context).primaryColor,
              //   trimMode: TrimMode.line,
              //   trimCollapsedText: '...Show more',
              //   trimExpandedText: '...Show less',
              //   userName: widget.name,
              //   moreStyle: TextStyle(
              //     fontSize: 15,
              //     color: Theme.of(context).primaryColor,
              //   ),
              // ),
              child: PostCaptionWidget(caption: widget.caption, isEditing: _isEditing,),
            ),

            Text("     ${widget.commentCount} comments"),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class PostCaptionWidget extends StatefulWidget {
  final String? caption;
  final String? name;
  final bool isEditing;

  const PostCaptionWidget({Key? key, this.caption, this.name,required this.isEditing,}) : super(key: key);

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
        style: Theme.of(context).textTheme.bodyText1!,
        decoration: InputDecoration(
          hintText: 'Type your caption...',
        ),
      );
    }else {
      return ReadMoreText(
        widget.caption ?? "",
        trimLines: 2,
        style: Theme.of(context).textTheme.bodyText1!,
        colorClickableText: Theme.of(context).primaryColor,
        trimMode: TrimMode.line,
        trimCollapsedText: '...Show more',
        trimExpandedText: '...Show less',
        userName: widget.name,
        moreStyle: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
