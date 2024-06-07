import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../services/token_storage_helper.dart';
import 'login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/providers/user_provider.dart';

class Register extends StatefulWidget {
  static const String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        // Add more specific validation for email if needed
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        confirmPassword = value;
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                child: MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
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
                            final errors = responseBody['errors'];
                            String errorMessage = '';
                            errors.forEach((key, value) {
                              errorMessage += value[0] + '\n';
                            });
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
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            if (userProvider.userData.isEmpty) {
                              userProvider.fetchUserData();
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(),
                                ));
                          }
                        }
                      } catch (e) {
                        // Handle error
                      } finally {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please correct the errors in the form",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
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
