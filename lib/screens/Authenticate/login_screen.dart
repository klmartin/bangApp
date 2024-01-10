import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bangapp/models/userprovider.dart';
import 'package:provider/provider.dart';
import '../../api/google_signin_api.dart';
import '../../constants/urls.dart';
import '../../nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Authenticate/register_screen.dart';
import 'package:bangapp/services/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/token_storage_helper.dart';
import '../Profile/edit_profile.dart';

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
  final user = GoogleSignInAccount;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false);
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign in Failed'),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EditPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ),
                  SizedBox(
                    height: 20.0,
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
                            labelText: 'Email',
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
                                Uri.parse('$baseUrl/v1/login'),
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
                                Provider.of<UserProvider>(context,
                                          listen: false)
                                      .setUser(responseBody);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      print("debug for shared preferences");
                                      print(prefs);
                                      print(responseBody['user_id']);
                                  prefs.setInt('user_id', responseBody['user_id']);
                                  await TokenManager.saveToken(responseBody['token']);
                                  prefs.setString(
                                      'user_image', responseBody['user_image']);
                                  prefs.setString('token', responseBody['token']);
                                  prefs.setString('name', responseBody['name']);
                                 
                                  prefs.setString('role', responseBody['role']);
                                       print('this is role');
                                print(prefs.getInt("user_id"));

                                _firebaseMessaging.getToken().then((token) async {
                                  Service().sendTokenToBackend(
                                      token, responseBody['user_id']);
                                       prefs.setString('device_token', token!);
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Nav(initialIndex: 0)),
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

                  const SizedBox(height: 20),

                  //or continue with
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //         child: Text(
                  //           'Or continue with',
                  //           style: TextStyle(color: Colors.grey[700]),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 20),
                  //google + apple sign in buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                    

                  //     MaterialButton(
                  //       onPressed: signIn,
                  //       child: Container(
                  //         padding: const EdgeInsets.all(20),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.white),
                  //           borderRadius: BorderRadius.circular(16),
                  //           color: Colors.grey[200],
                  //         ),
                  //         child: Image.asset(
                  //           'assets/images/google.png',
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),

                  //     const SizedBox(width: 10),

                  //     MaterialButton(
                  //       onPressed: signIn,
                  //       child: Container(
                  //         padding: const EdgeInsets.all(20),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.white),
                  //           borderRadius: BorderRadius.circular(16),
                  //           color: Colors.grey[200],
                  //         ),
                  //         child: Image.asset(
                  //           'assets/images/apple.png',
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SizedBox(height: 20),

                
                  const SizedBox(height: 20),
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
