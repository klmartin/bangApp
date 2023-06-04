import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nallagram/models/story_view_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/extension.dart';
import '../../services/animation.dart';
import 'package:nallagram/widgets/user_profile.dart';
import 'package:like_button/like_button.dart';
import 'package:nallagram/widgets/story_widget.dart';
import '../Comments/commentspage.dart';
import 'package:nallagram/screens/Widgets/readmore.dart';
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
    List<BoxData> boxes = [
      BoxData(
        imageUrl1: 'https://via.placeholder.com/1000x500',
        imageUrl2: 'https://via.placeholder.com/1000x500',
        text: 'Bang Battle 1',
      ),
      BoxData(
        imageUrl1: 'https://via.placeholder.com/1000x500',
        text: 'Bang Battle 2',
      ),
      BoxData(
        imageUrl1: 'https://via.placeholder.com/1000x500',
        text: 'Bang Battle 3',
      ),
      BoxData(
        imageUrl1: 'https://via.placeholder.com/1000x500',

        text: 'Bang Battle 3',
      ),
      BoxData(
        imageUrl1: 'https://via.placeholder.com/1000x500',
        text: 'Bang Battle 3',
      ),
    ];

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
    var response = await http.get(Uri.parse('http://192.168.15.229/social-backend-laravel/api/getPosts'));
    var data = json.decode(response.body);
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
        List<BoxData> boxes = [
          BoxData(
            imageUrl1: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/amber1.jpeg',
            imageUrl2: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/gigi1.jpeg',
            text: 'Bang Battle 1',
          ),
          BoxData(
            imageUrl1: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/amber2.jpeg',
            imageUrl2: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/gigi2.jpeg',
            text: 'Bang Battle 2',
          ),
          BoxData(
            imageUrl1: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/amber3.jpeg',
            imageUrl2: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/gigi3.jpeg',
            text: 'Bang Battle 3',
          ),
          BoxData(
            imageUrl1: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/amber3.jpeg',
            imageUrl2: 'http://192.168.15.229/social-backend-laravel/storage/app/images/battle/gigi4.jpeg',
            text: 'Bang Battle 3',
          ),

        ];
        List<Widget> postCards = [];
        int postCount =0;
        for (var post in snapshot.data) {

          final name = post['user']['name'];
          final followerCount = post['user']['followerCount'].toString();
          final caption = post['body'];
          final imgurl = post['image'];
          final challengeImgUrl = post['challenge_img'];
          final imgWidth = post['width'];
          final imgHeight = post['height'];
          final postId = post['id'];
          final userId = post['user']['id'];
          var isLiked = post['isFavorited']==0 ? false : true ;
          var likeCount = post['likeCount'];
          // final challengeimgWidth = post['chwidth'];
          // final challengeimgHeight =  post['chheight'];
          // final likeCount = likes.isEmpty ? 0 : int.parse(post['likes']['like_count']) ;
          if (challengeImgUrl != null) {
            if(postCount % 3 == 0){
              postCards.add(SmallBoxCarousel(boxes: boxes,));
            }
            else{
              postCards.add(
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(1, 30, 34, 45),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,


                                    //   createRoute(
                                    //     ProfileScreen(
                                    //       currentUser: widget.currentUser,
                                    //       id: widget.post.userId,
                                    //     ),
                                    //   ),
                                    // );
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
                                                  fontSize: 18,
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
                                                  fontSize: 18,
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
                        const SizedBox(height: 2),
                        AspectRatio(
                          aspectRatio: 190 / 150,
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
                        const SizedBox(height: 15),
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
                                        !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 40) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 40),
                                        SizedBox(width: 4),
                                        Positioned(
                                          top: 9,
                                          left: 13,
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
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
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        createRoute(
                                          CommentsPage(
                                            postId: postId,
                                            userId: 1,
                                            // currentUser: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.bubble_middle_bottom,
                                      color: Colors.black,
                                      size: 30,
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
                                                !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 40) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 40),
                                                SizedBox(width: 4),
                                                Positioned(
                                                  top: 9,
                                                  left: 13,
                                                  child: Text(
                                                    'B',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "$likeCount like",
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
                        if (caption != "") const SizedBox(height: 16),
                        if (caption != "")
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ReadMoreText(
                              caption,
                              trimLines: 2,
                              style: Theme.of(context).textTheme.bodyText1,
                              colorClickableText: Theme.of(context).primaryColor,
                              trimMode: TrimMode.line,
                              trimCollapsedText: '...Show more',
                              trimExpandedText: '...Show less',
                              moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ));
            }

            postCount ++;
          } else {
            if(postCount% 3 == 0){
              postCards.add(SmallBoxCarousel(boxes: boxes,));
            }else{
              postCards.add(
                  Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(1, 30, 34, 45),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   createRoute(
                                      //     ProfileScreen(
                                      //       currentUser: widget.currentUser,
                                      //       id: widget.post.userId,
                                      //     ),
                                      //   ),
                                      // );
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
                                                    fontSize: 18,
                                                    letterSpacing: 0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '         ${followerCount} Followers',
                                                  style: const TextStyle(
                                                    fontFamily: 'EuclidTriangle',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
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
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              viewImage(context, imgurl);
                            },
                            child: AspectRatio(
                              aspectRatio: imgWidth / imgHeight,
                              child: CachedNetworkImage(
                                imageUrl: imgurl,
                                placeholder: (context, url) => AspectRatio(
                                  aspectRatio: imgWidth / imgHeight,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(255, 30, 34, 45),
                                    highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
                                    child: Container(color: const Color.fromARGB(255, 30, 34, 45)),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !isLiked ?Icon(CupertinoIcons.heart, color: Colors.red, size: 40) : Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 40),
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
                          if (caption != "") const SizedBox(height: 16),
                          if (caption != "")
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ReadMoreText(
                                caption,
                                trimLines: 2,
                                style: Theme.of(context).textTheme.bodyText1,
                                colorClickableText: Theme.of(context).primaryColor,
                                trimMode: TrimMode.line,
                                trimCollapsedText: '...Show more',
                                trimExpandedText: '...Show less',
                                moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      )));
            }

            postCount ++;
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



