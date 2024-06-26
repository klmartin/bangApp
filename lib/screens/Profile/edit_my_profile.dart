import 'package:bangapp/constants/urls.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/screens/Profile/profile_upload.dart';
import 'package:bangapp/services/service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:io';
import '../../models/hobby.dart';
import '../../nav.dart';
import '../../services/api_cache_helper.dart';

enum ImageSourceType { gallery, camera }

class EditPage extends StatefulWidget {
  static const String id = 'edit';
  final TextEditingController nameController;
  final TextEditingController occupationController;
  final TextEditingController dateOfBirthController;
  final TextEditingController phoneNumberController;
  final TextEditingController bioController;
  String name;
  String phoneNumber;
  String occupation;
  String bio;

  String selectedHobbiesText = "";
  DateTime date_of_birth = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  String userImage ;
  var imagePicker;
  EditPage({
    required this.nameController,
    required this.occupationController,
    required this.dateOfBirthController,
    required this.phoneNumberController,
    required this.userImage,
    required this.name,
    required this.date_of_birth,
    required this.phoneNumber,
    required this.selectedHobbiesText,
    required this.occupation,
    required this.bio,
    required this.bioController,
  });
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Map<String, dynamic> _currentUser;

  @override
  void initState() {
    super.initState();
    rimage = null;

    widget.nameController.text = widget.name;
    widget.occupationController.text = widget.occupation;
    widget.phoneNumberController.text = widget.phoneNumber.toString();
    widget.dateOfBirthController.text = widget.date_of_birth.toString();
    widget.bioController.text = widget.bio;
    widget.imagePicker = ImagePicker();
  }


  bool showSpinner = false;
  @override
  List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];
  List<int> selectedHobbyIds = [];

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
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ModalProgressHUD(
        progressIndicator: LoadingAnimationWidget.staggeredDotsWave(
            color: Color(0xFFF40BF5), size: 30),
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(widget.userImage != '' && rimage == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.userImage, // Provide the remote URL here
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                      if(widget.userImage == '' && rimage == null)
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              //to show image, you type like this.
                              "assets/images/empty_profile.jpg",
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                      if(rimage != null && widget.userImage == '')
                        Padding(
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
                TextField(
                  textCapitalization:TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  controller: widget.nameController,
                  onChanged: (value) {
                    //Do something with the user input.
                    widget.name = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                        Icons.accessibility
                    ),
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
                  textCapitalization:TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  controller: widget.dateOfBirthController,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.date_of_birth,
                      //initialDate: DateTime.now(),
                      firstDate: DateTime(1900, 1),
                      lastDate: DateTime(2100, 12),
                    );
                    if (picked != null) {
                      setState(() {
                        widget.date_of_birth = picked;
                        widget._dateController.text = DateFormatter.formatDateTime(
                          dateTime: widget.date_of_birth,
                          outputFormat: 'dd/MM/yyyy',
                        );
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your date of birth',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                        Icons.date_range
                    ),
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
                  textCapitalization:TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  controller: widget.phoneNumberController,
                  onChanged: (value) {
                    //Do something with the user input.
                    widget.phoneNumber = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your phone number',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                        Icons.phone
                    ),
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
                  textCapitalization:TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    openFilterDialog();
                  },
                  readOnly: true, // Make the TextField read-only to prevent manual input
                  decoration: InputDecoration(
                    labelText: 'Select hobbies and interests',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                        Icons.accessibility_new
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  controller: TextEditingController(text: widget.selectedHobbiesText),
                  // Show the selected hobbies in the TextField
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textCapitalization:TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  controller: widget.occupationController,
                  onChanged: (value) {
                    widget.occupation = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Occupation',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                        Icons.work_outline
                    ),
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
                          textCapitalization:TextCapitalization.sentences,
                          minLines: 6,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textAlign: TextAlign.center,
                          controller: widget.bioController,
                          onChanged: (value) {
                            widget.bio = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                                Icons.info_outline
                            ),
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
                            setState(() {
                              showSpinner = true;
                            });
                            print('hobbies');
                            print(widget.selectedHobbiesText);
                            print('hobbies id');
                            await Service().setUserProfile(widget.date_of_birth,widget.phoneNumber,widget.selectedHobbiesText,widget.occupation,widget.bio,rimage,widget.name);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Nav(initialIndex: 4),
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
                            Color(0xFFF40BF5),
                            Color(0xFFBF46BE),
                            Color(0xFFF40BF5)
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
      ),
    );
  }
  void updateSelectedHobbiesText() {
    setState(() {
      widget.selectedHobbiesText = selectedHobbyList!
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
      listData:  await Service().fetchHobbies(), // Use hobbyList as the data source
      selectedListData: selectedHobbyList,
      choiceChipLabel: (hobby) => hobby!.name, // Access the name property of Hobby
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
                        XFile image = await widget.imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          rimage = image.path;
                          widget.userImage = '';
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
                  child: TextButton(
                      onPressed: () async {
                        // _handleURLButtonPress(context, ImageSourceType.camera);
                        XFile image = await widget.imagePicker.pickImage(
                          source: ImageSource.camera,
                        );
                        setState(() {
                          rimage = image.path;
                          widget.userImage = '';
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
                          Color(0xFFF40BF5),
                          Color(0xFFBF46BE),
                          Color(0xFFF40BF5)
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

}


ApiCacheHelper apiCacheHelper = ApiCacheHelper(
  baseUrl: baseUrl,
  numberOfPostsPerRequest: 10,
);

Future<List<Hobby>> fetchHobbies() async {
  final response = await apiCacheHelper.fetchHobbies();
  return response.map((json) => Hobby.fromJson(json)).toList();
}


