import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:bangapp/services/service.dart';
import '../../nav.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import 'create_page.dart';

enum ImageSourceType { gallery, camera }

class FinalCreate extends StatefulWidget {
  static const String id = 'final_posts';
  final Uint8List? editedImage;
  final Uint8List? editedImage2;
  final bool? challengeImg;
  final int? userChallenged;
  final int? postId;
  final String? editedVideo;
  final String ? editedVideo2;
  final String? type;
  const FinalCreate({
    Key? key,
    this.editedImage,
    this.userChallenged,
    this.challengeImg = false,
    this.editedImage2,
    this.postId,
    this.editedVideo,
    this.editedVideo2,
    this.type,
  }) : super(key: key);

  @override
  _FinaleCreateState createState() => _FinaleCreateState();
}

class _FinaleCreateState extends State<FinalCreate> {
  Service service = Service();
  var image;
  bool light = true;
  var caption;
  int bangUpdate = 0;
  int pinPost = 0 ;
  XFile? mediaFile;
  bool isLoading = false;
  VideoPlayerController? videoController;
  Future<String> saveUint8ListAsFile(Uint8List data, String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(data);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    List<Uint8List> images = [];
    List<String> videos = [];
    if(widget.editedImage != null && widget.editedImage2 != null && widget.type=='image') {
      List<Uint8List> images = [widget.editedImage!, widget.editedImage2!];
    }
    if(widget.editedVideo != null && widget.editedVideo2 != null) {
       videos.add(widget.editedVideo!);
       videos.add(widget.editedVideo2!);
    }
    Size size= MediaQuery.of(context).size;
    return  Scaffold(
        appBar: AppBar(
          title: Text(
            'Post',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () async {  Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Create(),
                ),
              );},
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
                child: Icon(Icons.arrow_back_rounded, size: 30),
              ),
            ),
            SizedBox(width: 10)
          ],
        ),
        body:ListView(
          padding: EdgeInsets.symmetric(horizontal: 1.0),
          children: [
            Container(
                child:Column (
                    children:[
                      Row(
                        children: [ // Display the first image
                        if (widget.editedImage != null && widget.editedImage2 == null )
                          Expanded(
                        child: InkWell(
                            child: Container(
                              width: size.width,
                              height: size.height /2 ,
                              child: Image.memory(
                                widget.editedImage!,
                                width: size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        else if (widget.editedImage2 != null && widget.editedImage != null)
                          Expanded(
                            child: SizedBox(
                              height: size.height/2, // Specify the desired height
                              child: PageView.builder(
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 190,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.red[200],
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Image.memory(
                                      images[index],
                                      width: 190.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else if(widget.editedVideo != null && widget.editedVideo2 == null && widget.editedImage2 == null)
                          InkWell(
                            child: Container(
                              width: size.width -4,
                              height: size.height / 2 ,
                              child: Chewie(
                                controller: ChewieController(
                                  videoPlayerController: VideoPlayerController.network(widget.editedVideo!),
                                  autoPlay: true,
                                  looping: false,
                                ),
                              ),
                            ),
                          )
                        else if(widget.editedVideo != null && widget.editedVideo2 != null)
                              Expanded(
                                child: SizedBox(
                                  height: size.height / 2, // Specify the desired height
                                  child: PageView.builder(
                                    itemCount: videos.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: size.width - 4,
                                        height: size.height / 2,
                                        child: Chewie(
                                          controller: ChewieController(
                                            videoPlayerController: VideoPlayerController.file(
                                              File(videos[index]),
                                            ),
                                            autoPlay: true,
                                            looping: true,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'Caption'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        initialValue: "",
                        decoration: InputDecoration(
                          hintText: 'Write a Caption!',
                          focusedBorder: UnderlineInputBorder(),
                        ),
                        maxLines: null,
                        onChanged: (val) {
                          setState(() {
                            caption = val;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Pin Post',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color:  Colors.red,
                            ),
                          ),
                          Switch(
                            value: pinPost == 1,
                            onChanged: (value) {
                              setState(() {
                                pinPost = value ? 1 : 0;
                              });
                            },
                          ),
                          FutureBuilder(
                            future: SharedPreferences.getInstance(),
                            builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                final sharedPreferences = snapshot.data;
                                final userRole = sharedPreferences?.getString("role"); // Replace "user_role" with the actual key for the role in shared preferences.
                                print('this is role');
                                print(userRole);
                                bool isAdmin = userRole == "admin";
                                return isAdmin
                                    ? Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Chemba ya Umbea',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Switch(
                                        value: bangUpdate == 1,
                                        onChanged: (value) {
                                          setState(() {
                                            bangUpdate = value ? 1 : 0;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                    : Container(); // Return an empty container if the user is not an admin
                              }

                              // Handle other connection states (loading, etc.) if needed
                              return Container(
                                child: Row(
                                  children: [
                                    Text(
                                      'Chemba ya Umbea',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Switch(
                                      value: bangUpdate == 1,
                                      onChanged: (value) {
                                        setState(() {
                                          bangUpdate = value ? 1 : 0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ); // Return a loading indicator while fetching shared preferences.
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      // Initially, loading is set to false
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 46.0),
                          child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                ? null : () async
                                {
                                  setState(() {isLoading = true;});
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                try {
                                  if (widget.editedImage != null && widget.editedImage2 == null && widget.challengeImg == false) {
                                    String filePath = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                    Map<String, String> body = {
                                      'user_id': prefs.getInt('user_id').toString(),
                                      'body': caption ?? " ",
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'type': widget.type!,
                                    };
                                    if(bangUpdate==1){
                                      print('naenda kwenye bangupdate');
                                      print(body);
                                      await service.addBangUpdate(body, filePath);
                                    }
                                    else{
                                      await service.addImage(body, filePath,);
                                    }
                                  }
                                  else if (widget.editedImage != null && widget.editedImage2 == null && widget.challengeImg == true) {
                                    String filePath = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                    Map<String, String> body = {
                                      'user_id': prefs.getInt('user_id').toString(),
                                      'body': caption ?? "",
                                      'post_id': widget.postId.toString(),
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'type': widget.type!,
                                    };
                                  await service.addChallenge(body, filePath, widget.userChallenged!);
                                  }
                                  else if (widget.editedVideo != null && widget.editedVideo2 == null && widget.type == 'video') {
                                    Map<String, String> body = {
                                      'user_id': prefs.getInt('user_id').toString(),
                                      'body': caption ?? "",
                                      'type': widget.type!,
                                      'pinned': pinPost == 1 ? '1' : '0',
                                    };
                                    if(bangUpdate==1){
                                      print('naenda kwenye bangupdate kwenye video');
                                      print(body);
                                      await service.addBangUpdate(body, widget.editedVideo.toString());
                                    }
                                    else{
                                      await service.addImage(body, widget.editedVideo.toString());
                                    }
                                  }
                                  else if(widget.editedVideo != null && widget.editedVideo2 != null && widget.type == 'video') {
                                    String? filePath1 = widget.editedVideo;
                                    Map<String, String> body = {
                                      'user_id': prefs.getInt('user_id').toString(),
                                      'body': caption ?? "",
                                      'type': widget.type!,
                                      'pinned': pinPost == 1 ? '1' : '0',
                                    };
                                    await service.addChallengImage(body, widget.editedVideo!,widget.editedVideo2!);
                                  }
                                  else {
                                    String filePath1 = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                    String filePath2 = await saveUint8ListAsFile(widget.editedImage2!, 'image2.jpg');
                                    Map<String, String> body = {
                                      'user_id': prefs.getInt('user_id').toString(),
                                      'body': caption ?? "",
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'type': widget.type!,
                                    };
                                    await service.addChallengImage(body, filePath1, filePath2);
                                }
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Nav()),);
                                } finally {
                                // After your button logic is done, set loading back to false
                                setState(() {
                                isLoading = false;
                                });
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Set the background color of the button
                                ),
                                child: Stack(
                                alignment: Alignment.center,
                                children: [
                                Visibility(
                                visible: !isLoading, // Show the CircularProgressIndicator when not loading
                                child: Text('Post'), // Display the button text
                                ),
                                Visibility(
                                visible: isLoading, // Show the CircularProgressIndicator when loading
                                child: CircularProgressIndicator(), // Display the CircularProgressIndicator
                                ),
                                ],
                                ),
                                ),
                          ),
                        ),
                      )

                      ]
                )
            )
          ],
        )
    );

  }
}


