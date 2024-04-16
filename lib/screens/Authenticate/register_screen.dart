import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../components/square_tiles.dart';
import '../../services/auth_services.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool _isObscured = true;
  bool _isObscuredConfirm = true;
  @override

  // Google sign-in method
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
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
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Check if the user canceled the login process
      if (loginResult.status == LoginStatus.cancelled) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtain the access token and exchange it for a credential
      final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Sign in to Firebase with the Facebook credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Facebook sign-in error: $e');
      throw e;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        progressIndicator: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30),
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
                  "assets/images/app_icon.jpg",
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
                  labelText: 'Enter Full Name',
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
                obscureText: _isObscured,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.lock_person),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                  ),
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
                obscureText: _isObscuredConfirm,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  confirmPassword = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.lock_person),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscuredConfirm = !_isObscuredConfirm;
                      });
                    },
                    icon: Icon(_isObscuredConfirm ? Icons.visibility_off : Icons.visibility),
                  ),
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
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setInt('user_id', responseBody['id']);
                            await TokenManager.saveToken(
                                responseBody['access_token']);
                            prefs.setString('token', responseBody['access_token']);
                            prefs.setString('name', responseBody['name']);
                            prefs.setString('email', responseBody['email']);
                            print(prefs.getString('name'));
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                      }
                      //Implement login functionality.
                      catch (e) {
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
                    style: TextStyle(color: Colors.black),
                  ),
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

              const SizedBox(height: 25),
              //google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  SquareTile(
                    imagePath: 'assets/images/google.png',
                    onTap: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        UserCredential userCredential = await signInWithGoogle();
                        // Handle successful sign-in
                        User? user = userCredential.user;
                        if (user != null) {
                          print([user.displayName,user.email,user.photoURL,user.phoneNumber]);
                          final newGoogleUser = await AuthService().addGoogleUser(user.displayName,user.email,user.photoURL,user.phoneNumber,user.uid);

                          if(newGoogleUser.containsKey('access_token')){

                            _firebaseMessaging.getToken().then((token) async {
                              Service().sendTokenToBackend(
                                  token, newGoogleUser['id']);
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setInt('user_id', newGoogleUser['id']);
                            await TokenManager.saveToken(
                                newGoogleUser['access_token']);
                            prefs.setString('token', newGoogleUser['access_token']);
                            prefs.setString('name', newGoogleUser['name']);
                            prefs.setString('email', newGoogleUser['email']);
                            print("this is seted ${prefs.getString('name')}");
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            if (userProvider.userData.isEmpty) {
                              userProvider.fetchUserData();
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(),
                                ));
                          }
                          print(newGoogleUser);
                        }
                        else{
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      }
                      catch(e){
                        print(e);
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
                  const SizedBox(width: 10),
                  //apple button
                  // SquareTile(
                  //   imagePath: 'assets/images/facebook.png',
                  //   onTap: () async {
                  //     try {
                  //       await signInWithFacebook();
                  //       // Handle successful sign-in
                  //     } catch (e) {
                  //       // Handle sign-in error
                  //     }
                  //   },
                  // ),

                ],
              ),

              const SizedBox(height: 25),
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
                        color: Color(0xFFF40BF5),
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
