import 'package:bangapp/screens/Widgets/post_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../providers/Profile_Provider.dart';
import 'package:bangapp/services/service.dart';
import '../../widgets/build_media.dart';
import '../Comments/post_comment.dart';
import '../Widgets/readmore.dart';
import 'package:provider/provider.dart';


class POstView2 extends StatefulWidget {

  ProfileProvider? myProvider;

  POstView2(

      this.myProvider,
      );
  static const id = 'postview';
  @override
  _POstViewState2 createState() => _POstViewState2();
}

class _POstViewState2 extends State<POstView2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("data"),
            // child: PostCard(widget.name!,widget.caption!,widget.imgurl!,widget.challengeImgUrl!,widget.imgWidth!,widget.imgHeight!,widget.postId!,widget.commentCount!,widget.userId!,widget.isLiked!,widget.likeCount!,widget.type!,widget.followerCount!,widget.created!,widget.user_image!,widget.pinnedImage!,widget.myProvider!),
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
  ProfileProvider myProvider;
  ScrollController _scrollController = ScrollController();
  PostCard(this.name,this.caption,this.postUrl,this.challengeImgUrl, this.imgWidth, this.imgHeight, this.postId, this.commentCount, this.userId,this.isLiked,this.likeCount,this.type,this.followerCount,this.createdAt,this.userImage,this.pinned,this.myProvider);
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
          title:  GestureDetector(
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
          actions: [

            SizedBox(width: 10)
          ],
        ),
        body:Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(1, 30, 34, 45),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postOptions(context, widget.userId, widget.userImage, widget.name, widget.followerCount, widget.postUrl, widget.postId, widget.userId, widget.type,widget.createdAt) ?? Container(),
                InkWell(
                  onTap: () {
                    viewImage(context, widget.postUrl);
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: buildMediaWidget(context, widget.postUrl,widget.type,widget.imgWidth,widget.imgHeight,widget.pinned),
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
                          SizedBox(width: 3), // Add some spacing between the username and caption
                          Expanded(
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
                                color: Theme.of(context).primaryColor,
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
                                      final countUpdate = Provider.of<ProfileProvider>(context, listen: false);
                                      widget.myProvider.increaseLikes(widget.postId);
                                      Service().likeAction(widget.postId, "A", widget.userId);

                                    },
                                    child: widget.isLiked
                                        ? Icon(CupertinoIcons.heart_fill,
                                        color: Colors.red, size: 25)
                                        : Icon(CupertinoIcons.heart,
                                        color: Colors.red, size: 25),
                                  ),
                                  Text(
                                    "${widget.likeCount.toString()} likes",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
                  child: Text('${widget.commentCount} comments'),
                ),

              ],
            )));
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
        style: Theme.of(context).textTheme.bodyLarge!,
        decoration: InputDecoration(
          hintText: 'Type your caption...',
        ),
      );
    }else {
      return ReadMoreText(
        widget.caption ?? "",
        trimLines: 2,
        style: Theme.of(context).textTheme.bodyLarge!,
        colorClickableText: Theme.of(context).primaryColor,
        trimMode: TrimMode.line,
        trimCollapsedText: '...Show more',
        trimExpandedText: '...Show less',
        moreStyle: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
