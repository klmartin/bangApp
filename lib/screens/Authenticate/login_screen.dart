import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bangapp/models/userprovider.dart';
import 'package:provider/provider.dart';
import '../../nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;
  @override
  void initState(){
    super.initState();
    Provider.of<UserProvider>(context,listen:false);
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
                    child: Hero(
                      tag: 'logo',
                      child: Text('Bang App',
                          style: TextStyle(
                            fontFamily: 'Billabong',
                            color: Colors.black,
                            fontSize: 50.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
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
                              showSpinner = true;
                            });
                            try {
                                final response = await http.post(
                                Uri.parse('https://kimjotech.com/BangAppBackend/api/v1/login'),
                                body: {
                                  'email': email,
                                  'password': password,
                                  },
                                );
                                print(response.body);
                              final responseBody = jsonDecode(response.body);
                                Provider.of<UserProvider>(context,listen:false).setUser(responseBody);


                                print(responseBody);
                              if (responseBody != null) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('user_id', responseBody['user_id']);
                                prefs.setString('token', responseBody['token']);
                                prefs.setString('user_image', responseBody['user_image']);
                                prefs.setString('name', responseBody['name']);
                                print(prefs.getInt("user_id"));
                                Navigator.pushNamed(context, Nav.id);
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
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.blueAccent
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
      ),
    );
  }
}
