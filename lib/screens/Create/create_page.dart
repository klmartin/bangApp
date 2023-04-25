import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nallagram/services/service.dart';
import '../../nav.dart';

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
              child: GestureDetector(
                onTap: () async {
                  var source = type == ImageSourceType.camera
                      ? ImageSource.camera
                      : ImageSource.gallery;
                  XFile image = await imagePicker.pickImage(
                    source: source,
                  );
                  setState(() {
                    if (image.path != null) {
                      _image = File(image.path);
                    } else if (image.path == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Sending Message"),
                      ));
                    }
                  });
                },
                child: Container(
                  width: 200,
                  height: 190,
                  decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(32)),
                  child: _image != null
                      ? Image.file(
                    _image,
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

        SizedBox(width: 15.0),
        _isSwitched ? Padding(
          padding: const EdgeInsets.only(top: 46.0),
          child: ElevatedButton(
              onPressed: () {
                Map<String, String> body = {
                  'caption': 'martin'};
                // ImageHandlerMulti(image,_image2);
                print('here');
                service.addChallengImage(body, _image.path,_image2.path);
                Navigator.pushNamed(context, Nav.id);
              },
              child: Text('Done')),
          ) : Padding(
          padding: const EdgeInsets.only(top: 46.0),
          child: ElevatedButton(
              onPressed: () {
                // ImageHandler(_image);
                Map<String, String> body = {
                  'caption': 'martin'};
                service.addImage(body, _image.path);
                Navigator.pushNamed(context, Nav.id);
              },
              child: Text('Done')),
        )
      ],
    );

  }
}

