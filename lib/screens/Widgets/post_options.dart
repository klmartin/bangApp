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
    padding: const EdgeInsets.only(
        left: 8.0, bottom:8,right: 8),
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
                                      // Show modal dialog with reporting reasons
                                      String reason = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Report Post"),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    title: Text("Hate"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Hate");
                                                    },
                                                    subtitle: Text('Slurs, Racist or sexist stereotypes, Dehumanization, Incitement of fear or discrimination, Hateful references, Hateful symbols & logos'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Abuse & Harassment"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Abuse & Harassment");
                                                    },
                                                    subtitle: Text('Insults, Unwanted Sexual Content & Graphic Objectification, Unwanted NSFW & Graphic Content, Violent Event Denial, Targeted Harassment and Inciting Harassment'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Violent Speech"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Violent Speech");
                                                    },
                                                    subtitle: Text('Violent Threats, Wish of Harm, Glorification of Violence, Incitement of Violence, Coded Incitement of Violence'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Child Safety"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Child Safety");
                                                    },
                                                    subtitle: Text('Child sexual exploitation, grooming, physical child abuse, underage user'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Privacy"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Child Safety");
                                                    },
                                                    subtitle: Text('Sharing private information, threatening to share/expose private information, sharing non-consensual intimate images, sharing images of me that I don’t want on the platform'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Spam"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Child Safety");
                                                    },
                                                    subtitle: Text('Fake accounts, financial scams, posting malicious links, misusing hashtags, fake engagement, repetitive replies, Reposts, or Direct Messages'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Suicide or self-harm"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Suicide or self-harm");
                                                    },
                                                    subtitle: Text('Encouraging, promoting, providing instructions or sharing strategies for self-harm.'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Sensitive or disturbing media"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Sensitive or disturbing media");
                                                    },
                                                    subtitle: Text('Graphic Content, Gratutitous Gore, Adult Nudity & Sexual Behavior, Violent Sexual Conduct, Bestiality & Necrophilia, Media depicting a deceased individual'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Deceptive identities"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Deceptive identities");
                                                    },
                                                    subtitle: Text('Impersonation, non-compliant parody/fan accounts'),
                                                  ),
                                                  ListTile(
                                                    title: Text("Violent & hateful entities"),
                                                    onTap: () {
                                                      Navigator.of(context).pop("Violent & hateful entities");
                                                    },
                                                    subtitle: Text('Violent extremism and terrorism, hate groups & networks'),
                                                  ),
                                                  // Add more reasons as needed
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      // If user selects a reason, report the post
                                      final response = await Service().reportPost(imagePostId, reason);
                                      print('reporting post');
                                      if(response.containsKey('message')){
                                        Fluttertoast.showToast(msg: response['message']);
                                      }
                                                                        },
                                    minLeadingWidth: 20,
                                    leading: Icon(
                                      CupertinoIcons.arrow_2_circlepath_circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      "Report this Post",
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
                  }
                );
              },
            );
          },
          child: Icon(
            CupertinoIcons.ellipsis_vertical,
            color: Colors.black,
            size: 24,
          ),
        ),
      ],
    ),
  );
}
