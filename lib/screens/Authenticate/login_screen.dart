import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bangapp/models/userprovider.dart';
import 'package:provider/provider.dart';
import '../../constants/urls.dart';
import '../../nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Authenticate/register_screen.dart';
import 'package:bangapp/services/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  final userId = null;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            fontSize: 50.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),*/
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
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
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your password.',
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = false;
                            });
                            try {
                              final response = await http.post(
                                Uri.parse(
                                    '$baseUrl/v1/login'),
                                body: {
                                  'email': email,
                                  'password': password,
                                },
                              );
                              final responseBody = jsonDecode(response.body);
                              if (responseBody.containsKey('error') &&
                                  responseBody['error'] ==
                                      'invalid_credentials') {
                                Fluttertoast.showToast(
                                  msg: responseBody['error'],
                                  toastLength: Toast
                                      .LENGTH_SHORT, // or Toast.LENGTH_LONG
                                  gravity:
                                      ToastGravity.CENTER, // Toast position
                                  timeInSecForIosWeb:
                                      1, // Time duration for iOS and web
                                  backgroundColor: Colors.grey[600],
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                showSpinner = false;
                              } else {
                                _firebaseMessaging
                                    .getToken()
                                    .then((token) async {
                                  Service().sendTokenToBackend(
                                      token, responseBody['user_id']);
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .setUser(responseBody);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setInt(
                                      'user_id', responseBody['user_id']);
                                  prefs.setString(
                                      'token', responseBody['token']);
                                  prefs.setString(
                                      'user_image', responseBody['user_image']);
                                  prefs.setString('name', responseBody['name']);
                                  prefs.setString('device_token', token!);
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Nav()),
                                );
                              }
                            }
                            //Implement login functionality.
                            catch (e) {
                              print(e);
                            } finally {
                              showSpinner = false;
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
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
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    //child: Text('Sign Up', style: TextStyle(color: Colors.indigo)),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'SignUp',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),

                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
