import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bangapp/services/service.dart';
import 'login_screen.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String email = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Wrap the Column with Center
        child: ModalProgressHUD(
          progressIndicator: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 30),
          inAsyncCall: isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Center the Column contents vertically
            children: [
              Image.asset(
                "images/app_icon.jpg",
                height: 60,
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: <Widget>[
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                      //Do something with the user input.
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Email to get a Reset Password Link',
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
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Show loader when button is pressed
                      });
                      var resetLink = await Service().getResetLink(email);
                      Fluttertoast.showToast(
                        msg: resetLink['message'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        isLoading =
                            false; // Hide loader after fetching reset link
                      });
                      if (resetLink['message'] ==
                          "Reset password link sent successfully") {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator() // Show circular progress indicator while loading
                        : Text('Get Link'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
