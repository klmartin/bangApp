import 'package:bangapp/constants/urls.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/screens/Profile/profile_upload.dart';
import 'package:bangapp/services/service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../models/hobby.dart';
import '../../nav.dart';
import '../../services/api_cache_helper.dart';

late String? _descr;
late String phoneNumber;
late String occupation;
String selectedHobbiesText = "";
DateTime date_of_birth = DateTime.now();
TextEditingController _dateController = TextEditingController();

Service? loggedInUser;

var imagePicker;

enum ImageSourceType { gallery, camera }

class EditPage extends StatefulWidget {
  //final GoogleSignInAccount user;
  static const String id = 'edit';
  EditPage({
    Key? key,
    //required this.user,
  }) : super(key: key);

  _EditPageState createState() => _EditPageState();
}

ApiCacheHelper apiCacheHelper = ApiCacheHelper(
  baseUrl: baseUrl,
  numberOfPostsPerRequest: 10,
);

Future<List<Hobby>> fetchHobbies() async {
  final response = await apiCacheHelper.fetchHobbies();
  print(response);
  return response.map((json) => Hobby.fromJson(json)).toList();
}

class _EditPageState extends State<EditPage> {
  late Map<String, dynamic> _currentUser;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  bool showSpinner = false;
  @override
  List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];
  List<int> selectedHobbyIds = [];


  void updateSelectedHobbiesText() {
    setState(() {
      selectedHobbiesText = selectedHobbyList!
          .map((hobby) => hobby.name!)
          .toList()
          .join(", "); // Concatenate hobby names with a comma and space
      selectedHobbyIds = selectedHobbyList!
          .map((hobby) => hobby.id!) // Access the ID property of the Hobby
          .toList();
    });
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Hobby>(
      context,
      listData: await fetchHobbies(), // Use hobbyList as the data source
      selectedListData: selectedHobbyList,
      choiceChipLabel: (hobby) =>
          hobby!.name, // Access the name property of Hobby
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (hobby, query) {
        return hobby.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedHobbyList = List.from(list!);
          updateSelectedHobbiesText();
        });

        Navigator.pop(context);
      },
    );
  }
  //late final GoogleSignInAccount user;

  chooseUploadFile(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                child: Container(
                  // padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                  child: TextButton(
                      onPressed: () async {
                        XFile image = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          rimage = image.path;
                        });
                        Navigator.pop(context, rimage);
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
                        XFile image = await imagePicker.pickImage(
                          source: ImageSource.camera,
                        );
                        setState(() {
                          rimage = image.path;
                        });
                        Navigator.pop(context, rimage);
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
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.black,
            )),
        title: Center(
          child: Text(
            'Set Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.check,
                color: Colors.purple,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    rimage != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(rimage!),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            "No Image",
                            style: TextStyle(fontSize: 20),
                          ),
                    TextButton(
                        onPressed: () {
                          chooseUploadFile(context);
                        },
                        child: Text(
                          'Change Profile photo',
                          style: TextStyle(color: Colors.purple),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: _dateController,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: date_of_birth,
                    //initialDate: DateTime.now(),
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime(2100, 12),
                  );
                  if (picked != null) {
                    setState(() {
                      date_of_birth = picked;
                      _dateController.text = DateFormatter.formatDateTime(
                        dateTime: date_of_birth,
                        outputFormat: 'dd/MM/yyyy',
                      );
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter your date of birth',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.date_range),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  //Do something with the user input.
                  phoneNumber = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your phone number',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.phone),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onTap: () async {
                  openFilterDialog();
                },
                readOnly:
                    true, // Make the TextField read-only to prevent manual input
                decoration: InputDecoration(
                  labelText: 'Select hobbies and intrests',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.accessibility_new),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                controller: TextEditingController(text: selectedHobbiesText),
                // Show the selected hobbies in the TextField
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  occupation = value;
                },
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.work_outline),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        //child: Text('Bio'),
                      ),
                      TextField(
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _descr = value;
                          //Do something with the user input.
                        },
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.info_outline),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
                child: Container(
                  // padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextButton(
                        onPressed: () async {
                          await Service().setUserProfile(
                              date_of_birth,
                              int.parse(phoneNumber),
                              selectedHobbiesText,
                              occupation,
                              _descr,
                              rimage,
                              '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Nav(initialIndex: 0),
                            ),
                          );
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange,
                          Colors.deepPurple,
                          Colors.redAccent
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
      ),
    );
  }
}
