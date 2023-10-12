//import 'dart:ffi';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filter_list/filter_list.dart';
import 'package:bangapp/constants/urls.dart';


class Register extends StatefulWidget {
  static const String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

/*class Hobby {
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
}*/

/*Future<List<Hobby>> fetchHobbies() async {
  print('fetching hobbies');
  final response = await http.get(Uri.parse('$baseUrl/hobbies'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    print(json.decode(response.body));
    return data.map((json) => Hobby.fromJson(json)).toList();

  } else {
    throw Exception('Failed to load hobbies');
  }
}*/

class _RegisterState extends State<Register> {
  @override
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //DateTime date_of_birth = DateTime.now();
  //TextEditingController _dateController = TextEditingController();
  //instance
  late String email;
  late String password;
  late String confirmPassword;
  late String name;
  //late String phoneNumber;
  //late String occupation;

  bool showSpinner = false;
  @override
   // List<Hobby>? selectedHobbyList;
    //List<Hobby> hobbyList = [];

  //String selectedHobbiesText = "";
  //List<int> selectedHobbyIds = [];

   /*loadHobbies() async {
    try {
      hobbyList = await fetchHobbies();
      return hobbyList;
    } catch (e) {
      // Handle error, if any
    }
  }
*/
  /*void updateSelectedHobbiesText() {
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
*/

 /* void openFilterDialog() async {
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
*/
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),

          child: ListView(

            children: <Widget>[

              SizedBox(
                height: 100,
              ),
              Center(
                child: Image.asset(
                  "images/app_icon.jpg",
                  height: 60,
                ),
                /*child: Hero(

                  tag: 'logo',

                  child: Text('Bang App',
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        color: Colors.black,
                        fontSize: 70.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),*/
              ),

              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  //Do something with the user input.
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your name',
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
              /*TextField(
                controller: _dateController,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: date_of_birth,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != date_of_birth) {
                    setState(() {
                      date_of_birth = picked;
                      // _dateController. = date_of_birth ;
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
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),*/
             /* SizedBox(
                height: 8.0,
              ),*/
             /* TextField(
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
                    BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),*/
              /*TextField(
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
                    BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),*/
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
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
             /* SizedBox(
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
                    BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),// Add an icon at the end of the TextField
                ),
                controller: TextEditingController(text: selectedHobbiesText),
                 // Show the selected hobbies in the TextField
              ),

              */

              SizedBox(
                height: 8.0,
              ),

              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                  hintText: 'Enter a password',
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
                height: 24.0,
              ),


              //confirm password
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  confirmPassword = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                  hintText: 'Confirm password',
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
                height: 24.0,
              ),

              Container(

               /* child: Padding(

                  padding: EdgeInsets.symmetric(vertical: 16.0),

                  child: Material(

                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,*/
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        if (password == confirmPassword) {
                          try {
                            print('this is data');
                            //print(date_of_birth.toString());
                            //print(json.encode(selectedHobbyIds).runtimeType);


                            final response = await http.post(
                              Uri.parse('$baseUrl/v1/register'),
                              body: {
                                'email': email,
                                'name': name,
                                //'date_of_birth':date_of_birth.toString(),
                                //'phone_number':phoneNumber,
                                'password': password,
                                //'occupation':occupation,
                                //'hobbies':json.encode(selectedHobbyIds)
                              },
                            );
                            final responseBody = jsonDecode(response.body);
                            // Provider.of<UserProvider>(context,listen:false).setUser(responseBody);
                            if (responseBody != null) {
                              if (responseBody.containsKey('errors')) {
                                setState(() {
                                  showSpinner = false;
                                });
                                // There are validation errors
                                final errors = responseBody['errors'];
                                String errorMessage = '';
                                // Iterate through the error messages and concatenate them into a single string
                                errors.forEach((key, value) {
                                  errorMessage += value[0] + '\n';
                                });
                                // Display a toast message with the error
                                Fluttertoast.showToast(
                                  msg: errorMessage,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                              else {
                                _firebaseMessaging.getToken().then((
                                    token) async {
                                  Service().sendTokenToBackend(
                                      token, responseBody['id']);
                                });
                                SharedPreferences prefs = await SharedPreferences
                                    .getInstance();
                                prefs.setInt('user_id', responseBody['id']);
                                prefs.setString(
                                    'token', responseBody['access_token']);
                                prefs.setString('name', responseBody['name']);
                                prefs.setString('email', responseBody['name']);
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                  builder: (context) => EditPage(),
                                ));
                              }
                            }
                          }
                          //Implement login functionality.
                          catch (e) {
                            print(e);
                          } finally {
                            showSpinner = false;
                          }
                        }else{

                          Fluttertoast.showToast(
                            msg: "Password and Confirm Password do not Match",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,


                          );
                          showSpinner = false;

                        }
                          //print(phoneNumber); print(password);
                        },
                      minWidth: 200.0,
                      height: 42.0,

                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),

                        ),

                      ),

                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        /*Colors.purple,
                              Colors.deepPurple,
                              Colors.blueAccent*/

                        Colors.deepOrange,
                        Colors.deepPurple,
                        Colors.redAccent
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(20.0)),
                    ),




                 // ),


             // ),


              MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  //child: Text('Already have an account Sign In')



              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}



