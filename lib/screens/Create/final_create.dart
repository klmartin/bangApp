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

  const FinalCreate({
    Key? key,
    this.editedImage,
  }) : super(key: key);

  @override
  _FinaleCreateState createState() => _FinaleCreateState();
}

class _FinaleCreateState extends State<FinalCreate> {
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      children: [
        SizedBox(height: 15.0),
        SwitchExample(editedImage: widget.editedImage), // Pass editedImage from widget
      ],
    );
  }
}


class SwitchExample extends StatefulWidget {
  final  Uint8List? editedImage;
  const SwitchExample({
    required this.editedImage,
  });
  // const SwitchExample(key);
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  @override
  Uint8List? editedImage;
  void initState() {
    super.initState();
    editedImage = widget.editedImage; // Access the editedImage from widget
  }
  Service service = Service();
  var image;
  bool light = true;
  bool _isSwitched = false;
  var image2;
  var _image;
  var _image2;
  var type;
  var caption;
  int pinPost = 0 ;
  XFile? mediaFile;
  VideoPlayerController? videoController;
  @override

  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Container(
          height: double.infinity,
          child:Column (
          children:[
          Row(
          children: [
          Container(
          width: size.width*0.4,
            child: InkWell(
              child: Container(
                width: 190,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: editedImage != null
                    ? Image.memory(
                  editedImage!,
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
          ]),
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
                  // ImageHandler(_image);
                  Map<String, String> body = {
                    'user_id': '3',
                    'body': caption,
                    'pinned': pinPost == 1 ? '1' : '0',
                  };
                  service.addImage(body, _image.path);
                  Navigator.pushNamed(context, Nav.id);
                },
                child: Text('Done')),
          )
        ]
       )
    );
  }


}


