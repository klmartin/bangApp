import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../components/square_tiles.dart';
import '../../constants/urls.dart';
import '../../nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Authenticate/register_screen.dart';
import 'package:bangapp/services/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/screens/Authenticate/reset_password.dart';
import '../../services/token_storage_helper.dart';

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
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
  }

  // Google sign-in method
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (e) {
      print('Google sign-in error: $e');
      throw e;
    }
  }

// Facebook sign-in method
  // Future<UserCredential> signInWithFacebook() async {
  //   try {
  //     // Trigger the sign-in flow
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     // Check if the user canceled the login process
  //     if (loginResult.status == LoginStatus.cancelled) {
  //       throw FirebaseAuthException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     }

  //     // Obtain the access token and exchange it for a credential
  //     final OAuthCredential credential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     // Sign in to Firebase with the Facebook credential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     print('Facebook sign-in error: $e');
  //     throw e;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
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
                      "assets/images/app_icon.jpg",
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
                            labelText: 'Email or Phone no',
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
                          obscureText: _isObscured,
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
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
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
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
                    child: Container(
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
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
                                setState(() {
                                  showSpinner = false;
                                });
                              } else {
                                setState(() {
                                  showSpinner = false;
                                });
                                SharedPreferences prefs =
                                      await SharedPreferences.getInstance();


                                  prefs.setInt(
                                      'user_id', responseBody['user_id']);
                                  await TokenManager.saveToken(
                                      responseBody['token']);
                                  prefs.setString(
                                      'user_image', responseBody['user_image']);
                                  prefs.setString(
                                      'token', responseBody['token']);
                                  prefs.setString('name', responseBody['name']);
                                  prefs.setString('role', responseBody['role']);
                                _firebaseMessaging
                                    .getToken()
                                    .then((token) async {

                                  Service().sendTokenToBackend(
                                      token, responseBody['user_id']);
                                  final userProvider =
                                      Provider.of<UserProvider>(context,
                                          listen: false);
                                  if (userProvider.userData.isEmpty) {
                                    userProvider.fetchUserData();
                                  }
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Nav(initialIndex: 0)),
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
                              color: Colors.black,
                            ),
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
                  const SizedBox(height: 25),
                  //google + apple sign in buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SquareTile(
                  //         imagePath: 'assets/images/google.png',
                  //         onTap: () async {
                  //           try {
                  //             UserCredential userCredential = await signInWithGoogle();
                  //             // Retrieve user details
                  //             User? user = userCredential.user;
                  //             if (user != null) {
                  //               final response = await http.post(
                  //                 Uri.parse('$baseUrl/v1/login'),
                  //                 body: {
                  //                   'email': user.email,
                  //                   'password': user.uid,
                  //                 },
                  //               );
                  //               final responseBody = jsonDecode(response.body);

                  //               if (responseBody.containsKey('error') &&
                  //                   responseBody['error'] ==
                  //                       'invalid_credentials') {
                  //                 Fluttertoast.showToast(
                  //                   msg: responseBody['error'],
                  //                   toastLength: Toast
                  //                       .LENGTH_SHORT, // or Toast.LENGTH_LONG
                  //                   gravity:
                  //                   ToastGravity.CENTER, // Toast position
                  //                   timeInSecForIosWeb:
                  //                   1, // Time duration for iOS and web
                  //                   backgroundColor: Colors.grey[600],
                  //                   textColor: Colors.white,
                  //                   fontSize: 16.0,
                  //                 );
                  //                 setState(() {
                  //                   showSpinner = false;
                  //                 });
                  //               } else {
                  //                 setState(() {
                  //                   showSpinner = false;
                  //                 });
                  //                 _firebaseMessaging
                  //                     .getToken()
                  //                     .then((token) async {
                  //                   SharedPreferences prefs =
                  //                   await SharedPreferences.getInstance();
                  //                   prefs.setInt(
                  //                       'user_id', responseBody['user_id']);
                  //                   await TokenManager.saveToken(
                  //                       responseBody['token']);
                  //                   prefs.setString(
                  //                       'user_image', responseBody['user_image']);
                  //                   prefs.setString(
                  //                       'token', responseBody['token']);
                  //                   prefs.setString('name', responseBody['name']);
                  //                   prefs.setString('device_token', token!);
                  //                   prefs.setString('role', responseBody['role']);

                  //                   Service().sendTokenToBackend(
                  //                       token, responseBody['user_id']);
                  //                   final userProvider =
                  //                   Provider.of<UserProvider>(context,
                  //                       listen: false);
                  //                   if (userProvider.userData.isEmpty) {
                  //                     userProvider.fetchUserData();
                  //                   }
                  //                 });
                  //                 Navigator.pushReplacement(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           Nav(initialIndex: 0)),
                  //                 );
                  //               }

                  //             }
                  //           } catch (e) {}
                  //         }),
                  //     const SizedBox(width: 10),
                  //     //apple button
                  //     // SquareTile(
                  //     //   imagePath: 'assets/images/facebook.png',
                  //     //   onTap: () async {
                  //     //     try {
                  //     //       await signInWithFacebook();
                  //     //       // Handle successful sign-in
                  //     //     } catch (e) {
                  //     //       // Handle sign-in error
                  //     //     }
                  //     //   },
                  //     // ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'SignUp',
                          style: TextStyle(
                            color: Color(0xFFF40BF5),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPassword(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Color(0xFFF40BF5),
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
