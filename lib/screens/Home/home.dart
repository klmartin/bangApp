import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/extension.dart';
import '../../services/animation.dart';
import 'package:bangapp/widgets/user_profile.dart';
import 'package:bangapp/widgets/build_media.dart';
import 'package:bangapp/screens/Widgets/like_button.dart';
import '../Comments/commentspage.dart';
import '../Profile/profile.dart';
import 'package:bangapp/screens/Widgets/readmore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Widgets/small_box.dart';

List<String> likedusers = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SizedBox spacing() {
    return SizedBox(
      width: 15.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                 // SmallBoxCarousel(boxes: boxes),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          PostStream(),
        ],
      ),
    ]);
  }
}
class PostStream extends StatelessWidget {
  Future<List<dynamic>> getPosts() async {
    var response = await http.get(Uri.parse('http://192.168.188.229/social-backend-laravel/api/getPosts'));
    var data = json.decode(response.body);
    print(response.body);
    return data['data']['data'];
  }
  void viewImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SizedBox.expand(
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
  String getMediaTypeFromUrl(String url) {
    final extension = url.split('.').last.toLowerCase();
    if (extension == 'jpg' || extension == 'jpeg' || extension == 'png' || extension == 'gif') {
      return 'image';
    } else if (extension == 'mp4' || extension == 'mov' || extension == 'avi' || extension == 'wmv') {
      return 'video';
    } else {
      return 'unknown'; // Return 'unknown' if the media type is unsupported
    }
  }
  @override

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        var postCount = 0;
        List<BoxData> boxes = [
          BoxData(
            imageUrl1: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/amber1.jpeg',
            imageUrl2: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/gigi1.jpeg',
            text: 'Nani Mkali ?',
          ),
          BoxData(
            imageUrl1: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/amber2.jpeg',
            imageUrl2: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/gigi2.jpeg',
            text: 'Nani Mkali ?',
          ),
          BoxData(
            imageUrl1: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/amber3.jpeg',
            imageUrl2: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/gigi3.jpeg',
            text: 'Nani Mkali ?',
          ),
          BoxData(
            imageUrl1: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/amber3.jpeg',
            imageUrl2: 'https://citsapps.com/social-backend-laravel/storage/app/images/battle/amber3.jpeg',
            text: 'Nani Mkali ?',
          ),

        ];
        List<Widget> postCards = [];

        if (snapshot.data != null) {
          final List<dynamic> dataList = snapshot.data as List<dynamic>;
          for (var post in dataList) {
            final name = post['user']['name'];
            final followerCount = post['user']['followerCount'].toString();
            final caption = post['body'];
            final imgurl = post['image'];
            final challengeImgUrl = post['challenge_img'];
            final imgWidth = post['width'];
            final imgHeight = post['height'];
            final postId = post['id'];
            final commentCount = post['commentCount'];
            final userId = post['user']['id'];
            var isLiked = post['isFavorited']==0 ? false : true ;
            var likeCount = post['likes'] != null && post['likes'].isNotEmpty ? post['likes'][0]['like_count'] : 0;
            var type = post['type'];
            var isPinned = post['pinned'];
            // final likeCount = likes.isEmpty ? 0 : int.parse(post['likes']['like_count']) ;
            postCount ++;
            if(postCount % 3 == 0){
              postCards.add(SmallBoxCarousel(boxes: boxes,));
            }
            if (challengeImgUrl != null) {
              postCards.add(
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(1, 30, 34, 45),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
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
                                          id: userId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      UserProfile(
                                        url: imgurl,
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
                                                name,
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
                                                '        ${followerCount} Followers',
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
                                                // if (widget.currentUser.id ==
                                                //     widget.post.userId)
                                                //   Column(
                                                //     children: [
                                                //       ListTile(
                                                //         onTap: () {
                                                //           BlocProvider.of<
                                                //               PostCubit>(
                                                //               context)
                                                //               .deletePost(
                                                //               widget
                                                //                   .currentUser
                                                //                   .id,
                                                //               widget.post
                                                //                   .postId);
                                                //           Navigator.pop(context);
                                                //         },
                                                //         minLeadingWidth: 20,
                                                //         leading: Icon(
                                                //           CupertinoIcons.delete,
                                                //           color: Theme.of(context)
                                                //               .primaryColor,
                                                //         ),
                                                //         title: Text(
                                                //           "Delete Post",
                                                //           style: Theme.of(context)
                                                //               .textTheme
                                                //               .bodyText1,
                                                //         ),
                                                //       ),
                                                //       Divider(
                                                //         height: .5,
                                                //         thickness: .5,
                                                //         color:
                                                //         Colors.grey.shade800,
                                                //       )
                                                //     ],
                                                //   ),
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
                        AspectRatio(
                          aspectRatio: 190 / 120,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    viewImage(context,imgurl);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: imgurl,
                                    placeholder: (context, url) => AspectRatio(
                                      aspectRatio: imgWidth / imgHeight,
                                      child: Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(255, 30, 34, 45),
                                        highlightColor:
                                        const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                                        child: Container(
                                            color: const Color.fromARGB(255, 30, 34, 45)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), //Add some spacing between the images
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    viewImage(context,challengeImgUrl);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: challengeImgUrl,
                                    placeholder: (context, url) => AspectRatio(
                                      aspectRatio: 190 / 250,
                                      child: Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(255, 30, 34, 45),
                                        highlightColor:
                                        const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                                        child: Container(
                                            color: const Color.fromARGB(255, 30, 34, 45)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),//displaying first challenge picture
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle the first heart icon tap
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
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
                                      "$likeCount likes" ,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),//for liking first picture
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
                                            postId: postId, userId: userId, messageStreamState: null,
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
                                  ),//for comments
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
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
                                                !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 30) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30),
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
                                              '$likeCount like',
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
                                  )

                                ],
                              ),
                            ],
                          ),
                        ),
                        if (caption != "") SizedBox(height: 16),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ReadMoreText(
                              caption,
                              trimLines: 2,
                              style: Theme.of(context).textTheme.bodyText1!,
                              colorClickableText: Theme.of(context).primaryColor,
                              trimMode: TrimMode.line,
                              trimCollapsedText: '...Show more',
                              trimExpandedText: '...Show less',
                              userName: name,
                              moreStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Text("     $commentCount comments"),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ));
            } else {
              postCards.add(
                  Container(
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
                                            id: userId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        UserProfile(
                                          url: imgurl,
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
                                                  name,
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
                                                  '        ${followerCount} Followers',
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
                                                  // if (widget.currentUser.id ==
                                                  //     widget.post.userId)
                                                  //   Column(
                                                  //     children: [
                                                  //       ListTile(
                                                  //         onTap: () {
                                                  //           BlocProvider.of<
                                                  //               PostCubit>(
                                                  //               context)
                                                  //               .deletePost(
                                                  //               widget
                                                  //                   .currentUser
                                                  //                   .id,
                                                  //               widget.post
                                                  //                   .postId);
                                                  //           Navigator.pop(context);
                                                  //         },
                                                  //         minLeadingWidth: 20,
                                                  //         leading: Icon(
                                                  //           CupertinoIcons.delete,
                                                  //           color: Theme.of(context)
                                                  //               .primaryColor,
                                                  //         ),
                                                  //         title: Text(
                                                  //           "Delete Post",
                                                  //           style: Theme.of(context)
                                                  //               .textTheme
                                                  //               .bodyText1,
                                                  //         ),
                                                  //       ),
                                                  //       Divider(
                                                  //         height: .5,
                                                  //         thickness: .5,
                                                  //         color:
                                                  //         Colors.grey.shade800,
                                                  //       )
                                                  //     ],
                                                  //   ),
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
                              viewImage(context, imgurl);
                            },
                            child: AspectRatio(
                              aspectRatio: imgWidth / imgHeight,
                              child: buildMediaWidget(context, imgurl,type,imgWidth,imgHeight,isPinned),
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
                                        postId: postId, userId: userId, messageStreamState: null,
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
                                        LikeButton(likeCount: 0 ,isLiked:isLiked,postId:postId),
                                        SizedBox(width: 4),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "$likeCount likes" ,
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
                          if (caption != "") const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ReadMoreText(
                              caption,
                              trimLines: 2,
                              style: Theme.of(context).textTheme.bodyText1!,
                              colorClickableText: Theme.of(context).primaryColor,
                              trimMode: TrimMode.line,
                              trimCollapsedText: '...Show more',
                              trimExpandedText: '...Show less',
                              userName: name,
                              moreStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),

                          Text("     $commentCount comments"),
                          const SizedBox(height: 20),
                        ],
                      )));
            }
          }
        }

        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: postCards.reversed.toList(),
        );
      },
    );
  }
  void setState(Null Function() param0) {}
}



