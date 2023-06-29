import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:bangapp/services/service.dart';
import '../../nav.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

final storage = FirebaseStorage.instance;
final store = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;


User user;


enum ImageSourceType { gallery, camera }

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  Service service = Service();
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      children: [
        SizedBox(height: 15.0),
        SizedBox(height: 15.0),
        SwitchExample(),
      ],
    );
  }

}

class SwitchExample extends StatefulWidget {
  const SwitchExample();
  // const SwitchExample(key);
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  @override
  Service service = Service();
  var image;
  bool light = true;
  bool _isSwitched = false;
  var image2;
  var _image;
  var _image2;
  var imagePickerr;
  var imagePicker;
  var type;
  var caption;
  int pinPost = 0 ;
  XFile mediaFile;
  VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    imagePickerr = ImagePicker();
    imagePicker = ImagePicker();
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          _isSwitched ? 'Challenge' : 'Normal',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: _isSwitched ? Colors.red : Colors.green,
          ),
        ),
        Switch(
          value: _isSwitched,
          onChanged: (value) {
            setState(() {
              _isSwitched = value;
            });
          },
        ),
        Row(
          children: [
            InkWell(
              child:
              GestureDetector(
                onTap: () async {


                  final mediaFile = await FilePicker.platform.pickFiles(

                    type: FileType.media,
                    allowMultiple: false,
                  );

                  setState(() {
                    if (mediaFile != null) {
                      if (mediaFile.files.first.path.contains('.mp4')) {
                        // Handle video file
                        videoController = VideoPlayerController.file(File(mediaFile.files.first.path))
                          ..initialize().then((_) {
                            setState(() {
                              videoController.play();
                            });
                          });
                      } else {
                        // Handle image file
                        this.mediaFile = XFile(mediaFile.files.first.path);
                        videoController?.dispose();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sending Message")),
                      );
                    }
                  });
                },
                child: Container(
                  width: 190,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: mediaFile != null && mediaFile.path.contains('.mp4')
                      ? AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  )
                      : mediaFile != null
                      ? Image.file(
                    File(mediaFile.path),
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
            SizedBox(width: 5,),
            _isSwitched ?
            Container(
              width: size.width*0.4,
              child: InkWell(
                child: GestureDetector(
                  onTap: () async {
                    var source2 = type == ImageSourceType.camera
                        ? ImageSource.camera
                        : ImageSource.gallery;
                    XFile image2 = await imagePickerr.pickImage(
                      source: source2,
                    );
                    setState(() {
                      if (image2.path != null) {
                        _image2 = File(image2.path);
                      } else if (image2.path == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Sending Message"),
                        ));
                      }
                    });
                  },
                  child: Container(
                    width: 190,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.circular(32)),
                    child: _image2 != null
                        ? Image.file(
                      _image2,
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
            ):SizedBox(),
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
        Text('BUY FOLLOWERS',style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '2.5K 1100 followers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '5K 1100 followers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '10K 1100 followers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
            child: Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.red.shade800,
              ),
              label: const Text('BRONZE'),
            ),
            onTap: () {
              //Prints the label of each tapped chip
              buildFab("bronze",context);
            },),
            GestureDetector(
              child: Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                ),
                label: const Text('SILVER'),
              ),
              onTap: () {
                buildFab("silver", context);
              },
            ),
            GestureDetector(
              child:Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.yellow.shade800,
                ),
                label: const Text('GOLD '),
              ),
              onTap: () {
                //Prints the label of each tapped chip
                buildFab("gold",context);
              },),
          ],
        ),
        SizedBox(width: 15.0),
        _isSwitched ? Padding(
          padding: const EdgeInsets.only(top: 46.0),
          child: ElevatedButton(
              onPressed: () {
                Map<String, String> body = {
                  'user_id': '3',
                  'body': caption,
                  'pinned': pinPost == 1 ? '1' : '0',
                };
                // ImageHandlerMulti(image,_image2);
                service.addChallengImage(body, _image.path,_image2.path);
                Navigator.pushNamed(context, Nav.id);
              },
              child: Text('Post')),
          ) : Padding(
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
      ],
    );
  }
  buildFab(value,BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    'Payment Options',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 25.0,
                ),
                title: Text('Tigo Pesa'),
                onTap: () {
                  print(value);
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (_) => CreatePost(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 25.0,
                ),
                title: Text('M-pesa'),
                onTap: () async {
                  print(value);
                  // Navigator.pop(context);
                  // await viewModel.pickImage(context: context);

                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 25.0,
                ),
                title: Text('Airtel Money'),
                onTap: () {
                  print(value);
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (_) => CreatePost(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 25.0,
                ),
                title: Text('Halo Pesa'),
                onTap: () {
                  print(value);
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (_) => CreatePost(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}


