import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:image_editor_plus/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:bangapp/services/service.dart';
import '../../nav.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
final storage = FirebaseStorage.instance;
final store = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

User? user;

enum ImageSourceType { gallery, camera }

class FinalCreate extends StatefulWidget {
  static const String id = 'final_posts';
  final Uint8List? editedImage;
  final Uint8List? editedImage2;
  const FinalCreate({
    Key? key,
    this.editedImage,
    this.editedImage2,
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

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return new Scaffold(
        body:ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: [
            SizedBox(height: 15.0),
            Container(
                child:Column (
                    children:[
                      Row(
                        children: [
                          // Display the first image
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
                                child: widget.editedImage != null
                                    ? Image.memory(
                                  widget.editedImage!,
                                  width: 190.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  width: 190,
                                  height: 200,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Display the second image if editedImage2 is not null
                          if (widget.editedImage2 != null)
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
                            onPressed: () {
                              if (widget.editedImage != null && widget.editedImage2 == null){
                                Map<String, String> body = {
                                  'user_id': '3',
                                  'body': caption,
                                  'pinned': pinPost == 1 ? '1' : '0',
                                };
                                service.addImage(body, widget.editedImage as String);
                                Navigator.pushNamed(context, Nav.id);
                              }
                              else{
                                Map<String, String> body = {
                                'user_id': '3',
                                'body': caption,
                                'pinned': pinPost == 1 ? '1' : '0',
                                };
                                service.addImage(body, widget.editedImage as String);
                                Navigator.pushNamed(context, Nav.id);
                                }
                            },
                            child: Text('Done')),
                      )
                    ]
                )
            )

            // SwitchExample(editedImage: widget.editedImage, editedImage2: widget.editedImage2), // Pass editedImage from widget
          ],
        )
    );

  }
}


