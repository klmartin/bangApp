import 'package:bangapp/constants/urls.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/screens/Profile/profile_upload.dart';
import 'package:bangapp/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../models/hobby.dart';
import '../../nav.dart';
import '../../services/api_cache_helper.dart';

late String? _descr;
late String? phoneNumber;
late String occupation;
String selectedHobbiesText = "";
DateTime date_of_birth = DateTime.now();
TextEditingController _dateController = TextEditingController();
late String msg;
late Service? loggedInUser;

var imagePicker;
final _formKey = GlobalKey<FormState>();

enum ImageSourceType { gallery, camera }

class EditPage extends StatefulWidget {
  static const String id = 'edit';
  EditPage({Key? key}) : super(key: key);

  _EditPageState createState() => _EditPageState();
}

ApiCacheHelper apiCacheHelper = ApiCacheHelper(
  baseUrl: baseUrl,
  numberOfPostsPerRequest: 10,
);

Future<List<Hobby>> fetchHobbies() async {
  final response = await apiCacheHelper.fetchHobbies();
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
  List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];
  List<int> selectedHobbyIds = [];

  void updateSelectedHobbiesText() {
    setState(() {
      selectedHobbiesText =
          selectedHobbyList!.map((hobby) => hobby.name!).toList().join(", ");
      selectedHobbyIds = selectedHobbyList!.map((hobby) => hobby.id!).toList();
    });
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Hobby>(
      context,
      listData: await fetchHobbies(),
      selectedListData: selectedHobbyList,
      choiceChipLabel: (hobby) => hobby!.name,
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

  void chooseUploadFile(BuildContext context) {
    showModalBottomSheet(
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
                  child: TextButton(
                      onPressed: () async {
                        XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          setState(() {
                            rimage = image.path;
                          });
                        }
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
                  child: TextButton(
                      onPressed: () async {
                        XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera,
                        );
                        if (image != null) {
                          setState(() {
                            rimage = image.path;
                          });
                        } else
                          msg = "Provide image";
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

  @override
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
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rimage != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
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
                SizedBox(height: 8.0),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _dateController,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: date_of_birth,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msg = 'Please enter your date of birth';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msg = 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return msg = 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  textAlign: TextAlign.center,
                  onTap: () async {
                    openFilterDialog();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select hobbies and interests',
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
                  validator: (value) {
                    if (selectedHobbyList == null ||
                        selectedHobbyList!.isEmpty) {
                      return msg = 'Please select at least one hobby';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msg = 'Please enter your occupation';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          minLines: 6,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _descr = value;
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return msg = 'Please enter your bio';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedHobbyList!.length < 5) {
                                Fluttertoast.showToast(msg: "error : $msg");
                              } else {
                                await Service().setUserProfile(
                                    date_of_birth,
                                    int.parse(phoneNumber!),
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
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Error message $msg",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
