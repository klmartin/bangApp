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
// import 'package:nallagram/screens/create_page.dart';
// import 'package:nallagram/nav.dart';
// import 'package:nallagram/screens/profile.dart';
import 'package:like_button/like_button.dart';
import 'package:nallagram/widgets/story_widget.dart';
import '../../widgets/post_card.dart';
import '../Comments/commentspage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      spacing(),
                      StoryWid(
                          img: StoryViewData[0].img,
                          name: StoryViewData[0].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[1].img,
                          name: StoryViewData[1].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[2].img,
                          name: StoryViewData[2].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[3].img,
                          name: StoryViewData[3].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[4].img,
                          name: StoryViewData[4].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[5].img,
                          name: StoryViewData[5].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[6].img,
                          name: StoryViewData[6].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[7].img,
                          name: StoryViewData[7].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[8].img,
                          name: StoryViewData[8].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[9].img,
                          name: StoryViewData[9].name),
                      spacing(),
                    ],
                  ),
                ),
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
    var response = await http.get(Uri.parse('http://192.168.111.229/social-backend-laravel/api/getAllPosts'));
    var data = json.decode(response.body);
    return data['posts'];
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
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

        List<Widget> postCards = [];

        for (var post in snapshot.data) {
          final caption = post['caption'];
          final imgurl = post['imgurl'];
          final challengeImgUrl = post['challengeImgUrl'];
          final imgWidth = post['width'];
          final imgHeight = post['height'];
          // final challengeimgWidth = post['chwidth'];
          // final challengeimgHeight =  post['chheight'];

          if (challengeImgUrl != null) {
            postCards.add(
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(1, 30, 34, 45),
                  ),
                  child: Column(
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
                                      Text(
                                        'widget.post.name',
                                        style: const TextStyle(
                                          fontFamily: 'EuclidTriangle',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 0,
                                          color: Colors.white,
                                        ),
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
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    AspectRatio(
                      aspectRatio: 190 / 150,
                      child: Row(
                        children: [
                          Expanded(
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
                          SizedBox(width: 5), //Add some spacing between the images
                          Expanded(
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            // onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     createRoute(
                            //       PostLikedBy(
                            //         postId: widget.post.postId,
                            //         currentUser: widget.currentUser,
                            //         userId: widget.post.userId,
                            //       ),
                            //     ),
                            //   );
                            // },
                            child: Text(
                              "${2} likes",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // final url = await getUrl(
                                  //   description: "state.post.caption",
                                  //   image: "state.post.postImageUrl",
                                  //   title:
                                  //   'Check out this post by Martin}',
                                  //   url:
                                  //   'https://anshrathod.vercel.app/socialapp?post_user_id=${state.post.userId}&post_id=${state.post.postId}&type=post',
                                  // );
                                  // Share.share(
                                  //     'Check out this post $url on Photoarc app',
                                  //     subject: 'Made in flutter with 💙');
                                },
                                child: const Icon(
                                  CupertinoIcons.share,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       createRoute(
                              //         CommentScreen(
                              //           postId: widget.post.postId,
                              //           userId: widget.post.userId,
                              //           currentUser: widget.currentUser,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: const Icon(
                              //     CupertinoIcons.bubble_middle_bottom,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // BlocProvider.of<PostCubit>(context).like();
                                },
                                // child: !state.isLiked
                                //     ? const Icon(
                                //   CupertinoIcons.heart,
                                //   color: Colors.white,
                                // )
                                //     : const Icon(
                                //   CupertinoIcons.heart_solid,
                                //   color: Colors.red,
                                // ),
                                child: const Icon(CupertinoIcons.heart,color:Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // if (widget.post.caption != "") const SizedBox(height: 16),
                    // if (widget.post.caption != "")
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: ReadMoreText(
                    //       widget.post.caption,
                    //       trimLines: 2,
                    //       style: Theme.of(context).textTheme.bodyText1,
                    //       colorClickableText: Theme.of(context).primaryColor,
                    //       trimMode: TrimMode.line,
                    //       trimCollapsedText: '...Show more',
                    //       trimExpandedText: '...Show less',
                    //       moreStyle: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //   ),
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
                                          Text(
                                            'widget.post.name',
                                            style: const TextStyle(
                                              fontFamily: 'EuclidTriangle',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 0,
                                              color: Colors.white,
                                            ),
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
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AspectRatio(
                          aspectRatio: imgWidth / imgHeight,
                          child: CachedNetworkImage(
                            imageUrl: imgurl,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio:190 / 250,
                              child: Shimmer.fromColors(
                                baseColor: const Color.fromARGB(255, 30, 34, 45),
                                highlightColor:
                                const Color.fromARGB(255, 30, 34, 45)
                                    .withOpacity(.85),
                                child: Container(
                                    color: const Color.fromARGB(255, 30, 34, 45)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                // onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     createRoute(
                                //       PostLikedBy(
                                //         postId: widget.post.postId,
                                //         currentUser: widget.currentUser,
                                //         userId: widget.post.userId,
                                //       ),
                                //     ),
                                //   );
                                // },
                                child: Text(
                                  "${2} likes",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    // onTap: () async {
                                    //   final url = await getUrl(
                                    //     description: state.post.caption,
                                    //     image: state.post.postImageUrl,
                                    //     title:
                                    //     'Check out this post by ${state.post.name}',
                                    //     url:
                                    //     'https://anshrathod.vercel.app/socialapp?post_user_id=${state.post.userId}&post_id=${state.post.postId}&type=post',
                                    //   );
                                    //   Share.share(
                                    //       'Check out this post $url on Photoarc app',
                                    //       subject: 'Made in flutter with 💙');
                                    // },
                                    child: const Icon(
                                      CupertinoIcons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  GestureDetector(
                                    // onTap: () {
                                    //   Navigator.push(
                                    //     context,
                                    //     createRoute(
                                    //       CommentScreen(
                                    //         postId: widget.post.postId,
                                    //         userId: widget.post.userId,
                                    //         currentUser: widget.currentUser,
                                    //       ),
                                    //     ),
                                    //   );
                                    // },
                                    child: const Icon(
                                      CupertinoIcons.bubble_middle_bottom,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // BlocProvider.of<PostCubit>(context).like();
                                    },
                                    // child: !state.isLiked
                                    //     ? const Icon(
                                    //   CupertinoIcons.heart,
                                    //   color: Colors.white,
                                    // )
                                    //     : const Icon(
                                    //   CupertinoIcons.heart_solid,
                                    //   color: Colors.red,
                                    // ),
                                    child: const Icon(CupertinoIcons.heart,color:Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // if (widget.post.caption != "") const SizedBox(height: 16),
                        // if (widget.post.caption != "")
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //     child: ReadMoreText(
                        //       widget.post.caption,
                        //       trimLines: 2,
                        //       style: Theme.of(context).textTheme.bodyText1,
                        //       colorClickableText: Theme.of(context).primaryColor,
                        //       trimMode: TrimMode.line,
                        //       trimCollapsedText: '...Show more',
                        //       trimExpandedText: '...Show less',
                        //       moreStyle: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: Theme.of(context).primaryColor,
                        //       ),
                        //     ),
                        //   ),
                        const SizedBox(height: 20),
                      ],
                    ))
            );
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
}



