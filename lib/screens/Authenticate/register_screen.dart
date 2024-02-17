//import 'dart:ffi';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/token_storage_helper.dart';
import 'login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/constants/urls.dart';

class Register extends StatefulWidget {
  static const String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String email;
  late String password;
  late String confirmPassword;
  late String name;
  bool showSpinner = false;
  @override
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
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.person),
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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your email or Phone Number',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.mail_outline),
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
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.lock_person),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
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
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.lock_person),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (password == confirmPassword) {
                      try {
                        var response = await http.post(
                          Uri.parse('$baseUrl/v1/register'),
                          body: jsonEncode({
                            'email': email,
                            'name': name,
                            'password': password,
                          }),
                          headers: {
                            HttpHeaders.contentTypeHeader: 'application/json',
                          },
                        );
                        final responseBody = jsonDecode(response.body);
                        print(responseBody);
                        if (responseBody != null) {
                          if (responseBody.containsKey('errors')) {
                            setState(() {
                              showSpinner = false;
                            });
                            // There are validation errors
                            final errors = responseBody['errors'];
                            String errorMessage = '';
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
                          } else {
                            _firebaseMessaging.getToken().then((token) async {
                              Service().sendTokenToBackend(
                                  token, responseBody['id']);
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setInt('user_id', responseBody['id']);
                            await TokenManager.saveToken(
                                responseBody['access_token']);
                            prefs.setString(
                                'token', responseBody['access_token']);
                            prefs.setString('name', responseBody['name']);
                            prefs.setString('email', responseBody['email']);
                            print(prefs.getString('name'));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
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
                    } else {
                      Fluttertoast.showToast(
                        msg: "Password and Confirm Password do not Match",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      showSpinner = false;
                    }
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
                        Colors.deepOrange,
                        Colors.deepPurple,
                        Colors.redAccent
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(20.0)),
              ),

              const SizedBox(height: 50),
              //google + apple sign in buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     //google button
              //     SquareTile(
              //       imagePath: 'assets/images/google.png',
              //       onTap: () => AuthService().signIn(),),
              //
              //     const SizedBox(width: 10),
              //     //apple button
              //     SquareTile(
              //       imagePath: 'assets/images/apple.png',
              //       onTap: () => AuthService().signIn(),
              //     ),
              //
              //   ],
              // ),

              const SizedBox(height: 50),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
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
