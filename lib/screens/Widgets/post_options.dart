import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/animation.dart';
import '../../widgets/delete_post.dart';
import '../../widgets/user_profile.dart';
import 'package:bangapp/screens/Profile/user_profile.dart' as User;
import '../Create/video_editing/video_edit.dart';
import 'dart:io';
import 'package:bangapp/services/service.dart';


Widget postOptions (BuildContext context,userId,userImage,userName,followerCount,imagePost,imagePostId,imageUserId,type,createdAt,postViews,widgetType)  {
  Future<Uint8List> fileToUint8List(File file) async {
    List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
    return Uint8List(0);
  }
  Future<int?> handleSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentUserId = prefs.getInt('user_id');
    // Use currentUserId as needed
    return currentUserId;
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
                  User.UserProfile(
                    userid: userId,
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
                    Text(createdAt)
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

                return FutureBuilder(
                    future: handleSharedPreferences(),
                  builder: (context,snapshot) {
                    int? currentUserId = snapshot.data as int?;
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
                              Column(
                                  children: [
                                    ListTile(
                                        leading: Icon(
                                      CupertinoIcons.eye,
                                      color: Theme.of(context)
                                          .primaryColor,
                                    ),
                                    title: Text(
                                      "$postViews Views",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
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
                              if (userId == currentUserId)
                                Column(
                                  children: [
                                    DeletePostWidget(imagePostId: imagePostId,type: widgetType,),
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
                                      Clipboard.setData(
                                          ClipboardData(
                                              text: imagePost.toString()));
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                        msg:'Copied to clipboard',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    },
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
                              Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      Service().reportPost(imagePostId);
                                      print('reporting post');
                                    },
                                    minLeadingWidth: 20,
                                    leading: Icon(
                                      CupertinoIcons.arrow_2_circlepath_circle,
                                      color: Theme.of(context)
                                          .primaryColor,
                                    ),
                                    title: Text(
                                      "Report this Post",
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
                  }
                );
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
