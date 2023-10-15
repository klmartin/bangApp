import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Home/Home2.dart';
import  'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bangapp/screens/Profile/profile_upload.dart';
import 'package:bangapp/services/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'edit_profile.dart';

late String? _name;
late String? _descr;
late String phoneNumber;
late String occupation;
DateTime date_of_birth = DateTime.now();
TextEditingController _dateController = TextEditingController();

Service?  loggedInUser;

class EditPage extends StatefulWidget {
  static const String id = 'edit';
  _EditPageState createState() => _EditPageState();
}

class Hobby {
  final String? name;
  final int ?id;
  final String? avatar;

  Hobby({this.name,this.id, this.avatar});

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      name: json['name'],
      id: json['id'],
      avatar: "", // You can set the avatar URL here if needed
    );
  }
}

Future<List<Hobby>> fetchHobbies() async {
  print('fetching hobbies');
  final response = await http.get(Uri.parse('$baseUrl/hobbies'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    print(json.decode(response.body));
    return data.map((json) => Hobby.fromJson(json)).toList();

  } else {
    throw Exception('Failed to load hobbies');
  }
}

class _EditPageState extends State<EditPage> {
  late Map<String, dynamic> _currentUser;
  @override
  void initState() {
    super.initState();
  }

  bool showSpinner = false;
  @override
   List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];

  String selectedHobbiesText = "";
  List<int> selectedHobbyIds = [];

  loadHobbies() async {
    try {
      hobbyList = await fetchHobbies();
      return hobbyList;
    } catch (e) {
      // Handle error, if any
    }
  }

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
      listData: await loadHobbies()!, // Use hobbyList as the data source
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
                            File(rimage!.path),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadProfile()));
                        },
                        child: Text(
                          'Change Profile photo',
                          style: TextStyle(color: Colors.purple),
                        ))
                  ],
                ),

                /*child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                    Container(

                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(32),

                        image: DecorationImage(
                          image: rimage != null
                              ?  File(rimage!.path),

                              //FileImage(rimage) as ImageProvider<Object> // Explicitly cast to ImageProvider<Object>
                              : CachedNetworkImageProvider(
                              'http://via.placeholder.com/200x150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UploadProfile()));
                          },
                          child: Text(
                            'Change Profile photo',
                            style: TextStyle(color: Colors.purple),
                          ))
                    ],
                  ),
                ),*/
              ),
             /* Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                     // child: Text('User Name', textAlign: TextAlign.center),

                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _name = value;
                        //Do something with the user input.
                      },
                      decoration: InputDecoration(
                         hintText: 'Enter your Name',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    */

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
                      //_dateController.text = formatDate(DateTime(date_of_birth.toString() as int), [yyyy, '-', mm, '-', dd]);
                       //_dateController.text = DateFormat.yMMMd().format(date_of_birth.toString());
                      //_dateController.text = date_of_birth.toString();

                      _dateController.text = DateFormatter.formatDateTime(
                        dateTime: date_of_birth,
                        outputFormat: 'dd/MM/yyyy',
                      );

                    });
                  }
                },
                decoration: InputDecoration(

                  hintText: 'Enter your Date of Birth',
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
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
                  hintText: 'Enter your phone number',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),


               SizedBox(
                height: 8.0,
              ),
               TextField(
                onTap: () async {
                   openFilterDialog();

                },
                readOnly: true, // Make the TextField read-only to prevent manual input
                decoration: InputDecoration(
                  labelText: "Select Hobbies",
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),// Add an icon at the end of the TextField
                ),
                controller: TextEditingController(text: selectedHobbiesText),
                 // Show the selected hobbies in the TextField
              ),



              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  occupation = value;
                },
                decoration: InputDecoration(
                  hintText: 'Occupation',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.purple, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
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
                        child: Text('Bio'),
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
                          hintText: 'Bio',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
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
                           Service().setUserProfile(_name,_descr, rimage.toString());
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => Home2(),
                             ),
                           );
                          print(rimage);
                          print("pressed");
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


                          /*Colors.purple,
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
      ),
    );
  }
}
