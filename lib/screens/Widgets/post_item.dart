import 'dart:typed_data';
import 'package:bangapp/screens/Widgets/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import '../../models/post.dart';
import '../../services/animation.dart';
import '../../services/extension.dart';
import '../../widgets/build_media.dart';
import '../../widgets/user_profile.dart';
import '../Comments/commentspage.dart';
import '../Create/video_editing/video_edit.dart';
import '../Profile/profile.dart';
import 'like_button.dart';
import 'dart:io';
class PostItem extends StatelessWidget {
  final int postId;
  final int userId;
  final String name;
  final String type;
  final String image;
  final challengeImg;
  final String caption;
  final int width;
  final int height;
  final int likeCountA;
  final int likeCountB;
  final int commentCount;
  final int followerCount;
  final List<Challenge> challenges;
  final isLiked ;
  final int isPinned;
  PostItem(this.postId,this.userId,this.name, this.image,this.challengeImg,this.caption,this.type,this.width,this.height,this.likeCountA,this.likeCountB,this.commentCount,this.followerCount,this.challenges,this.isLiked,this.isPinned);

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
  Future<Uint8List> fileToUint8List(File file) async {
    if (file != null) {
      List<int> bytes = await file.readAsBytes();
      return Uint8List.fromList(bytes);
    }
    return Uint8List(0);
  }
  Widget build(BuildContext context)
  {
    if (challengeImg != null && challenges.isEmpty ) {
      return Container(
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
                            url: image,
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
                                    '        $followerCount Followers',
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
                                      .bodyLarge)
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
                        backgroundColor:Colors.white,
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
                                                .bodyLarge,
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
                        viewImage(context,image);
                      },
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: width / height,
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
                        viewImage(context,challengeImg);
                      },
                      child: CachedNetworkImage(
                        imageUrl: challengeImg,
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
                  LikeButton(likeCount:likeCountA,isLiked:false,postId:postId,isChallenge:true,isButtonA:true,isButtonB:false),//for liking first picture
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
                                postId: postId, userId: userId,
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
                      LikeButton(likeCount:likeCountB,isLiked:false,postId:postId,isChallenge:true,isButtonA:false,isButtonB:true),

                    ],
                  ),
                ],
              ),
            ),
            if (caption != null) SizedBox(height: 16),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReadMoreText(
                  caption,
                  trimLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!,
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
      );
    }
    else if(challengeImg == null&& challenges.isEmpty ){
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
                                id: userId,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            UserProfile(
                              url: image,
                              size: 40,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '        $followerCount Followers',
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
                                    style: Theme.of(context).textTheme.bodyLarge)
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
                          backgroundColor:Colors.white,
                          context: context,
                          builder: (BuildContext ctx) {
                            return Container(
                                color: Colors.black,
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
                                                  .bodyLarge,
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
                                            onTap: () async {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                                              if (result != null) {
                                                File file = File(result.files.first.path!);
                                                final mimeType = lookupMimeType(file.path);
                                                if(mimeType!.startsWith('image/')){
                                                  Uint8List image = await fileToUint8List(file);
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ImageEditor(
                                                          image: image,
                                                          postId: postId,
                                                          userChallenged:userId,
                                                          challengeImg: true,
                                                          image2: null,
                                                          allowMultiple: true
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else if(mimeType.startsWith('video/')){
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => VideoEditor(
                                                        video: File(file.path),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else{
                                                  Fluttertoast.showToast(msg: "Unsupported file type.");
                                                }
                                              } else {
                                                // User canceled the picker
                                              }
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
                                                  .bodyLarge,
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
                  aspectRatio: width / height,
                  child: buildMediaWidget(context, image,type,width,height,isPinned),
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
                            postId: postId, userId: userId,
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
                    child:LikeButton(likeCount:0 ,isLiked:false,postId:postId,isChallenge: false,isButtonA: false,isButtonB: true),
                  ),
                ],
              ),
              if (caption != null) const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReadMoreText(
                  caption ,
                  trimLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!,
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
          )
      );
    }
    else if(challengeImg == null && challenges.isNotEmpty ){
      return Container(
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
                              url: image,
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
                                      '        $followerCount Followers',
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
                                        .bodyLarge)
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
                          backgroundColor:Colors.white,
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
                                                  .bodyLarge,
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
                                            onTap: () async {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                                              if (result != null) {
                                                File file = File(result.files.first.path!);
                                                final mimeType = lookupMimeType(file.path);
                                                if(mimeType!.startsWith('image/')){
                                                  Uint8List image = await fileToUint8List(file);
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ImageEditor(
                                                          image: image,
                                                          postId: postId,
                                                          userChallenged:userId,
                                                          challengeImg: true,
                                                          image2: null,
                                                          allowMultiple: true
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else if(mimeType.startsWith('video/')){
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => VideoEditor(
                                                        video: File(file.path),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else{
                                                  Fluttertoast.showToast(msg: "Unsupported file type.");
                                                }
                                              } else {
                                                // User canceled the picker
                                              }
                                            },
                                            minLeadingWidth: 20,
                                            leading: Icon(
                                              CupertinoIcons.photo,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              "Challenge Image",
                                              style: Theme.of(context).textTheme.bodyLarge,
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
              SizedBox(
                height: 400,
                child: PageView.builder(
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final imageUrl = challenges[index].challengeImg;
                    return  AspectRatio(
                        aspectRatio: width / height,
                        child: buildMediaWidget(context, imageUrl, type, width, height, isPinned),
                      );
                  },
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
                            postId: postId, userId: userId,
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
                    child: LikeButton(likeCount: 0 ,isLiked:false,postId:postId,isChallenge: false,isButtonA: false,isButtonB: true),
                  ),
                ],
              ),
              if (caption != null) const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReadMoreText(
                  caption ,
                  trimLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!,
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
          )
      );
    }
    else{return Container();}

  }
}