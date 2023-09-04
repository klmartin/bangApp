import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:bangapp/services/service.dart';
import '../../nav.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

enum ImageSourceType { gallery, camera }

class FinalCreate extends StatefulWidget {
  static const String id = 'final_posts';
  final Uint8List? editedImage;
  final Uint8List? editedImage2;
  final bool? challengeImg;
  final int? userChallenged;
  final int? postId;
  final String? editedVideo;
  const FinalCreate({
    Key? key,
    this.editedImage,
    this.userChallenged,
    this.challengeImg = false,
    this.editedImage2,
    this.postId,
    this.editedVideo
  }) : super(key: key);

  @override
  _FinaleCreateState createState() => _FinaleCreateState();
}

class _FinaleCreateState extends State<FinalCreate> {
  Service service = Service();
  var image;
  bool light = true;
  var type;
  var caption;
  int pinPost = 0 ;
  XFile? mediaFile;
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
    Size size= MediaQuery.of(context).size;
    return new Scaffold(
        body:ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: [
            SizedBox(height: 35.0),
            Container(
                child:Column (
                    children:[
                      Row(
                        children: [ // Display the first image
                        if (widget.editedImage != null && widget.editedVideo == null)
                        Expanded(
                        child: Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        child: InkWell(
                            child: Container(
                              width: 190,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Image.memory(
                                widget.editedImage!,
                                width: 190.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        )
                        else
                        Container(), // Empty container if the first image is null
                        // Display the second image if editedImage2 is not null
                        if (widget.editedImage2 != null && widget.editedVideo == null)
                        Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        width: size.width * 0.4,
                        child: InkWell(
                        child: Container(
                        width: 190,
                        height: 200,
                        decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.circular(32),
                        ),
                        child: Image.memory(
                        widget.editedImage2!,
                        width: 190.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                        ),
                        ),
                        ),
                        ),
                        if(widget.editedVideo != null && widget.editedImage == null && widget.editedImage2 == null)
                          Expanded(
                            child: Container(
                              height: videoController?.value.size?.height ,
                              child: Chewie(
                                controller: ChewieController(
                                  videoPlayerController: VideoPlayerController.network(widget.editedVideo!),
                                  autoPlay: true,
                                  looping: true,
                                ),
                              ),
                            ),
                          ),

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
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 46.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if (widget.editedImage != null && widget.editedImage2 == null && widget.challengeImg==false){
                                String filePath = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                print(filePath);
                                Map<String, String> body = {
                                  'user_id': prefs.getInt('user_id').toString(),
                                  'body': caption ?? "",
                                  'pinned': pinPost == 1 ? '1' : '0',
                                };
                                await service.addImage(body, filePath);
                                Navigator.pushNamed(context, Nav.id);
                              }
                              else if(widget.editedImage != null && widget.editedImage2 == null && widget.challengeImg==true){
                                String filePath = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                print(filePath);
                                Map<String, String> body = {
                                  'user_id': prefs.getInt('user_id').toString(),
                                  'body': caption ?? "",
                                  'post_id':widget.postId.toString(),
                                  'pinned': pinPost == 1 ? '1' : '0',
                                };
                                await service.addChallenge(body, filePath,widget.userChallenged!);
                                Navigator.pushNamed(context, Nav.id);
                              }
                              else if (widget.editedVideo != null && widget.editedImage2 == null && widget.editedImage==null){
                                String? filePath1 = widget.editedVideo;
                                if (filePath1 != null) { // Check if filePath1 is not null before using it
                                  Map<String, String> body = {
                                    'user_id': prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'type': 'video',
                                    if (videoController != null && videoController!.value.size != null) 'videoHeight': videoController!.value.size!.height.toString(),
                                    'pinned': pinPost == 1 ? '1' : '0',
                                  };
                                  await service.addImage(body, filePath1);
                                }
                                Navigator.pushNamed(context, Nav.id);
                              }
                              else{
                                String filePath1 = await saveUint8ListAsFile(widget.editedImage!, 'image.jpg');
                                String filePath2 = await saveUint8ListAsFile(widget.editedImage2!, 'image2.jpg');
                                Map<String, String> body = {
                                    'user_id': prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'pinned': pinPost == 1 ? '1' : '0',
                                  };
                                  await service.addChallengImage(body, filePath1,filePath2);
                                  Navigator.pushNamed(context, Nav.id);
                                }
                            },
                            child: Text('Done')),
                      )
                    ]
                )
            )
          ],
        )
    );

  }
}


