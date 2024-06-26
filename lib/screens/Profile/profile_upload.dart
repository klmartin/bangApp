import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

var rimage;
var imagePicker2;
enum ImageSourceType { gallery, camera }

class UploadProfile extends StatefulWidget {
  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    imagePicker2= ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Container(
                // padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                child: TextButton(
                    onPressed: () async {
                      XFile image = await imagePicker2.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        rimage = image.path;
                      });
                      Navigator.pop(context,rimage);
                    },
                    child: Text(
                      'Upload from Gallery',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold),
                    )),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.redAccent, Colors.orange],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Container(
                // padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                child: TextButton(
                    onPressed: () async {
                      // _handleURLButtonPress(context, ImageSourceType.camera);
                      XFile image = await imagePicker2.pickImage(
                        source: ImageSource.camera,
                      );
                      setState(() {
                        rimage = image.path;
                      });
                      Navigator.pop(context,rimage);
                    },
                    child: Text(
                      'Open Camera',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [

                        Colors.deepOrange,
                        Colors.deepPurple,
                        Colors.redAccent

                       /* Colors.purple,
                        Colors.deepPurple,
                        Colors.blueAccent*/

                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
