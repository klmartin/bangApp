import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import '../../services/animation.dart';
import '../../services/extension.dart';
import '../../widgets/user_profile.dart';
import '../Create/video_editing/video_edit.dart';
import '../Profile/profile.dart';
import 'dart:io';

Widget? postOptions (BuildContext context,userId,userImage,userName,followerCount,imagePost,imagePostId,imageUserId,type){
  Future<Uint8List> fileToUint8List(File file) async {
    if (file != null) {
      List<int> bytes = await file.readAsBytes();
      return Uint8List.fromList(bytes);
    }
    return Uint8List(0);
  }
  return  Padding(
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
                  url: userImage,
                  size: 40,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
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
              backgroundColor:Colors.black,
              context: context,
              builder: (BuildContext ctx) {
                return Container(
                    color: Colors.white,
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
                              color: Colors.blue,
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
                                              postId: imagePostId,
                                              userChallenged:imageUserId,
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
                                  "Challenge $type",
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
  );
}